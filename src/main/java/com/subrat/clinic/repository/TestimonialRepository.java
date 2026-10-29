package com.subrat.clinic.repository;

import com.subrat.clinic.model.Testimonial;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TestimonialRepository extends JpaRepository<Testimonial, Long> {

    List<Testimonial> findByActiveTrueOrderByDisplayOrderAscIdDesc();

    List<Testimonial> findAllByOrderByDisplayOrderAscIdDesc();
}
