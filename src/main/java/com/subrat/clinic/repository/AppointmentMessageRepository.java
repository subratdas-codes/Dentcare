package com.subrat.clinic.repository;

import com.subrat.clinic.model.AppointmentMessage;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AppointmentMessageRepository extends JpaRepository<AppointmentMessage, Long> {
    List<AppointmentMessage> findByAppointment_IdOrderBySentAtAsc(Long appointmentId);
}
