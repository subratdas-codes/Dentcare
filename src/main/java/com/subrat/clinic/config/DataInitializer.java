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
        seedDoctor("Dr. Priya Sharma", "Orthodontist", "priya.sharma@clinic.com", "9864002211", "doctor123", false);
        seedDoctor("Dr. Amit Verma", "Endodontist", "amit.verma@clinic.com", "9864002212", "doctor123", false);
        seedDoctor("Dr. Neha Gupta", "Cosmetic Dentist", "neha.gupta@clinic.com", "9864002213", "doctor123", false);
    }

    private void seedDoctor(String name, String specialization, String email, String phone, String password, boolean admin) {
        if (doctorRepository.findByEmail(email) == null) {
            Doctor doctor = new Doctor();
            doctor.setName(name);
            doctor.setSpecialization(specialization);
            doctor.setEmail(email);
            doctor.setPhone(phone);
            doctor.setPassword(passwordEncoder.encode(password));
            doctor.setAdmin(admin);
            doctorRepository.save(doctor);
            System.out.println(" Seeded doctor: " + email);
        }
    }
}