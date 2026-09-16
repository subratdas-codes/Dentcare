package com.subrat.clinic.service;

import com.subrat.clinic.model.Doctor;

import java.util.List;

public interface DoctorService {
    Doctor save(Doctor doctor);
    Doctor update(Doctor doctor);
    void deleteById(Long id);
    Doctor findById(Long id);
    List<Doctor> findAll();
    Doctor findByEmail(String email);
}
