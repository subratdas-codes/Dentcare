package com.subrat.clinic.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Service
public class MailService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MailService.class);

    public static final String ADMIN_EMAIL = "dentcare.support@gmail.com";

    private static final String BREVO_API_URL = "https://api.brevo.com/v3/smtp/email";

    @Value("${BREVO_API_KEY:}")
    private String brevoApiKey;

    @Value("${MAIL_USERNAME:}")
    private String mailUsername;

    private final ObjectMapper objectMapper = new ObjectMapper();
    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(20))
            .build();

    public MailService() {
    }

    @PostConstruct
    public void init() {
        if (isConfigured()) {
            LOGGER.info("[MAIL] HTTP API configured=true endpoint=BREVO (api.brevo.com over 443 - SMTP 587/465 is blocked on Render free tier)");
        } else {
            LOGGER.warn("[MAIL FALLBACK] Email not configured - set BREVO_API_KEY (and optionally MAIL_USERNAME as the sender)");
            LOGGER.warn("[MAIL FALLBACK] Password reset links will still print on-screen and in logs.");
        }
    }

    public boolean isConfigured() {
        return brevoApiKey != null && !brevoApiKey.isBlank();
    }

    public String getMailUsername() {
        return mailUsername != null && !mailUsername.isBlank() ? mailUsername : ADMIN_EMAIL;
    }

    /**
     * Best-effort raw connectivity probe (render SMTP vs HTTP egress). Results shown on
     * the admin Mail Test page so Render network issues are obvious, not silent.
     */
    public String runConnectivityCheck() {
        String[][] targets = {
                {"smtp.gmail.com", "465"}, {"smtp.gmail.com", "587"},
                {"smtp-relay.brevo.com", "587"}, {"smtp-relay.brevo.com", "465"},
                {"smtp.sendgrid.net", "587"}, {"example.com", "443"}
        };
        StringBuilder sb = new StringBuilder();
        for (String[] t : targets) {
            String host = t[0];
            int port = Integer.parseInt(t[1]);
            long start = System.currentTimeMillis();
            String result;
            try (java.net.Socket sock = new java.net.Socket()) {
                sock.connect(new java.net.InetSocketAddress(host, port), 5000);
                result = "OPEN (" + (System.currentTimeMillis() - start) + "ms)";
            } catch (Exception ex) {
                result = ex.getClass().getSimpleName();
            }
            sb.append(host).append(":").append(port).append(" = ").append(result).append("   ");
        }
        return sb.toString();
    }

    public String sendTest() {
        if (!isConfigured()) {
            return "Email NOT configured - set BREVO_API_KEY in Render. (See Mail Test page connectivity panel - SMTP 587/465 is blocked from Render free tier, only HTTP 443 works.)";
        }
        String outcome = sendHtml(ADMIN_EMAIL, "DentCare mail test", "If you can read this, DentCare email sending works via Brevo HTTP API.");
        return outcome == null
                ? "Sent OK via Brevo HTTP API - check dentcare.support@gmail.com inbox now (and spam)."
                : "FAILED: " + outcome;
    }

    public void sendPasswordReset(String to, String resetLink) {
        if (!isConfigured()) {
            LOGGER.warn("[MAIL FALLBACK] Password reset link for {}: {}", to, resetLink);
            return;
        }
        String text = "Hello,\n\n" +
                "You requested a password reset for your DentCare account.\n\n" +
                "Open the link below to choose a new password (valid for 30 minutes):\n" +
                resetLink + "\n\n" +
                "If you did not request this, you can safely ignore this email.\n\n" +
                "DentCare Support";
        String error = sendHtml(to, "Reset your DentCare password", text);
        if (error == null) {
            LOGGER.info("[MAIL] Sent password reset to {} via Brevo HTTP API", to);
        } else {
            LOGGER.error("[MAIL] Password reset FAILED to {}: {}", to, error);
        }
    }

    public void sendContactMessage(String name, String email, String subject, String message) {
        if (!isConfigured()) {
            LOGGER.warn("[MAIL FALLBACK] Contact message from {} <{}> | Subject: {} | {}", name, email, subject, message);
            return;
        }
        String text = "Name: " + name + "\nEmail: " + email + "\nSubject: " + subject + "\n\n" + message;
        String error = sendHtml(ADMIN_EMAIL, "Website Contact: " + subject, text);
        if (error == null) {
            LOGGER.info("[MAIL] Sent contact notification via Brevo HTTP API");
        } else {
            LOGGER.error("[MAIL] Contact notification FAILED: {}", error);
        }
    }

    private String sendHtml(String to, String subject, String text) {
        try {
            ObjectNode root = objectMapper.createObjectNode();
            ObjectNode sender = root.putObject("sender");
            sender.put("name", "DentCare");
            sender.put("email", getMailUsername());
            ArrayNode recipients = root.putArray("to");
            ObjectNode recipient = recipients.addObject();
            recipient.put("email", to);
            root.put("subject", subject);
            root.put("textContent", text libre);
            String body = objectMapper.writeValueAsString(root);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(BREVO_API_URL))
                    .timeout(Duration.ofSeconds(25))
                    .header("accept", "application/json")
                    .header("content-type", "application/json")
                    .header("api-key", brevoApiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(body))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                return null;
            }
            String detail = response.body();
            String msg = detail;
            try {
                JsonNode node = objectMapper.readTree(detail);
                JsonNode m = node.path("message");
                if (!m.isMissingNode()) msg = m.asText();
            } catch (Exception ignore) {
            }
            return "HTTP " + response.statusCode() + ": " + (msg != null && msg.length() > 200 ? msg.substring(0, 200) : msg);
        } catch (Exception ex) {
            return ex.getClass().getSimpleName() + ": " + ex.getMessage();
        }
    }
}
