package com.subrat.clinic.service;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class MailService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MailService.class);

    public static final String ADMIN_EMAIL = "dentcare.support@gmail.com";

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username:}")
    private String mailUsername;

    @Value("${spring.mail.host:}")
    private String mailHost;

    @Value("${spring.mail.port:587}")
    private String mailPort;

    public MailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    @PostConstruct
    public void logConfig() {
        LOGGER.info("[MAIL] SMTP configured={} host={} port={} username={}",
                isConfigured(), mailHost, mailPort, isConfigured() ? mailUsername : "(empty)");
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
        try {
            mailSender.send(mail);
            LOGGER.info("[MAIL] Test email sent to {}", ADMIN_EMAIL);
            return null;
        } catch (Exception ex) {
            LOGGER.error("[MAIL] Test email FAILED", ex);
            return ex.getMessage();
        }
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
        send("password reset", message);
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
        send("contact notification", mail);
    }

    private void send(String what, SimpleMailMessage message) {
        try {
            mailSender.send(message);
            LOGGER.info("[MAIL] Sent {} to {}", what, message.getTo()[0]);
        } catch (Exception ex) {
            LOGGER.error("[MAIL] FAILED to send " + what + " to "
                    + (message.getTo() != null && message.getTo().length > 0 ? message.getTo()[0] : "?")
                    + " - check MAIL_USERNAME/MAIL_PASSWORD app password", ex);
        }
    }
}