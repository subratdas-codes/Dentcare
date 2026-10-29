package com.subrat.clinic.model;

public enum AppointmentType {

    CONSULTATION("Consultation", "bi-chat-square-text"),
    TREATMENT("Treatment", "bi-clipboard2-pulse");

    private final String label;
    private final String icon;

    AppointmentType(String label, String icon) {
        this.label = label;
        this.icon = icon;
    }

    public String getLabel() {
        return label;
    }

    public String getIcon() {
        return icon;
    }
}
