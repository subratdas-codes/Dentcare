package com.subrat.clinic.service;

import com.subrat.clinic.model.Appointment;
import java.util.List;

public interface AppointmentService {
    Appointment save(Appointment appointment);
    List<Appointment> getAll();
    List<Appointment> findByDoctorName(String doctorName);
    List<Appointment> findByEmail(String email);

    Appointment getById(Long id);     
    void deleteById(Long id);         
}
