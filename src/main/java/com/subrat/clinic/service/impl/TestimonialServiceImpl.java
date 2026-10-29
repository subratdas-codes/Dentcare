package com.subrat.clinic.service.impl;

import com.subrat.clinic.model.Testimonial;
import com.subrat.clinic.repository.TestimonialRepository;
import com.subrat.clinic.service.TestimonialService;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TestimonialServiceImpl implements TestimonialService {

    private final TestimonialRepository repository;

    public TestimonialServiceImpl(TestimonialRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<Testimonial> findActive() {
        return repository.findByActiveTrueOrderByDisplayOrderAscIdDesc();
    }

    @Override
    public List<Testimonial> findAll() {
        return repository.findAllByOrderByDisplayOrderAscIdDesc();
    }

    @Override
    public Testimonial findById(Long id) {
        return id == null ? null : repository.findById(id).orElse(null);
    }

    @Override
    @Transactional
    public Testimonial save(Testimonial testimonial) {
        return repository.save(testimonial);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id != null) {
            repository.deleteById(id);
        }
    }

    @Override
    @Transactional
    public void toggle(Long id) {
        Testimonial testimonial = findById(id);
        if (testimonial != null) {
            testimonial.setActive(!testimonial.isActive());
            repository.save(testimonial);
        }
    }
}
