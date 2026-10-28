package com.subrat.clinic.repository;

import com.subrat.clinic.model.ServicePrice;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ServicePriceRepository extends JpaRepository<ServicePrice, Long> {

    ServicePrice findByServiceNameIgnoreCase(String serviceName);

    List<ServicePrice> findAllByOrderByIdAsc();
}
