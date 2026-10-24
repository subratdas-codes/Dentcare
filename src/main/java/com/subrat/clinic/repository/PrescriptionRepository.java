package com.subrat.clinic.repository;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.Patient;
import com.subrat.clinic.model.Prescription;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PrescriptionRepository extends JpaRepository<Prescription, Long> {
    List<Prescription> findByPatient(Patient patient);
    List<Prescription> findByAppointment(Appointment appointment);
}
