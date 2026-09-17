package com.subrat.clinic.controller;

import com.subrat.clinic.model.Patient;
import com.subrat.clinic.model.PasswordResetToken;
import com.subrat.clinic.repository.PasswordResetTokenRepository;
import com.subrat.clinic.service.MailService;
import com.subrat.clinic.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Controller
public class AuthenticationController {

    @Autowired
    private PatientService patientService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    @Autowired
    private MailService mailService;

    @Value("${app.reset-link-base:http://localhost:8080}")
    private String resetLinkBase;

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("patient", new Patient());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute Patient patient,
                               @RequestParam String confirmPassword,
                               Model model) {
        if (!patient.getPassword().equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match.");
            return "register";
        }
        if (patientService.findByEmail(patient.getEmail()) != null) {
            model.addAttribute("error", "An account with this email already exists.");
            return "register";
        }
        patient.setPassword(passwordEncoder.encode(patient.getPassword()));
        patientService.save(patient);
        return "redirect:/login?registered=true";
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }

    @GetMapping("/profile")
    public String showProfile(Authentication authentication, Model model) {
        Patient patient = patientService.findByEmail(authentication.getName());
        if (patient == null) return "redirect:/login";
        model.addAttribute("patient", patient);
        return "profile";
    }

    @GetMapping("/change-password")
    public String showChangePasswordForm() {
        return "change_password";
    }

    @PostMapping("/change-password")
    public String changePassword(Authentication authentication,
                                 @RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 Model model) {

        Patient user = patientService.findByEmail(authentication.getName());
        if (user == null) return "redirect:/login";

        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            model.addAttribute("error", "Old password is incorrect.");
            return "change_password";
        }
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "New passwords do not match.");
            return "change_password";
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        patientService.save(user);
        model.addAttribute("success", "Password changed successfully!");
        return "change_password";
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "forgot_password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam String email, Model model) {
        Patient patient = patientService.findByEmail(email);
        if (patient != null) {
            PasswordResetToken existing = tokenRepository.findByEmail(email);
            if (existing != null) {
                tokenRepository.delete(existing);
            }

            PasswordResetToken resetToken = new PasswordResetToken();
            resetToken.setToken(UUID.randomUUID().toString());
            resetToken.setEmail(email);
            resetToken.setExpiryDate(LocalDateTime.now().plusMinutes(30));
            tokenRepository.save(resetToken);

            String link = resetLinkBase + "/reset-password?token=" + resetToken.getToken();
            mailService.sendPasswordReset(email, link);
        }
        model.addAttribute("success",
                "If an account exists for that email, a password reset link has been sent.");
        return "forgot_password";
    }

    @GetMapping("/reset-password")
    public String showResetPasswordForm(@RequestParam String token, Model model) {
        PasswordResetToken resetToken = tokenRepository.findByToken(token);
        if (resetToken == null || resetToken.isExpired()) {
            model.addAttribute("error", "The reset link is invalid or has expired.");
            return "reset_password";
        }
        model.addAttribute("token", token);
        return "reset_password";
    }

    @PostMapping("/reset-password")
    public String processResetPassword(@RequestParam String token,
                                       @RequestParam String newPassword,
                                       @RequestParam String confirmPassword,
                                       Model model) {
        PasswordResetToken resetToken = tokenRepository.findByToken(token);
        if (resetToken == null || resetToken.isExpired()) {
            model.addAttribute("error", "The reset link is invalid or has expired.");
            return "reset_password";
        }
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match.");
            model.addAttribute("token", token);
            return "reset_password";
        }
        Patient patient = patientService.findByEmail(resetToken.getEmail());
        if (patient == null) {
            model.addAttribute("error", "No account found for this request.");
            return "reset_password";
        }
        patient.setPassword(passwordEncoder.encode(newPassword));
        patientService.save(patient);
        tokenRepository.delete(resetToken);
        return "redirect:/login?reset=true";
    }
}