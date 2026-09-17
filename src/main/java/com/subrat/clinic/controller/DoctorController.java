package com.subrat.clinic.controller;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.service.AppointmentService;
import com.subrat.clinic.service.DoctorService;
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

    @Autowired
    private DoctorService doctorService;

    @Autowired
    private PatientService patientService;

    @Autowired
    private AppointmentService appointmentService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/dashboard")
    public String adminDashboard(Model model) {
        model.addAttribute("doctorCount", doctorService.findAll().size());
        model.addAttribute("patientCount", patientService.getAll().size());
        model.addAttribute("appointmentCount", appointmentService.getAll().size());
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
    public String listPatients(Model model) {
        model.addAttribute("patients", patientService.getAll());
        return "admin/patient_list";
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
}

