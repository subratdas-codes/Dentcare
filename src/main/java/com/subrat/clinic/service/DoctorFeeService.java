package com.subrat.clinic.service;

import com.subrat.clinic.model.AppointmentType;
import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.model.DoctorFee;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface DoctorFeeService {

    List<DoctorFee> findByDoctor(Doctor doctor);

    List<DoctorFee> findAll();

    DoctorFee findById(Long id);

    BigDecimal resolveFee(Doctor doctor, AppointmentType type, String serviceName, BigDecimal fallback);

    Map<Long, Map<String, BigDecimal>> approvedFeeMap();

    List<DoctorFee> pendingFees();

    long pendingCount();

    void requestFee(Doctor doctor, String serviceName, BigDecimal amount);

    void adminSetFee(Long doctorId, String serviceName, BigDecimal amount);

    void approve(Long id);

    void reject(Long id);

    void deleteFee(Long id);

    void deleteForDoctor(Long doctorId);
}
