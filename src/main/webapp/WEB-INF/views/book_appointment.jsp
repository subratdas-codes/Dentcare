<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Book Appointment - DentCare Dental Clinic</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="<c:url value='/lib/owlcarousel/assets/owl.carousel.min.css' />" rel="stylesheet">
    <link href="<c:url value='/lib/animate/animate.min.css' />" rel="stylesheet">

    <!-- Bootstrap + Template Stylesheet -->
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<c:url value='/css/style.css' />" rel="stylesheet">
</head>
<body>

<!-- Navbar -->
<%@ include file="_user_navbar.jsp" %>

<!-- Hero Start -->
<div class="container-fluid bg-primary py-5 hero-header mb-5">
    <div class="row py-3">
        <div class="col-12 text-center">
            <h1 class="display-4 text-white animated zoomIn">Book Appointment</h1>
            <a href="${pageContext.request.contextPath}/" class="h5 text-white-50">Home</a>
            <i class="far fa-circle text-white px-2"></i>
            <a href="${pageContext.request.contextPath}/book_appointment" class="h5 text-white">Book Appointment</a>
        </div>
    </div>
</div>
<!-- Hero End -->

<!-- Booking Form Start -->
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

                    <c:if test="${param.success == 'true'}">
                        <div class="alert alert-success bg-white text-success p-3 mb-3 rounded">
                            Appointment booked successfully!
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/book" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="row g-3">
                            <div class="col-12 col-sm-6">
                                <select class="form-select bg-light border-0" name="service" style="height: 55px;" required>
                                    <option value="" disabled selected>Select A Service</option>
                                    <option value="Teeth Cleaning">Teeth Cleaning</option>
                                    <option value="Root Canal">Root Canal</option>
                                    <option value="Braces">Braces</option>
                                    <option value="Tooth Whitening">Tooth Whitening</option>
                                    <option value="Dental Implants">Dental Implants</option>
                                </select>
                            </div>
                            <div class="col-12 col-sm-6">
                                <select class="form-select bg-light border-0" name="doctorName" style="height: 55px;" required>
                                    <option value="" disabled selected>Select Doctor</option>
                                    <c:forEach var="doc" items="${doctors}">
                                        <c:if test="${doc.specialization ne 'Admin' and not doc.admin}">
                                            <option value="${doc.name}">${doc.name} - ${doc.specialization}</option>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${empty doctors}">
                                        <option value="Dr. Priya Sharma">Dr. Priya Sharma - Orthodontist</option>
                                        <option value="Dr. Amit Verma">Dr. Amit Verma - Endodontist</option>
                                        <option value="Dr. Neha Gupta">Dr. Neha Gupta - Cosmetic Dentist</option>
                                    </c:if>
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
<!-- Booking Form End -->

<!-- Footer Start -->
<div class="container-fluid bg-primary text-white py-4 mt-5">
    <div class="container text-center">
        <p class="mb-0">&copy; <span id="year"></span> DentCare Dental Clinic. All rights reserved.</p>
    </div>
</div>
<!-- Footer End -->

<!-- Back to Top -->
<a href="#" class="btn btn-lg btn-primary btn-lg-square rounded back-to-top"><i class="bi bi-arrow-up"></i></a>

<!-- JS Libraries -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/lib/wow/wow.min.js' />"></script>
<script src="<c:url value='/lib/easing/easing.min.js' />"></script>
<script src="<c:url value='/lib/waypoints/waypoints.min.js' />"></script>
<script src="<c:url value='/lib/owlcarousel/owl.carousel.min.js' />"></script>
<script src="<c:url value='/js/main.js' />"></script>
<script>
    document.getElementById('year').textContent = new Date().getFullYear();
</script>
</body>
</html>