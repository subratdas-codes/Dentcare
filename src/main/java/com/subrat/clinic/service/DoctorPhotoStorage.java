package com.subrat.clinic.service;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;
import javax.imageio.ImageIO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

/** Stores and removes doctor profile photos shared by the admin and doctor portals. */
@Component
public class DoctorPhotoStorage {

    @Value("${app.upload-dir:uploads}")
    private String uploadDirectory;

    public String save(MultipartFile photo) throws IOException {
        if (photo == null || photo.isEmpty()) {
            return null;
        }
        if (photo.getSize() > 5L * 1024 * 1024) {
            throw new IllegalArgumentException("Choose an image smaller than 5 MB.");
        }
        byte[] bytes = photo.getBytes();
        String extension;
        if (bytes.length >= 8 && (bytes[0] & 0xff) == 0x89 && bytes[1] == 'P'
                && bytes[2] == 'N' && bytes[3] == 'G') {
            extension = ".png";
        } else if (bytes.length >= 3 && (bytes[0] & 0xff) == 0xff
                && (bytes[1] & 0xff) == 0xd8 && (bytes[2] & 0xff) == 0xff) {
            extension = ".jpg";
        } else {
            throw new IllegalArgumentException("Use a valid JPEG or PNG image.");
        }
        BufferedImage image = ImageIO.read(new ByteArrayInputStream(bytes));
        if (image == null || image.getWidth() > 6000 || image.getHeight() > 6000) {
            throw new IllegalArgumentException("The selected image is invalid or too large in dimensions.");
        }

        Path directory = Path.of(uploadDirectory).toAbsolutePath().normalize().resolve("doctors");
        Files.createDirectories(directory);
        String filename = UUID.randomUUID() + extension;
        Files.write(directory.resolve(filename), bytes);
        return "/uploads/doctors/" + filename;
    }

    public void delete(String imagePath) {
        if (imagePath == null || !imagePath.matches("/uploads/doctors/[a-fA-F0-9-]+\\.(jpg|png)")) {
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
