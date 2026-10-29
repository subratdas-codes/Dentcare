<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Services - ${site.siteName}</title>
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
        .dc-card { background: #fff; border: 1px solid #e4ebf3; border-radius: 1rem; overflow: hidden; height: 100%; transition: transform .16s ease, box-shadow .16s ease; }
        .dc-card:hover { transform: translateY(-3px); box-shadow: 0 20px 40px -30px rgba(11,23,42,.55); }
        .dc-card img { width: 100%; height: 190px; object-fit: cover; }
        .dc-price { color: #0b5d57; font-weight: 800; font-size: 1.15rem; white-space: nowrap; }
        .dc-muted { color: #52627a; }
        .dc-step { background: #fff; border: 1px solid #e4ebf3; border-radius: 1rem; padding: 1.25rem; height: 100%; }
        .dc-step .num { width: 38px; height: 38px; border-radius: .7rem; background: #eaf7f4; color: #0b5d57; font-weight: 800; display: flex; align-items: center; justify-content: center; margin-bottom: .8rem; }
        .dc-cta { background: linear-gradient(120deg, #0b172a 0%, #0f4f4a 60%, #0f766e 100%); border-radius: 1.1rem; color: #fff; }
        .dc-cta p { color: #d8e5f2; }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; border-radius: .65rem; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .dc-badge { background: #eaf7f4; color: #0b5d57; border-radius: 999px; padding: .25rem .65rem; font-size: .72rem; font-weight: 700; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<header class="dc-hero">
    <div class="container">
        <div class="row align-items-center g-4">
            <div class="col-lg-8">
                <div class="eyebrow mb-2">Our treatments</div>
                <h1 class="display-5 fw-bold mb-3"><c:out value="${site.serviceHeading}" /></h1>
                <p class="mb-0" style="max-width:700px;"><c:out value="${site.serviceText}" /></p>
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
        <c:when test="${not empty servicePrices}">
            <div class="row g-4">
                <c:forEach var="sp" items="${servicePrices}" varStatus="s">
                    <c:set var="serviceImage" value="${s.index % 4 + 1}" />
                    <div class="col-md-6 col-xl-4">
                        <article class="dc-card d-flex flex-column">
                            <img src="${pageContext.request.contextPath}/img/service-${serviceImage}.jpg" alt="<c:out value='${sp.serviceName}' />">
                            <div class="p-4 d-flex flex-column flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start gap-2 mb-2">
                                    <h2 class="h5 fw-bold mb-0"><c:out value="${sp.serviceName}" /></h2>
                                    <span class="dc-price">₹<fmt:formatNumber value="${sp.fee}" minFractionDigits="0" maxFractionDigits="0" /></span>
                                </div>
                                <p class="small dc-muted flex-grow-1 mb-3">
                                    <c:out value="${empty sp.description ? 'Delivered by an experienced DentCare dentist with clear pricing and aftercare advice.' : sp.description}" />
                                </p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="dc-badge"><i class="bi bi-shield-check me-1"></i>Clear pricing</span>
                                    <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-sm btn-teal">Book this</a>
                                </div>
                            </div>
                        </article>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info border-0 shadow-sm">
                <i class="bi bi-info-circle me-2"></i>Our treatment list is being updated. Please call the clinic or send us a message and we will help you book.
            </div>
        </c:otherwise>
    </c:choose>

    <section class="mt-5 pt-4">
        <div class="text-center mb-4">
            <div class="text-uppercase fw-bold small" style="color:#0b5d57;letter-spacing:.08em;">How it works</div>
            <h2 class="display-6 fw-bold mt-1">Four calm steps from enquiry to aftercare</h2>
        </div>
        <div class="row g-3">
            <div class="col-md-6 col-xl-3">
                <div class="dc-step">
                    <div class="num">1</div>
                    <h3 class="h6 fw-bold">Consult</h3>
                    <p class="small dc-muted mb-0">Meet your dentist, share your concerns and get a full oral health check.</p>
                </div>
            </div>
            <div class="col-md-6 col-xl-3">
                <div class="dc-step">
                    <div class="num">2</div>
                    <h3 class="h6 fw-bold">Plan</h3>
                    <p class="small dc-muted mb-0">Receive a clear treatment plan with the exact approved fee before anything begins.</p>
                </div>
            </div>
            <div class="col-md-6 col-xl-3">
                <div class="dc-step">
                    <div class="num">3</div>
                    <h3 class="h6 fw-bold">Treat</h3>
                    <p class="small dc-muted mb-0">Gentle, modern treatment with numbing and comfort checks at every stage.</p>
                </div>
            </div>
            <div class="col-md-6 col-xl-3">
                <div class="dc-step">
                    <div class="num">4</div>
                    <h3 class="h6 fw-bold">Aftercare</h3>
                    <p class="small dc-muted mb-0">Leave with simple aftercare instructions and a follow-up plan if you need one.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="dc-cta p-4 p-lg-5 mt-5">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
            <div>
                <h2 class="h3 fw-bold mb-2">Not sure which treatment you need?</h2>
                <p class="mb-0">Start with a consultation. Your dentist will explain the options and the exact fee.</p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-light fw-semibold px-4 py-3">Book a consultation</a>
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline-light fw-semibold px-4 py-3">Ask a question</a>
            </div>
        </div>
    </section>
</main>

<%@ include file="_user_footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
