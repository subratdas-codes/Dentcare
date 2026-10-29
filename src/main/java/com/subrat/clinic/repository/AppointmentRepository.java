package com.subrat.clinic.repository;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.AppointmentStatus;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByDoctorName(String doctorName);
    List<Appointment> findByDoctorIdOrDoctorName(Long doctorId, String doctorName);
    List<Appointment> findByEmail(String email);
    List<Appointment> findByEmailOrderByAppointmentDateDescAppointmentTimeDesc(String email);
    List<Appointment> findByDoctorIdAndAppointmentDate(Long doctorId, LocalDate appointmentDate);
    List<Appointment> findByEmailAndAppointmentDate(String email, LocalDate appointmentDate);
    List<Appointment> findByAppointmentDate(LocalDate appointmentDate);
    List<Appointment> findByService(String service);
    List<Appointment> findByStatus(AppointmentStatus status);
    Appointment findByPaymentReference(String paymentReference);
}
