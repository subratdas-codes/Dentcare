package com.subrat.clinic.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Locale;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpRequestResponseHolder;
import org.springframework.security.web.context.SecurityContextRepository;

/**
 * Keeps the admin, doctor and patient login sessions independent from each other.
 *
 * <p>A browser has one HTTP session, but that session can hold more than one
 * {@link SecurityContext}. The active context is selected from the URL (for
 * example {@code /admin/**} uses the admin context and {@code /doctor/**} uses
 * the doctor context), so signing in to one portal never silently signs the
 * user in to another portal.</p>
 */
public class PortalSecurityContextRepository implements SecurityContextRepository {

    public enum Portal {
        PATIENT,
        ADMIN,
        DOCTOR;

        String sessionKey() {
            return "DENTCARE_SECURITY_CONTEXT_" + name();
        }
    }

    private static final String ACTIVE_PORTAL = "DENTCARE_ACTIVE_PORTAL";

    @Override
    public SecurityContext loadContext(HttpRequestResponseHolder requestResponseHolder) {
        HttpServletRequest request = requestResponseHolder.getRequest();
        HttpSession session = request.getSession(false);
        Portal explicitPortal = portalForRequest(request);

        Portal portal = explicitPortal;
        if (portal == null) {
            portal = activePortal(session);
            if (read(session, portal) == null) {
                portal = firstAvailable(session);
            }
        }

        if (explicitPortal != null && session != null) {
            session.setAttribute(ACTIVE_PORTAL, explicitPortal.name());
        }

        SecurityContext context = read(session, portal);
        return context != null ? context : SecurityContextHolder.createEmptyContext();
    }

    @Override
    public void saveContext(SecurityContext context, HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(true);
        Portal portal = portalForRequest(request);
        if (portal == null) {
            portal = portalForAuthentication(context.getAuthentication());
        }
        if (portal == null) {
            portal = activePortal(session);
        }
        if (portal == null) {
            portal = Portal.PATIENT;
        }

        if (context.getAuthentication() == null) {
            session.removeAttribute(portal.sessionKey());
            refreshActivePortal(session);
            return;
        }

        session.setAttribute(portal.sessionKey(), context);
        session.setAttribute(ACTIVE_PORTAL, portal.name());
    }

    @Override
    public boolean containsContext(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        Portal explicitPortal = portalForRequest(request);
        if (explicitPortal != null) {
            return read(session, explicitPortal) != null;
        }
        Portal active = activePortal(session);
        if (read(session, active) != null) {
            return true;
        }
        return firstAvailable(session) != null;
    }

    /** Removes the active portal's context without touching the other portals. */
    public void clearContext(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        Portal portal = portalForRequest(request);
        if (portal == null) {
            portal = activePortal(session);
        }
        if (portal == null) {
            portal = portalForAuthentication(SecurityContextHolder.getContext().getAuthentication());
        }
        if (portal != null) {
            session.removeAttribute(portal.sessionKey());
        }
        refreshActivePortal(session);
    }

    private SecurityContext read(HttpSession session, Portal portal) {
        if (session == null || portal == null) {
            return null;
        }
        Object value = session.getAttribute(portal.sessionKey());
        return value instanceof SecurityContext securityContext ? securityContext : null;
    }

    private Portal activePortal(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute(ACTIVE_PORTAL);
        return value instanceof String name ? parse(name) : null;
    }

    private Portal firstAvailable(HttpSession session) {
        if (session == null) {
            return null;
        }
        for (Portal portal : new Portal[] { Portal.PATIENT, Portal.ADMIN, Portal.DOCTOR }) {
            if (session.getAttribute(portal.sessionKey()) != null) {
                return portal;
            }
        }
        return null;
    }

    private void refreshActivePortal(HttpSession session) {
        Portal active = activePortal(session);
        if (read(session, active) != null) {
            return;
        }
        Portal next = firstAvailable(session);
        if (next != null) {
            session.setAttribute(ACTIVE_PORTAL, next.name());
        } else {
            session.removeAttribute(ACTIVE_PORTAL);
        }
    }

    private Portal portalForRequest(HttpServletRequest request) {
        String path = request.getRequestURI();
        String contextPath = request.getContextPath();
        if (contextPath != null && !contextPath.isEmpty() && path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }

        if (path.equals("/admin/login/doctor")
                || path.equals("/admin/doctor")
                || path.startsWith("/admin/doctor/")
                || path.equals("/admin/doctor-dashboard")
                || path.equals("/doctor")
                || path.startsWith("/doctor/")) {
            return Portal.DOCTOR;
        }
        if (path.equals("/admin") || path.startsWith("/admin/")) {
            return Portal.ADMIN;
        }

        String requested = request.getParameter("portal");
        if (requested != null) {
            String normalized = requested.trim().toUpperCase(Locale.ROOT);
            if ("ADMIN".equals(normalized)) {
                String staffRole = request.getParameter("staffRole");
                return "DOCTOR".equalsIgnoreCase(staffRole) ? Portal.DOCTOR : Portal.ADMIN;
            }
            if ("DOCTOR".equals(normalized)) {
                return Portal.DOCTOR;
            }
            if ("PATIENT".equals(normalized) || "USER".equals(normalized)) {
                return Portal.PATIENT;
            }
        }
        return null;
    }

    private Portal portalForAuthentication(Authentication authentication) {
        if (authentication == null) {
            return null;
        }
        boolean admin = authentication.getAuthorities().stream()
                .anyMatch(authority -> "ROLE_ADMIN".equals(authority.getAuthority()));
        if (admin) {
            return Portal.ADMIN;
        }
        boolean doctor = authentication.getAuthorities().stream()
                .anyMatch(authority -> "ROLE_DOCTOR".equals(authority.getAuthority()));
        return doctor ? Portal.DOCTOR : Portal.PATIENT;
    }

    private Portal parse(String name) {
        try {
            return Portal.valueOf(name.trim().toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ignored) {
            return null;
        }
    }
}
