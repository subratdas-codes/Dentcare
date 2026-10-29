<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Receipts &amp; Payments - ${site.siteName}</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <style>
        body { background: #f5f8fb; color: #1d2b3f; }
        .dc-card { border: 1px solid #e7ecf3; border-radius: 1rem; background: #fff; }
        .dc-receipt { border: 1px solid #e7ecf3; border-radius: .9rem; background: #fff; padding: 1rem 1.15rem; }
        .dc-receipt + .dc-receipt { margin-top: .8rem; }
        .dc-ref { font-family: ui-monospace, SFMono-Regular, Menlo, monospace; font-size: .8rem; color: #64748b; }
        .badge-soft-success { background: #e7f7ef; color: #15803d; }
        .badge-soft-warning { background: #fff6e5; color: #92400e; }
        .badge-soft-info { background: #e6f7fa; color: #0e7490; }
        .badge-soft-danger { background: #fdecec; color: #b91c1c; }
        .dc-account-wrap { position: sticky; top: 110px; }
        .dc-total { background: #0f766e; color: #fff; border-radius: 1rem; padding: 1.25rem; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<div class="container py-4 py-lg-5">
    <div class="mb-4">
        <div class="text-uppercase small fw-bold mb-1" style="color:#0f766e;letter-spacing:.07em;">Patient account</div>
        <h1 class="h3 fw-bold mb-1">Receipts &amp; payments</h1>
        <p class="text-muted mb-0">Every confirmed booking, its reference ID and branded PDF receipt.</p>
    </div>

    <div class="row g-4">
        <div class="col-lg-3">
            <div class="dc-account-wrap">
                <c:set var="activeAccount" value="receipts" />
                <%@ include file="_account_sidebar.jsp" %>
            </div>
        </div>
        <div class="col-lg-9">
            <div class="dc-total d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-4">
                <div>
                    <div class="small text-white-50">Total paid online</div>
                    <div class="h3 fw-bold mb-0">₹<fmt:formatNumber value="${totalPaid}" minFractionDigits="2" maxFractionDigits="2" /></div>
                </div>
                <div class="small text-white-50">Cash bookings are marked “Pay at clinic” and do not count here.</div>
            </div>

            <c:if test="${not empty receipts}">
                <c:forEach var="a" items="${receipts}">
                    <article class="dc-receipt">
                        <div class="d-flex flex-column flex-sm-row justify-content-between gap-2">
                            <div>
                                <div class="d-flex flex-wrap align-items-center gap-2 mb-1">
                                    <h2 class="h6 fw-bold mb-0"><c:out value="${a.service}" /></h2>
                                    <span class="badge badge-soft-${a.paymentStatus.badgeClass}">${a.paymentStatus.label}</span>
                                    <c:if test="${a.cancelled}"><span class="badge badge-soft-danger">Cancelled</span></c:if>
                                </div>
                                <div class="small text-muted"><c:out value="${a.doctorName}" /> · <c:out value="${a.appointmentDate}" /> at <c:out value="${a.appointmentTime}" /></div>
                                <div class="dc-ref mt-1"><c:out value="${a.paymentReference}" /></div>
                                <div class="small text-muted mt-1">
                                    <c:if test="${not empty a.paymentMethod}">${a.paymentMethod.label} · <c:out value="${a.paymentDetail}" /></c:if>
                                    <c:if test="${empty a.paymentMethod}">Payment not completed</c:if>
                                </div>
                            </div>
                            <div class="text-sm-end">
                                <div class="fw-bold fs-5 mb-2">₹<fmt:formatNumber value="${a.amount}" minFractionDigits="2" maxFractionDigits="2" /></div>
                                <a class="btn btn-sm btn-outline-dark" href="${pageContext.request.contextPath}/booking/confirmation/${a.paymentReference}">
                                    <i class="bi bi-receipt me-1"></i>Booking details
                                </a>
                                <a class="btn btn-sm btn-outline-secondary mt-1" href="${pageContext.request.contextPath}/booking/receipt/${a.paymentReference}/download">
                                    <i class="bi bi-file-earmark-pdf me-1"></i>Download PDF
                                </a>
                            </div>
                        </div>
                    </article>
                </c:forEach>
            </c:if>

            <c:if test="${empty receipts}">
                <div class="dc-card text-center py-5">
                    <i class="bi bi-receipt-cutoff fs-1 text-muted"></i>
                    <h2 class="h6 fw-bold mt-3">No receipts yet</h2>
                    <p class="text-muted mb-3">Receipts appear here once you pay or choose pay-at-clinic.</p>
                    <a href="${pageContext.request.contextPath}/book_appointment" class="btn text-white fw-semibold" style="background:#0f766e;border-radius:.6rem;">Book a visit</a>
                </div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="_user_footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
