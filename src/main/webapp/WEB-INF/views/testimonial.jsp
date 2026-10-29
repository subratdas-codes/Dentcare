<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Patient Stories - ${site.siteName}</title>
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
        .dc-review { background: #fff; border: 1px solid #e4ebf3; border-radius: 1rem; padding: 1.5rem; height: 100%; display: flex; flex-direction: column; }
        .dc-stars { color: #b45309; font-size: .9rem; letter-spacing: .08em; }
        .dc-avatar { width: 46px; height: 46px; border-radius: 50%; background: #eaf7f4; color: #0b5d57; display: flex; align-items: center; justify-content: center; font-weight: 800; flex: 0 0 46px; }
        .dc-muted { color: #52627a; }
        .dc-quote { color: #33445c; font-size: .95rem; flex-grow: 1; }
        .dc-cta { background: linear-gradient(120deg, #0b172a 0%, #0f4f4a 60%, #0f766e 100%); border-radius: 1.1rem; color: #fff; }
        .dc-cta p { color: #d8e5f2; }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; border-radius: .65rem; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .dc-strip { background: #fff; border: 1px solid #e4ebf3; border-radius: 1rem; padding: 1.1rem 1.3rem; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<header class="dc-hero">
    <div class="container">
        <div class="row align-items-center g-4">
            <div class="col-lg-8">
                <div class="eyebrow mb-2">Patient stories</div>
                <h1 class="display-5 fw-bold mb-3"><c:out value="${site.testimonialHeading}" /></h1>
                <p class="mb-0" style="max-width:720px;"><c:out value="${site.testimonialText}" /></p>
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
        <c:when test="${not empty testimonials}">
            <div class="row g-4">
                <c:forEach var="t" items="${testimonials}">
                    <div class="col-md-6 col-xl-4">
                        <article class="dc-review">
                            <div class="dc-stars mb-3">
                                <c:forEach begin="1" end="${t.rating}"><i class="fa fa-star"></i></c:forEach>
                                <c:forEach begin="${t.rating + 1}" end="5"><i class="far fa-star"></i></c:forEach>
                            </div>
                            <p class="dc-quote mb-4">&ldquo;<c:out value="${t.message}" />&rdquo;</p>
                            <div class="d-flex align-items-center gap-3">
                                <div class="dc-avatar"><c:out value="${t.initial}" /></div>
                                <div>
                                    <div class="fw-bold" style="color:#10243e;"><c:out value="${t.patientName}" /></div>
                                    <div class="small dc-muted"><c:out value="${empty t.treatment ? 'DentCare patient' : t.treatment}" /></div>
                                </div>
                            </div>
                        </article>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info border-0 shadow-sm">
                <i class="bi bi-chat-quote me-2"></i>Patient reviews will appear here soon. You can be the first to share your experience.
            </div>
        </c:otherwise>
    </c:choose>

    <section class="dc-strip mt-5 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
        <div>
            <h2 class="h6 fw-bold mb-1">Visited us recently?</h2>
            <p class="small dc-muted mb-0">Tell us how your visit went. We read every message and publish reviews with permission.</p>
        </div>
        <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline-success fw-semibold">Share your experience</a>
    </section>

    <section class="dc-cta p-4 p-lg-5 mt-4">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
            <div>
                <h2 class="h3 fw-bold mb-2">Ready to book your own visit?</h2>
                <p class="mb-0">Pick a dentist and see the exact approved fee before you pay.</p>
            </div>
            <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-light fw-semibold px-4 py-3">Book an appointment</a>
        </div>
    </section>
</main>

<%@ include file="_user_footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
