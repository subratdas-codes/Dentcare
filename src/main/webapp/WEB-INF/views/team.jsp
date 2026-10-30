<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Our Dentists - ${site.siteName}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<c:url value='/css/style.css' />" rel="stylesheet">
    <style>
        body { background: #f5f8fb; color: #1d2b3f; }
        .dc-hero { background: linear-gradient(120deg, #0b172a 0%, #0f4f4a 60%, #0f766e 100%); color: #fff; padding: 3.2rem 0 2.6rem; }
        .dc-hero .eyebrow { color: #a8eadf; text-transform: uppercase; letter-spacing: .09em; font-size: .74rem; font-weight: 700; }
        .dc-hero p { color: #d8e5f2; }
        .dc-doctor { background: #fff; border: 1px solid #e4ebf3; border-radius: 1rem; overflow: hidden; height: 100%; transition: transform .16s ease, box-shadow .16s ease; }
        .dc-doctor:hover { transform: translateY(-3px); box-shadow: 0 20px 40px -30px rgba(11,23,42,.55); }
        .dc-doctor img { width: 100%; height: 280px; object-fit: cover; }
        .dc-doctor .avatar { width: 100%; height: 280px; display: flex; align-items: center; justify-content: center; background: #eaf7f4; color: #0b5d57; font-size: 4rem; font-weight: 800; }
        .dc-role { color: #0b5d57; font-weight: 700; font-size: .88rem; }
        .dc-muted { color: #52627a; }
        .dc-cta { background: linear-gradient(120deg, #0b172a 0%, #0f4f4a 60%, #0f766e 100%); border-radius: 1.1rem; color: #fff; }
        .dc-cta p { color: #d8e5f2; }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; border-radius: .65rem; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .dc-value { background: #fff; border: 1px solid #e4ebf3; border-radius: 1rem; padding: 1.4rem; height: 100%; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<header class="dc-hero">
    <div class="container">
        <div class="row align-items-center g-4">
            <div class="col-lg-8">
                <div class="eyebrow mb-2">Our dentists</div>
                <h1 class="display-5 fw-bold mb-3"><c:out value="${site.teamHeading}" /></h1>
                <p class="mb-0" style="max-width:720px;"><c:out value="${site.teamText}" /></p>
            </div>
            <div class="col-lg-4 text-lg-end">
                <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-light fw-semibold px-4 py-3">
                    <i class="bi bi-calendar2-check me-2"></i><c:out value="${site.bookButton}" />
                </a>
            </div>
        </div>
    </div>
</header>

<main class="container py-5">
    <c:choose>
        <c:when test="${not empty doctors}">
            <div class="row g-4">
                <c:forEach var="doc" items="${doctors}" varStatus="s">
                    <c:set var="teamImage" value="${s.index % 3 + 1}" />
                    <div class="col-md-6 col-xl-4">
                        <article class="dc-doctor d-flex flex-column">
                            <c:choose>
                                <c:when test="${not empty doc.profileImagePath}">
                                    <img src="${pageContext.request.contextPath}${doc.profileImagePath}" alt="<c:out value='${doc.name}' />" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/team-${teamImage}.jpg';">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/img/team-${teamImage}.jpg" alt="<c:out value='${doc.name}' />">
                                </c:otherwise>
                            </c:choose>
                            <div class="p-4 d-flex flex-column flex-grow-1">
                                <h2 class="h5 fw-bold mb-1"><c:out value="${doc.name}" /></h2>
                                <div class="dc-role mb-3"><c:out value="${empty doc.specialization ? 'General Dentistry' : doc.specialization}" /></div>
                                <p class="small dc-muted flex-grow-1 mb-3">
                                    <c:out value="${empty doc.description ? 'An experienced DentCare dentist focused on gentle, clear care for every patient.' : doc.description}" />
                                </p>
                                <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-teal btn-sm align-self-start px-3">
                                    <i class="bi bi-calendar2-check me-1"></i>Book with this dentist
                                </a>
                            </div>
                        </article>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info border-0 shadow-sm">
                <i class="bi bi-info-circle me-2"></i>Our dentist profiles are being updated. Please contact the clinic to book an appointment.
            </div>
        </c:otherwise>
    </c:choose>

    <section class="mt-5 pt-4">
        <div class="text-center mb-4">
            <div class="text-uppercase fw-bold small" style="color:#0b5d57;letter-spacing:.08em;">Why patients choose us</div>
            <h2 class="display-6 fw-bold mt-1">Care that takes its time</h2>
        </div>
        <div class="row g-3">
            <div class="col-md-4">
                <div class="dc-value">
                    <i class="bi bi-chat-heart fs-3" style="color:#0b5d57;"></i>
                    <h3 class="h6 fw-bold mt-3">We listen first</h3>
                    <p class="small dc-muted mb-0">Every visit starts with your concerns, not a treatment list.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="dc-value">
                    <i class="bi bi-shield-check fs-3" style="color:#0b5d57;"></i>
                    <h3 class="h6 fw-bold mt-3">Clear pricing</h3>
                    <p class="small dc-muted mb-0">Approved fees are shown before booking and locked on your receipt.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="dc-value">
                    <i class="bi bi-stars fs-3" style="color:#0b5d57;"></i>
                    <h3 class="h6 fw-bold mt-3">Modern equipment</h3>
                    <p class="small dc-muted mb-0">Comfortable, up-to-date tools and gentle techniques for calmer visits.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="dc-cta p-4 p-lg-5 mt-5">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
            <div>
                <h2 class="h3 fw-bold mb-2">Choose your dentist and time</h2>
                <p class="mb-0">See the exact approved fee for your dentist before you pay.</p>
            </div>
            <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-light fw-semibold px-4 py-3">Book an appointment</a>
        </div>
    </section>
</main>

<%@ include file="_user_footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
