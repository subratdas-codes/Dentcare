<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="activePage" value="invoices" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoices &amp; Receipts - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .panel { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; overflow: hidden; }
        .panel-head { padding: 1rem 1.25rem; border-bottom: 1px solid #eef2f7; }
        .table thead th { color: #52627a; font-size: .72rem; letter-spacing: .05em; text-transform: uppercase; white-space: nowrap; }
        .badge-soft { border-radius: 999px; padding: .2rem .55rem; font-size: .72rem; font-weight: 700; }
        .badge-soft-success { background: #e7f7ef; color: #15803d; }
        .badge-soft-warning { background: #fff6e5; color: #92400e; }
        .badge-soft-info { background: #e6f7fa; color: #0e7490; }
        .stat-mini { border: 1px solid #e4ebf3; border-radius: .9rem; background: #fff; padding: .8rem 1rem; }
        .stat-mini .num { font-size: 1.3rem; font-weight: 800; line-height: 1.1; }
        .stat-mini .lbl { color: #52627a; font-size: .73rem; font-weight: 600; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>
<div class="container-fluid py-4 px-3 px-lg-4">
    <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mb-4 gap-3">
        <div>
            <h1 class="h4 fw-bold mb-1">Invoices &amp; receipts</h1>
            <p class="text-muted mb-0">Every booking's fee, payment state and downloadable receipt.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/settings#receipts" class="btn btn-outline-secondary"><i class="bi bi-sliders me-1"></i>Receipt text settings</a>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-6 col-md-4"><div class="stat-mini"><div class="num">${appointments.size()}</div><div class="lbl">Bookings</div></div></div>
        <div class="col-6 col-md-4"><div class="stat-mini"><div class="num">${paidCount}</div><div class="lbl">Paid / pay at clinic</div></div></div>
        <div class="col-12 col-md-4"><div class="stat-mini"><div class="num" style="color:#0f766e;">₹<fmt:formatNumber value="${revenue}" minFractionDigits="2" maxFractionDigits="2" /></div><div class="lbl">Online revenue</div></div></div>
    </div>

    <section class="panel">
        <div class="panel-head fw-semibold">Payment records</div>
        <c:choose>
            <c:when test="${not empty appointments}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead><tr><th class="ps-4">Booking</th><th>Patient</th><th>Doctor</th><th>Service</th><th>Amount</th><th>Payment</th><th>Reference</th><th class="text-end pe-4">Receipt</th></tr></thead>
                        <tbody>
                        <c:forEach var="a" items="${appointments}">
                            <tr>
                                <td class="ps-4"><div class="small fw-semibold">#${a.id}</div><div class="small text-muted"><c:out value="${a.appointmentDate}" /></div></td>
                                <td><div class="small fw-semibold"><c:out value="${a.patientName}" /></div><div class="small text-muted"><c:out value="${a.email}" /></div></td>
                                <td class="small"><c:out value="${a.doctorName}" /></td>
                                <td class="small"><c:out value="${a.service}" /><br><span class="text-muted">${a.appointmentType.label}</span></td>
                                <td class="fw-semibold">₹<fmt:formatNumber value="${a.amount}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                <td><span class="badge-soft badge-soft-${a.paymentStatus.badgeClass}">${a.paymentStatus.label}</span><c:if test="${not empty a.paymentMethod}"><div class="small text-muted mt-1">${a.paymentMethod.label}</div></c:if></td>
                                <td class="small font-monospace"><c:out value="${empty a.paymentReference ? '—' : a.paymentReference}" /></td>
                                <td class="text-end pe-4">
                                    <c:choose>
                                        <c:when test="${a.paymentPending or empty a.paymentReference}"><span class="small text-muted">Awaiting payment</span></c:when>
                                        <c:otherwise>
                                            <div class="d-inline-flex gap-1">
                                                <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/booking/confirmation/${a.paymentReference}" target="_blank" rel="noopener" title="Open"><i class="bi bi-box-arrow-up-right"></i></a>
                                                <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/booking/receipt/${a.paymentReference}/download" title="Download PDF receipt"><i class="bi bi-file-earmark-pdf"></i></a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise><div class="text-center text-muted py-5"><i class="bi bi-receipt fs-1 d-block mb-2"></i>No bookings to invoice yet.</div></c:otherwise>
        </c:choose>
    </section>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
