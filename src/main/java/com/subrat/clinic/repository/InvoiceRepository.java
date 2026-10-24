package com.subrat.clinic.repository;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.Invoice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface InvoiceRepository extends JpaRepository<Invoice, Long> {
    Optional<Invoice> findByAppointment(Appointment appointment);
    Optional<Invoice> findByInvoiceNumber(String invoiceNumber);
}
