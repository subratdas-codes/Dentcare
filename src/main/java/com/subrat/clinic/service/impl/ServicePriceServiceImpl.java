package com.subrat.clinic.service.impl;

import com.subrat.clinic.model.ServicePrice;
import com.subrat.clinic.repository.ServicePriceRepository;
import com.subrat.clinic.service.ServicePriceService;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ServicePriceServiceImpl implements ServicePriceService {

    @Autowired
    private ServicePriceRepository servicePriceRepository;

    @Override
    public List<ServicePrice> findAll() {
        return servicePriceRepository.findAllByOrderByIdAsc();
    }

    @Override
    public List<ServicePrice> findActive() {
        return findAll().stream().filter(ServicePrice::isActive).toList();
    }

    @Override
    public ServicePrice findById(Long id) {
        return id == null ? null : servicePriceRepository.findById(id).orElse(null);
    }

    @Override
    public ServicePrice findByServiceName(String serviceName) {
        if (serviceName == null || serviceName.isBlank()) {
            return null;
        }
        return servicePriceRepository.findByServiceNameIgnoreCase(serviceName.trim());
    }

    @Override
    public ServicePrice save(ServicePrice servicePrice) {
        servicePrice.setUpdatedAt(LocalDateTime.now());
        return servicePriceRepository.save(servicePrice);
    }

    @Override
    public void delete(Long id) {
        if (id != null) {
            servicePriceRepository.deleteById(id);
        }
    }
}
