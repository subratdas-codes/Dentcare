package com.subrat.clinic.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Service;

import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

@Service
public class MailService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MailService.class);

    public static final String ADMIN_EMAIL = "dentcare.support@gmail.com";

    private static final String BREVO_URL = "https://api.brevo.com/v3/smtp/email";

    @Value("${spring.mail.host:}")
    private String mailHost;

    @Value("${spring.mail.port:587}")
    private String mailPort;

    @Value("${spring.mail.username:}")
    private String mailUsername;

    @Value("${spring.mail.password:}")
    private String mailPassword;

    @Value("${BREVO_API_KEY:}")
    private String brevoApiKey;

    private final ObjectMapper objectMapper = new ObjectMapper();
    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(20))
            .build();

    private final List<JavaMailSender> smtpSenders = new ArrayList<>();

    @PostConstruct
    public void init() {
        if (brevoApiKey != null && !brevoApiKey.isBlank()) {
            LOGGER.info("[MAIL] Provider=BREVO-HTTP configured=true (api.brevo.com:443 - reaches Render where SMTP is blocked)");
            return;
        }
        if (mailUsername == null || mailUsername.isBlank() || mailHost == null || mailHost.isBlank()) {
            LOGGER.warn("[MAIL] NOT configured - set BREVO_API_KEY (recommended) OR SMTP_HOST/SMTP_PORT/MAIL_USERNAME/MAIL_PASSWORD");
            return;
        }
        int basePort;
        try {
            basePort = Integer.parseInt(mailPort.trim());
        } catch (NumberFormatException ex) {
            basePort = 587;
        }
        Set<Integer> ports = new LinkedHashSet<>();
        ports.add(basePort);
        ports.add(465);
        ports.add(587);
        String host = mailHost.trim();
        for (int p : ports) {
            smtpSenders.add(build(host, p, p == 465));
        }
        LOGGER.info("[MAIL] Provider=SMTP configured=true host={} username={} ports={}", host, mailUsername, ports);
    }

    private JavaMailSender build(String host, int port, boolean ssl) {
        JavaMailSenderImpl sender = new JavaMailSenderImpl();
        sender.setHost(host);
        sender.setPort(port);
        sender.setUsername(mailUsername);
        sender.setPassword(mailPassword);
        Properties props = sender.getJavaMailProperties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.connectiontimeout", "15000");
        props.put("mail.smtp.timeout", "15000");
        props.put("mail.smtp.writetimeout", "15000");
        if (ssl) {
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.socketFactory.port", String.valueOf(port));
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        } else {
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
        }
        return sender;
    }

    public boolean isConfigured() {
        return (brevoApiKey != null && !brevoApiKey.isBlank())
                || (mailUsername != null && !mailUsername.isBlank());
    }

    public boolean usesBrevo() {
        return brevoApiKey != null && !brevoApiKey.isBlank();
    }

    public String getMailUsername() {
        return usesBrevo() ? ADMIN_EMAIL : mailUsername;
    }

    public String runConnectivityCheck() {
        String[] targets = {
                "smtp-relay.brevo.com:587", "smtp-relay.brevo.com:465",
                "smtp.gmail.com:587", "smtp.gmail.com:465",
                "api.brevo.com:443", "example.com:443"
        };
        StringBuilder sb = new StringBuilder();
        for (String t : targets) {
            String[] hp = t.split(":");
            String host = hp[0];
            int port = Integer.parseInt(hp[1]);
            long start = System.currentTimeMillis();
            String result;
            try (Socket sock = new Socket()) {
                sock.setSoTimeout(6000);
                sock.connect(new InetSocketAddress(host, port), 6000);
                result = "OPEN (" + (System.currentTimeMillis() - start) + "ms)";
            } catch (Exception ex) {
                result = ex.getClass().getSimpleName();
            }
            sb.append(t).append(" = ").append(result).append("   ");
        }
        return sb.toString().trim();
    }

    public String sendTest() {
        SendResult r = route(makeMessage(ADMIN_EMAIL, "DentCare Mail Test",
                "If you can read this, DentCare email sending (Brevo HTTP API) is working correctly."));
        if (r.ok) {
            LOGGER.info("[MAIL] Test email sent to {} via {}", ADMIN_EMAIL, r.endpoint);
            return r.endpoint;
        }
        LOGGER.error("[MAIL] Test email FAILED: {}", r.failures);
        return "FAILED: " + r.failures;
    }

    public void sendPasswordReset(String to, String resetLink) {
        SimpleMailMessage mail = makeMessage(to, "Reset your DentCare password",
                "Hello,\n\n" +
                        "You requested a password reset for your DentCare account.\n\n" +
                        "Open the link below to choose a new password (valid for 30 minutes):\n" +
                        resetLink + "\n\n" +
                        "If you did not request this, you can safely ignore this email.\n\n" +
                        "DentCare Support");
        SendResult r = route(mail);
        if (r.ok) {
            LOGGER.info("[MAIL] Password reset sent to {} via {}", to, r.endpoint);
        } else {
            LOGGER.error("[MAIL] Password reset send FAILED to {}: {}", to, r.failures);
        }
    }

    public void sendContactMessage(String name, String email, String subject, String message) {
        SimpleMailMessage mail = makeMessage(ADMIN_EMAIL, "Website Contact: " + subject,
                "Name: " + name + "\nEmail: " + email + "\nSubject: " + subject + "\n\n" + message);
        SendResult r = route(mail);
        if (r.ok) {
            LOGGER.info("[MAIL] Contact notification sent via {}", r.endpoint);
        } else {
            LOGGER.error("[MAIL] Contact notification FAILED: {}", r.failures);
        }
    }

    private SimpleMailMessage makeMessage(String to, String subject, String text) {
        SimpleMailMessage mail = new SimpleMailMessage();
        mail.setFrom(getMailUsername());
        mail.setTo(to);
        mail.setSubject(subject);
        mail.setText(text);
        return mail;
    }

    private SendResult brevo(SimpleMailMessage mail) {
        try {
            ObjectNode root = objectMapper.createObjectNode();
            ObjectNode sender = root.putObject("sender");
            sender.put("name", "DentCare");
            sender.put("email", ADMIN_EMAIL);
            ArrayNode to = root.putArray("to");
            ObjectNode recipient = to.addObject();
            recipient.put("email", mail.getTo()[0]);
            root.put("subject", mail.getSubject());
            root.put("textContent", mail.getText());

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(BREVO_URL))
                    .timeout(Duration.ofSeconds(30))
                    .header("accept", "application/json")
                    .header("content-type", "application/json")
                    .header("api-key", brevoApiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(root.toString()))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                SendResult r = new SendResult();
                r.ok = true;
                r.endpoint = "Brevo HTTP API (443) -> HTTP " + response.statusCode();
                return r;
            }
            SendResult r = new SendResult();
            r.ok = false;
            r.failures = "Brevo HTTP " + response.statusCode() + ": " + bodySummary(response.body());
            return r;
        } catch (Exception ex) {
            SendResult r = new SendResult();
            r.ok = false;
            r.failures = "Brevo HTTP " + ex.getClass().getSimpleName() + ": " + ex.getMessage();
            return r;
        }
    }

    private String bodySummary(String body) {
        if (body == null) {
            return "";
        }
        return body.length() > 300 ? body.substring(0, 300) : body;
    }

    private SendResult route(SimpleMailMessage mail) {
        List<String> errors = new ArrayList<>();
        if (!isConfigured()) {
            LOGGER.warn("[MAIL FALLBACK] {} | Subject: {} | {}", mail.getTo()[0], mail.getSubject(), mail.getText());
            SendResult r = new SendResult();
            r.ok = false;
            r.endpoint = "fallback";
            r.failures = "Mail not configured";
            return r;
        }
        if (usesBrevo()) {
            SendResult br = brevo(mail);
            if (br.ok) {
                return br;
            }
            errors.add(br.failures);
        }
        for (JavaMailSender sender : smtpSenders) {
            String ep = sender instanceof JavaMailSenderImpl impl
                    ? impl.getHost() + ":" + impl.getPort()
                    : "unknown";
            try {
                sender.send(mail);
                SendResult r = new SendResult();
                r.ok = true;
                r.endpoint = "SMTP " + ep;
                return r;
            } catch (Exception ex) {
                errors.add(ep + " -> " + ex.getMessage());
            }
        }
        SendResult r = new SendResult();
        r.ok = false;
        r.endpoint = "none";
        r.failures = String.join(" | ", errors);
        return r;
    }

    private static final class SendResult {
        boolean ok;
        String endpoint;
        String failures;
    }
}
