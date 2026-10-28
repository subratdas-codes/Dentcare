package com.subrat.clinic.controller;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.service.AppointmentService;
import com.subrat.clinic.service.DoctorPhotoStorage;
import com.subrat.clinic.service.DoctorService;
import com.subrat.clinic.service.MailService;
import com.subrat.clinic.service.PatientService;
import java.io.IOException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class DoctorController {

    @GetMapping("/login")
    public String adminLogin(Authentication authentication, Model model) {
        if (hasAdminRole(authentication)) {
            return "redirect:/admin/dashboard";
        }
        model.addAttribute("selectedRole", "ADMIN");
        return "admin/login";
    }

    @GetMapping("/login/admin")
    public String adminLoginSelected(Authentication authentication, Model model) {
        if (hasAdminRole(authentication)) {
            return "redirect:/admin/dashboard";
        }
        model.addAttribute("selectedRole", "ADMIN");
        return "admin/login";
    }

    @GetMapping("/login/doctor")
    public String doctorLoginSelected() {
        return "redirect:/doctor/login";
    }

    @GetMapping("/forgot-password")
    public String adminForgotPassword() {
        return "admin/forgot_password";
    }

    @PostMapping("/forgot-password")
    public String adminForgotPasswordPost(@RequestParam String email, Model model) {
        model.addAttribute("success", "If an account exists for that email, a password reset link has been sent.");
        return "admin/forgot_password";
    }

    @GetMapping("/reset-password")
    public String adminResetPassword() {
        return "admin/reset_password";
    }

    @GetMapping("/debug")
    @org.springframework.web.bind.annotation.ResponseBody
    public String debug() {
        return "ok";
    }

    @GetMapping({"/doctor", "/doctor/dashboard", "/doctor-dashboard"})
    public String legacyDoctorDashboard() {
        return "redirect:/doctor/dashboard";
    }

    @Autowired
    private DoctorService doctorService;

    @Autowired
    private PatientService patientService;

    @Autowired
    private AppointmentService appointmentService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private DoctorPhotoStorage doctorPhotoStorage;

    @Autowired
    private MailService mailService;

    @GetMapping("/register")
    public String doctorRegisterForm() {
        return "redirect:/doctor/register";
    }

    @PostMapping("/register")
    public String doctorRegister() {
        return "redirect:/doctor/register";
    }

    @GetMapping({"", "/"})
    public String adminRoot(Authentication authentication) {
        return hasAdminRole(authentication)
                ? "redirect:/admin/dashboard"
                : "redirect:/admin/login";
    }

    @GetMapping("/dashboard")
    public String adminDashboard(Authentication authentication, Model model) {
        if (!hasAdminRole(authentication)) {
            return "redirect:/admin/login";
        }
        List<Appointment> appointments = appointmentService.getAll();
        model.addAttribute("doctorCount", doctorService.findAll().size());
        model.addAttribute("patientCount", patientService.getAll().size());
        model.addAttribute("appointmentCount", appointments.size());
        model.addAttribute("doctors", doctorService.findAll());
        model.addAttribute("appointments", appointments);
        model.addAttribute("patients", patientService.getAll());
        return "admin/dashboard";
    }

    private boolean hasAdminRole(Authentication authentication) {
        return authentication != null && authentication.getAuthorities().stream()
                .anyMatch(authority -> "ROLE_ADMIN".equals(authority.getAuthority()));
    }

    // ---------------- DOCTOR CRUD ---------------- //

    @GetMapping("/doctors")
    public String listDoctors(Model model) {
        model.addAttribute("doctors", doctorService.findAll());
        return "admin/doctor_list";
    }

    @GetMapping("/doctors/add")
    public String addDoctorForm(Model model) {
        model.addAttribute("doctor", new Doctor());
        return "admin/doctor_form";
    }

    @GetMapping("/doctors/edit/{id}")
    public String editDoctor(@PathVariable Long id, Model model) {
        model.addAttribute("doctor", doctorService.findById(id));
        return "admin/doctor_form";
    }

    @PostMapping("/doctors/save")
    public String saveDoctor(@ModelAttribute Doctor doctor) {
        Doctor existing = doctor.getId() != null ? doctorService.findById(doctor.getId()) : null;
        String email = doctor.getEmail() == null ? "" : doctor.getEmail().trim().toLowerCase();
        if (email.isEmpty()) {
            return "redirect:/admin/doctors?error=email";
        }
        Doctor byEmail = doctorService.findByEmail(email);
        if (byEmail != null && (existing == null || !byEmail.getId().equals(doctor.getId()))) {
            return "redirect:/admin/doctors?error=duplicate";
        }
        if (patientService.findByEmail(email) != null) {
            return "redirect:/admin/doctors?error=duplicatePatient";
        }
        doctor.setEmail(email);
        if (doctor.getPassword() == null || doctor.getPassword().isBlank()) {
            if (existing != null) {
                doctor.setPassword(existing.getPassword());
            }
        } else {
            doctor.setPassword(passwordEncoder.encode(doctor.getPassword()));
        }
        if (existing != null) {
            if (doctor.getDescription() == null) doctor.setDescription(existing.getDescription());
            if (doctor.getProfileImagePath() == null) doctor.setProfileImagePath(existing.getProfileImagePath());
        }
        doctorService.save(doctor);
        return "redirect:/admin/doctors";
    }

    @PostMapping("/doctors/delete/{id}")
    public String deleteDoctor(@PathVariable Long id) {
        doctorService.deleteById(id);
        return "redirect:/admin/doctors";
    }

    // ---------------- PATIENT VIEW ---------------- //

    @GetMapping("/patients")
    public String listPatients(Model model,
                                @RequestParam(value = "q", required = false) String query) {
        List<com.subrat.clinic.model.Patient> patients = patientService.getAll();
        if (query != null && !query.trim().isEmpty()) {
            String q = query.trim().toLowerCase();
            patients = patients.stream()
                    .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(q))
                            || (p.getEmail() != null && p.getEmail().toLowerCase().contains(q))
                            || (p.getPhone() != null && p.getPhone().toLowerCase().contains(q)))
                    .toList();
            model.addAttribute("q", query.trim());
        }
        model.addAttribute("patients", patients);
        return "admin/patient_list";
    }

    @GetMapping("/patients/edit/{id}")
    public String editPatient(@PathVariable Long id, Model model) {
        model.addAttribute("patient", patientService.getById(id));
        return "admin/patient_form";
    }

    @PostMapping("/patients/save")
    public String savePatient(@ModelAttribute com.subrat.clinic.model.Patient patient) {
        com.subrat.clinic.model.Patient existing = patient.getId() != null ? patientService.getById(patient.getId()) : null;
        if (patient.getPassword() == null || patient.getPassword().isBlank()) {
            if (existing != null) {
                patient.setPassword(existing.getPassword());
            }
        } else {
            patient.setPassword(passwordEncoder.encode(patient.getPassword()));
        }
        if (existing != null && (patient.getPassword() == null || patient.getPassword().isBlank())) {
            patient.setPassword(existing.getPassword());
        }
        patientService.save(patient);
        return "redirect:/admin/patients";
    }

    @GetMapping("/patients/delete/{id}")
    public String deletePatient(@PathVariable Long id) {
        patientService.deleteById(id);
        return "redirect:/admin/patients";
    }

    // ---------------- APPOINTMENT CRUD ---------------- //

    @GetMapping("/appointments")
    public String listAppointments(Model model) {
        model.addAttribute("appointments", appointmentService.getAll());
        return "admin/appointment_list";
    }

    @GetMapping("/appointments/edit/{id}")
    public String editAppointment(@PathVariable Long id, Model model) {
        model.addAttribute("appointment", appointmentService.getById(id));
        return "admin/edit_appointment";  // JSP: edit_appointment.jsp
    }

    @PostMapping("/appointments/update")
    public String updateAppointment(@ModelAttribute Appointment appointment) {
        appointmentService.save(appointment);  // save() works for both create/update
        return "redirect:/admin/appointments";
    }

    @PostMapping("/appointments/delete/{id}")
    public String deleteAppointment(@PathVariable Long id) {
        appointmentService.deleteById(id);
        return "redirect:/admin/appointments";
    }

    // ---------------- MAIL TEST ---------------- //

    @GetMapping("/mail-test")
    public String mailTest(Model model) {
        model.addAttribute("configured", mailService.isConfigured());
        model.addAttribute("mailUsername", mailService.getMailUsername());
        return "admin/mail_test";
    }

    @PostMapping("/mail-test/send")
    public String mailTestSend(Model model) {
        String error = mailService.sendTest();
        model.addAttribute("sendResult",
                error == null
                        ? "Sent OK - check dentcare.support@gmail.com inbox (and spam) now."
                        : "FAILED: " + error);
        model.addAttribute("configured", mailService.isConfigured());
        model.addAttribute("mailUsername", mailService.getMailUsername());
        return "admin/mail_test";
    }

    @PostMapping("/mail-test/connect")
    public String mailTestConnect(Model model) {
        model.addAttribute("connectResult", mailService.runConnectivityCheck());
        model.addAttribute("configured", mailService.isConfigured());
        model.addAttribute("mailUsername", mailService.getMailUsername());
        return "admin/mail_test";
    }

    @GetMapping("/pricing")
    public String pricing(Model model) {
        return "admin/pricing";
    }

    @GetMapping("/invoices")
    public String invoices(Model model) {
        model.addAttribute("appointments", appointmentService.getAll());
        return "admin/invoices";
    }

    @GetMapping("/profile")
    public String profile(Authentication authentication, Model model) {
        Doctor doctor = doctorService.findByEmail(authentication.getName());
        if (doctor == null) return "redirect:/admin/login";
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
        Doctor doctor = doctorService.findByEmail(authentication.getName());
        if (doctor == null) return "redirect:/admin/login";
        if (phone.length() > 40 || specialization.isBlank() || specialization.length() > 120
                || description.length() > 2000) {
            redirectAttributes.addFlashAttribute("error", "Please check the profile fields and try again.");
            return "redirect:/admin/profile";
        }

        String priorPhoto = doctor.getProfileImagePath();
        try {
            if (photo != null && !photo.isEmpty()) {
                doctor.setProfileImagePath(doctorPhotoStorage.save(photo));
            }
        } catch (IOException | IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("error", exception.getMessage());
            return "redirect:/admin/profile";
        }

        doctor.setPhone(phone.trim());
        doctor.setSpecialization(specialization.trim());
        doctor.setDescription(description.trim());
        doctorService.save(doctor);
        if (photo != null && !photo.isEmpty() && priorPhoto != null) {
            doctorPhotoStorage.delete(priorPhoto);
        }
        redirectAttributes.addFlashAttribute("success", "Your profile has been updated.");
        return "redirect:/admin/profile";
    }

    @GetMapping("/change-password")
    public String showStaffChangePassword() {
        return "admin/change_password";
    }

    @PostMapping("/change-password")
    public String changeStaffPassword(Authentication authentication,
                                     @RequestParam String currentPassword,
                                     @RequestParam String newPassword,
                                     @RequestParam String confirmPassword,
                                     Model model) {
        Doctor doctor = doctorService.findByEmail(authentication.getName());
        if (doctor == null) return "redirect:/admin/login";
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
}

