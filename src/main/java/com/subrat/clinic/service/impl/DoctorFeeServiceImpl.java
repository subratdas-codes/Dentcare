package com.subrat.clinic.service.impl;

import com.subrat.clinic.model.AppointmentType;
import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.model.DoctorFee;
import com.subrat.clinic.model.DoctorFeeStatus;
import com.subrat.clinic.repository.DoctorFeeRepository;
import com.subrat.clinic.service.DoctorFeeService;
import com.subrat.clinic.service.DoctorService;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DoctorFeeServiceImpl implements DoctorFeeService {

    private static final BigDecimal MAX_FEE = new BigDecimal("1000000");

    private final DoctorFeeRepository repository;
    private final DoctorService doctorService;

    public DoctorFeeServiceImpl(DoctorFeeRepository repository, DoctorService doctorService) {
        this.repository = repository;
        this.doctorService = doctorService;
    }

    @Override
    public List<DoctorFee> findByDoctor(Doctor doctor) {
        return doctor == null || doctor.getId() == null
                ? List.of()
                : repository.findByDoctorIdOrderByServiceNameAsc(doctor.getId());
    }

    @Override
    public List<DoctorFee> findAll() {
        return repository.findAll();
    }

    @Override
    public DoctorFee findById(Long id) {
        return id == null ? null : repository.findById(id).orElse(null);
    }

    @Override
    public BigDecimal resolveFee(Doctor doctor, AppointmentType type, String serviceName, BigDecimal fallback) {
        if (doctor == null || doctor.getId() == null) {
            return fallback;
        }
        String key = type == AppointmentType.CONSULTATION ? DoctorFee.CONSULTATION : serviceName;
        DoctorFee override = repository.findByDoctorIdAndServiceNameIgnoreCase(doctor.getId(), key);
        if (override != null && override.getFee() != null && override.getFee().signum() >= 0) {
            return override.getFee();
        }
        return fallback;
    }

    @Override
    public Map<Long, Map<String, BigDecimal>> approvedFeeMap() {
        Map<Long, Map<String, BigDecimal>> result = new LinkedHashMap<>();
        for (DoctorFee fee : repository.findAll()) {
            if (fee.getDoctor() == null || fee.getDoctor().getId() == null || fee.getFee() == null) {
                continue;
            }
            result.computeIfAbsent(fee.getDoctor().getId(), ignored -> new LinkedHashMap<>())
                    .put(fee.getServiceName(), fee.getFee());
        }
        return result;
    }

    @Override
    public List<DoctorFee> pendingFees() {
        return repository.findByStatusOrderByUpdatedAtDesc(DoctorFeeStatus.PENDING);
    }

    @Override
    public long pendingCount() {
        return repository.countByStatus(DoctorFeeStatus.PENDING);
    }

    @Override
    @Transactional
    public void requestFee(Doctor doctor, String serviceName, BigDecimal amount) {
        if (doctor == null || doctor.getId() == null) {
            throw new IllegalArgumentException("Doctor account is required.");
        }
        BigDecimal validated = validate(amount);
        String key = normalize(serviceName);
        DoctorFee fee = repository.findByDoctorIdAndServiceNameIgnoreCase(doctor.getId(), key);
        if (fee == null) {
            fee = new DoctorFee();
            fee.setDoctor(doctor);
            fee.setServiceName(key);
        }
        fee.setRequestedFee(validated);
        fee.setStatus(DoctorFeeStatus.PENDING);
        fee.setUpdatedAt(LocalDateTime.now());
        repository.save(fee);
    }

    @Override
    @Transactional
    public void adminSetFee(Long doctorId, String serviceName, BigDecimal amount) {
        Doctor doctor = doctorService.findById(doctorId);
        if (doctor == null) {
            throw new IllegalArgumentException("That doctor could not be found.");
        }
        BigDecimal validated = validate(amount);
        String key = normalize(serviceName);
        DoctorFee fee = repository.findByDoctorIdAndServiceNameIgnoreCase(doctorId, key);
        if (fee == null) {
            fee = new DoctorFee();
            fee.setDoctor(doctor);
            fee.setServiceName(key);
        }
        fee.setFee(validated);
        fee.setRequestedFee(null);
        fee.setStatus(DoctorFeeStatus.APPROVED);
        fee.setUpdatedAt(LocalDateTime.now());
        repository.save(fee);
    }

    @Override
    @Transactional
    public void approve(Long id) {
        DoctorFee fee = findById(id);
        if (fee == null) {
            return;
        }
        if (fee.getRequestedFee() != null) {
            fee.setFee(fee.getRequestedFee());
            fee.setRequestedFee(null);
        }
        fee.setStatus(DoctorFeeStatus.APPROVED);
        fee.setUpdatedAt(LocalDateTime.now());
        repository.save(fee);
    }

    @Override
    @Transactional
    public void reject(Long id) {
        DoctorFee fee = findById(id);
        if (fee == null) {
            return;
        }
        fee.setRequestedFee(null);
        fee.setStatus(fee.getFee() == null ? DoctorFeeStatus.REJECTED : DoctorFeeStatus.APPROVED);
        fee.setUpdatedAt(LocalDateTime.now());
        repository.save(fee);
    }

    @Override
    public void deleteFee(Long id) {
        if (id != null) {
            repository.deleteById(id);
        }
    }

    @Override
    @Transactional
    public void deleteForDoctor(Long doctorId) {
        if (doctorId != null) {
            repository.deleteByDoctorId(doctorId);
        }
    }

    private String normalize(String serviceName) {
        if (serviceName == null || serviceName.isBlank()
                || "CONSULTATION".equalsIgnoreCase(serviceName.trim())) {
            return DoctorFee.CONSULTATION;
        }
        return serviceName.trim();
    }

    private BigDecimal validate(BigDecimal amount) {
        if (amount == null || amount.signum() < 0 || amount.compareTo(MAX_FEE) > 0) {
            throw new IllegalArgumentException("Enter a fee between ₹0 and ₹10,00,000.");
        }
        return amount.setScale(2, RoundingMode.HALF_UP);
    }
}
