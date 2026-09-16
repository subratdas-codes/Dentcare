package com.subrat.clinic.service;

import com.subrat.clinic.model.Patient;
import java.util.List;

public interface PatientService {
    Patient save(Patient patient);
    List<Patient> getAll();
    Patient getById(Long id);
    void deleteById(Long id);

    /**
     * Retrieve a patient by email for authentication.
     */
    Patient findByEmail(String email);
}
