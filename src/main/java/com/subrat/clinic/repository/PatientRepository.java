package com.subrat.clinic.repository;

import com.subrat.clinic.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PatientRepository extends JpaRepository<Patient, Long> {
    /**
     * Find a patient by their email address for authentication purposes.
     */
    Patient findByEmail(String email);
}
