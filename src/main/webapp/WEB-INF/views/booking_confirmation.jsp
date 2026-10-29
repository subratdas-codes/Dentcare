<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${appointment.cancelled ? 'Booking Cancelled' : 'Booking Confirmed'} - ${site.siteName}</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <style>
        body { background: #f5f8fb; color: #1d2b3f; }
        .dc-hero { background: #0f766e; color: #fff; border-radius: 1.1rem; }
        .dc-hero.cancelled { background: #7f1d1d; }
        .dc-hero-icon { width: 72px; height: 72px; border-radius: 50%; background: rgba(255,255,255,.16); display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto .8rem; }
        .dc-receipt { border: 1px solid #e7ecf3; border-radius: 1rem; background: #fff; }
        .dc-ref-box { background: #f1faf8; border: 2px dashed #9fd3cc; border-radius: .9rem; padding: 1rem 1.25rem; }
        .dc-ref { font-family: ui-monospace, SFMono-Regular, Menlo, monospace; font-size: 1.2rem; font-weight: 800; letter-spacing: .03em; }
        .dc-label { color: #52627a; font-size: .72rem; text-transform: uppercase; letter-spacing: .06em; }
        .dc-value { font-weight: 600; }
        .dc-row { display: flex; justify-content: space-between; gap: 1rem; padding: .6rem 0; border-bottom: 1px dashed #e7ecf3; font-size: .9rem; }
        .dc-row:last-child { border-bottom: 0; }
        .badge-soft { border-radius: 999px; padding: .25rem .6rem; font-size: .74rem; font-weight: 700; }
        .badge-soft-success { background: #e7f7ef; color: #15803d; }
        .badge-soft-warning { background: #fff6e5; color: #92400e; }
        .badge-soft-info { background: #e6f7fa; color: #0e7490; }
        .badge-soft-danger { background: #fdecec; color: #b91c1c; }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; border-radius: .65rem; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        @media print {
            body { background: #fff; }
            .no-print, nav, footer { display: none !important; }
            .dc-receipt { box-shadow: none; border: 1px solid #cfd8e3; }
            .dc-hero { background: #0f766e !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            .container { max-width: 100% !important; }
        }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<div class="container py-4 py-lg-5" style="max-width: 960px;">
    <header class="dc-hero ${appointment.cancelled ? 'cancelled' : ''} p-4 p-md-5 text-center mb-4 no-print">
        <div class="dc-hero-icon"><i class="fas ${appointment.cancelled ? 'fa-times' : 'fa-check'}"></i></div>
        <h1 class="h3 fw-bold mb-1">${appointment.cancelled ? 'Appointment cancelled' : (appointment.cashPayment ? 'Appointment booked · pay at clinic' : 'Appointment confirmed')}</h1>
        <p class="mb-0" style="color:#cdeee8;">${appointment.cancelled ? 'This visit is cancelled. The record stays in your account.' : 'Your booking is locked in. Keep the reference ID handy.'}</p>
    </header>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="dc-ref-box text-center mb-4 no-print">
                <div class="dc-label mb-1">Booking reference</div>
                <div class="dc-ref" id="referenceId"><c:out value="${appointment.paymentReference}" /></div>
                <button class="btn btn-sm btn-outline-secondary mt-2" type="button" id="copyReference"><i class="far fa-copy me-1"></i>Copy reference</button>
            </div>

            <article class="dc-receipt p-4 p-md-5" id="receiptCard">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-2 mb-4">
                    <div>
                        <h2 class="h5 fw-bold mb-1"><i class="fas fa-tooth me-2" style="color:#0b5d57;"></i><c:out value="${site.receiptTitle}" /></h2>
                        <p class="text-muted small mb-0"><c:out value="${site.siteName}" /> · <c:out value="${site.footerAddress}" /></p>
                        <p class="text-muted small mb-0"><c:out value="${site.footerPhone}" /> · <c:out value="${site.footerEmail}" /></p>
                    </div>
                    <div class="text-md-end">
                        <span class="badge-soft badge-soft-${appointment.paymentStatus.badgeClass}">${appointment.paymentStatus.label}</span>
                        <c:if test="${appointment.cancelled}"><span class="badge-soft badge-soft-danger ms-1">Cancelled</span></c:if>
                        <div class="dc-label mt-2">Reference</div>
                        <div class="small fw-semibold"><c:out value="${appointment.paymentReference}" /></div>
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-sm-6"><div class="dc-label">Patient</div><div class="dc-value"><c:out value="${appointment.patientName}" /></div><div class="small text-muted"><c:out value="${appointment.email}" /></div></div>
                    <div class="col-sm-6"><div class="dc-label">Doctor</div><div class="dc-value"><c:out value="${appointment.doctorName}" /></div></div>
                    <div class="col-sm-6"><div class="dc-label">Visit type</div><div class="dc-value">${appointment.appointmentType.label}</div></div>
                    <div class="col-sm-6"><div class="dc-label">Service</div><div class="dc-value"><c:out value="${appointment.service}" /></div></div>
                    <div class="col-sm-6"><div class="dc-label">Appointment</div><div class="dc-value"><c:out value="${appointment.appointmentDate}" /> at <c:out value="${appointment.appointmentTime}" /></div></div>
                    <div class="col-sm-6"><div class="dc-label">Appointment status</div><div class="dc-value">${appointment.status.label}</div></div>
                </div>

                <div class="pt-2">
                    <div class="dc-row"><span class="text-muted">Payment method</span><span class="fw-semibold"><c:choose><c:when test="${not empty appointment.paymentMethod}">${appointment.paymentMethod.label}</c:when><c:otherwise>—</c:otherwise></c:choose></span></div>
                    <div class="dc-row"><span class="text-muted">Payment detail</span><span class="fw-semibold"><c:out value="${empty appointment.paymentDetail ? '—' : appointment.paymentDetail}" /></span></div>
                    <div class="dc-row"><span class="text-muted">Payment status</span><span class="fw-semibold">${appointment.paymentStatus.label}</span></div>
                    <c:if test="${not empty appointment.paidAtDisplay}"><div class="dc-row"><span class="text-muted">Paid on</span><span class="fw-semibold"><c:out value="${appointment.paidAtDisplay}" /></span></div></c:if>
                    <div class="dc-row"><span class="text-muted">Amount</span><span class="fs-5 fw-bold" style="color:#0b5d57;">₹<fmt:formatNumber value="${appointment.amount}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span></div>
                </div>

                <c:if test="${appointment.cashPayment and not appointment.cancelled}">
                    <div class="alert alert-info mt-3 mb-0"><i class="fas fa-info-circle me-2"></i>Please pay <strong>₹<fmt:formatNumber value="${appointment.amount}" type="number" minFractionDigits="2" maxFractionDigits="2" /></strong> at the clinic reception before your consultation.</div>
                </c:if>

                <div class="mt-4 pt-3" style="border-top:1px solid #eef2f7;">
                    <p class="small text-muted mb-1"><c:out value="${site.receiptNote}" /></p>
                    <p class="small text-muted mb-0"><c:out value="${site.receiptFooter}" /></p>
                </div>
            </article>

            <div class="d-flex flex-wrap gap-2 justify-content-center mt-4 no-print">
                <a class="btn btn-teal" href="${pageContext.request.contextPath}/booking/receipt/${appointment.paymentReference}/download">
                    <i class="bi bi-file-earmark-pdf me-1"></i>Download PDF receipt
                </a>
                <button class="btn btn-outline-dark" type="button" onclick="window.print()"><i class="fas fa-print me-1"></i>Print receipt</button>
                <sec:authorize access="hasRole('USER')">
                    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/my/appointments"><i class="fas fa-calendar-check me-1"></i>My appointments</a>
                    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/my/receipts"><i class="bi bi-receipt me-1"></i>All receipts</a>
                </sec:authorize>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/book_appointment"><i class="fas fa-plus me-1"></i>Book another</a>
            </div>

            <p class="text-center text-muted small mt-3 no-print">This receipt is also available any time under My Appointments and Receipts.</p>
        </div>
    </div>
</div>

<%@ include file="_user_footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.getElementById('copyReference').addEventListener('click', function () {
    var text = document.getElementById('referenceId').textContent.trim();
    if (navigator.clipboard) {
        navigator.clipboard.writeText(text).then(function () {
            var button = document.getElementById('copyReference');
            button.innerHTML = '<i class="fas fa-check me-1"></i>Copied';
            setTimeout(function () { button.innerHTML = '<i class="far fa-copy me-1"></i>Copy reference'; }, 1600);
        });
    }
});
</script>
</body>
</html>
