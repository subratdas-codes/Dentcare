package com.subrat.clinic.service.impl;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.repository.AppointmentRepository;
import com.subrat.clinic.service.AppointmentService;

import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AppointmentServiceImpl implements AppointmentService {

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Override
    public Appointment save(Appointment appointment) {
        return appointmentRepository.save(appointment);
    }

    @Override
    public List<Appointment> getAll() {
        return appointmentRepository.findAll();
    }

    @Override
    public List<Appointment> findByDoctorName(String doctorName) {
        if (doctorName == null || doctorName.isBlank()) {
            return List.of();
        }
        return appointmentRepository.findByDoctorName(doctorName);
    }

    @Override
    public List<Appointment> findByDoctor(Doctor doctor) {
        if (doctor == null || doctor.getId() == null) {
            return List.of();
        }
        return appointmentRepository.findByDoctorIdOrDoctorName(doctor.getId(), doctor.getName())
                .stream()
                .sorted(Comparator.comparing(Appointment::getAppointmentDate,
                                Comparator.nullsLast(Comparator.naturalOrder()))
                        .thenComparing(Appointment::getAppointmentTime,
                                Comparator.nullsLast(Comparator.naturalOrder()))
                        .reversed())
                .toList();
    }

    @Override
    public List<Appointment> findByEmail(String email) {
        if (email == null || email.isBlank()) {
            return List.of();
        }
        return appointmentRepository.findByEmailOrderByAppointmentDateDescAppointmentTimeDesc(email.trim());
    }

    @Override
    public Appointment findByReference(String reference) {
        if (reference == null || reference.isBlank()) {
            return null;
        }
        return appointmentRepository.findByPaymentReference(reference.trim());
    }

    
    @Override
    public Appointment getById(Long id) {
        return appointmentRepository.findById(id).orElse(null); // or throw exception
    }

 
    @Override
    public void deleteById(Long id) {
        appointmentRepository.deleteById(id);
    }
}
