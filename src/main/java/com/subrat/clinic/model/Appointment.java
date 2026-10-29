package com.subrat.clinic.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(indexes = {
        @Index(name = "idx_appointment_email", columnList = "email"),
        @Index(name = "idx_appointment_doctor", columnList = "doctorId"),
        @Index(name = "idx_appointment_date", columnList = "appointmentDate")
})
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
 
    private String patientName;
    private String email;
    private String phone;
    private Long doctorId;
    private String doctorName;
    private String service;
    private LocalDate appointmentDate;
    private LocalTime appointmentTime;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private AppointmentType appointmentType = AppointmentType.TREATMENT;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private AppointmentStatus status = AppointmentStatus.BOOKED;

    private LocalDateTime cancelledAt;

    @Column(precision = 10, scale = 2)
    private BigDecimal amount;

    @Enumerated(EnumType.STRING)
    private PaymentMethod paymentMethod;

    @Enumerated(EnumType.STRING)
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;

    @Column(unique = true, length = 40)
    private String paymentReference;

    @Column(length = 160)
    private String paymentDetail;

    private LocalDateTime paidAt;

    @OneToMany(mappedBy = "appointment", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<AppointmentMessage> messages = new ArrayList<>();

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Long getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(Long doctorId) {
        this.doctorId = doctorId;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public AppointmentType getAppointmentType() {
        return appointmentType == null ? AppointmentType.TREATMENT : appointmentType;
    }

    public void setAppointmentType(AppointmentType appointmentType) {
        this.appointmentType = appointmentType;
    }

    public AppointmentStatus getStatus() {
        return status == null ? AppointmentStatus.BOOKED : status;
    }

    public void setStatus(AppointmentStatus status) {
        this.status = status;
    }

    public LocalDateTime getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(LocalDateTime cancelledAt) {
        this.cancelledAt = cancelledAt;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public LocalDate getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(LocalDate appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public LocalTime getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(LocalTime appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public PaymentStatus getPaymentStatus() {
        return paymentStatus == null ? PaymentStatus.PENDING : paymentStatus;
    }

    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentReference() {
        return paymentReference;
    }

    public void setPaymentReference(String paymentReference) {
        this.paymentReference = paymentReference;
    }

    public String getPaymentDetail() {
        return paymentDetail;
    }

    public void setPaymentDetail(String paymentDetail) {
        this.paymentDetail = paymentDetail;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public String getPaidAtDisplay() {
        return paidAt == null ? null
                : paidAt.format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a"));
    }

    public boolean isCashPayment() {
        return getPaymentStatus() == PaymentStatus.PAY_AT_CLINIC;
    }

    public boolean isPaymentPending() {
        return getPaymentStatus() == PaymentStatus.PENDING;
    }

    public boolean isCancelled() {
        return getStatus() == AppointmentStatus.CANCELLED;
    }

    public boolean isCompleted() {
        return getStatus() == AppointmentStatus.COMPLETED;
    }

    public boolean isBooked() {
        return getStatus() == AppointmentStatus.BOOKED;
    }

    public boolean isConsultation() {
        return getAppointmentType() == AppointmentType.CONSULTATION;
    }

    public boolean isUpcoming() {
        return isBooked() && appointmentDate != null
                && !appointmentDate.isBefore(LocalDate.now());
    }

    public boolean isPastVisit() {
        return !isCancelled() && appointmentDate != null
                && appointmentDate.isBefore(LocalDate.now());
    }

    public String getStatusBadgeClass() {
        return getStatus().getBadgeClass();
    }
}
