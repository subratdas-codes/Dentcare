<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Pricing - ${site.siteName}</title>
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
        .dc-panel { background: #fff; border: 1px solid #e4ebf3; border-radius: 1rem; overflow: hidden; }
        .dc-panel-head { padding: 1.1rem 1.35rem; border-bottom: 1px solid #eef2f7; }
        .dc-muted { color: #52627a; }
        .dc-price { color: #0b5d57; font-weight: 800; white-space: nowrap; }
        .dc-consult { border: 2px solid #0f766e; border-radius: 1rem; background: #fff; padding: 1.5rem; height: 100%; }
        .dc-consult .amount { font-size: 2.4rem; font-weight: 800; color: #0b5d57; line-height: 1; }
        .dc-note { background: #eef8f6; border: 1px solid #c6e9d8; color: #0b4f49; border-radius: .9rem; }
        .dc-table td, .dc-table th { vertical-align: middle; }
        .dc-table thead th { color: #52627a; font-size: .74rem; letter-spacing: .05em; text-transform: uppercase; border-bottom-width: 1px; }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; border-radius: .65rem; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .dc-chip { background: #eaf7f4; color: #0b5d57; border-radius: 999px; padding: .28rem .7rem; font-size: .74rem; font-weight: 700; display: inline-flex; align-items: center; gap: .3rem; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<header class="dc-hero">
    <div class="container">
        <div class="row align-items-center g-4">
            <div class="col-lg-8">
                <div class="eyebrow mb-2">Pricing</div>
                <h1 class="display-5 fw-bold mb-3"><c:out value="${site.pricingHeading}" /></h1>
                <p class="mb-0" style="max-width:720px;"><c:out value="${site.pricingText}" /></p>
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
    <div class="row g-4 mb-4">
        <div class="col-lg-5">
            <div class="dc-consult">
                <div class="dc-chip mb-3"><i class="bi bi-stethoscope"></i>Standard consultation</div>
                <div class="amount mb-2">₹<fmt:formatNumber value="${consultationFee}" minFractionDigits="0" maxFractionDigits="0" /></div>
                <p class="dc-muted mb-3">A one-to-one visit with a dentist: examination, questions and a clear treatment plan.</p>
                <ul class="list-unstyled small dc-muted mb-4">
                    <li class="mb-2"><i class="bi bi-check2-circle me-2" style="color:#15803d;"></i>Full oral health check</li>
                    <li class="mb-2"><i class="bi bi-check2-circle me-2" style="color:#15803d;"></i>Written treatment plan</li>
                    <li class="mb-2"><i class="bi bi-check2-circle me-2" style="color:#15803d;"></i>No hidden charges</li>
                </ul>
                <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-teal w-100 py-2">Book a consultation</a>
            </div>
        </div>
        <div class="col-lg-7">
            <div class="dc-note p-4 h-100">
                <h2 class="h5 fw-bold mb-3"><i class="bi bi-info-circle me-2"></i>How DentCare pricing works</h2>
                <p class="small mb-2">The prices below are the standard clinic prices for each treatment.</p>
                <p class="small mb-2">Some dentists have an approved doctor-specific fee. The exact amount is always shown on the booking page before you pay.</p>
                <p class="small mb-0">If a doctor requests a fee change, it only goes live after admin approval. Your confirmed receipt never changes after payment.</p>
            </div>
        </div>
    </div>

    <section class="dc-panel">
        <div class="dc-panel-head d-flex flex-column flex-sm-row justify-content-between gap-2">
            <div>
                <h2 class="h5 fw-bold mb-1">Treatment price list</h2>
                <p class="small dc-muted mb-0">Consultation and treatment fees, updated by the clinic.</p>
            </div>
            <span class="dc-chip align-self-sm-center"><i class="bi bi-lightning-charge"></i>Live prices</span>
        </div>
        <c:choose>
            <c:when test="${not empty servicePrices}">
                <div class="table-responsive">
                    <table class="table table-hover dc-table mb-0">
                        <thead>
                        <tr>
                            <th class="ps-4">Treatment</th>
                            <th>What it includes</th>
                            <th class="text-end">Standard fee</th>
                            <th class="text-end pe-4">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="sp" items="${servicePrices}">
                            <tr>
                                <td class="ps-4 fw-semibold" style="min-width:190px;"><c:out value="${sp.serviceName}" /></td>
                                <td class="small dc-muted" style="min-width:260px;">
                                    <c:out value="${empty sp.description ? 'Delivered by an experienced DentCare dentist with clear pricing.' : sp.description}" />
                                </td>
                                <td class="text-end dc-price">₹<fmt:formatNumber value="${sp.fee}" minFractionDigits="0" maxFractionDigits="0" /></td>
                                <td class="text-end pe-4">
                                    <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-sm btn-outline-success">Book</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="p-4"><div class="alert alert-info mb-0">Prices are being updated. Please contact the clinic for a current quote.</div></div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="row g-4 mt-1">
        <div class="col-md-4">
            <div class="dc-panel h-100 p-4">
                <i class="bi bi-shield-check fs-3" style="color:#0b5d57;"></i>
                <h3 class="h6 fw-bold mt-3">No surprise charges</h3>
                <p class="small dc-muted mb-0">Your total is shown before payment and printed on your PDF receipt.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="dc-panel h-100 p-4">
                <i class="bi bi-arrow-repeat fs-3" style="color:#0b5d57;"></i>
                <h3 class="h6 fw-bold mt-3">Always current</h3>
                <p class="small dc-muted mb-0">The booking page refreshes fees automatically, so you never see a stale price.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="dc-panel h-100 p-4">
                <i class="bi bi-file-earmark-pdf fs-3" style="color:#0b5d57;"></i>
                <h3 class="h6 fw-bold mt-3">Branded receipts</h3>
                <p class="small dc-muted mb-0">Download a DentCare PDF receipt for every payment from your account.</p>
            </div>
        </div>
    </section>
</main>

<%@ include file="_user_footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
