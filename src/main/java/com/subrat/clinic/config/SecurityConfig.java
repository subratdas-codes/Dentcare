package com.subrat.clinic.config;

import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.model.Patient;
import com.subrat.clinic.repository.DoctorRepository;
import com.subrat.clinic.repository.PatientRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
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
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return (request, response, authentication) -> {
            boolean admin = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
            boolean doctor = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_DOCTOR"));

            // The staff portal's role selector is enforced on the server; it is
            // not just a visual choice in the login page.
            if ("admin".equals(request.getParameter("portal"))) {
                String selectedRole = request.getParameter("staffRole");
                boolean roleMatches = ("ADMIN".equals(selectedRole) && admin)
                        || ("DOCTOR".equals(selectedRole) && doctor);
                if (!roleMatches) {
                    SecurityContextHolder.clearContext();
                    var session = request.getSession(false);
                    if (session != null) session.invalidate();
                    response.sendRedirect(request.getContextPath()
                            + "/admin/login?error=true&role="
                            + ("DOCTOR".equals(selectedRole) ? "DOCTOR" : "ADMIN"));
                    return;
                }
            }

            if (admin) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (doctor) {
                response.sendRedirect(request.getContextPath() + "/admin/doctor-dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        };
    }

    @Bean
    public AuthenticationFailureHandler authenticationFailureHandler() {
        return (request, response, exception) -> {
            if ("admin".equals(request.getParameter("portal"))) {
                String role = "DOCTOR".equals(request.getParameter("staffRole")) ? "DOCTOR" : "ADMIN";
                response.sendRedirect(request.getContextPath() + "/admin/login?error=true&role=" + role);
            } else {
                response.sendRedirect(request.getContextPath() + "/login?error=true");
            }
        };
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   AuthenticationSuccessHandler authenticationSuccessHandler,
                                                   AuthenticationFailureHandler authenticationFailureHandler) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                new AntPathRequestMatcher("/admin/login"),
                                new AntPathRequestMatcher("/admin/forgot-password"),
                                new AntPathRequestMatcher("/admin/reset-password"),
                                new AntPathRequestMatcher("/admin/register")
                        ).permitAll()
                        .requestMatchers(
                                new AntPathRequestMatcher("/admin/doctors"),
                                new AntPathRequestMatcher("/admin/doctors/**"),
                                new AntPathRequestMatcher("/admin/patients"),
                                new AntPathRequestMatcher("/admin/patients/**"),
                                new AntPathRequestMatcher("/admin/pricing"),
                                new AntPathRequestMatcher("/admin/pricing/**"),
                                new AntPathRequestMatcher("/admin/invoices"),
                                new AntPathRequestMatcher("/admin/invoices/**"),
                                new AntPathRequestMatcher("/admin/mail-test"),
                                new AntPathRequestMatcher("/admin/mail-test/**"),
                                new AntPathRequestMatcher("/admin/appointments/edit/**"),
                                new AntPathRequestMatcher("/admin/appointments/update"),
                                new AntPathRequestMatcher("/admin/appointments/delete/**")
                        ).hasRole("ADMIN")
                        .requestMatchers(new AntPathRequestMatcher("/admin/**")).hasAnyRole("ADMIN", "DOCTOR")
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
                                new AntPathRequestMatcher("/favicon.ico"),
                                new AntPathRequestMatcher("/actuator/health"),
                                new AntPathRequestMatcher("/actuator/health/**")).permitAll()
                        .anyRequest().permitAll()
                )
                .exceptionHandling(ex -> ex
                        .defaultAuthenticationEntryPointFor(
                                (request, response, authException) -> response.sendRedirect(request.getContextPath() + "/admin/login"),
                                new org.springframework.security.web.util.matcher.AntPathRequestMatcher("/admin/**")
                        )
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .successHandler(authenticationSuccessHandler)
                        .failureHandler(authenticationFailureHandler)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessHandler((request, response, authentication) -> {
                            boolean staff = authentication != null && authentication.getAuthorities().stream()
                                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN")
                                            || a.getAuthority().equals("ROLE_DOCTOR"));
                            String destination = staff ? "/admin/login?logout=true" : "/login?logout=true";
                            response.sendRedirect(request.getContextPath() + destination);
                        })
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                );
        return http.build();
    }
}
