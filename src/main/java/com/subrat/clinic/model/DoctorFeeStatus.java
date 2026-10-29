package com.subrat.clinic.model;

public enum DoctorFeeStatus {

    APPROVED("Approved", "success"),
    PENDING("Pending approval", "warning"),
    REJECTED("Rejected", "danger");

    private final String label;
    private final String badgeClass;

    DoctorFeeStatus(String label, String badgeClass) {
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
