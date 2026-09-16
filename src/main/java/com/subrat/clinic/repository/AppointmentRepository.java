package com.subrat.clinic.repository;

import com.subrat.clinic.model.Appointment;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByDoctorName(String doctorName);
    List<Appointment> findByEmail(String email);
    List<Appointment> findByAppointmentDate(LocalDate appointmentDate);
    List<Appointment> findByService(String service);
}
