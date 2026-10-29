package com.subrat.clinic.service.impl;

import com.subrat.clinic.model.SiteSetting;
import com.subrat.clinic.repository.SiteSettingRepository;
import com.subrat.clinic.service.SiteSettingService;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SiteSettingServiceImpl implements SiteSettingService {

    private static final Map<String, String> DEFAULTS = buildDefaults();

    private final SiteSettingRepository repository;
    private volatile Map<String, String> cache;

    public SiteSettingServiceImpl(SiteSettingRepository repository) {
        this.repository = repository;
    }

    private static Map<String, String> buildDefaults() {
        Map<String, String> defaults = new LinkedHashMap<>();
        defaults.put("siteName", "DentCare");
        defaults.put("siteTagline", "Gentle dentistry, modern care");
        defaults.put("homeEyebrow", "Keep Your Teeth Healthy");
        defaults.put("homeHeading", "Take The Best Quality Dental Treatment");
        defaults.put("homeText", "Gentle, modern dentistry with clear pricing and dentists who listen.");
        defaults.put("aboutHeading", "A calmer kind of dental care");
        defaults.put("aboutText", "At DentCare we combine gentle treatment, transparent pricing and modern equipment so every visit feels calm and predictable. Our dentists explain each option before anything begins.");
        defaults.put("offerTitle", "New patient checkup offer");
        defaults.put("offerText", "Book your first consultation and get a complete oral health check with a clear treatment plan and no hidden charges.");
        defaults.put("serviceHeading", "Care for every smile");
        defaults.put("serviceText", "From routine cleaning to implants, every treatment is delivered by an experienced dentist with clear pricing.");
        defaults.put("teamHeading", "Meet your dentists");
        defaults.put("teamText", "A small, experienced team that takes time to explain every step of your treatment.");
        defaults.put("pricingHeading", "Clear, fair treatment prices");
        defaults.put("pricingText", "These are the standard clinic prices. Your dentist's approved fee is always shown before you pay.");
        defaults.put("testimonialHeading", "What our patients say");
        defaults.put("testimonialText", "Real feedback from patients who booked through DentCare.");
        defaults.put("contactHeading", "We are happy to help");
        defaults.put("contactText", "Send us a message, call the clinic or visit us. Our team replies during opening hours.");
        defaults.put("hoursWeekday", "Mon - Fri: 8:00 AM - 9:00 PM");
        defaults.put("hoursSaturday", "Saturday: 8:00 AM - 7:00 PM");
        defaults.put("hoursSunday", "Sunday: 8:00 AM - 5:00 PM");
        defaults.put("socialFacebook", "");
        defaults.put("socialInstagram", "");
        defaults.put("socialTwitter", "");
        defaults.put("socialLinkedin", "");
        defaults.put("mapQuery", "Patia, Bhubaneswar, Odisha, India 751024");
        defaults.put("navHome", "Home");
        defaults.put("navServices", "Services");
        defaults.put("navDoctors", "Doctors");
        defaults.put("navPricing", "Pricing");
        defaults.put("navContact", "Contact");
        defaults.put("bookButton", "Book Appointment");
        defaults.put("accountLabel", "My Account");
        defaults.put("footerAbout", "DentCare is a modern dental clinic focused on calm, comfortable visits for every patient.");
        defaults.put("footerAddress", "Patia, Bhubaneswar, Odisha 751024");
        defaults.put("footerPhone", "+91 94371 23456");
        defaults.put("footerEmail", "dentcare.support@gmail.com");
        defaults.put("footerHours", "Mon-Sat: 9:00 AM - 7:00 PM");
        defaults.put("footerCopyright", "DentCare Dental Clinic. All rights reserved.");
        defaults.put("consultationFee", "199.00");
        defaults.put("announcement", "New patient consultations from ₹199");
        defaults.put("bookingNote", "Choose a one-to-one consultation or a specific treatment with the dentist you prefer.");
        defaults.put("receiptTitle", "Payment Receipt");
        defaults.put("receiptNote", "This is a computer-generated receipt. Please keep it for your records.");
        defaults.put("receiptFooter", "Thank you for choosing DentCare. Please arrive 10 minutes before your appointment.");
        return Map.copyOf(defaults);
    }

    @Override
    public Map<String, String> getSite() {
        Map<String, String> current = cache;
        if (current == null) {
            current = load();
            cache = current;
        }
        return current;
    }

    @Override
    public String get(String key) {
        return getSite().getOrDefault(key, DEFAULTS.getOrDefault(key, ""));
    }

    @Override
    public BigDecimal getConsultationFee() {
        String raw = get("consultationFee");
        try {
            BigDecimal fee = new BigDecimal(raw);
            return fee.signum() < 0 ? new BigDecimal("199.00") : fee;
        } catch (NumberFormatException exception) {
            return new BigDecimal("199.00");
        }
    }

    @Override
    @Transactional
    public void update(Map<String, String> values) {
        for (Map.Entry<String, String> entry : values.entrySet()) {
            String key = entry.getKey();
            if (!DEFAULTS.containsKey(key) || entry.getValue() == null) {
                continue;
            }
            String value = entry.getValue().trim();
            SiteSetting setting = repository.findBySettingKey(key);
            if (setting == null) {
                setting = new SiteSetting();
                setting.setSettingKey(key);
            }
            setting.setSettingValue(value.length() > 1100 ? value.substring(0, 1100) : value);
            setting.setUpdatedAt(LocalDateTime.now());
            repository.save(setting);
        }
        cache = null;
    }

    private Map<String, String> load() {
        Map<String, String> merged = new LinkedHashMap<>(DEFAULTS);
        for (SiteSetting setting : repository.findAll()) {
            if (setting.getSettingKey() != null && setting.getSettingValue() != null
                    && DEFAULTS.containsKey(setting.getSettingKey())) {
                merged.put(setting.getSettingKey(), setting.getSettingValue());
            }
        }
        return Map.copyOf(merged);
    }
}
