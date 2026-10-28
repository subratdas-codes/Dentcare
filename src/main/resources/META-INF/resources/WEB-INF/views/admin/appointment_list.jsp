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
    <title>Appointments - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f6f8fc; }
        .card-table { border: none; border-radius: 1rem; overflow: hidden; box-shadow: 0 40px 70px -50px rgba(15, 31, 58, 0.9); }
        .table-hover tbody tr { transition: all 0.2s ease; }
        .table-hover tbody tr:hover { background-color: rgba(6, 163, 218, 0.05); }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mb-4 gap-3">
        <div>
            <h4 class="fw-bold mb-1"><sec:authorize access="hasRole('DOCTOR')">My Assigned Appointments</sec:authorize><sec:authorize access="hasRole('ADMIN')">Appointment Management</sec:authorize></h4>
            <p class="text-muted mb-0"><sec:authorize access="hasRole('DOCTOR')">View patient appointments assigned to your doctor account.</sec:authorize><sec:authorize access="hasRole('ADMIN')">Track, edit and manage all patient appointments.</sec:authorize></p>
        </div>
        <div class="text-muted small">Total: ${appointments.size()} appointment(s)</div>
    </div>

    <c:if test="${not empty appointments}">
        <div class="card card-table">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                    <tr>
                        <th class="text-uppercase small text-muted">#</th>
                        <th class="text-uppercase small text-muted">Patient</th>
                        <th class="text-uppercase small text-muted">Contact</th>
                        <th class="text-uppercase small text-muted">Doctor</th>
                        <th class="text-uppercase small text-muted">Service</th>
                        <th class="text-uppercase small text-muted">Fee</th>
                        <th class="text-uppercase small text-muted">Payment</th>
                        <th class="text-uppercase small text-muted">Date</th>
                        <th class="text-uppercase small text-muted">Time</th>
                        <th class="text-uppercase small text-muted text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="a" items="${appointments}">
                        <tr>
                            <td class="text-muted">${a.id}</td>
                            <td>
                                <div class="fw-semibold">${a.patientName}</div>
                                <small class="text-muted">${a.email}</small>
                            </td>
                            <td>${a.phone}</td>
                            <td><span class="badge bg-primary bg-opacity-10 text-primary">${a.doctorName}</span></td>
                            <td>${a.service}</td>
                            <td class="fw-semibold">
                                <c:choose>
                                    <c:when test="${not empty a.amount}">
                                        ₹<fmt:formatNumber value="${a.amount}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                                    </c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="badge bg-${a.paymentStatus.badgeClass} bg-opacity-10 text-${a.paymentStatus.badgeClass}">
                                    ${a.paymentStatus.label}
                                </span>
                                <c:if test="${not empty a.paymentMethod}">
                                    <div class="small text-muted mt-1">${a.paymentMethod.label}</div>
                                </c:if>
                                <c:if test="${not empty a.paymentReference}">
                                    <div class="small text-muted font-monospace">${a.paymentReference}</div>
                                </c:if>
                            </td>
                            <td>${a.appointmentDate}</td>
                            <td>${a.appointmentTime}</td>
                            <td class="text-center">
                                <sec:authorize access="hasRole('ADMIN')">
                                    <a href="${pageContext.request.contextPath}/admin/appointments/edit/${a.id}" class="btn btn-sm btn-outline-primary">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                </sec:authorize>
                                <sec:authorize access="hasRole('ADMIN')">
                                    <form action="${pageContext.request.contextPath}/admin/appointments/delete/${a.id}" method="post" class="d-inline"
                                          onsubmit="return confirm('Delete appointment #${a.id}?');">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </sec:authorize>
                                <sec:authorize access="hasRole('DOCTOR')">
                                    <a href="${pageContext.request.contextPath}/doctor/appointments/${a.id}/chat" class="btn btn-sm btn-outline-primary">
                                        <i class="bi bi-chat-dots"></i>
                                    </a>
                                </sec:authorize>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <c:if test="${empty appointments}">
        <div class="card card-table">
            <div class="card-body text-center py-5 text-muted">
                <i class="bi bi-calendar-x fs-1 mb-3"></i>
                <div>No appointments yet.</div>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>
