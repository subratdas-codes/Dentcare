package com.subrat.clinic.service;

import com.subrat.clinic.model.DoctorPhoto;
import com.subrat.clinic.repository.DoctorPhotoRepository;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Base64;
import java.util.UUID;
import javax.imageio.ImageIO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

/**
 * Stores and removes doctor profile photos shared by the admin and doctor
 * portals.
 *
 * <p>New photos are written to PostgreSQL, not to the local filesystem. Free
 * container hosts (Render, Koyeb, Vercel) throw away local files on every
 * deploy or restart, so the database is the only durable place for them. Legacy
 * files under {@code /uploads/doctors/} are still served and can still be
 * deleted.</p>
 */
@Component
public class DoctorPhotoStorage {

    private final DoctorPhotoRepository doctorPhotoRepository;
    private final String uploadDirectory;

    public DoctorPhotoStorage(DoctorPhotoRepository doctorPhotoRepository,
                              @Value("${app.upload-dir:uploads}") String uploadDirectory) {
        this.doctorPhotoRepository = doctorPhotoRepository;
        this.uploadDirectory = uploadDirectory;
    }

    public String save(MultipartFile photo) throws IOException {
        if (photo == null || photo.isEmpty()) {
            return null;
        }
        if (photo.getSize() > 5L * 1024 * 1024) {
            throw new IllegalArgumentException("Choose an image smaller than 5 MB.");
        }
        byte[] bytes = photo.getBytes();
        String extension;
        String contentType;
        if (bytes.length >= 8 && (bytes[0] & 0xff) == 0x89 && bytes[1] == 'P'
                && bytes[2] == 'N' && bytes[3] == 'G') {
            extension = ".png";
            contentType = "image/png";
        } else if (bytes.length >= 3 && (bytes[0] & 0xff) == 0xff
                && (bytes[1] & 0xff) == 0xd8 && (bytes[2] & 0xff) == 0xff) {
            extension = ".jpg";
            contentType = "image/jpeg";
        } else {
            throw new IllegalArgumentException("Use a valid JPEG or PNG image.");
        }
        BufferedImage image = ImageIO.read(new ByteArrayInputStream(bytes));
        if (image == null || image.getWidth() > 6000 || image.getHeight() > 6000) {
            throw new IllegalArgumentException("The selected image is invalid or too large in dimensions.");
        }

        DoctorPhoto stored = new DoctorPhoto();
        stored.setId(UUID.randomUUID() + extension);
        stored.setContentType(contentType);
        stored.setData(Base64.getEncoder().encodeToString(bytes));
        try {
            doctorPhotoRepository.save(stored);
        } catch (RuntimeException exception) {
            throw new IOException("Could not store the photo. Please try again.", exception);
        }
        return "/doctor-photo/" + stored.getId();
    }

    public void delete(String imagePath) {
        if (imagePath == null) {
            return;
        }
        if (imagePath.startsWith("/doctor-photo/")) {
            String id = imagePath.substring("/doctor-photo/".length());
            if (!id.matches("[a-fA-F0-9-]+\\.(jpg|png)")) {
                return;
            }
            try {
                doctorPhotoRepository.findById(id).ifPresent(doctorPhotoRepository::delete);
            } catch (RuntimeException ignored) {
                // A failed cleanup must not undo a successfully saved profile.
            }
            return;
        }

        if (!imagePath.matches("/uploads/doctors/[a-fA-F0-9-]+\\.(jpg|png)")) {
            return;
        }
        try {
            Path uploadRoot = Path.of(uploadDirectory).toAbsolutePath().normalize();
            Path doctorPhotoDirectory = uploadRoot.resolve("doctors").normalize();
            Path image = doctorPhotoDirectory.resolve(imagePath.substring(imagePath.lastIndexOf('/') + 1)).normalize();
            if (image.startsWith(doctorPhotoDirectory)) {
                Files.deleteIfExists(image);
            }
        } catch (IOException ignored) {
            // A failed cleanup must not undo a successfully saved profile.
        }
    }
}
