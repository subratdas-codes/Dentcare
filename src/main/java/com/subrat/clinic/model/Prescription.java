package com.subrat.clinic.model;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name =  prescriptions)
public class Prescription {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = appointment_id)
    private Appointment appointment;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = patient_id)
    private Patient patient;
    @Column(length = 2000)
    private String diagnosis;
    @Column(length = 4000)
    private String medicines;
    @Column(length = 2000)
    private String advice;
    private LocalDateTime createdAt;
    @PrePersist
    protected void onCreate() { createdAt = LocalDateTime.now(); }
    public Prescription() {}
    public Long getId() { return id; } public void setId(Long id) { this.id = id; }
    public Appointment getAppointment() { return appointment; } public void setAppointment(Appointment appointment) { this.appointment = appointment; }
    public Patient getPatient() { return patient; } public void setPatient(Patient patient) { this.patient = patient; }
    public String getDiagnosis() { return diagnosis; } public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }
    public String getMedicines() { return medicines; } public void setMedicines(String medicines) { this.medicines = medicines; }
    public String getAdvice() { return advice; } public void setAdvice(String advice) { this.advice = advice; }
    public LocalDateTime getCreatedAt() { return createdAt; } public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
