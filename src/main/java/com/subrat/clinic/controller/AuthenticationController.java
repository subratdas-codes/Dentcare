package com.subrat.clinic.controller;

import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.model.Patient;
import com.subrat.clinic.model.PasswordResetToken;
import com.subrat.clinic.repository.DoctorRepository;
import com.subrat.clinic.repository.PasswordResetTokenRepository;
import com.subrat.clinic.service.MailService;
import com.subrat.clinic.service.PatientService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.time.LocalDateTime;
import java.util.Locale;
import java.util.UUID;

@Controller
public class AuthenticationController {

    @Autowired
    private PatientService patientService;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    @Autowired
    private MailService mailService;

    @Value("${app.reset-link-base:}")
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
        if (patient.getPassword() == null || !patient.getPassword().equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match.");
            model.addAttribute("patient", patient);
            return "register";
        }
        if (patient.getPassword().length() < 8) {
            model.addAttribute("error", "Use a password with at least 8 characters.");
            model.addAttribute("patient", patient);
            return "register";
        }
        if (patient.getEmail() == null || patient.getEmail().trim().isEmpty()) {
            model.addAttribute("error", "Email address is required.");
            model.addAttribute("patient", patient);
            return "register";
        }
        patient.setEmail(patient.getEmail().trim().toLowerCase(Locale.ROOT));
        if (patientService.findByEmail(patient.getEmail()) != null
                || doctorRepository.findByEmail(patient.getEmail()) != null) {
            model.addAttribute("error", "An account with this email already exists.");
            model.addAttribute("patient", patient);
            return "register";
        }
        if (patient.getName() == null || patient.getName().trim().isEmpty()) {
            model.addAttribute("error", "Full name is required.");
            model.addAttribute("patient", patient);
            return "register";
        }
        patient.setName(patient.getName().trim());
        if (patient.getPhone() != null && patient.getPhone().trim().isEmpty()) {
            patient.setPhone(null);
        }
        patient.setPassword(passwordEncoder.encode(patient.getPassword()));
        patientService.save(patient);
        return "redirect:/login?registered=true";
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }

    @GetMapping("/portal")
    public String showPortalChooser(Authentication authentication) {
        if (authentication != null) {
            boolean admin = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
            boolean doctor = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_DOCTOR"));
            boolean patient = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_USER"));
            if (admin) {
                return "redirect:/admin/dashboard";
            }
            if (doctor) {
                return "redirect:/doctor/dashboard";
            }
            if (patient) {
                return "redirect:/";
            }
        }
        return "portal_chooser";
    }

    @GetMapping("/profile")
    public String showProfile(Authentication authentication, Model model) {
        Patient patient = currentPatient(authentication);
        if (patient == null) {
            return "redirect:/login";
        }
        model.addAttribute("patient", patient);
        return "profile";
    }

    @PostMapping("/profile")
    public String updateProfile(Authentication authentication,
                                @RequestParam String name,
                                @RequestParam(required = false) String phone,
                                @RequestParam(defaultValue = "0") int age,
                                RedirectAttributes redirectAttributes) {
        Patient patient = currentPatient(authentication);
        if (patient == null) {
            return "redirect:/login";
        }
        if (name == null || name.trim().length() < 2 || name.trim().length() > 120) {
            redirectAttributes.addFlashAttribute("error", "Enter your full name (2-120 characters).");
            return "redirect:/profile";
        }
        if (phone != null && phone.trim().length() > 40) {
            redirectAttributes.addFlashAttribute("error", "Phone number is too long.");
            return "redirect:/profile";
        }
        if (age < 0 || age > 120) {
            redirectAttributes.addFlashAttribute("error", "Enter a valid age between 0 and 120.");
            return "redirect:/profile";
        }
        patient.setName(name.trim());
        patient.setPhone(phone == null || phone.trim().isEmpty() ? null : phone.trim());
        patient.setAge(age);
        patientService.save(patient);
        redirectAttributes.addFlashAttribute("success", "Your personal details were updated.");
        return "redirect:/profile";
    }

    @GetMapping("/change-password")
    public String showChangePasswordForm() {
        return "redirect:/profile?tab=security";
    }

    @PostMapping("/change-password")
    public String changePassword(Authentication authentication,
                                 @RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 RedirectAttributes redirectAttributes) {
        return changePasswordInternal(authentication, oldPassword, newPassword, confirmPassword, redirectAttributes);
    }

    @PostMapping("/profile/password")
    public String changeProfilePassword(Authentication authentication,
                                        @RequestParam String oldPassword,
                                        @RequestParam String newPassword,
                                        @RequestParam String confirmPassword,
                                        RedirectAttributes redirectAttributes) {
        return changePasswordInternal(authentication, oldPassword, newPassword, confirmPassword, redirectAttributes);
    }

    private String changePasswordInternal(Authentication authentication,
                                          String oldPassword,
                                          String newPassword,
                                          String confirmPassword,
                                          RedirectAttributes redirectAttributes) {
        Patient user = currentPatient(authentication);
        if (user == null) {
            return "redirect:/login";
        }
        if (!passwordEncoder.matches(oldPassword == null ? "" : oldPassword, user.getPassword())) {
            redirectAttributes.addFlashAttribute("passwordError", "Your current password is incorrect.");
            return "redirect:/profile?tab=security";
        }
        if (newPassword == null || newPassword.length() < 8) {
            redirectAttributes.addFlashAttribute("passwordError", "Use a new password with at least 8 characters.");
            return "redirect:/profile?tab=security";
        }
        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("passwordError", "The new passwords do not match.");
            return "redirect:/profile?tab=security";
        }
        if (passwordEncoder.matches(newPassword, user.getPassword())) {
            redirectAttributes.addFlashAttribute("passwordError", "Choose a password different from the current one.");
            return "redirect:/profile?tab=security";
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        patientService.save(user);
        redirectAttributes.addFlashAttribute("passwordSuccess", "Password changed successfully.");
        return "redirect:/profile?tab=security";
    }

    @GetMapping({"/forgot-password", "/admin/forgot-password", "/doctor/forgot-password"})
    public String showForgotPasswordForm(HttpServletRequest request, Model model) {
        model.addAttribute("portal", portalFromRequest(request));
        return "forgot_password";
    }

    @PostMapping({"/forgot-password", "/admin/forgot-password", "/doctor/forgot-password"})
    public String processForgotPassword(@RequestParam String email,
                                        HttpServletRequest request,
                                        Model model) {
        String normalized = email == null ? "" : email.trim().toLowerCase(Locale.ROOT);
        String accountType = findAccountType(normalized);
        if (accountType != null) {
            PasswordResetToken existing = tokenRepository.findByEmail(normalized);
            if (existing != null) {
                tokenRepository.delete(existing);
            }

            PasswordResetToken resetToken = new PasswordResetToken();
            resetToken.setToken(UUID.randomUUID().toString());
            resetToken.setEmail(normalized);
            resetToken.setAccountType(accountType);
            resetToken.setExpiryDate(LocalDateTime.now().plusMinutes(30));
            tokenRepository.save(resetToken);

            mailService.sendPasswordReset(normalized, buildResetLink(request, resetToken.getToken()));
        }
        model.addAttribute("portal", portalFromRequest(request));
        model.addAttribute("success",
                "If an account exists for that email, a password reset link has been sent. The link is valid for 30 minutes.");
        return "forgot_password";
    }

    @GetMapping({"/reset-password", "/admin/reset-password", "/doctor/reset-password"})
    public String showResetPasswordForm(@RequestParam(required = false) String token,
                                        HttpServletRequest request,
                                        Model model) {
        model.addAttribute("portal", portalFromRequest(request));
        if (token == null || token.isBlank()) {
            model.addAttribute("error", "The reset link is invalid or has expired. Request a new link.");
            return "reset_password";
        }
        PasswordResetToken resetToken = tokenRepository.findByToken(token.trim());
        if (resetToken == null || resetToken.isExpired()) {
            model.addAttribute("error", "The reset link is invalid or has expired. Request a new link.");
            return "reset_password";
        }
        model.addAttribute("token", token.trim());
        model.addAttribute("portal", portalForAccountType(resetToken.getAccountType()));
        return "reset_password";
    }

    @PostMapping({"/reset-password", "/admin/reset-password", "/doctor/reset-password"})
    public String processResetPassword(@RequestParam(required = false) String token,
                                       @RequestParam(required = false) String newPassword,
                                       @RequestParam(required = false) String confirmPassword,
                                       HttpServletRequest request,
                                       Model model) {
        model.addAttribute("portal", portalFromRequest(request));
        PasswordResetToken resetToken = token == null || token.isBlank()
                ? null
                : tokenRepository.findByToken(token.trim());
        if (resetToken == null || resetToken.isExpired()) {
            model.addAttribute("error", "The reset link is invalid or has expired. Request a new link.");
            return "reset_password";
        }
        String accountType = resetToken.getAccountType();
        model.addAttribute("portal", portalForAccountType(accountType));
        model.addAttribute("token", token.trim());
        if (newPassword == null || newPassword.length() < 8) {
            model.addAttribute("error", "Use a password with at least 8 characters.");
            return "reset_password";
        }
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match.");
            return "reset_password";
        }
        if ("PATIENT".equals(accountType)) {
            Patient patient = patientService.findByEmail(resetToken.getEmail());
            if (patient == null) {
                model.addAttribute("error", "No account found for this request.");
                return "reset_password";
            }
            patient.setPassword(passwordEncoder.encode(newPassword));
            patientService.save(patient);
        } else {
            Doctor doctor = doctorRepository.findByEmail(resetToken.getEmail());
            if (doctor == null) {
                model.addAttribute("error", "No account found for this request.");
                return "reset_password";
            }
            doctor.setPassword(passwordEncoder.encode(newPassword));
            doctorRepository.save(doctor);
        }
        tokenRepository.delete(resetToken);
        return switch (accountType) {
            case "ADMIN" -> "redirect:/admin/login?reset=true";
            case "DOCTOR" -> "redirect:/doctor/login?reset=true";
            default -> "redirect:/login?reset=true";
        };
    }

    private String findAccountType(String email) {
        if (patientService.findByEmail(email) != null) {
            return "PATIENT";
        }
        Doctor doctor = doctorRepository.findByEmail(email);
        if (doctor != null) {
            return doctor.isAdmin() ? "ADMIN" : "DOCTOR";
        }
        return null;
    }

    private String portalFromRequest(HttpServletRequest request) {
        String uri = request.getRequestURI();
        if (uri.contains("/admin/")) {
            return "ADMIN";
        }
        if (uri.contains("/doctor/")) {
            return "DOCTOR";
        }
        return "PATIENT";
    }

    private String portalForAccountType(String accountType) {
        return switch (accountType == null ? "PATIENT" : accountType) {
            case "ADMIN" -> "ADMIN";
            case "DOCTOR" -> "DOCTOR";
            default -> "PATIENT";
        };
    }

    private String buildResetLink(HttpServletRequest request, String token) {
        String configuredBase = resetLinkBase == null ? "" : resetLinkBase.trim();
        if (!configuredBase.isEmpty()
                && !configuredBase.contains("localhost")
                && !configuredBase.contains("127.0.0.1")) {
            return configuredBase.replaceAll("/+$", "") + "/reset-password?token=" + token;
        }
        return ServletUriComponentsBuilder.fromContextPath(request)
                .path("/reset-password")
                .queryParam("token", token)
                .build()
                .toUriString();
    }

    private Patient currentPatient(Authentication authentication) {
        if (authentication == null) {
            return null;
        }
        return patientService.findByEmail(authentication.getName());
    }
}
