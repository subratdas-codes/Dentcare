package com.subrat.clinic.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Patient testimonial shown on the public home and testimonial pages.
 * Admin users create, edit, reorder, hide and delete these rows.
 */
@Entity
@Table(name = "testimonials")
public class Testimonial {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 90)
    private String patientName;

    @Column(length = 120)
    private String treatment;

    @Column(nullable = false, length = 1000)
    private String message;

    @Column(nullable = false)
    private int rating = 5;

    @Column(nullable = false)
    private int displayOrder = 0;

    @Column(nullable = false)
    private boolean active = true;

    private LocalDateTime createdAt = LocalDateTime.now();

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

    public String getTreatment() {
        return treatment;
    }

    public void setTreatment(String treatment) {
        this.treatment = treatment;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getRating() {
        return Math.max(1, Math.min(5, rating));
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getInitial() {
        return patientName == null || patientName.isBlank()
                ? "P" : patientName.trim().substring(0, 1).toUpperCase();
    }
}
