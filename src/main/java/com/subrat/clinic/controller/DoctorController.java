package com.subrat.clinic.controller;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.service.AppointmentService;
import com.subrat.clinic.service.DoctorService;
import com.subrat.clinic.service.MailService;
import com.subrat.clinic.service.PatientService;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;
import javax.imageio.ImageIO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import java.util.Objects;

@Controller
@RequestMapping("/admin")
public class DoctorController {

    @GetMapping("/login")
    public String adminLogin() {
        return "admin/login";
    }

    @GetMapping("/login/admin")
    public String adminLoginSelected(Model model) {
        model.addAttribute("selectedRole", "ADMIN");
        return "admin/login";
    }

    @GetMapping("/login/doctor")
    public String doctorLoginSelected(Model model) {
        model.addAttribute("selectedRole", "DOCTOR");
        return "admin/login";
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

    @GetMapping("/doctor/dashboard")
    public String doctorDashboard(Authentication authentication, Model model) {
        return populateDoctorDashboard(authentication, model);
    }

    @GetMapping("/doctor-dashboard")
    public String legacyDoctorDashboard() {
        return "redirect:/admin/doctor/dashboard";
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
    private MailService mailService;

    @Value("${app.upload-dir:uploads}")
    private String uploadDirectory;

    @GetMapping("/register")
    public String doctorRegisterForm(Model model) {
        model.addAttribute("doctor", new com.subrat.clinic.model.Doctor());
        return "admin/doctor_register";
    }

    @PostMapping("/register")
    public String doctorRegister(@ModelAttribute Doctor doctor, Model model) {
        String email = doctor.getEmail() == null ? "" : doctor.getEmail().trim().toLowerCase();
        if (doctor.getName() == null || doctor.getName().isBlank()
                || doctor.getPassword() == null || doctor.getPassword().length() < 8) {
            model.addAttribute("error", "Enter your full name and a password of at least 8 characters.");
            model.addAttribute("doctor", doctor);
            return "admin/doctor_register";
        }
        if (doctorService.findByEmail(email) != null) {
            model.addAttribute("error", "An account with this email already exists.");
            model.addAttribute("doctor", doctor);
            return "admin/doctor_register";
        }
        doctor.setEmail(email);
        doctor.setName(doctor.getName().trim());
        doctor.setAdmin(false);
        doctor.setPassword(passwordEncoder.encode(doctor.getPassword()));
        doctorService.save(doctor);
        return "redirect:/admin/login/doctor?registered=true";
    }

    @GetMapping({"", "/"})
    public String adminRoot(Authentication authentication) {
        return isDoctor(authentication)
                ? "redirect:/admin/doctor/dashboard"
                : "redirect:/admin/dashboard";
    }

    @GetMapping("/dashboard")
    public String adminDashboard(Authentication authentication, Model model) {
        if (isDoctor(authentication)) {
            return populateDoctorDashboard(authentication, model);
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

    private String populateDoctorDashboard(Authentication authentication, Model model) {
        if (authentication == null || !isDoctor(authentication)) {
            return "redirect:/admin/login";
        }
        Doctor doctor = doctorService.findByEmail(authentication.getName());
        if (doctor == null || doctor.getName() == null || doctor.getName().isBlank()) {
            return "redirect:/admin/login/doctor?error=true";
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

    private boolean isDoctor(Authentication authentication) {
        return authentication != null && authentication.getAuthorities().stream()
                .anyMatch(authority -> Objects.equals(authority.getAuthority(), "ROLE_DOCTOR"));
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
    public String listAppointments(Authentication authentication, Model model) {
        List<Appointment> appointments;
        if (isDoctor(authentication)) {
            Doctor doctor = doctorService.findByEmail(authentication.getName());
            appointments = doctor == null ? List.of() : appointmentService.findByDoctorName(doctor.getName());
        } else {
            appointments = appointmentService.getAll();
        }
        model.addAttribute("appointments", appointments);
        return "admin/appointment_list"; // Use appointment_list.jsp (not 'appointments.jsp' to avoid conflict)
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
                doctor.setProfileImagePath(saveDoctorPhoto(photo));
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
            deletePriorDoctorPhoto(priorPhoto);
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

    private String saveDoctorPhoto(MultipartFile photo) throws IOException {
        if (photo.getSize() > 5L * 1024 * 1024) {
            throw new IllegalArgumentException("Choose an image smaller than 5 MB.");
        }
        byte[] bytes = photo.getBytes();
        String extension;
        if (bytes.length >= 8 && (bytes[0] & 0xff) == 0x89 && bytes[1] == 'P'
                && bytes[2] == 'N' && bytes[3] == 'G') {
            extension = ".png";
        } else if (bytes.length >= 3 && (bytes[0] & 0xff) == 0xff
                && (bytes[1] & 0xff) == 0xd8 && (bytes[2] & 0xff) == 0xff) {
            extension = ".jpg";
        } else {
            throw new IllegalArgumentException("Use a valid JPEG or PNG image.");
        }
        BufferedImage image = ImageIO.read(new ByteArrayInputStream(bytes));
        if (image == null || image.getWidth() > 6000 || image.getHeight() > 6000) {
            throw new IllegalArgumentException("The selected image is invalid or too large in dimensions.");
        }

        Path directory = Path.of(uploadDirectory).toAbsolutePath().normalize().resolve("doctors");
        Files.createDirectories(directory);
        String filename = UUID.randomUUID() + extension;
        Files.write(directory.resolve(filename), bytes);
        return "/uploads/doctors/" + filename;
    }

    private void deletePriorDoctorPhoto(String imagePath) {
        if (!imagePath.matches("/uploads/doctors/[a-fA-F0-9-]+\\.(jpg|png)")) return;
        try {
            Path uploadRoot = Path.of(uploadDirectory).toAbsolutePath().normalize();
            Path doctorPhotoDirectory = uploadRoot.resolve("doctors").normalize();
            Path image = doctorPhotoDirectory.resolve(imagePath.substring(imagePath.lastIndexOf('/') + 1)).normalize();
            if (image.startsWith(doctorPhotoDirectory)) Files.deleteIfExists(image);
        } catch (IOException ignored) {
            // A failed cleanup must not undo a successfully saved profile.
        }
    }
}

