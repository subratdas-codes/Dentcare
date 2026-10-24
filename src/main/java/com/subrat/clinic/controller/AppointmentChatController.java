package com.subrat.clinic.controller;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.AppointmentMessage;
import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.repository.AppointmentMessageRepository;
import com.subrat.clinic.service.AppointmentService;
import com.subrat.clinic.service.DoctorService;
import java.util.Objects;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

@Controller
public class AppointmentChatController {

    private final AppointmentService appointmentService;
    private final DoctorService doctorService;
    private final AppointmentMessageRepository messageRepository;

    public AppointmentChatController(AppointmentService appointmentService,
                                     DoctorService doctorService,
                                     AppointmentMessageRepository messageRepository) {
        this.appointmentService = appointmentService;
        this.doctorService = doctorService;
        this.messageRepository = messageRepository;
    }

    @GetMapping("/admin/doctor/appointments/{appointmentId}/chat")
    public String doctorChat(@PathVariable Long appointmentId,
                             Authentication authentication,
                             Model model) {
        Doctor doctor = requireDoctor(authentication);
        Appointment appointment = requireAppointment(appointmentId);
        requireAssignedDoctor(doctor, appointment);
        populateConversation(appointment, true, model);
        return "appointment_chat";
    }

    @PostMapping("/admin/doctor/appointments/{appointmentId}/chat")
    public String doctorSendMessage(@PathVariable Long appointmentId,
                                    Authentication authentication,
                                    @RequestParam String body) {
        Doctor doctor = requireDoctor(authentication);
        Appointment appointment = requireAppointment(appointmentId);
        requireAssignedDoctor(doctor, appointment);
        return saveMessage(appointment, authentication.getName(), "DOCTOR", body,
                "/admin/doctor/appointments/" + appointmentId + "/chat");
    }

    @GetMapping("/my/appointments/{appointmentId}/chat")
    public String patientChat(@PathVariable Long appointmentId,
                              Authentication authentication,
                              Model model) {
        Appointment appointment = requireAppointment(appointmentId);
        requireAppointmentPatient(authentication, appointment);
        populateConversation(appointment, false, model);
        return "appointment_chat";
    }

    @PostMapping("/my/appointments/{appointmentId}/chat")
    public String patientSendMessage(@PathVariable Long appointmentId,
                                     Authentication authentication,
                                     @RequestParam String body) {
        Appointment appointment = requireAppointment(appointmentId);
        requireAppointmentPatient(authentication, appointment);
        return saveMessage(appointment, authentication.getName(), "PATIENT", body,
                "/my/appointments/" + appointmentId + "/chat");
    }

    private Doctor requireDoctor(Authentication authentication) {
        if (authentication == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        }
        Doctor doctor = doctorService.findByEmail(authentication.getName());
        if (doctor == null || doctor.isAdmin()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN);
        }
        return doctor;
    }

    private Appointment requireAppointment(Long appointmentId) {
        Appointment appointment = appointmentService.getById(appointmentId);
        if (appointment == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
        return appointment;
    }

    private void requireAssignedDoctor(Doctor doctor, Appointment appointment) {
        if (doctor.getName() == null || appointment.getDoctorName() == null
                || !doctor.getName().trim().equalsIgnoreCase(appointment.getDoctorName().trim())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
    }

    private void requireAppointmentPatient(Authentication authentication, Appointment appointment) {
        if (authentication == null || appointment.getEmail() == null
                || !appointment.getEmail().trim().equalsIgnoreCase(authentication.getName())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
    }

    private void populateConversation(Appointment appointment, boolean staffConversation, Model model) {
        model.addAttribute("appointment", appointment);
        model.addAttribute("messages", messageRepository.findByAppointment_IdOrderBySentAtAsc(appointment.getId()));
        model.addAttribute("staffConversation", staffConversation);
        model.addAttribute("postUrl", staffConversation
                ? "/admin/doctor/appointments/" + appointment.getId() + "/chat"
                : "/my/appointments/" + appointment.getId() + "/chat");
        model.addAttribute("backUrl", staffConversation
                ? "/admin/doctor/dashboard"
                : "/my/appointments");
    }

    private String saveMessage(Appointment appointment, String senderEmail, String senderRole,
                               String rawBody, String redirectPath) {
        String body = rawBody == null ? "" : rawBody.trim();
        if (body.isEmpty() || body.length() > 2000) {
            return "redirect:" + redirectPath + "?error=message";
        }
        AppointmentMessage message = new AppointmentMessage();
        message.setAppointment(appointment);
        message.setSenderEmail(Objects.requireNonNull(senderEmail));
        message.setSenderRole(senderRole);
        message.setBody(body);
        messageRepository.save(message);
        return "redirect:" + redirectPath + "?sent=true";
    }
}
