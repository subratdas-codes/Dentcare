package com.subrat.clinic.config;

import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.model.Patient;
import com.subrat.clinic.repository.DoctorRepository;
import com.subrat.clinic.repository.PatientRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public PortalSecurityContextRepository portalSecurityContextRepository() {
        return new PortalSecurityContextRepository();
    }

    @Bean
    public UserDetailsService userDetailsService(PatientRepository patientRepository,
                                                 DoctorRepository doctorRepository) {
        return email -> {
            Patient patient = patientRepository.findByEmail(email);
            if (patient != null) {
                return User.withUsername(patient.getEmail())
                        .password(patient.getPassword())
                        .roles("USER")
                        .build();
            }

            Doctor doctor = doctorRepository.findByEmail(email);
            if (doctor != null) {
                if (doctor.isAdmin()) {
                    return User.withUsername(doctor.getEmail())
                            .password(doctor.getPassword())
                            .roles("ADMIN")
                            .build();
                } else {
                    return User.withUsername(doctor.getEmail())
                            .password(doctor.getPassword())
                            .roles("DOCTOR")
                            .build();
                }
            }

            throw new UsernameNotFoundException("No user found with email: " + email);
        };
    }

    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler(
            PortalSecurityContextRepository portalSecurityContextRepository) {
        return (request, response, authentication) -> {
            boolean admin = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
            boolean doctor = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_DOCTOR"));

            // The staff portal's role selector is enforced on the server; it is
            // not just a visual choice in the login page.
            String requestedPortal = request.getParameter("portal");
            String selectedRole = request.getParameter("staffRole");
            boolean staffDoctor;
            boolean staffAdmin;
            if (selectedRole != null && !selectedRole.isBlank()) {
                staffDoctor = "DOCTOR".equalsIgnoreCase(selectedRole);
                staffAdmin = "ADMIN".equalsIgnoreCase(selectedRole);
            } else {
                staffDoctor = "DOCTOR".equalsIgnoreCase(requestedPortal);
                staffAdmin = "ADMIN".equalsIgnoreCase(requestedPortal)
                        || "admin".equalsIgnoreCase(requestedPortal);
            }

            // Admin and doctor accounts must use their own login page. This keeps
            // the patient login page patient-only and stops staff sessions from
            // appearing inside the user portal.
            if ((admin || doctor) && !staffAdmin && !staffDoctor) {
                SecurityContextHolder.clearContext();
                String staffLogin = admin ? "/admin/login" : "/doctor/login";
                response.sendRedirect(request.getContextPath() + staffLogin + "?error=portal");
                return;
            }

            if ((staffAdmin && !admin) || (staffDoctor && !doctor)) {
                portalSecurityContextRepository.clearContext(request);
                SecurityContextHolder.clearContext();
                String roleLoginPath = staffDoctor ? "/doctor/login" : "/admin/login";
                response.sendRedirect(request.getContextPath() + roleLoginPath + "?error=role");
                return;
            }

            if (admin) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (doctor) {
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        };
    }

    @Bean
    public AuthenticationFailureHandler authenticationFailureHandler() {
        return (request, response, exception) -> {
            String requestedPortal = request.getParameter("portal");
            String selectedRole = request.getParameter("staffRole");
            boolean staffDoctor = "DOCTOR".equalsIgnoreCase(selectedRole)
                    || "DOCTOR".equalsIgnoreCase(requestedPortal);
            boolean staffAdmin = "ADMIN".equalsIgnoreCase(selectedRole)
                    || "ADMIN".equalsIgnoreCase(requestedPortal)
                    || "admin".equalsIgnoreCase(requestedPortal);

            if (staffDoctor) {
                response.sendRedirect(request.getContextPath() + "/doctor/login?error=true");
            } else if (staffAdmin) {
                response.sendRedirect(request.getContextPath() + "/admin/login?error=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/login?error=true");
            }
        };
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   PortalSecurityContextRepository portalSecurityContextRepository,
                                                   AuthenticationSuccessHandler authenticationSuccessHandler,
                                                   AuthenticationFailureHandler authenticationFailureHandler) throws Exception {
        http
                .securityContext(context -> context.securityContextRepository(portalSecurityContextRepository))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                new AntPathRequestMatcher("/admin/login"),
                                new AntPathRequestMatcher("/admin/login/**"),
                                new AntPathRequestMatcher("/admin/forgot-password"),
                                new AntPathRequestMatcher("/admin/reset-password"),
                                new AntPathRequestMatcher("/admin/register"),
                                new AntPathRequestMatcher("/doctor/login"),
                                new AntPathRequestMatcher("/doctor/register"),
                                new AntPathRequestMatcher("/doctor/forgot-password"),
                                new AntPathRequestMatcher("/doctor/reset-password")
                        ).permitAll()
                        // Legacy doctor URLs kept alive for old bookmarks/links.
                        .requestMatchers(
                                new AntPathRequestMatcher("/admin/doctor"),
                                new AntPathRequestMatcher("/admin/doctor/**"),
                                new AntPathRequestMatcher("/admin/doctor-dashboard")
                        ).hasRole("DOCTOR")
                        .requestMatchers(new AntPathRequestMatcher("/admin/**")).hasRole("ADMIN")
                        .requestMatchers(new AntPathRequestMatcher("/doctor/**")).hasRole("DOCTOR")
                        .requestMatchers(new AntPathRequestMatcher("/profile"),
                                new AntPathRequestMatcher("/change-password"),
                                new AntPathRequestMatcher("/book_appointment"),
                                new AntPathRequestMatcher("/book"),
                                new AntPathRequestMatcher("/my/**")).hasRole("USER")
                        .requestMatchers(
                                new AntPathRequestMatcher("/login"),
                                new AntPathRequestMatcher("/register"),
                                new AntPathRequestMatcher("/doctor/register"),
                                new AntPathRequestMatcher("/forgot-password"),
                                new AntPathRequestMatcher("/reset-password"),
                                new AntPathRequestMatcher("/"),
                                new AntPathRequestMatcher("/about"),
                                new AntPathRequestMatcher("/service"),
                                new AntPathRequestMatcher("/team"),
                                new AntPathRequestMatcher("/price"),
                                new AntPathRequestMatcher("/testimonial"),
                                new AntPathRequestMatcher("/contact"),
                                new AntPathRequestMatcher("/css/**"),
                                new AntPathRequestMatcher("/js/**"),
                                new AntPathRequestMatcher("/img/**"),
                                new AntPathRequestMatcher("/lib/**"),
                                new AntPathRequestMatcher("/uploads/**"),
                                new AntPathRequestMatcher("/favicon.ico"),
                                new AntPathRequestMatcher("/actuator/health"),
                                new AntPathRequestMatcher("/actuator/health/**")).permitAll()
                        .anyRequest().permitAll()
                )
                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint((request, response, authException) -> {
                            String path = request.getRequestURI().substring(request.getContextPath().length());
                            String destination;
                            if (path.equals("/doctor") || path.startsWith("/doctor/")
                                    || path.equals("/admin/doctor") || path.startsWith("/admin/doctor/")
                                    || path.equals("/admin/doctor-dashboard")) {
                                destination = "/doctor/login";
                            } else if (path.equals("/admin") || path.startsWith("/admin/")) {
                                destination = "/admin/login";
                            } else {
                                destination = "/login";
                            }
                            response.sendRedirect(request.getContextPath() + destination);
                        })
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .successHandler(authenticationSuccessHandler)
                        .failureHandler(authenticationFailureHandler)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .addLogoutHandler((request, response, authentication) ->
                                portalSecurityContextRepository.clearContext(request))
                        .logoutSuccessHandler((request, response, authentication) -> {
                            boolean admin = authentication != null && authentication.getAuthorities().stream()
                                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
                            boolean doctor = authentication != null && authentication.getAuthorities().stream()
                                    .anyMatch(a -> a.getAuthority().equals("ROLE_DOCTOR"));
                            String destination = admin ? "/admin/login?logout=true"
                                    : doctor ? "/doctor/login?logout=true" : "/login?logout=true";
                            response.sendRedirect(request.getContextPath() + destination);
                        })
                        .invalidateHttpSession(false)
                        .clearAuthentication(true)
                );
        return http.build();
    }
}
