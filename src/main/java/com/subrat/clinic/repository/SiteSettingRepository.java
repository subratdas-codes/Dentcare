package com.subrat.clinic.repository;

import com.subrat.clinic.model.SiteSetting;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SiteSettingRepository extends JpaRepository<SiteSetting, Long> {

    SiteSetting findBySettingKey(String settingKey);
}
