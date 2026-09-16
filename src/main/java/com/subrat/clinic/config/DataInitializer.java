package com.subrat.clinic.config;

import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.repository.DoctorRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer {

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostConstruct
    public void createDefaultAdmin() {
        if (doctorRepository.findByEmail("admin@clinic.com") == null) {
            Doctor admin = new Doctor();
            admin.setName("Admin");
            admin.setEmail("admin@clinic.com");
            admin.setPhone("9937111000");
            admin.setSpecialization("Admin");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setAdmin(true);

            doctorRepository.save(admin);
            System.out.println(" Default admin created: admin@clinic.com / admin123");
        }
    }
}