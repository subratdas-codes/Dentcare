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
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
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
            if (doctor != null && doctor.isAdmin()) {
                return User.withUsername(doctor.getEmail())
                        .password(doctor.getPassword())
                        .roles("ADMIN")
                        .build();
            }

            throw new UsernameNotFoundException("No user found with email: " + email);
        };
    }

    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return (request, response, authentication) -> {
            boolean admin = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
            if (admin) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        };
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   AuthenticationSuccessHandler authenticationSuccessHandler) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(new AntPathRequestMatcher("/admin/**")).hasRole("ADMIN")
                        .requestMatchers(new AntPathRequestMatcher("/profile"),
                                new AntPathRequestMatcher("/change-password"),
                                new AntPathRequestMatcher("/my/**")).hasRole("USER")
                        .requestMatchers(
                                new AntPathRequestMatcher("/login"),
                                new AntPathRequestMatcher("/register"),
                                new AntPathRequestMatcher("/"),
                                new AntPathRequestMatcher("/about"),
                                new AntPathRequestMatcher("/service"),
                                new AntPathRequestMatcher("/team"),
                                new AntPathRequestMatcher("/price"),
                                new AntPathRequestMatcher("/testimonial"),
                                new AntPathRequestMatcher("/contact"),
                                new AntPathRequestMatcher("/book_appointment"),
                                new AntPathRequestMatcher("/book"),
                                new AntPathRequestMatcher("/css/**"),
                                new AntPathRequestMatcher("/js/**"),
                                new AntPathRequestMatcher("/img/**"),
                                new AntPathRequestMatcher("/lib/**"),
                                new AntPathRequestMatcher("/favicon.ico"),
                                new AntPathRequestMatcher("/actuator/health"),
                                new AntPathRequestMatcher("/actuator/health/**")).permitAll()
                        .anyRequest().permitAll()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .successHandler(authenticationSuccessHandler)
                        .failureUrl("/login?error=true")
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout=true")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                );
        return http.build();
    }
}