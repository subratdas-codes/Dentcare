<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>My Appointments - DentCare</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<c:url value='/css/style.css' />" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6fb; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-1">
        <h2 class="fw-bold mb-0">My Appointments</h2>
        <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-primary">
            <i class="fa fa-calendar-plus me-1"></i>Book New Appointment
        </a>
    </div>
    <p class="text-muted mb-4">
        Logged in as <strong><sec:authentication property="name" /></strong>
    </p>

    <c:if test="${param.cancelled == 'true'}">
        <div class="alert alert-success shadow-sm">Appointment cancelled successfully.</div>
    </c:if>

    <c:if test="${not empty appointments}">
        <div class="card shadow-sm border-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                    <tr>
                        <th>#</th>
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
                            <td class="fw-semibold">${a.doctorName}</td>
                            <td>${a.service}</td>
                            <td>${a.appointmentDate}</td>
                            <td>${a.appointmentTime}</td>
                            <td class="text-center">
                                <form action="${pageContext.request.contextPath}/my/appointments/cancel/${a.id}" method="post" class="d-inline"
                                      onsubmit="return confirm('Cancel this appointment?');">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        <i class="fa fa-times me-1"></i>Cancel
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
            You have no appointments yet.
            <a href="${pageContext.request.contextPath}/book_appointment" class="alert-link">Book one now</a>.
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>