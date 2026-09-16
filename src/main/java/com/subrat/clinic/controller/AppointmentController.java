package com.subrat.clinic.controller;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.service.AppointmentService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Controller
public class AppointmentController {

	@Autowired
	private AppointmentService appointmentService;

    // Home page
    @GetMapping("/")
    public String showHomePage(Model model) {
        model.addAttribute("appointment", new Appointment());
        return "index";
    }

    // Standalone booking form (book_appointment.jsp)
    @GetMapping("/book_appointment")
    public String showBookAppointmentForm(Model model) {
        model.addAttribute("appointment", new Appointment());
        return "book_appointment";
    }

    // Handle the booking form submission
    @PostMapping("/book")
    public String bookAppointment(
            @RequestParam String patientName,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam String doctorName,
            @RequestParam("service") String serviceType,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate appointmentDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime appointmentTime
    ) {
        Appointment appointment = new Appointment();
        appointment.setPatientName(patientName);
        appointment.setEmail(email);
        appointment.setPhone(phone);
        appointment.setDoctorName(doctorName);
        appointment.setService(serviceType);
        appointment.setAppointmentDate(appointmentDate);
        appointment.setAppointmentTime(appointmentTime);

        appointmentService.save(appointment);
        return "redirect:/book_appointment?success=true";
    }

    // Logged-in patient: list own appointments
    @GetMapping("/my/appointments")
    public String userAppointments(Authentication authentication, Model model) {
        String email = authentication.getName();
        List<Appointment> userAppointments = appointmentService.findByEmail(email);
        model.addAttribute("appointments", userAppointments);
        return "my_appointments";
    }

    // Static pages
    @GetMapping("/contact")
    public String showContactPage() {
        return "contact";
    }

    @GetMapping("/about")
    public String showAboutPage() {
        return "about";
    }

    @GetMapping("/service")
    public String showService() {
        return "service";
    }

    @GetMapping("/testimonial")
    public String showTestimonial() {
        return "testimonial";
    }

    @GetMapping("/team")
    public String showTeamPage() {
        return "team";
    }

    @GetMapping("/price")
    public String showPricingPage() {
        return "price";
    }
}