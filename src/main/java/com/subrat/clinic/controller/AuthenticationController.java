package com.subrat.clinic.controller;

import com.subrat.clinic.model.Patient;
import com.subrat.clinic.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthenticationController {

    @Autowired
    private PatientService patientService;

    @Autowired
    private PasswordEncoder passwordEncoder;

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
}