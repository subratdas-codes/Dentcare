package com.subrat.clinic.service;

import com.subrat.clinic.model.Testimonial;
import java.util.List;

public interface TestimonialService {

    List<Testimonial> findActive();

    List<Testimonial> findAll();

    Testimonial findById(Long id);

    Testimonial save(Testimonial testimonial);

    void delete(Long id);

    void toggle(Long id);
}
