package com.subrat.clinic.service;

import com.subrat.clinic.model.ServicePrice;
import java.util.List;

public interface ServicePriceService {

    List<ServicePrice> findAll();

    ServicePrice findById(Long id);

    ServicePrice findByServiceName(String serviceName);

    ServicePrice save(ServicePrice servicePrice);
}
