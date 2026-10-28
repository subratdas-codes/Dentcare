package com.subrat.clinic.controller;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.service.AppointmentService;
import com.subrat.clinic.service.DoctorPhotoStorage;
import com.subrat.clinic.service.DoctorService;
import com.subrat.clinic.service.PatientService;
import java.io.IOException;
import java.util.List;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/** Dedicated, separate doctor portal. It never shares a login with the admin portal. */
@Controller
@RequestMapping("/doctor")
public class DoctorPortalController {

    private final DoctorService doctorService;
    private final PatientService patientService;
    private final AppointmentService appointmentService;
    private final PasswordEncoder passwordEncoder;
    private final DoctorPhotoStorage doctorPhotoStorage;

    public DoctorPortalController(DoctorService doctorService,
                                  PatientService patientService,
                                  AppointmentService appointmentService,
                                  PasswordEncoder passwordEncoder,
                                  DoctorPhotoStorage doctorPhotoStorage) {
        this.doctorService = doctorService;
        this.patientService = patientService;
        this.appointmentService = appointmentService;
        this.passwordEncoder = passwordEncoder;
        this.doctorPhotoStorage = doctorPhotoStorage;
    }

    @GetMapping({"", "/"})
    public String root(Authentication authentication) {
        return isDoctor(authentication)
                ? "redirect:/doctor/dashboard"
                : "redirect:/doctor/login";
    }

    @GetMapping("/login")
    public String login(Authentication authentication, Model model) {
        if (isDoctor(authentication)) {
            return "redirect:/doctor/dashboard";
        }
        model.addAttribute("selectedRole", "DOCTOR");
        return "admin/login";
    }

    @GetMapping("/register")
    public String registerForm(Model model) {
        model.addAttribute("doctor", new Doctor());
        return "admin/doctor_register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute Doctor doctor, Model model) {
        String email = doctor.getEmail() == null ? "" : doctor.getEmail().trim().toLowerCase();
        if (doctor.getName() == null || doctor.getName().isBlank()
                || doctor.getPassword() == null || doctor.getPassword().length() < 8) {
            model.addAttribute("error", "Enter your full name and a password of at least 8 characters.");
            model.addAttribute("doctor", doctor);
            return "admin/doctor_register";
        }
        if (doctorService.findByEmail(email) != null || patientService.findByEmail(email) != null) {
            model.addAttribute("error", "An account with this email already exists.");
            model.addAttribute("doctor", doctor);
            return "admin/doctor_register";
        }
        doctor.setEmail(email);
        doctor.setName(doctor.getName().trim());
        doctor.setAdmin(false);
        doctor.setPassword(passwordEncoder.encode(doctor.getPassword()));
        doctorService.save(doctor);
        return "redirect:/doctor/login?registered=true";
    }

    @GetMapping("/forgot-password")
    public String forgotPassword(Model model) {
        model.addAttribute("selectedRole", "DOCTOR");
        return "admin/forgot_password";
    }

    @PostMapping("/forgot-password")
    public String forgotPasswordPost(@RequestParam String email, Model model) {
        model.addAttribute("selectedRole", "DOCTOR");
        model.addAttribute("success", "If an account exists for that email, a password reset link has been sent.");
        return "admin/forgot_password";
    }

    @GetMapping("/reset-password")
    public String resetPassword(Model model) {
        model.addAttribute("selectedRole", "DOCTOR");
        return "admin/reset_password";
    }

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        return populateDashboard(authentication, model);
    }

    @GetMapping("/appointments")
    public String appointments(Authentication authentication, Model model) {
        Doctor doctor = requireDoctor(authentication);
        if (doctor == null) {
            return "redirect:/doctor/login";
        }
        model.addAttribute("appointments", appointmentService.findByDoctorName(doctor.getName()));
        return "admin/appointment_list";
    }

    @GetMapping("/profile")
    public String profile(Authentication authentication, Model model) {
        Doctor doctor = requireDoctor(authentication);
        if (doctor == null) {
            return "redirect:/doctor/login";
        }
        model.addAttribute("doctor", doctor);
        return "admin/profile";
    }

    @PostMapping(value = "/profile", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public String updateProfile(Authentication authentication,
                                @RequestParam String phone,
                                @RequestParam String specialization,
                                @RequestParam(required = false, defaultValue = "") String description,
                                @RequestParam(required = false) MultipartFile photo,
                                RedirectAttributes redirectAttributes) {
        Doctor doctor = requireDoctor(authentication);
        if (doctor == null) {
            return "redirect:/doctor/login";
        }
        if (phone.length() > 40 || specialization.isBlank() || specialization.length() > 120
                || description.length() > 2000) {
            redirectAttributes.addFlashAttribute("error", "Please check the profile fields and try again.");
            return "redirect:/doctor/profile";
        }

        String priorPhoto = doctor.getProfileImagePath();
        try {
            if (photo != null && !photo.isEmpty()) {
                doctor.setProfileImagePath(doctorPhotoStorage.save(photo));
            }
        } catch (IOException | IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("error", exception.getMessage());
            return "redirect:/doctor/profile";
        }

        doctor.setPhone(phone.trim());
        doctor.setSpecialization(specialization.trim());
        doctor.setDescription(description.trim());
        doctorService.save(doctor);
        if (photo != null && !photo.isEmpty() && priorPhoto != null) {
            doctorPhotoStorage.delete(priorPhoto);
        }
        redirectAttributes.addFlashAttribute("success", "Your profile has been updated.");
        return "redirect:/doctor/profile";
    }

    @GetMapping("/change-password")
    public String changePasswordForm(Authentication authentication) {
        return requireDoctor(authentication) == null
                ? "redirect:/doctor/login"
                : "admin/change_password";
    }

    @PostMapping("/change-password")
    public String changePassword(Authentication authentication,
                                 @RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 Model model) {
        Doctor doctor = requireDoctor(authentication);
        if (doctor == null) {
            return "redirect:/doctor/login";
        }
        if (!passwordEncoder.matches(currentPassword, doctor.getPassword())) {
            model.addAttribute("error", "Current password is incorrect.");
        } else if (newPassword.length() < 8) {
            model.addAttribute("error", "Use a password with at least 8 characters.");
        } else if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "The new passwords do not match.");
        } else {
            doctor.setPassword(passwordEncoder.encode(newPassword));
            doctorService.save(doctor);
            model.addAttribute("success", "Password changed successfully.");
        }
        return "admin/change_password";
    }

    private String populateDashboard(Authentication authentication, Model model) {
        Doctor doctor = requireDoctor(authentication);
        if (doctor == null) {
            return "redirect:/doctor/login";
        }

        List<Appointment> appointments = appointmentService.findByDoctorName(doctor.getName());
        long assignedPatientCount = appointments.stream()
                .map(Appointment::getEmail)
                .filter(email -> email != null && !email.isBlank())
                .distinct()
                .count();
        model.addAttribute("doctor", doctor);
        model.addAttribute("appointments", appointments);
        model.addAttribute("appointmentCount", appointments.size());
        model.addAttribute("patientCount", assignedPatientCount);
        return "admin/doctor_dashboard";
    }

    private Doctor requireDoctor(Authentication authentication) {
        if (!isDoctor(authentication)) {
            return null;
        }
        Doctor doctor = doctorService.findByEmail(authentication.getName());
        return doctor != null && !doctor.isAdmin() ? doctor : null;
    }

    private boolean isDoctor(Authentication authentication) {
        return authentication != null && authentication.getAuthorities().stream()
                .anyMatch(authority -> "ROLE_DOCTOR".equals(authority.getAuthority()));
    }
}
