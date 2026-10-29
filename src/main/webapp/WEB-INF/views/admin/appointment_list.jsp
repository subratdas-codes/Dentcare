<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="activePage" value="appointments" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - DentCare</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .panel { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; overflow: hidden; }
        .panel-head { padding: 1rem 1.25rem; border-bottom: 1px solid #eef2f7; }
        .table thead th { color: #52627a; font-size: .72rem; letter-spacing: .05em; text-transform: uppercase; white-space: nowrap; }
        .badge-soft { border-radius: 999px; padding: .2rem .55rem; font-size: .72rem; font-weight: 700; }
        .badge-soft-primary { background: #e8f1ff; color: #1d4ed8; }
        .badge-soft-success { background: #e7f7ef; color: #15803d; }
        .badge-soft-danger { background: #fdecec; color: #b91c1c; }
        .badge-soft-warning { background: #fff6e5; color: #92400e; }
        .badge-soft-info { background: #e6f7fa; color: #0e7490; }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .filter-chip { border: 1px solid #e4ebf3; border-radius: 999px; padding: .35rem .8rem; font-size: .8rem; font-weight: 600; color: #3f5169; text-decoration: none; background: #fff; }
        .filter-chip.active { background: #0f766e; border-color: #0f766e; color: #fff; }
        .stat-mini { border: 1px solid #e4ebf3; border-radius: .8rem; background: #fff; padding: .65rem .9rem; display: block; color: inherit; text-decoration: none; height: 100%; }
        .stat-mini:hover { border-color: #0f766e; color: inherit; background: #f7fcfb; }
        .stat-mini .num { font-size: 1.1rem; font-weight: 800; line-height: 1; color: #10243e; }
        .stat-mini .lbl { color: #52627a; font-size: .7rem; font-weight: 600; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-3 px-lg-4">
    <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mb-3 gap-3">
        <div>
            <h1 class="h4 fw-bold mb-1">
                <sec:authorize access="hasRole('DOCTOR')">My assigned patients</sec:authorize>
                <sec:authorize access="hasRole('ADMIN')">Appointment management</sec:authorize>
            </h1>
            <p class="text-muted mb-0">
                <sec:authorize access="hasRole('DOCTOR')">Only appointments assigned to your doctor account are shown.</sec:authorize>
                <sec:authorize access="hasRole('ADMIN')">Search, filter and update every appointment in the clinic.</sec:authorize>
            </p>
        </div>
        <span class="badge bg-light text-dark border px-3 py-2">${appointments.size()} appointment(s)</span>
    </div>

    <c:if test="${not empty success}"><div class="alert alert-success shadow-sm"><i class="bi bi-check-circle me-2"></i><c:out value="${success}" /></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger shadow-sm"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${error}" /></div></c:if>

    <sec:authorize access="hasRole('ADMIN')">
        <div class="row g-2 mb-3">
            <div class="col-6 col-md-3">
                <a class="stat-mini" href="${pageContext.request.contextPath}/admin/appointments?status=BOOKED"><div class="num">${bookedCount}</div><div class="lbl">Booked</div></a>
            </div>
            <div class="col-6 col-md-3">
                <a class="stat-mini" href="${pageContext.request.contextPath}/admin/appointments?status=COMPLETED"><div class="num" style="color:#15803d;">${completedCount}</div><div class="lbl">Completed</div></a>
            </div>
            <div class="col-6 col-md-3">
                <a class="stat-mini" href="${pageContext.request.contextPath}/admin/appointments?status=CANCELLED"><div class="num" style="color:#b91c1c;">${cancelledCount}</div><div class="lbl">Cancelled</div></a>
            </div>
            <div class="col-6 col-md-3">
                <a class="stat-mini" href="${pageContext.request.contextPath}/admin/invoices"><div class="num" style="color:#0b5d57;">₹<fmt:formatNumber value="${revenue}" minFractionDigits="0" maxFractionDigits="0" /></div><div class="lbl">Paid revenue</div></a>
            </div>
            <div class="col-6 col-md-3">
                <a class="stat-mini" href="${pageContext.request.contextPath}/admin/appointments?date=today"><div class="num" style="color:#15803d;">${todayCount}</div><div class="lbl">Today</div></a>
            </div>
            <div class="col-6 col-md-3">
                <a class="stat-mini" href="${pageContext.request.contextPath}/admin/appointments?payment=PENDING"><div class="num" style="color:#92400e;">${pendingPaymentCount}</div><div class="lbl">Pending payment</div></a>
            </div>
            <div class="col-6 col-md-3">
                <a class="stat-mini" href="${pageContext.request.contextPath}/admin/appointments?payment=PAID"><div class="num" style="color:#15803d;">${paidCount}</div><div class="lbl">Paid receipts</div></a>
            </div>
            <div class="col-6 col-md-3">
                <a class="stat-mini" href="${pageContext.request.contextPath}/admin/doctor-fees"><div class="num" style="color:#92400e;">${pendingFeeCount}</div><div class="lbl">Fee approvals</div></a>
            </div>
        </div>

        <div class="panel mb-3">
            <div class="p-3">
                <div class="d-flex flex-column flex-lg-row justify-content-between gap-2 mb-2">
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/admin/appointments" class="filter-chip ${empty selectedStatus and empty selectedPayment and empty selectedDate ? 'active' : ''}">All</a>
                        <a href="${pageContext.request.contextPath}/admin/appointments?status=BOOKED" class="filter-chip ${selectedStatus == 'BOOKED' ? 'active' : ''}">Booked</a>
                        <a href="${pageContext.request.contextPath}/admin/appointments?status=COMPLETED" class="filter-chip ${selectedStatus == 'COMPLETED' ? 'active' : ''}">Completed</a>
                        <a href="${pageContext.request.contextPath}/admin/appointments?status=CANCELLED" class="filter-chip ${selectedStatus == 'CANCELLED' ? 'active' : ''}">Cancelled</a>
                    </div>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/admin/appointments?date=today" class="filter-chip ${selectedDate == 'today' ? 'active' : ''}"><i class="bi bi-sun me-1"></i>Today</a>
                        <a href="${pageContext.request.contextPath}/admin/appointments?payment=PENDING" class="filter-chip ${selectedPayment == 'PENDING' ? 'active' : ''}"><i class="bi bi-hourglass me-1"></i>Pending pay</a>
                        <a href="${pageContext.request.contextPath}/admin/appointments?payment=PAID" class="filter-chip ${selectedPayment == 'PAID' ? 'active' : ''}"><i class="bi bi-check2-circle me-1"></i>Paid</a>
                        <a href="${pageContext.request.contextPath}/admin/appointments?payment=PAY_AT_CLINIC" class="filter-chip ${selectedPayment == 'PAY_AT_CLINIC' ? 'active' : ''}"><i class="bi bi-cash me-1"></i>At clinic</a>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/admin/appointments" method="get" class="d-flex flex-column flex-sm-row gap-2">
                    <c:if test="${not empty selectedStatus}"><input type="hidden" name="status" value="${selectedStatus}"></c:if>
                    <c:if test="${not empty selectedPayment}"><input type="hidden" name="payment" value="${selectedPayment}"></c:if>
                    <c:if test="${not empty selectedDate}"><input type="hidden" name="date" value="${selectedDate}"></c:if>
                    <div class="input-group flex-grow-1">
                        <span class="input-group-text bg-white"><i class="bi bi-search" style="color:#52627a;"></i></span>
                        <input type="text" name="q" value="${q}" class="form-control" placeholder="Patient, doctor, phone or reference">
                    </div>
                    <button class="btn btn-teal" type="submit">Search</button>
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-outline-secondary">Reset</a>
                </form>
            </div>
        </div>
    </sec:authorize>

    <div class="panel">
        <c:choose>
            <c:when test="${not empty appointments}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead><tr><th class="ps-4">Patient</th><th>Doctor</th><th>Visit</th><th>Schedule</th><th>Fee</th><th>Payment</th><th>Status</th><th class="text-end pe-4">Actions</th></tr></thead>
                        <tbody>
                        <c:forEach var="a" items="${appointments}">
                            <tr>
                                <td class="ps-4">
                                    <div class="fw-semibold"><c:out value="${a.patientName}" /></div>
                                    <small class="text-muted"><c:out value="${a.email}" /></small>
                                    <c:if test="${not empty a.phone}"><div class="small text-muted"><c:out value="${a.phone}" /></div></c:if>
                                </td>
                                <td class="small"><c:out value="${a.doctorName}" /></td>
                                <td>
                                    <div class="small fw-semibold"><c:out value="${a.service}" /></div>
                                    <span class="badge-soft badge-soft-primary">${a.appointmentType.label}</span>
                                </td>
                                <td class="small text-muted"><c:out value="${a.appointmentDate}" /><br><c:out value="${a.appointmentTime}" /></td>
                                <td class="fw-semibold">₹<fmt:formatNumber value="${a.amount}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                <td>
                                    <span class="badge-soft badge-soft-${a.paymentStatus.badgeClass}">${a.paymentStatus.label}</span>
                                    <c:if test="${not empty a.paymentMethod}"><div class="small text-muted mt-1">${a.paymentMethod.label}</div></c:if>
                                    <c:if test="${not empty a.paymentReference}"><div class="small text-muted font-monospace">${a.paymentReference}</div></c:if>
                                </td>
                                <td><span class="badge-soft badge-soft-${a.statusBadgeClass}">${a.status.label}</span></td>
                                <td class="text-end pe-4">
                                    <div class="d-inline-flex gap-1">
                                        <sec:authorize access="hasRole('ADMIN')">
                                            <a href="${pageContext.request.contextPath}/admin/appointments/edit/${a.id}" class="btn btn-sm btn-outline-secondary" title="Edit"><i class="bi bi-pencil"></i></a>
                                            <c:if test="${a.booked}">
                                                <form action="${pageContext.request.contextPath}/admin/appointments/status" method="post" class="d-inline">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                    <input type="hidden" name="id" value="${a.id}" />
                                                    <input type="hidden" name="status" value="COMPLETED" />
                                                    <button class="btn btn-sm btn-outline-success" title="Mark completed"><i class="bi bi-check2"></i></button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/appointments/status" method="post" class="d-inline" onsubmit="return confirm('Cancel this appointment?');">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                    <input type="hidden" name="id" value="${a.id}" />
                                                    <input type="hidden" name="status" value="CANCELLED" />
                                                    <button class="btn btn-sm btn-outline-warning" title="Cancel"><i class="bi bi-x-circle"></i></button>
                                                </form>
                                            </c:if>
                                            <form action="${pageContext.request.contextPath}/admin/appointments/delete/${a.id}" method="post" class="d-inline" onsubmit="return confirm('Delete appointment #${a.id} permanently?');">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                <button class="btn btn-sm btn-outline-danger" title="Delete"><i class="bi bi-trash"></i></button>
                                            </form>
                                        </sec:authorize>
                                        <sec:authorize access="hasRole('DOCTOR')">
                                            <a href="${pageContext.request.contextPath}/doctor/appointments/${a.id}/chat" class="btn btn-sm btn-outline-success" title="Message patient"><i class="bi bi-chat-dots"></i></a>
                                        </sec:authorize>
                                        <c:if test="${not empty a.paymentReference}">
                                            <a href="${pageContext.request.contextPath}/booking/receipt/${a.paymentReference}/download" class="btn btn-sm btn-outline-secondary" title="Download PDF receipt"><i class="bi bi-file-earmark-pdf"></i></a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center text-muted py-5">
                    <i class="bi bi-calendar2-x fs-1 d-block mb-2"></i>
                    <c:choose>
                        <c:when test="${not empty q or not empty selectedStatus or not empty selectedPayment or not empty selectedDate}">No appointments match this filter.</c:when>
                        <c:otherwise>No appointments yet.</c:otherwise>
                    </c:choose>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
