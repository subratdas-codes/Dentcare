package com.subrat.clinic.controller;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.AppointmentStatus;
import com.subrat.clinic.model.AppointmentType;
import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.model.DoctorFee;
import com.subrat.clinic.model.Patient;
import com.subrat.clinic.model.PaymentStatus;
import com.subrat.clinic.model.ServicePrice;
import com.subrat.clinic.service.AppointmentService;
import com.subrat.clinic.service.DoctorFeeService;
import com.subrat.clinic.service.DoctorPhotoStorage;
import com.subrat.clinic.service.DoctorService;
import com.subrat.clinic.service.MailService;
import com.subrat.clinic.service.PatientService;
import com.subrat.clinic.service.ServicePriceService;
import com.subrat.clinic.service.SiteSettingService;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
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

    @Autowired
    private ServicePriceService servicePriceService;

    @Autowired
    private DoctorFeeService doctorFeeService;

    @Autowired
    private SiteSettingService siteSettingService;

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
        List<Appointment> appointments = appointmentService.getAll().stream()
                .sorted(Comparator.comparing(Appointment::getAppointmentDate,
                                Comparator.nullsLast(Comparator.naturalOrder()))
                        .thenComparing(Appointment::getAppointmentTime,
                                Comparator.nullsLast(Comparator.naturalOrder()))
                        .reversed())
                .toList();
        LocalDate today = LocalDate.now();
        BigDecimal revenue = appointments.stream()
                .filter(a -> a.getPaymentStatus() == PaymentStatus.PAID)
                .map(Appointment::getAmount)
                .filter(java.util.Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        long todayCount = appointments.stream()
                .filter(a -> today.equals(a.getAppointmentDate()))
                .filter(a -> a.getStatus() != AppointmentStatus.CANCELLED)
                .count();
        long pendingPayments = appointments.stream()
                .filter(a -> a.getPaymentStatus() == PaymentStatus.PENDING)
                .filter(a -> a.getStatus() != AppointmentStatus.CANCELLED)
                .count();

        model.addAttribute("doctorCount", doctorService.findAll().size());
        model.addAttribute("patientCount", patientService.getAll().size());
        model.addAttribute("appointmentCount", appointments.size());
        model.addAttribute("todayCount", todayCount);
        model.addAttribute("revenue", revenue);
        model.addAttribute("pendingPayments", pendingPayments);
        model.addAttribute("doctors", doctorService.findAll());
        model.addAttribute("appointments", appointments);
        model.addAttribute("patients", patientService.getAll());
        return "admin/dashboard";
    }

    private boolean hasAdminRole(Authentication authentication) {
        return authentication != null && authentication.getAuthorities().stream()
                .anyMatch(authority -> "ROLE_ADMIN".equals(authority.getAuthority()));
    }

    private boolean contains(String value, String query) {
        return value != null && value.toLowerCase(Locale.ROOT).contains(query);
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
    public String saveDoctor(@ModelAttribute Doctor doctor, RedirectAttributes redirectAttributes) {
        Doctor existing = doctor.getId() != null ? doctorService.findById(doctor.getId()) : null;
        String email = doctor.getEmail() == null ? "" : doctor.getEmail().trim().toLowerCase(Locale.ROOT);
        if (email.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Email address is required.");
            return "redirect:/admin/doctors";
        }
        Doctor byEmail = doctorService.findByEmail(email);
        if (byEmail != null && (existing == null || !byEmail.getId().equals(doctor.getId()))) {
            redirectAttributes.addFlashAttribute("error", "A staff account with this email already exists.");
            return "redirect:/admin/doctors";
        }
        if (patientService.findByEmail(email) != null) {
            redirectAttributes.addFlashAttribute("error", "A patient account already uses this email.");
            return "redirect:/admin/doctors";
        }
        if (doctor.getName() == null || doctor.getName().trim().length() < 2) {
            redirectAttributes.addFlashAttribute("error", "Enter the doctor's full name.");
            return "redirect:/admin/doctors";
        }
        if (doctor.getSpecialization() == null || doctor.getSpecialization().isBlank()) {
            redirectAttributes.addFlashAttribute("error", "Enter a specialization.");
            return "redirect:/admin/doctors";
        }
        if (existing == null && (doctor.getPassword() == null || doctor.getPassword().length() < 8)) {
            redirectAttributes.addFlashAttribute("error", "Set a login password of at least 8 characters for the new doctor.");
            return "redirect:/admin/doctors";
        }
        doctor.setEmail(email);
        doctor.setName(doctor.getName().trim());
        doctor.setSpecialization(doctor.getSpecialization().trim());
        if (doctor.getPassword() == null || doctor.getPassword().isBlank()) {
            doctor.setPassword(existing.getPassword());
        } else {
            doctor.setPassword(passwordEncoder.encode(doctor.getPassword()));
        }
        if (existing != null) {
            if (doctor.getDescription() == null) doctor.setDescription(existing.getDescription());
            if (doctor.getProfileImagePath() == null) doctor.setProfileImagePath(existing.getProfileImagePath());
        }
        doctorService.save(doctor);
        redirectAttributes.addFlashAttribute("success",
                existing == null ? "Doctor account created." : "Doctor account updated.");
        return "redirect:/admin/doctors";
    }

    @PostMapping("/doctors/delete/{id}")
    public String deleteDoctor(@PathVariable Long id,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        Doctor current = doctorService.findByEmail(authentication.getName());
        if (current != null && id.equals(current.getId())) {
            redirectAttributes.addFlashAttribute("error", "You cannot delete your own admin account.");
            return "redirect:/admin/doctors";
        }
        doctorFeeService.deleteForDoctor(id);
        doctorService.deleteById(id);
        redirectAttributes.addFlashAttribute("success", "Doctor account deleted.");
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

    @GetMapping("/patients/add")
    public String addPatientForm(Model model) {
        model.addAttribute("patient", new Patient());
        return "admin/patient_form";
    }

    @GetMapping("/patients/edit/{id}")
    public String editPatient(@PathVariable Long id, Model model) {
        model.addAttribute("patient", patientService.getById(id));
        return "admin/patient_form";
    }

    @PostMapping("/patients/save")
    public String savePatient(@ModelAttribute Patient patient, RedirectAttributes redirectAttributes) {
        Patient existing = patient.getId() != null ? patientService.getById(patient.getId()) : null;
        String email = patient.getEmail() == null ? "" : patient.getEmail().trim().toLowerCase(Locale.ROOT);
        if (email.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Email address is required.");
            return existing == null ? "redirect:/admin/patients/add" : "redirect:/admin/patients/edit/" + patient.getId();
        }
        Patient byEmail = patientService.findByEmail(email);
        if (byEmail != null && (existing == null || !byEmail.getId().equals(patient.getId()))) {
            redirectAttributes.addFlashAttribute("error", "A patient with this email already exists.");
            return existing == null ? "redirect:/admin/patients/add" : "redirect:/admin/patients/edit/" + patient.getId();
        }
        if (doctorService.findByEmail(email) != null) {
            redirectAttributes.addFlashAttribute("error", "A staff account already uses this email.");
            return existing == null ? "redirect:/admin/patients/add" : "redirect:/admin/patients/edit/" + patient.getId();
        }
        if (patient.getName() == null || patient.getName().trim().length() < 2) {
            redirectAttributes.addFlashAttribute("error", "Enter the patient's full name.");
            return existing == null ? "redirect:/admin/patients/add" : "redirect:/admin/patients/edit/" + patient.getId();
        }
        if (existing == null && (patient.getPassword() == null || patient.getPassword().length() < 8)) {
            redirectAttributes.addFlashAttribute("error", "Set a password of at least 8 characters for the new patient.");
            return "redirect:/admin/patients/add";
        }
        patient.setEmail(email);
        patient.setName(patient.getName().trim());
        if (patient.getPassword() == null || patient.getPassword().isBlank()) {
            patient.setPassword(existing.getPassword());
        } else {
            patient.setPassword(passwordEncoder.encode(patient.getPassword()));
        }
        patientService.save(patient);
        redirectAttributes.addFlashAttribute("success",
                existing == null ? "Patient account created." : "Patient account updated.");
        return "redirect:/admin/patients";
    }

    @PostMapping("/patients/delete/{id}")
    public String deletePatient(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        patientService.deleteById(id);
        redirectAttributes.addFlashAttribute("success", "Patient account deleted.");
        return "redirect:/admin/patients";
    }

    @PostMapping("/patients/reset-password/{id}")
    public String resetPatientPassword(@PathVariable Long id,
                                       @RequestParam String newPassword,
                                       RedirectAttributes redirectAttributes) {
        Patient patient = patientService.getById(id);
        if (patient == null) {
            redirectAttributes.addFlashAttribute("error", "That patient could not be found.");
            return "redirect:/admin/patients";
        }
        if (newPassword == null || newPassword.length() < 8) {
            redirectAttributes.addFlashAttribute("error", "Use a password with at least 8 characters.");
            return "redirect:/admin/patients/edit/" + id;
        }
        patient.setPassword(passwordEncoder.encode(newPassword));
        patientService.save(patient);
        redirectAttributes.addFlashAttribute("success", "Password reset for " + patient.getName() + ".");
        return "redirect:/admin/patients/edit/" + id;
    }

    // ---------------- APPOINTMENT CRUD ---------------- //

    @GetMapping("/appointments")
    public String listAppointments(@RequestParam(required = false) String status,
                                   @RequestParam(required = false) String q,
                                   Model model) {
        List<Appointment> all = appointmentService.getAll().stream()
                .sorted(Comparator.comparing(Appointment::getAppointmentDate,
                                Comparator.nullsLast(Comparator.naturalOrder()))
                        .thenComparing(Appointment::getAppointmentTime,
                                Comparator.nullsLast(Comparator.naturalOrder()))
                        .reversed())
                .toList();
        String selected = status == null ? "" : status.trim().toUpperCase(Locale.ROOT);
        String query = q == null ? "" : q.trim().toLowerCase(Locale.ROOT);
        List<Appointment> filtered = all.stream()
                .filter(a -> selected.isEmpty() || a.getStatus().name().equals(selected))
                .filter(a -> query.isEmpty()
                        || contains(a.getPatientName(), query)
                        || contains(a.getEmail(), query)
                        || contains(a.getPhone(), query)
                        || contains(a.getDoctorName(), query)
                        || contains(a.getPaymentReference(), query))
                .toList();

        model.addAttribute("appointments", filtered);
        model.addAttribute("selectedStatus", selected);
        model.addAttribute("q", q == null ? "" : q.trim());
        model.addAttribute("bookedCount", all.stream().filter(a -> a.getStatus() == AppointmentStatus.BOOKED).count());
        model.addAttribute("completedCount", all.stream().filter(a -> a.getStatus() == AppointmentStatus.COMPLETED).count());
        model.addAttribute("cancelledCount", all.stream().filter(a -> a.getStatus() == AppointmentStatus.CANCELLED).count());
        model.addAttribute("revenue", all.stream()
                .filter(a -> a.getPaymentStatus() == PaymentStatus.PAID)
                .map(Appointment::getAmount)
                .filter(java.util.Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add));
        return "admin/appointment_list";
    }

    @GetMapping("/appointments/edit/{id}")
    public String editAppointment(@PathVariable Long id, Model model) {
        model.addAttribute("appointment", appointmentService.getById(id));
        model.addAttribute("doctors", doctorService.findAll().stream()
                .filter(doctor -> !doctor.isAdmin()).toList());
        model.addAttribute("servicePrices", servicePriceService.findAll());
        return "admin/edit_appointment";
    }

    @PostMapping("/appointments/update")
    public String updateAppointment(@RequestParam Long id,
                                    @RequestParam String patientName,
                                    @RequestParam String email,
                                    @RequestParam String phone,
                                    @RequestParam(required = false) Long doctorId,
                                    @RequestParam(required = false) String doctorName,
                                    @RequestParam(required = false) String appointmentType,
                                    @RequestParam(required = false) String service,
                                    @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate appointmentDate,
                                    @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime appointmentTime,
                                    @RequestParam(required = false) BigDecimal amount,
                                    @RequestParam(required = false) String status,
                                    RedirectAttributes redirectAttributes) {
        Appointment appointment = appointmentService.getById(id);
        if (appointment == null) {
            redirectAttributes.addFlashAttribute("error", "That appointment could not be found.");
            return "redirect:/admin/appointments";
        }
        Doctor doctor = doctorId != null ? doctorService.findById(doctorId) : doctorService.findByName(doctorName);
        if (doctor != null && !doctor.isAdmin()) {
            appointment.setDoctorId(doctor.getId());
            appointment.setDoctorName(doctor.getName());
        } else if (doctorName != null && !doctorName.isBlank()) {
            appointment.setDoctorName(doctorName.trim());
        }
        appointment.setPatientName(patientName.trim());
        appointment.setEmail(email.trim().toLowerCase(Locale.ROOT));
        appointment.setPhone(phone.trim());
        appointment.setAppointmentType("CONSULTATION".equalsIgnoreCase(appointmentType)
                ? AppointmentType.CONSULTATION : AppointmentType.TREATMENT);
        appointment.setService(appointment.isConsultation() ? "General Consultation"
                : (service == null ? appointment.getService() : service.trim()));
        appointment.setAppointmentDate(appointmentDate);
        appointment.setAppointmentTime(appointmentTime);
        if (amount != null && amount.signum() >= 0) {
            appointment.setAmount(amount.setScale(2, RoundingMode.HALF_UP));
        }
        try {
            AppointmentStatus newStatus = AppointmentStatus.valueOf(
                    status == null ? "" : status.trim().toUpperCase(Locale.ROOT));
            appointment.setStatus(newStatus);
            if (newStatus == AppointmentStatus.CANCELLED && appointment.getCancelledAt() == null) {
                appointment.setCancelledAt(java.time.LocalDateTime.now());
            } else if (newStatus != AppointmentStatus.CANCELLED) {
                appointment.setCancelledAt(null);
            }
        } catch (IllegalArgumentException ignored) {
            // Keep the current status if no valid value was submitted.
        }
        appointmentService.save(appointment);
        redirectAttributes.addFlashAttribute("success", "Appointment #" + id + " updated.");
        return "redirect:/admin/appointments";
    }

    @PostMapping("/appointments/status")
    public String updateAppointmentStatus(@RequestParam Long id,
                                          @RequestParam String status,
                                          RedirectAttributes redirectAttributes) {
        Appointment appointment = appointmentService.getById(id);
        if (appointment != null) {
            try {
                AppointmentStatus newStatus = AppointmentStatus.valueOf(status.trim().toUpperCase(Locale.ROOT));
                appointment.setStatus(newStatus);
                if (newStatus == AppointmentStatus.CANCELLED) {
                    appointment.setCancelledAt(java.time.LocalDateTime.now());
                } else {
                    appointment.setCancelledAt(null);
                }
                appointmentService.save(appointment);
                redirectAttributes.addFlashAttribute("success", "Appointment marked " + newStatus.getLabel().toLowerCase(Locale.ROOT) + ".");
            } catch (IllegalArgumentException exception) {
                redirectAttributes.addFlashAttribute("error", "Invalid appointment status.");
            }
        }
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
        model.addAttribute("servicePrices", servicePriceService.findAll());
        model.addAttribute("consultationFee", siteSettingService.getConsultationFee());
        return "admin/pricing";
    }

    @PostMapping("/pricing/update")
    public String updatePricing(@RequestParam(required = false) Long id,
                                @RequestParam(required = false) BigDecimal fee,
                                RedirectAttributes redirectAttributes) {
        ServicePrice price = servicePriceService.findById(id);
        if (price == null) {
            redirectAttributes.addFlashAttribute("error", "That service could not be found.");
            return "redirect:/admin/pricing";
        }
        if (fee == null || fee.compareTo(BigDecimal.ZERO) < 0
                || fee.compareTo(new BigDecimal("1000000")) > 0) {
            redirectAttributes.addFlashAttribute("error",
                    "Enter a fee between ₹0 and ₹10,00,000.");
            return "redirect:/admin/pricing";
        }
        price.setFee(fee.setScale(2, RoundingMode.HALF_UP));
        servicePriceService.save(price);
        redirectAttributes.addFlashAttribute("success",
                price.getServiceName() + " fee updated to ₹" + price.getFee() + ".");
        return "redirect:/admin/pricing";
    }

    @GetMapping("/doctor-fees")
    public String doctorFees(Model model) {
        List<Doctor> doctors = doctorService.findAll().stream()
                .filter(doctor -> !doctor.isAdmin())
                .toList();
        Map<Long, List<DoctorFee>> feesByDoctor = new LinkedHashMap<>();
        for (Doctor doctor : doctors) {
            feesByDoctor.put(doctor.getId(), doctorFeeService.findByDoctor(doctor));
        }
        model.addAttribute("doctors", doctors);
        model.addAttribute("feesByDoctor", feesByDoctor);
        model.addAttribute("pendingFees", doctorFeeService.pendingFees());
        model.addAttribute("servicePrices", servicePriceService.findAll());
        model.addAttribute("consultationFee", siteSettingService.getConsultationFee());
        return "admin/doctor_fees";
    }

    @PostMapping("/doctor-fees/set")
    public String setDoctorFee(@RequestParam Long doctorId,
                               @RequestParam String serviceName,
                               @RequestParam BigDecimal fee,
                               RedirectAttributes redirectAttributes) {
        try {
            doctorFeeService.adminSetFee(doctorId, serviceName, fee);
            redirectAttributes.addFlashAttribute("success", "Doctor fee saved.");
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("error", exception.getMessage());
        }
        return "redirect:/admin/doctor-fees";
    }

    @PostMapping("/doctor-fees/approve")
    public String approveDoctorFee(@RequestParam Long id, RedirectAttributes redirectAttributes) {
        doctorFeeService.approve(id);
        redirectAttributes.addFlashAttribute("success", "Fee request approved and live on the booking page.");
        return "redirect:/admin/doctor-fees";
    }

    @PostMapping("/doctor-fees/reject")
    public String rejectDoctorFee(@RequestParam Long id, RedirectAttributes redirectAttributes) {
        doctorFeeService.reject(id);
        redirectAttributes.addFlashAttribute("success", "Fee request rejected.");
        return "redirect:/admin/doctor-fees";
    }

    @PostMapping("/doctor-fees/delete")
    public String deleteDoctorFee(@RequestParam Long id, RedirectAttributes redirectAttributes) {
        doctorFeeService.deleteFee(id);
        redirectAttributes.addFlashAttribute("success", "Doctor fee override removed. The standard price now applies.");
        return "redirect:/admin/doctor-fees";
    }

    @GetMapping("/settings")
    public String settings(Model model) {
        model.addAttribute("siteSettings", siteSettingService.getSite());
        return "admin/settings";
    }

    @PostMapping("/settings")
    public String saveSettings(@RequestParam Map<String, String> values,
                               RedirectAttributes redirectAttributes) {
        String siteName = values.get("siteName");
        if (siteName == null || siteName.isBlank()) {
            redirectAttributes.addFlashAttribute("error", "Clinic name is required.");
            return "redirect:/admin/settings";
        }
        String consultation = values.get("consultationFee");
        if (consultation == null || consultation.isBlank()) {
            redirectAttributes.addFlashAttribute("error", "Consultation fee is required.");
            return "redirect:/admin/settings";
        }
        try {
            BigDecimal fee = new BigDecimal(consultation.trim());
            if (fee.signum() < 0 || fee.compareTo(new BigDecimal("1000000")) > 0) {
                redirectAttributes.addFlashAttribute("error", "Consultation fee must be between ₹0 and ₹10,00,000.");
                return "redirect:/admin/settings";
            }
        } catch (NumberFormatException exception) {
            redirectAttributes.addFlashAttribute("error", "Enter a valid consultation fee.");
            return "redirect:/admin/settings";
        }
        siteSettingService.update(values);
        redirectAttributes.addFlashAttribute("success", "Website content and fees updated. Changes are live now.");
        return "redirect:/admin/settings";
    }

    @GetMapping("/invoices")
    public String invoices(Model model) {
        List<Appointment> appointments = appointmentService.getAll().stream()
                .sorted(Comparator.comparing(Appointment::getAppointmentDate,
                                Comparator.nullsLast(Comparator.naturalOrder()))
                        .reversed())
                .toList();
        BigDecimal revenue = appointments.stream()
                .filter(a -> a.getPaymentStatus() == PaymentStatus.PAID)
                .map(Appointment::getAmount)
                .filter(java.util.Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        model.addAttribute("appointments", appointments);
        model.addAttribute("revenue", revenue);
        model.addAttribute("paidCount", appointments.stream()
                .filter(a -> a.getPaymentStatus() != PaymentStatus.PENDING).count());
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

