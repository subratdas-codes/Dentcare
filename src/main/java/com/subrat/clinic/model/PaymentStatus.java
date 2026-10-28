package com.subrat.clinic.model;

public enum PaymentStatus {

    PENDING("Payment pending", "warning"),
    PAID("Paid", "success"),
    PAY_AT_CLINIC("Pay at clinic", "info");

    private final String label;
    private final String badgeClass;

    PaymentStatus(String label, String badgeClass) {
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
