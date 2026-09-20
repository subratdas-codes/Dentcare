package com.subrat.clinic.service;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

@Service
public class MailService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MailService.class);

    public static final String ADMIN_EMAIL = "dentcare.support@gmail.com";

    @Value("${spring.mail.username:}")
    private String mailUsername;

    @Value("${spring.mail.password:}")
    private String mailPassword;

    private final List<JavaMailSender> senders = new ArrayList<>();

    public MailService() {
    }

    @PostConstruct
    public void init() {
        if (isConfigured()) {
            senders.add(build("smtp.gmail.com", 465, true));
            senders.add(build("smtp.gmail.com", 587, false));
            LOGGER.info("[MAIL] SMTP configured=true username={} endpoints=smtp.gmail.com:465(SSL), smtp.gmail.com:587(STARTTLS)",
                    mailUsername);
        } else {
            LOGGER.warn("[MAIL] SMTP configured=false - MAIL_USERNAME / MAIL_PASSWORD not set");
        }
    }

    private JavaMailSender build(String host, int port, boolean ssl) {
        JavaMailSenderImpl sender = new JavaMailSenderImpl();
        sender.setHost(host);
        sender.setPort(port);
        sender.setProtocol("smtp");
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
            props.put("mail.smtp.starttls.enable", "false");
        } else {
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.enable", "false");
        }
        return sender;
    }

    public boolean isConfigured() {
        return mailUsername != null && !mailUsername.isBlank();
    }

    public String getMailUsername() {
        return mailUsername;
    }

    public String sendTest() {
        if (!isConfigured()) {
            return "Mail is NOT configured - Render env vars MAIL_USERNAME / MAIL_PASSWORD are empty or not set.";
        }
        SimpleMailMessage mail = new SimpleMailMessage();
        mail.setFrom(mailUsername);
        mail.setTo(ADMIN_EMAIL);
        mail.setSubject("DentCare mail test");
        mail.setText("If you can read this, DentCare email sending is working correctly.");
        SendOutcome outcome = route(mail);
        if (outcome.ok) {
            LOGGER.info("[MAIL] Test email sent to {} via {}", ADMIN_EMAIL, outcome.endpoint);
            return "Sent OK (via " + outcome.endpoint + ") - check dentcare.support@gmail.com inbox (and spam) now.";
        }
        LOGGER.error("[MAIL] Test email FAILED: {}", outcome.failures);
        return "FAILED: " + outcome.failures;
    }

    public void sendPasswordReset(String to, String resetLink) {
        if (!isConfigured()) {
            LOGGER.warn("[MAIL FALLBACK] Password reset link for {}: {}", to, resetLink);
            return;
        }
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(mailUsername);
        message.setTo(to);
        message.setSubject("Reset your DentCare password");
        message.setText("Hello,\n\n" +
                "You requested a password reset for your DentCare account.\n\n" +
                "Open the link below to choose a new password (valid for 30 minutes):\n" +
                resetLink + "\n\n" +
                "If you did not request this, you can safely ignore this email.\n\n" +
                "DentCare Support");
        SendOutcome outcome = route(message);
        if (outcome.ok) {
            LOGGER.info("[MAIL] Sent password reset to {} via {}", to, outcome.endpoint);
        } else {
            LOGGER.error("[MAIL] Password reset send FAILED to {}: {}", to, outcome.failures);
        }
    }

    public void sendContactMessage(String name, String email, String subject, String message) {
        if (!isConfigured()) {
            LOGGER.warn("[MAIL FALLBACK] Contact message from {} <{}> | Subject: {} | {}", name, email, subject, message);
            return;
        }
        SimpleMailMessage mail = new SimpleMailMessage();
        mail.setFrom(mailUsername);
        mail.setTo(ADMIN_EMAIL);
        mail.setSubject("Website Contact: " + subject);
        mail.setText("Name: " + name + "\nEmail: " + email + "\nSubject: " + subject + "\n\n" + message);
        SendOutcome outcome = route(mail);
        if (outcome.ok) {
            LOGGER.info("[MAIL] Sent contact notification via {}", outcome.endpoint);
        } else {
            LOGGER.error("[MAIL] Contact notification send FAILED: {}", outcome.failures);
        }
    }

    private static final class SendOutcome {
        boolean ok;
        String endpoint;
        String failures;
    }

    private SendOutcome route(SimpleMailMessage message) {
        List<String> errors = new ArrayList<>();
        for (int i = 0; i < senders.size(); i++) {
            JavaMailSender sender = senders.get(i);
            String ep = (i == 0 ? "smtp.gmail.com:465 (SSL)" : "smtp.gmail.com:587 (STARTTLS)");
            try {
                sender.send(message);
                SendOutcome o = new SendOutcome();
                o.ok = true;
                o.endpoint = ep;
                return o;
            } catch (Exception ex) {
                errors.add(ep + " -> " + ex.getMessage());
            }
        }
        SendOutcome o = new SendOutcome();
        o.ok = false;
        o.failures = String.join(" | ", errors);
        return o;
    }
}