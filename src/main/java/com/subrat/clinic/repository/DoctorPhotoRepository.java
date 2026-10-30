package com.subrat.clinic.repository;

import com.subrat.clinic.model.DoctorPhoto;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DoctorPhotoRepository extends JpaRepository<DoctorPhoto, String> {
}
