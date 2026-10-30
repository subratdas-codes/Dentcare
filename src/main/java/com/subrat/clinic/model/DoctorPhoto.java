package com.subrat.clinic.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;

/**
 * A doctor profile photo stored in the database rather than on the local
 * filesystem. Free container hosts have an ephemeral filesystem, so local files
 * disappear on every deploy or restart; the database is the one piece of
 * storage that survives.
 */
@Entity
@Table(name = "doctor_photos")
public class DoctorPhoto {

    /** UUID plus a .jpg/.png suffix, also used as the public URL segment. */
    @Id
    @Column(length = 80)
    private String id;

    @Column(nullable = false, length = 100)
    private String contentType;

    /**
     * Base64 image bytes. PostgreSQL and H2 both support an unbounded TEXT
     * column, which avoids database-specific binary large-object handling.
     */
    @Column(columnDefinition = "text", nullable = false)
    private String data;

    @Column(nullable = false)
    private Instant createdAt = Instant.now();

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }
}
