package com.subrat.clinic.model;

public enum AppointmentStatus {

    BOOKED("Booked", "primary"),
    COMPLETED("Completed", "success"),
    CANCELLED("Cancelled", "danger");

    private final String label;
    private final String badgeClass;

    AppointmentStatus(String label, String badgeClass) {
        this.label = label;
        this.badgeClass = badgeClass;
    }

    public String getLabel() {
        return label;
    }

    public String getBadgeClass() {
        return badgeClass;
    }
}
