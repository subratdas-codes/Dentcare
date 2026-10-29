package com.subrat.clinic.service;

import java.math.BigDecimal;
import java.util.Map;

public interface SiteSettingService {

    Map<String, String> getSite();

    String get(String key);

    BigDecimal getConsultationFee();

    void update(Map<String, String> values);
}
