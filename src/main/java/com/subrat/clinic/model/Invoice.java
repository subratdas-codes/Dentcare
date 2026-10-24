package com.subrat.clinic.model;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = " invoices\)
public class Invoice {

 @Id
 @GeneratedValue(strategy = GenerationType.IDENTITY)
 private Long id;

 @OneToOne(fetch = FetchType.LAZY)
 @JoinColumn(name = \appointment_id\, unique = true)
 private Appointment appointment;

 @Column(nullable = false, unique = true)
 private String invoiceNumber;

 private BigDecimal amount;

 @Enumerated(EnumType.STRING)
 private InvoiceStatus status = InvoiceStatus.UNPAID;

 private LocalDateTime issuedAt;
 private LocalDateTime paidAt;

 @PrePersist
 protected void onCreate() { issuedAt = LocalDateTime.now(); if (status == null) status = InvoiceStatus.UNPAID; if (invoiceNumber == null) invoiceNumber = \INV-\ + System.currentTimeMillis(); }

 public Invoice() {}
 public Long getId() { return id; } public void setId(Long id) { this.id = id; }
 public Appointment getAppointment() { return appointment; } public void setAppointment(Appointment appointment) { this.appointment = appointment; }
 public String getInvoiceNumber() { return invoiceNumber; } public void setInvoiceNumber(String invoiceNumber) { this.invoiceNumber = invoiceNumber; }
 public BigDecimal getAmount() { return amount; } public void setAmount(BigDecimal amount) { this.amount = amount; }
 public InvoiceStatus getStatus() { return status; } public void setStatus(InvoiceStatus status) { this.status = status; }
 public LocalDateTime getIssuedAt() { return issuedAt; } public void setIssuedAt(LocalDateTime issuedAt) { this.issuedAt = issuedAt; }
 public LocalDateTime getPaidAt() { return paidAt; } public void setPaidAt(LocalDateTime paidAt) { this.paidAt = paidAt; }
}
