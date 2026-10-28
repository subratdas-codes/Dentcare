package com.subrat.clinic.model;

public enum PaymentMethod {

    NETBANKING("Net Banking"),
    QR("QR Code"),
    UPI("UPI"),
    DEBIT_CARD("Debit Card"),
    CREDIT_CARD("Credit Card"),
    CASH("Cash");

    private final String label;

    PaymentMethod(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }

    public boolean isOnline() {
        return this != CASH;
    }
}
