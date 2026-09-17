package com.subrat.clinic.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class MailService {

    public static final String ADMIN_EMAIL = "dentcare.support@gmail.com";

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username:}")
    private String mailUsername;

    public MailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public boolean isConfigured() {
        return mailUsername != null && !mailUsername.isBlank();
    }

    public void sendPasswordReset(String to, String resetLink) {
        if (!isConfigured()) {
            System.out.println(" [MAIL FALLBACK] Password reset link for " + to + ": " + resetLink);
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
        mailSender.send(message);
    }

    public void sendContactMessage(String name, String email, String subject, String message) {
        if (!isConfigured()) {
            System.out.println(" [MAIL FALLBACK] Contact message from " + name + " <" + email + "> | Subject: "
                    + subject + " | " + message);
            return;
        }
        SimpleMailMessage mail = new SimpleMailMessage();
        mail.setFrom(mailUsername);
        mail.setTo(ADMIN_EMAIL);
        mail.setSubject("Website Contact: " + subject);
        mail.setText("Name: " + name + "\nEmail: " + email + "\nSubject: " + subject + "\n\n" + message);
        mailSender.send(mail);
    }
}