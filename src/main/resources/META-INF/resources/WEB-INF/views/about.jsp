<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>About Us - ${site.siteName}</title>
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
        .dc-panel { background: #fff; border: 1px solid #e4ebf3; border-radius: 1rem; padding: 1.5rem; height: 100%; }
        .dc-muted { color: #52627a; }
        .dc-stat { background: #fff; border: 1px solid #e4ebf3; border-radius: 1rem; padding: 1.2rem; text-align: center; height: 100%; }
        .dc-stat .num { font-size: 1.9rem; font-weight: 800; color: #0b5d57; line-height: 1; }
        .dc-stat .lbl { color: #52627a; font-size: .8rem; font-weight: 600; margin-top: .35rem; }
        .dc-img { border-radius: 1rem; overflow: hidden; }
        .dc-img img { width: 100%; height: 100%; object-fit: cover; min-height: 320px; }
        .dc-cta { background: linear-gradient(120deg, #0b172a 0%, #0f4f4a 60%, #0f766e 100%); border-radius: 1.1rem; color: #fff; }
        .dc-cta p { color: #d8e5f2; }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; border-radius: .65rem; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<header class="dc-hero">
    <div class="container">
        <div class="row align-items-center g-4">
            <div class="col-lg-8">
                <div class="eyebrow mb-2">About DentCare</div>
                <h1 class="display-5 fw-bold mb-3"><c:out value="${site.aboutHeading}" /></h1>
                <p class="mb-0" style="max-width:720px;"><c:out value="${site.aboutText}" /></p>
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
    <div class="row g-3 mb-5">
        <div class="col-6 col-lg-3">
            <div class="dc-stat"><div class="num">${fn:length(servicePrices)}+</div><div class="lbl">Treatments offered</div></div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="dc-stat"><div class="num">3</div><div class="lbl">Experienced dentists</div></div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="dc-stat"><div class="num">15 min</div><div class="lbl">Average booking time</div></div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="dc-stat"><div class="num">7 days</div><div class="lbl">Open every week</div></div>
        </div>
    </div>

    <div class="row g-4 align-items-stretch mb-5">
        <div class="col-lg-6">
            <div class="dc-img h-100">
                <img src="${pageContext.request.contextPath}/img/about.jpg" alt="DentCare clinic">
            </div>
        </div>
        <div class="col-lg-6">
            <div class="dc-panel">
                <div class="text-uppercase fw-bold small mb-2" style="color:#0b5d57;letter-spacing:.08em;">Our approach</div>
                <h2 class="display-6 fw-bold mb-3">Calm visits, clear answers</h2>
                <p class="dc-muted">DentCare was built around a simple idea: dental care should feel predictable. That means explaining what we find, what it costs and what happens next, before any treatment starts.</p>
                <p class="dc-muted">Our dentists use modern equipment and gentle techniques, and our booking system shows the exact approved fee for your chosen dentist. No surprise charges, no guesswork.</p>
                <div class="row g-3 mt-2">
                    <div class="col-sm-6">
                        <div class="d-flex gap-2"><i class="bi bi-check2-circle" style="color:#15803d;"></i><span class="small">Transparent pricing</span></div>
                    </div>
                    <div class="col-sm-6">
                        <div class="d-flex gap-2"><i class="bi bi-check2-circle" style="color:#15803d;"></i><span class="small">Gentle treatment</span></div>
                    </div>
                    <div class="col-sm-6">
                        <div class="d-flex gap-2"><i class="bi bi-check2-circle" style="color:#15803d;"></i><span class="small">Modern equipment</span></div>
                    </div>
                    <div class="col-sm-6">
                        <div class="d-flex gap-2"><i class="bi bi-check2-circle" style="color:#15803d;"></i><span class="small">Clear aftercare</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <section>
        <div class="text-center mb-4">
            <div class="text-uppercase fw-bold small" style="color:#0b5d57;letter-spacing:.08em;">What we stand for</div>
            <h2 class="display-6 fw-bold mt-1">Three promises we keep</h2>
        </div>
        <div class="row g-3">
            <div class="col-md-4">
                <div class="dc-panel">
                    <i class="bi bi-chat-heart fs-3" style="color:#0b5d57;"></i>
                    <h3 class="h6 fw-bold mt-3">Listen before treating</h3>
                    <p class="small dc-muted mb-0">Your concerns guide the visit. We explain every option in plain language.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="dc-panel">
                    <i class="bi bi-receipt fs-3" style="color:#0b5d57;"></i>
                    <h3 class="h6 fw-bold mt-3">Price before payment</h3>
                    <p class="small dc-muted mb-0">The approved fee is shown on the booking page and locked on your receipt.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="dc-panel">
                    <i class="bi bi-person-check fs-3" style="color:#0b5d57;"></i>
                    <h3 class="h6 fw-bold mt-3">Stay reachable</h3>
                    <p class="small dc-muted mb-0">Questions after your visit? Call, email or send a message through the site.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="dc-cta p-4 p-lg-5 mt-5">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
            <div>
                <h2 class="h3 fw-bold mb-2">Come see the clinic for yourself</h2>
                <p class="mb-0">Book a consultation and meet the team. We will take it from there.</p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-light fw-semibold px-4 py-3">Book an appointment</a>
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline-light fw-semibold px-4 py-3">Contact us</a>
            </div>
        </div>
    </section>
</main>

<%@ include file="_user_footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
