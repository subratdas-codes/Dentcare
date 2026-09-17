<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - DentCare</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6fb; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white py-3 text-center">
                    <i class="bi bi-person-circle fs-2 d-block mb-1"></i>
                    <h5 class="mb-0">My Profile</h5>
                </div>
                <div class="card-body p-4">
                    <table class="table table-borderless">
                        <tbody>
                        <tr>
                            <td class="fw-semibold text-muted w-25"><i class="bi bi-person me-2"></i>Name</td>
                            <td>${patient.name}</td>
                        </tr>
                        <tr>
                            <td class="fw-semibold text-muted"><i class="bi bi-envelope me-2"></i>Email</td>
                            <td>${patient.email}</td>
                        </tr>
                        <tr>
                            <td class="fw-semibold text-muted"><i class="bi bi-telephone me-2"></i>Phone</td>
                            <td>${patient.phone}</td>
                        </tr>
                        </tbody>
                    </table>
                    <hr>
                    <h6 class="fw-bold text-muted mb-3">Quick Actions</h6>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-primary">
                            <i class="bi bi-calendar-plus me-2"></i>Book Appointment
                        </a>
                        <a href="${pageContext.request.contextPath}/my/appointments" class="btn btn-outline-primary">
                            <i class="bi bi-calendar-check me-2"></i>My Appointments
                        </a>
                        <a href="${pageContext.request.contextPath}/change-password" class="btn btn-outline-secondary">
                            <i class="bi bi-shield-lock me-2"></i>Change Password
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>