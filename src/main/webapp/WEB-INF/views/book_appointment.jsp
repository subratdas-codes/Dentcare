<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="index.jsp" />

<!-- Hero Section -->
<div class="container-fluid bg-primary py-5 hero-header mb-5">
    <div class="row py-3">
        <div class="col-12 text-center">
            <h1 class="display-3 text-white animated zoomIn">Book Appointment</h1>
            <a href="/" class="h4 text-white">Home</a>
            <i class="far fa-circle text-white px-2"></i>
            <a href="#" class="h4 text-white">Book Appointment</a>
        </div>
    </div>
</div>

<!-- Booking Form -->
<div class="container-fluid bg-primary bg-appointment my-5 wow fadeInUp" data-wow-delay="0.1s">
    <div class="container">
        <div class="row gx-5">
            <div class="col-lg-6 py-5">
                <div class="py-5">
                    <h1 class="display-5 text-white mb-4">We Are A Certified and Award Winning Dental Clinic You Can Trust</h1>
                    <p class="text-white mb-0">
                        Our trusted and professional dentists are here for you. Book your appointment and smile better.
                    </p>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="appointment-form h-100 d-flex flex-column justify-content-center text-center p-5 wow zoomIn" data-wow-delay="0.6s">
                    <h1 class="text-white mb-4">Make Appointment</h1>

                    <c:if test="${success}">
                        <div class="alert alert-success bg-white text-success p-3 mb-3 rounded">
                            Appointment booked successfully!
                        </div>
                    </c:if>

                    <form action="book" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="row g-3">
                            <div class="col-12 col-sm-6">
                                <select class="form-select bg-light border-0" name="service" style="height: 55px;" required>
                                    <option value="" disabled selected>Select A Service</option>
                                    <option value="Teeth Cleaning">Teeth Cleaning</option>
                                    <option value="Root Canal">Root Canal</option>
                                    <option value="Braces">Braces</option>
                                </select>
                            </div>
                            <div class="col-12 col-sm-6">
                                <select class="form-select bg-light border-0" name="doctorName" style="height: 55px;" required>
                                    <option value="" disabled selected>Select Doctor</option>
                                    <option value="Dr. A">Dr. A</option>
                                    <option value="Dr. B">Dr. B</option>
                                    <option value="Dr. C">Dr. C</option>
                                </select>
                            </div>
                            <div class="col-12 col-sm-6">
                                <input type="text" name="patientName" class="form-control bg-light border-0" placeholder="Your Name" style="height: 55px;" required />
                            </div>
                            <div class="col-12 col-sm-6">
                                <input type="email" name="email" class="form-control bg-light border-0" placeholder="Your Email" style="height: 55px;" required />
                            </div>
                            <div class="col-12 col-sm-6">
                                <input type="text" name="phone" class="form-control bg-light border-0" placeholder="Phone Number" style="height: 55px;" required />
                            </div>
                            <div class="col-12 col-sm-6">
                                <input type="date" name="appointmentDate" class="form-control bg-light border-0" style="height: 55px;" required />
                            </div>
                            <div class="col-12 col-sm-6">
                                <input type="time" name="appointmentTime" class="form-control bg-light border-0" style="height: 55px;" required />
                            </div>
                            <div class="col-12">
                                <button class="btn btn-dark w-100 py-3" type="submit">Book Appointment</button>
                            </div>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
</div>


