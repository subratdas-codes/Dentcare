package com.subrat.clinic.config;

import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.model.DoctorFee;
import com.subrat.clinic.model.DoctorFeeStatus;
import com.subrat.clinic.model.ServicePrice;
import com.subrat.clinic.repository.DoctorFeeRepository;
import com.subrat.clinic.repository.DoctorRepository;
import com.subrat.clinic.repository.ServicePriceRepository;
import jakarta.annotation.PostConstruct;
import java.math.BigDecimal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer {

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private ServicePriceRepository servicePriceRepository;

    @Autowired
    private DoctorFeeRepository doctorFeeRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostConstruct
    public void createDefaultAdmin() {
        String adminEmail = "dentcare.support@gmail.com";
        Doctor currentAdmin = doctorRepository.findByEmail(adminEmail);
        if (currentAdmin == null) {
            Doctor legacyAdmin = doctorRepository.findByEmail("admin@clinic.com");
            if (legacyAdmin != null) {
                legacyAdmin.setEmail(adminEmail);
                doctorRepository.save(legacyAdmin);
                System.out.println(" Admin email migrated to: " + adminEmail);
            } else {
                Doctor admin = new Doctor();
                admin.setName("Admin");
                admin.setEmail(adminEmail);
                admin.setPhone("9437123456");
                admin.setSpecialization("Admin");
                admin.setPassword(passwordEncoder.encode("admin123"));
                admin.setAdmin(true);

                doctorRepository.save(admin);
                System.out.println(" Default admin created: " + adminEmail + " / admin123");
            }
        }
        seedDoctor("Dr. Priya Sharma", "Orthodontist", "priya.sharma@clinic.com", "9864002211", "doctor123", false);
        seedDoctor("Dr. Amit Verma", "Endodontist", "amit.verma@clinic.com", "9864002212", "doctor123", false);
        seedDoctor("Dr. Neha Gupta", "Cosmetic Dentist", "neha.gupta@clinic.com", "9864002213", "doctor123", false);

        seedServicePrice("Teeth Cleaning", "999.00");
        seedServicePrice("Root Canal", "8999.00");
        seedServicePrice("Braces", "15000.00");
        seedServicePrice("Tooth Whitening", "2999.00");
        seedServicePrice("Dental Implants", "4999.00");

        if (doctorFeeRepository.count() == 0) {
            seedDoctorFee("priya.sharma@clinic.com", DoctorFee.CONSULTATION, "250.00");
            seedDoctorFee("priya.sharma@clinic.com", "Braces", "16000.00");
            seedDoctorFee("amit.verma@clinic.com", DoctorFee.CONSULTATION, "199.00");
            seedDoctorFee("amit.verma@clinic.com", "Root Canal", "9500.00");
            seedDoctorFee("neha.gupta@clinic.com", DoctorFee.CONSULTATION, "299.00");
            seedDoctorFee("neha.gupta@clinic.com", "Tooth Whitening", "3500.00");
            seedDoctorFee("neha.gupta@clinic.com", "Dental Implants", "5200.00");
        }
    }

    private void seedDoctorFee(String doctorEmail, String serviceName, String fee) {
        Doctor doctor = doctorRepository.findByEmail(doctorEmail);
        if (doctor == null
                || doctorFeeRepository.findByDoctorIdAndServiceNameIgnoreCase(doctor.getId(), serviceName) != null) {
            return;
        }
        DoctorFee doctorFee = new DoctorFee();
        doctorFee.setDoctor(doctor);
        doctorFee.setServiceName(serviceName);
        doctorFee.setFee(new BigDecimal(fee));
        doctorFee.setStatus(DoctorFeeStatus.APPROVED);
        doctorFeeRepository.save(doctorFee);
    }

    private void seedServicePrice(String name, String fee) {
        if (servicePriceRepository.findByServiceNameIgnoreCase(name) == null) {
            ServicePrice price = new ServicePrice();
            price.setServiceName(name);
            price.setFee(new BigDecimal(fee));
            servicePriceRepository.save(price);
            System.out.println(" Seeded service fee: " + name + " = " + fee);
        }
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