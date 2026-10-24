package com.subrat.clinic.config;

import java.nio.file.Path;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class DoctorPhotoWebConfig implements WebMvcConfigurer {

    private final String uploadDirectory;

    public DoctorPhotoWebConfig(@Value("${app.upload-dir:uploads}") String uploadDirectory) {
        this.uploadDirectory = uploadDirectory;
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path uploadRoot = Path.of(uploadDirectory).toAbsolutePath().normalize();
        String location = uploadRoot.toUri().toString();
        if (!location.endsWith("/")) location += "/";
        registry.addResourceHandler("/uploads/**").addResourceLocations(location);
    }
}
