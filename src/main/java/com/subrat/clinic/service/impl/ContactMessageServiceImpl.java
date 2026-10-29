package com.subrat.clinic.service.impl;

import com.subrat.clinic.model.ContactMessage;
import com.subrat.clinic.repository.ContactMessageRepository;
import com.subrat.clinic.service.ContactMessageService;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ContactMessageServiceImpl implements ContactMessageService {

    private final ContactMessageRepository repository;

    public ContactMessageServiceImpl(ContactMessageRepository repository) {
        this.repository = repository;
    }

    @Override
    public ContactMessage save(ContactMessage message) {
        return repository.save(message);
    }

    @Override
    public List<ContactMessage> findAll() {
        return repository.findAllByOrderByCreatedAtDesc();
    }

    @Override
    public ContactMessage findById(Long id) {
        return id == null ? null : repository.findById(id).orElse(null);
    }

    @Override
    public long unreadCount() {
        return repository.countByReadFalse();
    }

    @Override
    @Transactional
    public void markRead(Long id, boolean read) {
        ContactMessage message = findById(id);
        if (message != null) {
            message.setRead(read);
            repository.save(message);
        }
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id != null) {
            repository.deleteById(id);
        }
    }
}
