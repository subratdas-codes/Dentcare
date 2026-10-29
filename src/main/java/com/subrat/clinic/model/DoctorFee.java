package com.subrat.clinic.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * A doctor-specific fee. serviceName is "CONSULTATION" for the consultation
 * charge, otherwise it holds a treatment name. Only APPROVED rows (with a
 * non-null fee) affect booking prices; a doctor's request stays PENDING until
 * an admin approves it.
 */
@Entity
@Table(name = "doctor_fees",
        uniqueConstraints = @UniqueConstraint(columnNames = {"doctor_id", "service_name"}))
public class DoctorFee {

    public static final String CONSULTATION = "CONSULTATION";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    @Column(name = "service_name", nullable = false, length = 120)
    private String serviceName;

    @Column(precision = 10, scale = 2)
    private BigDecimal fee;

    @Column(precision = 10, scale = 2)
    private BigDecimal requestedFee;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private DoctorFeeStatus status = DoctorFeeStatus.APPROVED;

    private LocalDateTime updatedAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public BigDecimal getFee() {
        return fee;
    }

    public void setFee(BigDecimal fee) {
        this.fee = fee;
    }

    public BigDecimal getRequestedFee() {
        return requestedFee;
    }

    public void setRequestedFee(BigDecimal requestedFee) {
        this.requestedFee = requestedFee;
    }

    public DoctorFeeStatus getStatus() {
        return status == null ? DoctorFeeStatus.APPROVED : status;
    }

    public void setStatus(DoctorFeeStatus status) {
        this.status = status;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isConsultation() {
        return CONSULTATION.equalsIgnoreCase(serviceName);
    }

    public String getLabel() {
        return isConsultation() ? "Consultation" : serviceName;
    }

    public BigDecimal getDisplayFee() {
        return fee != null ? fee : requestedFee;
    }

    public boolean isPending() {
        return getStatus() == DoctorFeeStatus.PENDING;
    }
}
