<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Booking Confirmed - DentCare</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<c:url value='/css/style.css' />" rel="stylesheet">
    <style>
        body { background: #f4f6fb; }
        .success-hero { background: linear-gradient(135deg, #0f9d58 0%, #087f4a 100%); color: #fff; border-radius: 1.25rem; }
        .success-icon { width: 86px; height: 86px; border-radius: 50%; background: rgba(255,255,255,.18); display: flex; align-items: center; justify-content: center; font-size: 2.6rem; margin: 0 auto 1rem; }
        .receipt-card { border: none; border-radius: 1.1rem; box-shadow: 0 30px 70px -45px rgba(15, 31, 58, 0.8); }
        .reference-box { background: #f0fbff; border: 2px dashed #06A3DA; border-radius: .9rem; padding: 1rem 1.25rem; }
        .reference-id { font-family: "Courier New", monospace; font-size: 1.35rem; font-weight: 700; letter-spacing: .04em; color: #091E3E; }
        .detail-label { color: #7a879b; font-size: .78rem; text-transform: uppercase; letter-spacing: .06em; }
        .detail-value { font-weight: 600; color: #1d2a3f; }
        .receipt-row { display: flex; justify-content: space-between; padding: .65rem 0; border-bottom: 1px dashed #e6eaf2; }
        .receipt-row:last-child { border-bottom: 0; }
        @media print {
            body { background: #fff; }
            .no-print, nav, footer, .back-to-top { display: none !important; }
            .receipt-card { box-shadow: none; border: 1px solid #dee2e6; }
            .success-hero { background: #0f9d58 !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
        }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<div class="container py-5">
    <div class="success-hero p-4 p-md-5 text-center mb-4">
        <div class="success-icon"><i class="fas fa-check"></i></div>
        <h1 class="fw-bold mb-2">Appointment Confirmed</h1>
        <p class="mb-0 opacity-75">Your booking is locked in. Keep the reference ID handy.</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="reference-box text-center mb-4">
                <div class="detail-label mb-1">Booking Reference ID</div>
                <div class="reference-id" id="referenceId">${appointment.paymentReference}</div>
                <button class="btn btn-sm btn-outline-primary mt-2 no-print" type="button" id="copyReference">
                    <i class="far fa-copy me-1"></i>Copy Reference
                </button>
            </div>

            <div class="receipt-card bg-white p-4 p-md-5">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-2">
                    <div>
                        <h5 class="fw-bold mb-1"><i class="fas fa-tooth text-primary me-2"></i>DentCare Receipt</h5>
                        <p class="text-muted mb-0">Patia, Bhubaneswar, Odisha - 751024</p>
                    </div>
                    <span class="badge bg-${appointment.paymentStatus.badgeClass} bg-opacity-10 text-${appointment.paymentStatus.badgeClass} px-3 py-2 fs-6">
                        ${appointment.paymentStatus.label}
                    </span>
                </div>

                <div class="row g-4 mb-3">
                    <div class="col-sm-6">
                        <div class="detail-label">Patient</div>
                        <div class="detail-value">${appointment.patientName}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="detail-label">Doctor</div>
                        <div class="detail-value">${appointment.doctorName}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="detail-label">Service</div>
                        <div class="detail-value">${appointment.service}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="detail-label">Appointment</div>
                        <div class="detail-value">${appointment.appointmentDate} at ${appointment.appointmentTime}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="detail-label">Payment method</div>
                        <div class="detail-value">${appointment.paymentMethod.label}</div>
                    </div>
                    <div class="col-sm-6">
                        <div class="detail-label">Payment detail</div>
                        <div class="detail-value"><c:out value="${appointment.paymentDetail}" /></div>
                    </div>
                </div>

                <div class="receipt-row">
                    <span class="text-muted">Booking reference</span>
                    <span class="fw-semibold">${appointment.paymentReference}</span>
                </div>
                <c:if test="${not empty appointment.paidAtDisplay}">
                    <div class="receipt-row">
                        <span class="text-muted">Paid on</span>
                        <span class="fw-semibold">${appointment.paidAtDisplay}</span>
                    </div>
                </c:if>
                <div class="receipt-row">
                    <span class="text-muted">Amount</span>
                    <span class="fs-5 fw-bold text-primary">₹<fmt:formatNumber value="${appointment.amount}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span>
                </div>

                <c:if test="${appointment.cashPayment}">
                    <div class="alert alert-info mt-4 mb-0">
                        <i class="fas fa-info-circle me-2"></i>
                        Please pay <strong>₹<fmt:formatNumber value="${appointment.amount}" type="number" minFractionDigits="2" maxFractionDigits="2" /></strong>
                        at the clinic reception before your consultation.
                    </div>
                </c:if>

                <div class="d-flex flex-wrap gap-2 justify-content-center mt-4 no-print">
                    <button class="btn btn-outline-primary" type="button" onclick="window.print()">
                        <i class="fas fa-print me-1"></i>Print Receipt
                    </button>
                    <sec:authorize access="hasRole('USER')">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/my/appointments">
                            <i class="fas fa-calendar-check me-1"></i>My Appointments
                        </a>
                    </sec:authorize>
                    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/book_appointment">
                        <i class="fas fa-plus me-1"></i>Book Another
                    </a>
                    <a class="btn btn-light" href="${pageContext.request.contextPath}/">Back to Home</a>
                </div>
            </div>

            <p class="text-center text-muted small mt-4 no-print">
                A confirmation for this booking is available under My Appointments.
            </p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('copyReference').addEventListener('click', function () {
        var text = document.getElementById('referenceId').textContent.trim();
        if (navigator.clipboard) {
            navigator.clipboard.writeText(text).then(function () {
                var button = document.getElementById('copyReference');
                button.innerHTML = '<i class="fas fa-check me-1"></i>Copied';
                setTimeout(function () {
                    button.innerHTML = '<i class="far fa-copy me-1"></i>Copy Reference';
                }, 1800);
            });
        }
    });
</script>
</body>
</html>
