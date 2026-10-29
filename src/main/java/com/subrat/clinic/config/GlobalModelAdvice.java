package com.subrat.clinic.config;

import com.subrat.clinic.model.Patient;
import com.subrat.clinic.service.DoctorFeeService;
import com.subrat.clinic.service.PatientService;
import com.subrat.clinic.service.SiteSettingService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAdvice {

    private static final String PATIENT_REQUEST_ATTRIBUTE = "dc.currentPatient";

    private final SiteSettingService siteSettingService;
    private final PatientService patientService;
    private final DoctorFeeService doctorFeeService;

    public GlobalModelAdvice(SiteSettingService siteSettingService,
                             PatientService patientService,
                             DoctorFeeService doctorFeeService) {
        this.siteSettingService = siteSettingService;
        this.patientService = patientService;
        this.doctorFeeService = doctorFeeService;
    }

    @ModelAttribute("hasAdminRole")
    public boolean hasAdminRole(Authentication authentication) {
        return hasRole(authentication, "ROLE_ADMIN");
    }

    @ModelAttribute("hasDoctorRole")
    public boolean hasDoctorRole(Authentication authentication) {
        return hasRole(authentication, "ROLE_DOCTOR");
    }

    @ModelAttribute("hasUserRole")
    public boolean hasUserRole(Authentication authentication) {
        return hasRole(authentication, "ROLE_USER");
    }

    @ModelAttribute("site")
    public java.util.Map<String, String> site() {
        return siteSettingService.getSite();
    }

    @ModelAttribute("currentPatient")
    public Patient currentPatient(Authentication authentication, HttpServletRequest request) {
        if (!hasRole(authentication, "ROLE_USER")) {
            return null;
        }
        Object cached = request.getAttribute(PATIENT_REQUEST_ATTRIBUTE);
        if (cached instanceof Patient patient) {
            return patient;
        }
        Patient patient = patientService.findByEmail(authentication.getName());
        request.setAttribute(PATIENT_REQUEST_ATTRIBUTE, patient);
        return patient;
    }

    @ModelAttribute("currentPatientName")
    public String currentPatientName(Authentication authentication, HttpServletRequest request) {
        Patient patient = currentPatient(authentication, request);
        if (patient != null && patient.getName() != null && !patient.getName().isBlank()) {
            return patient.getName().trim();
        }
        String email = authentication == null ? "" : authentication.getName();
        int at = email.indexOf('@');
        return at > 0 ? email.substring(0, at) : email;
    }

    @ModelAttribute("currentPatientInitial")
    public String currentPatientInitial(Authentication authentication, HttpServletRequest request) {
        String name = currentPatientName(authentication, request);
        return name == null || name.isBlank()
                ? "U" : name.substring(0, 1).toUpperCase();
    }

    @ModelAttribute("pendingFeeCount")
    public long pendingFeeCount(Authentication authentication) {
        return hasRole(authentication, "ROLE_ADMIN") ? doctorFeeService.pendingCount() : 0L;
    }

    private boolean hasRole(Authentication authentication, String role) {
        if (authentication == null) return false;
        return authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals(role));
    }
}
