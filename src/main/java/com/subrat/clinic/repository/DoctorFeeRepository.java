package com.subrat.clinic.repository;

import com.subrat.clinic.model.DoctorFee;
import com.subrat.clinic.model.DoctorFeeStatus;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DoctorFeeRepository extends JpaRepository<DoctorFee, Long> {

    List<DoctorFee> findByDoctorIdOrderByServiceNameAsc(Long doctorId);

    DoctorFee findByDoctorIdAndServiceNameIgnoreCase(Long doctorId, String serviceName);

    List<DoctorFee> findByStatusOrderByUpdatedAtDesc(DoctorFeeStatus status);

    long countByStatus(DoctorFeeStatus status);

    void deleteByDoctorId(Long doctorId);
}
