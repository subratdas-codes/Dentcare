package com.subrat.clinic.repository;

import com.subrat.clinic.model.Treatment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface TreatmentRepository extends JpaRepository<Treatment, Long> {
    Optional<Treatment> findByName(String name);
    List<Treatment> findByActiveTrue();
}
