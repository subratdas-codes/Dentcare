package com.subrat.clinic.service;

import com.subrat.clinic.model.ContactMessage;
import java.util.List;

public interface ContactMessageService {

    ContactMessage save(ContactMessage message);

    List<ContactMessage> findAll();

    ContactMessage findById(Long id);

    long unreadCount();

    void markRead(Long id, boolean read);

    void delete(Long id);
}
