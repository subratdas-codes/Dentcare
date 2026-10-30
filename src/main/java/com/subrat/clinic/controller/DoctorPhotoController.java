package com.subrat.clinic.controller;

import com.subrat.clinic.model.DoctorPhoto;
import com.subrat.clinic.repository.DoctorPhotoRepository;
import java.util.Base64;
import java.util.Optional;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

/** Serves doctor profile photos that are stored in the database. */
@Controller
public class DoctorPhotoController {

    private static final String PUBLIC_CACHE = "public, max-age=31536000, immutable";

    private final DoctorPhotoRepository doctorPhotoRepository;

    public DoctorPhotoController(DoctorPhotoRepository doctorPhotoRepository) {
        this.doctorPhotoRepository = doctorPhotoRepository;
    }

    @GetMapping("/doctor-photo/{filename:.+}")
    public ResponseEntity<byte[]> photo(@PathVariable String filename) {
        if (!filename.matches("[a-fA-F0-9-]+\\.(jpg|png)")) {
            return ResponseEntity.notFound().build();
        }
        Optional<DoctorPhoto> photo = doctorPhotoRepository.findById(filename);
        if (photo.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        DoctorPhoto stored = photo.get();
        MediaType contentType;
        try {
            contentType = MediaType.parseMediaType(stored.getContentType());
        } catch (RuntimeException exception) {
            contentType = MediaType.APPLICATION_OCTET_STREAM;
        }
        return ResponseEntity.ok()
                .contentType(contentType)
                .header(HttpHeaders.CACHE_CONTROL, PUBLIC_CACHE)
                .body(Base64.getDecoder().decode(stored.getData()));
    }
}
