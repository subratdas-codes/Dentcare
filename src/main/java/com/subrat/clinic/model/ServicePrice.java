package com.subrat.clinic.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

/**
 * Fee charged for a treatment/service. Admin users manage these rows from
 * /admin/pricing and the booking flow reads the live fee from this table.
 */
@Entity
@Table(name = "service_prices")
public class ServicePrice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 120)
    private String serviceName;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal fee;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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
}
