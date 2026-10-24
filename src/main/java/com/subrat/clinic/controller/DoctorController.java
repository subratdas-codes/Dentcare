package com.subrat.clinic.controller;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.service.AppointmentService;
import com.subrat.clinic.service.DoctorService;
import com.subrat.clinic.service.MailService;
import com.subrat.clinic.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class DoctorController {

    @GetMapping("/login")
    public String adminLogin() {
        return "admin/login";
    }

    @GetMapping("/debug")
    @org.springframework.web.bind.annotation.ResponseBody
    public String debug() {
        return "ok";
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

    @GetMapping("/register")
    public String doctorRegisterForm(Model model) {
        model.addAttribute("doctor", new com.subrat.clinic.model.Doctor());
        return "admin/doctor_register";
    }

    @PostMapping("/register")
    public String doctorRegister(@ModelAttribute com.subrat.clinic.model.Doctor doctor) {
        Doctor existing = doctorService.findByEmail(doctor.getEmail());
        if (existing != null) {
            return "redirect:/admin/login?error=true";
        }
        doctor.setAdmin(false);
        if (doctor.getPassword() != null) {
            doctor.setPassword(passwordEncoder.encode(doctor.getPassword()));
        }
        doctorService.save(doctor);
        return "redirect:/admin/login?registered=true";
    }

    @GetMapping({"", "/"})
    public String adminRoot() {
        return "redirect:/admin/dashboard";
    }

    @GetMapping("/dashboard")
    public String adminDashboard(Model model) {
        model.addAttribute("doctorCount", doctorService.findAll().size());
        model.addAttribute("patientCount", patientService.getAll().size());
        model.addAttribute("appointmentCount", appointmentService.getAll().size());
        model.addAttribute("doctors", doctorService.findAll());
        model.addAttribute("appointments", appointmentService.getAll());
        model.addAttribute("patients", patientService.getAll());
        return "admin/dashboard";
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
    public String profile(org.springframework.security.core.Authentication authentication, Model model) {
        String email = authentication.getName();
        com.subrat.clinic.model.Doctor doctor = doctorService.findByEmail(email);
        if (doctor != null) {
            model.addAttribute("doctor", doctor);
            return "admin/profile";
        }
        return "admin/profile";
    }
}

