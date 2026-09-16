package com.subrat.clinic.service.impl;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.repository.AppointmentRepository;
import com.subrat.clinic.service.AppointmentService;

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
    public List<Appointment> findByEmail(String email) {
        return appointmentRepository.findByEmail(email);
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
