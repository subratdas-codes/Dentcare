
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title><c:out value="${site.siteName}" /> - Gentle Dental Care</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="Gentle dentistry, clear pricing and easy online booking." name="description">

    <!-- Favicon -->
    <link href="${pageContext.request.contextPath}/img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet"> 

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />
    <link href="lib/twentytwenty/twentytwenty.css" rel="stylesheet" />

    <!-- Customized Bootstrap Stylesheet -->
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="<c:url value='/css/style.css' />" rel="stylesheet">
</head>

<body>
    <!-- Topbar / Navbar Start -->
    <%@ include file="_user_navbar.jsp" %>
    <!-- Topbar / Navbar End -->




    <!-- Carousel Start -->
    <div class="container-fluid p-0">
        <div id="header-carousel" class="carousel slide carousel-fade" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img class="w-100" src="img/carousel-1.jpg" alt="Image">
                    <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                        <div class="p-3" style="max-width: 900px;">
                            <h5 class="text-white text-uppercase mb-3 animated slideInDown"><c:out value="${site.homeEyebrow}" /></h5>
                            <h1 class="display-1 text-white mb-md-2 animated zoomIn"><c:out value="${site.homeHeading}" /></h1>
                            <p class="text-white mb-md-4 animated fadeIn"><c:out value="${site.homeText}" /></p>
                            <sec:authorize access="isAuthenticated()">
                            <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-primary py-md-3 px-md-5 me-3 animated slideInLeft">Appointment</a>
                            </sec:authorize>
                            <a href="${pageContext.request.contextPath}/contact" class="btn btn-secondary py-md-3 px-md-5 animated slideInRight">Contact Us</a>
                        </div>
                    </div>
                </div>
                <div class="carousel-item">
                    <img class="w-100" src="img/carousel-2.jpg" alt="Image">
                    <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                        <div class="p-3" style="max-width: 900px;">
                            <h5 class="text-white text-uppercase mb-3 animated slideInDown"><c:out value="${site.homeEyebrow}" /></h5>
                            <h1 class="display-1 text-white mb-md-2 animated zoomIn"><c:out value="${site.homeHeading}" /></h1>
                            <p class="text-white mb-md-4 animated fadeIn"><c:out value="${site.homeText}" /></p>
                            <sec:authorize access="isAuthenticated()">
                            <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-primary py-md-3 px-md-5 me-3 animated slideInLeft">Appointment</a>
                            </sec:authorize>
                            <a href="${pageContext.request.contextPath}/contact" class="btn btn-secondary py-md-3 px-md-5 animated slideInRight">Contact Us</a>
                        </div>
                    </div>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#header-carousel"
                data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#header-carousel"
                data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>
    </div>
    <!-- Carousel End -->


    <!-- Banner Start -->
    <div class="container-fluid banner mb-5">
        <div class="container">
            <div class="row gx-0">
                <div class="col-lg-4 wow zoomIn" data-wow-delay="0.1s">
                    <div class="bg-primary d-flex flex-column p-5" style="height: 300px;">
                        <h3 class="text-white mb-3">Opening Hours</h3>
                        <div class="d-flex justify-content-between text-white mb-3">
                            <p class="mb-0"><i class="far fa-clock me-2"></i><c:out value="${site.hoursWeekday}" /></p>
                        </div>
                        <div class="d-flex justify-content-between text-white mb-3">
                            <p class="mb-0"><c:out value="${site.hoursSaturday}" /></p>
                        </div>
                        <div class="d-flex justify-content-between text-white mb-3">
                            <p class="mb-0"><c:out value="${site.hoursSunday}" /></p>
                        </div>
                        <sec:authorize access="isAuthenticated()">
                            <a class="btn btn-light mt-auto" href="${pageContext.request.contextPath}/book_appointment">Appointment</a>
                        </sec:authorize>
                        <sec:authorize access="!isAuthenticated()">
                            <a class="btn btn-light mt-auto" href="${pageContext.request.contextPath}/contact">Contact Us</a>
                        </sec:authorize>
                    </div>
                </div>
                <div class="col-lg-4 wow zoomIn" data-wow-delay="0.3s">
                    <div class="bg-dark d-flex flex-column p-5" style="height: 300px;">
                        <h3 class="text-white mb-3">Our Services</h3>
                        <p class="text-white mb-3"><c:out value="${site.serviceText}" /></p>
                        <a class="btn btn-light mt-auto" href="${pageContext.request.contextPath}/service">Explore Services</a>
                    </div>
                </div>
                <div class="col-lg-4 wow zoomIn" data-wow-delay="0.6s">
                    <div class="bg-secondary d-flex flex-column p-5" style="height: 300px;">
                        <h3 class="text-white mb-3">Make Appointment</h3>
                        <sec:authorize access="isAuthenticated()">
                            <p class="text-white">Book your preferred time with our trusted and professional dentists.</p>
                            <a href="tel:<c:out value='${site.footerPhone}' />" class="text-white text-decoration-none"><h2 class="text-white mb-0"><c:out value="${site.footerPhone}" /></h2></a>
                            <a class="btn btn-light mt-auto" href="${pageContext.request.contextPath}/book_appointment">Book Now</a>
                        </sec:authorize>
                        <sec:authorize access="!isAuthenticated()">
                            <p class="text-white">Please login or register to book an appointment with our trusted dentists.</p>
                            <a href="tel:<c:out value='${site.footerPhone}' />" class="text-white text-decoration-none"><h2 class="text-white mb-0"><c:out value="${site.footerPhone}" /></h2></a>
                            <a class="btn btn-light mt-auto" href="${pageContext.request.contextPath}/login">Login to Book</a>
                        </sec:authorize>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Banner Start -->


    <!-- About Start -->
    <div class="container-fluid py-5 wow fadeInUp" data-wow-delay="0.1s">
        <div class="container">
            <div class="row g-5">
                <div class="col-lg-7">
                    <div class="section-title mb-4">
                        <h5 class="position-relative d-inline-block text-primary text-uppercase">About Us</h5>
                        <h1 class="display-5 mb-0"><c:out value="${site.aboutHeading}" /></h1>
                    </div>
                    <h4 class="text-body fst-italic mb-4"><c:out value="${site.siteTagline}" /></h4>
                    <p class="mb-4"><c:out value="${site.aboutText}" /></p>
                    <div class="row g-3">
                        <div class="col-sm-6 wow zoomIn" data-wow-delay="0.3s">
                            <h5 class="mb-3"><i class="fa fa-check-circle text-primary me-3"></i>Experienced Dentists</h5>
                            <h5 class="mb-3"><i class="fa fa-check-circle text-primary me-3"></i>Gentle, Modern Care</h5>
                        </div>
                        <div class="col-sm-6 wow zoomIn" data-wow-delay="0.6s">
                            <h5 class="mb-3"><i class="fa fa-check-circle text-primary me-3"></i>Open 7 Days</h5>
                            <h5 class="mb-3"><i class="fa fa-check-circle text-primary me-3"></i>Fair, Approved Prices</h5>
                        </div>
                    </div>
                    <sec:authorize access="isAuthenticated()">
                    <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-primary py-3 px-5 mt-4 wow zoomIn" data-wow-delay="0.6s">Make Appointment</a>
                    </sec:authorize>
                    <sec:authorize access="!isAuthenticated()">
                    <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary py-3 px-5 mt-4 wow zoomIn" data-wow-delay="0.6s">Contact Us</a>
                    </sec:authorize>
                </div>
                <div class="col-lg-5" style="min-height: 500px;">
                    <div class="position-relative h-100">
                        <img class="position-absolute w-100 h-100 rounded wow zoomIn" data-wow-delay="0.9s" src="img/about.jpg" style="object-fit: cover;">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- About End -->


    <!-- Appointment Start -->
    <div class="container-fluid bg-primary bg-appointment my-5 wow fadeInUp" data-wow-delay="0.1s">
        <div class="container">
            <div class="row gx-5">
                <div class="col-lg-6 py-5">
                    <div class="py-5">
                        <h1 class="display-5 text-white mb-4"><c:out value="${site.offerTitle}" /></h1>
                        <p class="text-white mb-0"><c:out value="${site.offerText}" /></p>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="appointment-form h-100 d-flex flex-column justify-content-center text-center p-5 wow zoomIn" data-wow-delay="0.6s">
                        <sec:authorize access="isAuthenticated()">
                        <h1 class="text-white mb-4">Make Appointment</h1>
                      <form action="${pageContext.request.contextPath}/book" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <div class="row g-3">
                                <div class="col-12 col-sm-6">
                                    <select class="form-select bg-light border-0" name="service" style="height: 55px;" required>
                                        <option value="" disabled selected>Select A Service</option>
                                        <c:forEach var="sp" items="${servicePrices}">
                                            <option value="${sp.serviceName}">${sp.serviceName} - ₹${sp.fee}</option>
                                        </c:forEach>
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
                                    <button class="btn btn-dark w-100 py-3" type="submit">Make Appointment</button>
                                </div>
                            </div>
                        </form>
                        </sec:authorize>
                        <sec:authorize access="!isAuthenticated()">
                            <h1 class="text-white mb-4">Make Appointment</h1>
                            <p class="text-white mb-4">Please login or register to book an appointment with our trusted and professional dentists.</p>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-light py-3 w-100 mb-3">Login to Book</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-dark py-3 w-100">Register</a>
                        </sec:authorize>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Appointment End -->


    <!-- Service Start -->
    <div class="container-fluid py-5 wow fadeInUp" data-wow-delay="0.1s">
        <div class="container">
            <div class="text-center section-title mb-5">
                <h5 class="position-relative d-inline-block text-primary text-uppercase">Our Services</h5>
                <h1 class="display-5 mb-3"><c:out value="${site.serviceHeading}" /></h1>
                <p class="mb-0 mx-auto" style="max-width:720px;"><c:out value="${site.serviceText}" /></p>
            </div>
            <div class="row g-5 align-items-center">
                <div class="col-lg-5 wow zoomIn" data-wow-delay="0.3s">
                    <div class="position-relative rounded overflow-hidden" style="min-height:420px;">
                        <img class="position-absolute w-100 h-100" src="${pageContext.request.contextPath}/img/about.jpg" style="object-fit:cover;" alt="DentCare clinic">
                    </div>
                </div>
                <div class="col-lg-7">
                    <div class="row g-4">
                        <c:forEach var="sp" items="${servicePrices}" varStatus="s" end="3">
                            <c:set var="imageIndex" value="${s.index % 4 + 1}" />
                            <div class="col-sm-6 wow zoomIn" data-wow-delay="0.3s">
                                <div class="service-item h-100 bg-light rounded overflow-hidden d-flex flex-column">
                                    <img class="img-fluid" src="${pageContext.request.contextPath}/img/service-${imageIndex}.jpg" alt="<c:out value='${sp.serviceName}' />">
                                    <div class="p-4 d-flex flex-column flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-start gap-2 mb-2">
                                            <h5 class="mb-0"><c:out value="${sp.serviceName}" /></h5>
                                            <span class="badge text-white" style="background:#0f766e;">₹<fmt:formatNumber value="${sp.fee}" minFractionDigits="0" maxFractionDigits="0" /></span>
                                        </div>
                                        <p class="small mb-3" style="color:#52627a;"><c:out value="${empty sp.description ? 'Delivered by an experienced DentCare dentist with clear pricing.' : sp.description}" /></p>
                                        <a class="btn btn-sm btn-primary mt-auto align-self-start" href="${pageContext.request.contextPath}/book_appointment">Book this treatment</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty servicePrices}">
                            <div class="col-12"><div class="alert alert-info mb-0">Our treatment list is being updated. Please call the clinic or send us a message.</div></div>
                        </c:if>
                    </div>
                </div>
            </div>
            <div class="text-center mt-5">
                <a href="${pageContext.request.contextPath}/service" class="btn btn-primary py-3 px-5">View all services</a>
            </div>
        </div>
    </div>
    <!-- Service End -->





    <!-- Pricing Start -->
    <div class="container-fluid py-5 wow fadeInUp" data-wow-delay="0.1s">
        <div class="container">
            <div class="row g-5">
                <div class="col-lg-4">
                    <div class="section-title mb-4">
                        <h5 class="position-relative d-inline-block text-primary text-uppercase">Pricing Plan</h5>
                        <h1 class="display-5 mb-0"><c:out value="${site.pricingHeading}" /></h1>
                    </div>
                    <p class="mb-4"><c:out value="${site.pricingText}" /></p>
                    <h5 class="text-uppercase" style="color:#0b5d57;">Call for Appointment</h5>
                    <a href="tel:<c:out value='${site.footerPhone}' />" class="text-decoration-none" style="color:inherit;"><h1 class="wow fadeInUp" data-wow-delay="0.6s"><c:out value="${site.footerPhone}" /></h1></a>
                    <a href="${pageContext.request.contextPath}/price" class="btn btn-primary py-3 px-5 mt-3">Compare all prices</a>
                </div>
                <div class="col-lg-8">
                    <div class="row g-4">
                        <c:forEach var="sp" items="${servicePrices}" varStatus="s" end="5">
                            <c:set var="priceImage" value="${s.index % 3 + 1}" />
                            <div class="col-md-6 col-xl-4 wow zoomIn" data-wow-delay="0.3s">
                                <div class="price-item pb-4 h-100">
                                    <div class="position-relative">
                                        <img class="img-fluid rounded-top w-100" src="${pageContext.request.contextPath}/img/price-${priceImage}.jpg" alt="<c:out value='${sp.serviceName}' />" style="height:150px;object-fit:cover;">
                                        <div class="d-flex align-items-center justify-content-center bg-light rounded pt-2 px-3 position-absolute top-100 start-50 translate-middle" style="z-index:2;">
                                            <h2 class="m-0" style="color:#0b5d57;">₹<fmt:formatNumber value="${sp.fee}" minFractionDigits="0" maxFractionDigits="0" /></h2>
                                        </div>
                                    </div>
                                    <div class="position-relative text-center bg-light border-bottom border-primary py-5 p-4 d-flex flex-column h-100">
                                        <h4><c:out value="${sp.serviceName}" /></h4>
                                        <hr class="text-primary w-50 mx-auto mt-0">
                                        <p class="small mb-3" style="color:#52627a;"><c:out value="${empty sp.description ? 'Clear pricing and a personalised treatment plan.' : sp.description}" /></p>
                                        <div class="d-flex justify-content-between mb-2"><span>Modern Equipment</span><i class="fa fa-check text-primary pt-1"></i></div>
                                        <div class="d-flex justify-content-between mb-2"><span>Professional Dentist</span><i class="fa fa-check text-primary pt-1"></i></div>
                                        <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-primary py-2 px-4 mt-auto">Book now</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty servicePrices}">
                            <div class="col-12"><div class="alert alert-info mb-0">Prices are being updated. Please contact the clinic for a quote.</div></div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Pricing End -->


    <!-- Testimonial Start -->
    <div class="container-fluid py-5 my-5 wow fadeInUp" data-wow-delay="0.1s" style="background:#0b172a;">
        <div class="container py-4">
            <div class="text-center section-title mb-5">
                <h5 class="position-relative d-inline-block text-uppercase" style="color:#a8eadf;">Patient Stories</h5>
                <h1 class="display-5 text-white mb-3"><c:out value="${site.testimonialHeading}" /></h1>
                <p class="mb-0 mx-auto" style="max-width:700px;color:#d8e5f2;"><c:out value="${site.testimonialText}" /></p>
            </div>
            <div class="row g-4 justify-content-center">
                <c:forEach var="t" items="${testimonials}" varStatus="s" end="5">
                    <div class="col-md-6 col-xl-4 wow zoomIn" data-wow-delay="0.3s">
                        <div class="bg-white rounded p-4 h-100 d-flex flex-column">
                            <div class="mb-2" style="color:#92400e;">
                                <c:forEach begin="1" end="${t.rating}"><i class="fa fa-star"></i></c:forEach>
                            </div>
                            <p class="mb-4" style="color:#33445c;">&ldquo;<c:out value="${t.message}" />&rdquo;</p>
                            <div class="d-flex align-items-center gap-3 mt-auto">
                                <div class="rounded-circle d-flex align-items-center justify-content-center" style="width:44px;height:44px;background:#eaf7f4;color:#0b5d57;font-weight:800;"><c:out value="${t.initial}" /></div>
                                <div>
                                    <div class="fw-bold" style="color:#10243e;"><c:out value="${t.patientName}" /></div>
                                    <div class="small" style="color:#5b6b82;"><c:out value="${empty t.treatment ? 'DentCare patient' : t.treatment}" /></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty testimonials}">
                    <div class="col-lg-8"><div class="alert alert-light mb-0 text-center">Patient reviews will appear here soon.</div></div>
                </c:if>
            </div>
            <div class="text-center mt-5">
                <a href="${pageContext.request.contextPath}/testimonial" class="btn btn-light py-3 px-5">Read all reviews</a>
            </div>
        </div>
    </div>
    <!-- Testimonial End -->


    <!-- Team Start -->
    <div class="container-fluid py-5">
        <div class="container">
            <div class="row g-4 align-items-stretch">
                <div class="col-lg-4 wow slideInUp" data-wow-delay="0.1s">
                    <div class="section-title bg-light rounded h-100 p-5 d-flex flex-column justify-content-center">
                        <h5 class="position-relative d-inline-block text-primary text-uppercase">Our Dentists</h5>
                        <h1 class="display-6 mb-3"><c:out value="${site.teamHeading}" /></h1>
                        <p style="color:#52627a;"><c:out value="${site.teamText}" /></p>
                        <a href="${pageContext.request.contextPath}/team" class="btn btn-primary py-3 px-5 align-self-start mt-2">Meet the team</a>
                    </div>
                </div>
                <c:forEach var="doc" items="${doctors}" varStatus="s" end="2">
                    <div class="col-md-6 col-lg-4 wow slideInUp" data-wow-delay="0.3s">
                        <div class="team-item h-100 d-flex flex-column">
                            <div class="position-relative rounded-top" style="z-index:1;">
                                <c:choose>
                                    <c:when test="${not empty doc.profileImagePath}">
                                        <img class="img-fluid rounded-top w-100" src="${pageContext.request.contextPath}${doc.profileImagePath}" alt="<c:out value='${doc.name}' />" style="height:260px;object-fit:cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="teamImage" value="${s.index % 3 + 1}" />
                                        <img class="img-fluid rounded-top w-100" src="${pageContext.request.contextPath}/img/team-${teamImage}.jpg" alt="<c:out value='${doc.name}' />" style="height:260px;object-fit:cover;">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="team-text position-relative bg-light text-center rounded-bottom p-4 flex-grow-1">
                                <h4 class="mb-1"><c:out value="${doc.name}" /></h4>
                                <p class="mb-2" style="color:#0b5d57;font-weight:600;"><c:out value="${doc.specialization}" /></p>
                                <p class="small mb-3" style="color:#52627a;"><c:out value="${empty doc.description ? 'Experienced DentCare dentist focused on gentle, clear care.' : doc.description}" /></p>
                                <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-sm btn-primary">Book a visit</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty doctors}">
                    <div class="col-lg-8"><div class="alert alert-info mb-0">Our dentist profiles are being updated. Please contact the clinic to book.</div></div>
                </c:if>
            </div>
        </div>
    </div>
    <!-- Team End -->


    <!-- Booking CTA Start -->
    <div class="container-fluid py-5 wow fadeInUp" data-wow-delay="0.1s">
        <div class="container">
            <div class="rounded p-5 text-center" style="background:linear-gradient(120deg,#0b172a 0%,#0f4f4a 60%,#0f766e 100%);">
                <h2 class="display-6 text-white mb-3">Ready for a calmer dental visit?</h2>
                <p class="mb-4 mx-auto" style="max-width:620px;color:#d8e5f2;">Pick a dentist, choose a treatment and see the exact approved fee before you pay. Booking takes about two minutes.</p>
                <div class="d-flex flex-wrap justify-content-center gap-2">
                    <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-light py-3 px-5">Book an appointment</a>
                    <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline-light py-3 px-5">Ask a question</a>
                </div>
            </div>
        </div>
    </div>
    <!-- Booking CTA End -->
    

    <!-- Footer Start -->
    <%@ include file="_user_footer.jsp" %>
    <!-- Footer End -->


    <!-- Back to Top -->
    <a href="#" class="btn btn-lg btn-primary btn-lg-square rounded back-to-top"><i class="bi bi-arrow-up"></i></a>


    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="lib/wow/wow.min.js"></script>
    <script src="lib/easing/easing.min.js"></script>
    <script src="lib/waypoints/waypoints.min.js"></script>
    <script src="lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="lib/tempusdominus/js/moment.min.js"></script>
    <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
    <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>
    <script src="lib/twentytwenty/jquery.event.move.js"></script>
    <script src="lib/twentytwenty/jquery.twentytwenty.js"></script>

    <!-- Template Javascript -->
    <script src="js/main.js" defer></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var dateInput = document.querySelector('input[name="appointmentDate"]');
            if (dateInput) {
                var today = new Date();
                var yyyy = today.getFullYear();
                var mm = String(today.getMonth() + 1).padStart(2, '0');
                var dd = String(today.getDate()).padStart(2, '0');
                dateInput.min = yyyy + '-' + mm + '-' + dd;
            }
        });
    </script>
</body>

</html>