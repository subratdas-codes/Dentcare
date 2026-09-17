<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="appointments" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Appointment - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6fb; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="row justify-content-center">
        <div class="col-lg-7 col-md-9">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0"><i class="bi bi-calendar-check me-2"></i>Edit Appointment</h5>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/admin/appointments/update" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="id" value="${appointment.id}" />

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Patient Name</label>
                                <input type="text" name="patientName" value="${appointment.patientName}" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Email</label>
                                <input type="email" name="email" value="${appointment.email}" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Phone</label>
                                <input type="text" name="phone" value="${appointment.phone}" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Doctor</label>
                                <input type="text" name="doctorName" value="${appointment.doctorName}" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Service</label>
                                <select name="service" class="form-select" required>
                                    <option value="Teeth Cleaning" ${appointment.service == 'Teeth Cleaning' ? 'selected' : ''}>Teeth Cleaning</option>
                                    <option value="Root Canal" ${appointment.service == 'Root Canal' ? 'selected' : ''}>Root Canal</option>
                                    <option value="Braces" ${appointment.service == 'Braces' ? 'selected' : ''}>Braces</option>
                                    <option value="Tooth Whitening" ${appointment.service == 'Tooth Whitening' ? 'selected' : ''}>Tooth Whitening</option>
                                    <option value="Dental Implants" ${appointment.service == 'Dental Implants' ? 'selected' : ''}>Dental Implants</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Date</label>
                                <input type="date" name="appointmentDate" value="${appointment.appointmentDate}" class="form-control" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Time</label>
                                <input type="time" name="appointmentTime" value="${appointment.appointmentTime}" class="form-control" required />
                            </div>
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-light border">
                                <i class="bi bi-arrow-left me-1"></i>Back
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-lg me-1"></i>Update Appointment
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>