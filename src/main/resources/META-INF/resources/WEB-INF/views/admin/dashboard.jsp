<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="dashboard" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - DentCare</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6fb; }
        .stat-card { border: none; border-radius: 0.9rem; transition: transform 0.15s ease; }
        .stat-card:hover { transform: translateY(-4px); }
        .stat-icon { width: 56px; height: 56px; border-radius: 0.9rem; display: flex; align-items: center; justify-content: center; font-size: 1.6rem; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Admin Dashboard</h4>
            <p class="text-muted mb-0">Overview of your clinic at a glance.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-primary">
            <i class="bi bi-plus-lg me-1"></i>New Appointment
        </a>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="card stat-card shadow-sm">
                <div class="card-body d-flex align-items-center">
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary me-3"><i class="bi bi-person-badge"></i></div>
                    <div>
                        <div class="fs-3 fw-bold">${doctorCount}</div>
                        <div class="text-muted">Total Doctors</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card shadow-sm">
                <div class="card-body d-flex align-items-center">
                    <div class="stat-icon bg-success bg-opacity-10 text-success me-3"><i class="bi bi-people"></i></div>
                    <div>
                        <div class="fs-3 fw-bold">${patientCount}</div>
                        <div class="text-muted">Total Patients</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card shadow-sm">
                <div class="card-body d-flex align-items-center">
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning me-3"><i class="bi bi-calendar-check"></i></div>
                    <div>
                        <div class="fs-3 fw-bold">${appointmentCount}</div>
                        <div class="text-muted">Total Appointments</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body text-center py-5">
                    <i class="bi bi-person-badge fs-1 text-primary"></i>
                    <h5 class="fw-bold mt-3">Manage Doctors</h5>
                    <p class="text-muted">Add, edit or remove clinic doctors.</p>
                    <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-primary">Doctors</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body text-center py-5">
                    <i class="bi bi-people fs-1 text-success"></i>
                    <h5 class="fw-bold mt-3">Manage Patients</h5>
                    <p class="text-muted">View all registered patients.</p>
                    <a href="${pageContext.request.contextPath}/admin/patients" class="btn btn-success">Patients</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body text-center py-5">
                    <i class="bi bi-calendar-check fs-1 text-warning"></i>
                    <h5 class="fw-bold mt-3">Manage Appointments</h5>
                    <p class="text-muted">View and edit all bookings.</p>
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-warning">Appointments</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>