<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        body { background-color: #f4f6fb; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Appointment Management</h4>
            <p class="text-muted mb-0">${appointments.size()} appointment(s) booked so far.</p>
        </div>
    </div>

    <c:if test="${not empty appointments}">
        <div class="card shadow-sm border-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Patient</th>
                        <th>Contact</th>
                        <th>Doctor</th>
                        <th>Service</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th class="text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="a" items="${appointments}">
                        <tr>
                            <td>${a.id}</td>
                            <td>
                                <div class="fw-semibold">${a.patientName}</div>
                                <small class="text-muted">${a.email}</small>
                            </td>
                            <td>${a.phone}</td>
                            <td><span class="badge bg-info bg-opacity-25 text-dark">${a.doctorName}</span></td>
                            <td>${a.service}</td>
                            <td>${a.appointmentDate}</td>
                            <td>${a.appointmentTime}</td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/admin/appointments/edit/${a.id}" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil me-1"></i>Edit
                                </a>
                                <form action="${pageContext.request.contextPath}/admin/appointments/delete/${a.id}" method="post" class="d-inline"
                                      onsubmit="return confirm('Delete appointment #${a.id}?');">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        <i class="bi bi-trash me-1"></i>Delete
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <c:if test="${empty appointments}">
        <div class="alert alert-info shadow-sm">
            <i class="bi bi-info-circle me-2"></i>No appointments yet. They appear here as soon as patients book.
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>