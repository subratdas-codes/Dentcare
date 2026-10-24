<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="activePage" value="dashboard" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - DentCare</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f6f8fc; }
        .stat-card { border: none; border-radius: 1rem; box-shadow: 0 30px 60px -40px rgba(15, 31, 58, 0.8); transition: all 0.2s ease; overflow: hidden; }
        .stat-card:hover { transform: translateY(-6px); box-shadow: 0 40px 70px -35px rgba(6, 163, 218, 0.4); }
        .stat-icon { width: 60px; height: 60px; border-radius: 1rem; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; }
        .quick-card { border: none; border-radius: 1rem; transition: all 0.2s ease; }
        .quick-card:hover { transform: translateY(-4px); box-shadow: 0 30px 60px -40px rgba(15, 31, 58, 0.9); }
        .table-card { border: none; border-radius: 1rem; box-shadow: 0 40px 70px -50px rgba(15, 31, 58, 0.9); overflow: hidden; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mb-4 gap-3">
        <div>
            <h4 class="fw-bold mb-1">Dashboard Overview</h4>
            <p class="text-muted mb-0">Manage doctors, patients, appointments and clinic operations from here.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-primary">
                <i class="bi bi-calendar-plus me-1"></i>View Appointments
            </a>
            <sec:authorize access="hasRole('ADMIN')">
                <a href="${pageContext.request.contextPath}/admin/doctors/add" class="btn btn-outline-primary">
                    <i class="bi bi-person-plus me-1"></i>Add Doctor
                </a>
            </sec:authorize>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <sec:authorize access="hasRole('ADMIN')">
            <div class="col-md-4">
                <div class="card stat-card h-100">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted mb-1">Total Doctors</p>
                            <h2 class="fw-bold mb-0">${doctorCount}</h2>
                            <small class="text-primary">Manage staff</small>
                        </div>
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary"><i class="bi bi-person-badge"></i></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/doctors" class="card-footer bg-transparent border-0 text-decoration-none text-primary fw-semibold d-flex justify-content-between align-items-center">
                        <span>Go to Doctors</span>
                        <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stat-card h-100">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted mb-1">Total Patients</p>
                            <h2 class="fw-bold mb-0">${patientCount}</h2>
                            <small class="text-success">Registered users</small>
                        </div>
                        <div class="stat-icon bg-success bg-opacity-10 text-success"><i class="bi bi-people"></i></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/patients" class="card-footer bg-transparent border-0 text-decoration-none text-success fw-semibold d-flex justify-content-between align-items-center">
                        <span>Go to Patients</span>
                        <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
        </sec:authorize>
        <div class="col-md-4">
            <div class="card stat-card h-100">
                <div class="card-body d-flex align-items-center justify-content-between">
                    <div>
                        <p class="text-muted mb-1">Total Appointments</p>
                        <h2 class="fw-bold mb-0">${appointmentCount}</h2>
                        <small class="text-warning">All bookings</small>
                    </div>
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning"><i class="bi bi-calendar-check"></i></div>
                </div>
                <a href="${pageContext.request.contextPath}/admin/appointments" class="card-footer bg-transparent border-0 text-decoration-none text-warning fw-semibold d-flex justify-content-between align-items-center">
                    <span>Go to Appointments</span>
                    <i class="bi bi-arrow-right"></i>
                </a>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="card table-card h-100">
                <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center py-3">
                    <div>
                        <h6 class="fw-bold mb-1">Recent Appointments</h6>
                        <small class="text-muted">Latest bookings in the clinic</small>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-sm btn-outline-primary">View All</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                        <tr>
                            <th class="text-uppercase small text-muted">Patient</th>
                            <th class="text-uppercase small text-muted">Doctor</th>
                            <th class="text-uppercase small text-muted">Service</th>
                            <th class="text-uppercase small text-muted">Date</th>
                            <th class="text-uppercase small text-muted">Time</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="a" items="${appointments}" varStatus="s">
                            <c:if test="${s.index < 6}">
                                <tr>
                                    <td>
                                        <div class="fw-semibold">${a.patientName}</div>
                                        <small class="text-muted">${a.phone}</small>
                                    </td>
                                    <td><span class="badge bg-primary bg-opacity-10 text-primary">${a.doctorName}</span></td>
                                    <td>${a.service}</td>
                                    <td>${a.appointmentDate}</td>
                                    <td>${a.appointmentTime}</td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        <c:if test="${empty appointments}">
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">No appointments yet.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card table-card h-100">
                <div class="card-header bg-white border-0 py-3">
                    <h6 class="fw-bold mb-1">Quick Actions</h6>
                    <small class="text-muted">Jump to key management areas</small>
                </div>
                <div class="card-body d-grid gap-2">
                    <sec:authorize access="hasRole('ADMIN')">
                        <a href="${pageContext.request.contextPath}/admin/doctors/add" class="btn btn-outline-primary d-flex justify-content-between align-items-center">
                            <span><i class="bi bi-person-plus me-2"></i>Add New Doctor</span>
                            <i class="bi bi-chevron-right"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/patients" class="btn btn-outline-success d-flex justify-content-between align-items-center">
                            <span><i class="bi bi-people me-2"></i>Manage Patients</span>
                            <i class="bi bi-chevron-right"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/pricing" class="btn btn-outline-info d-flex justify-content-between align-items-center">
                            <span><i class="bi bi-currency-rupee me-2"></i>Update Pricing</span>
                            <i class="bi bi-chevron-right"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/invoices" class="btn btn-outline-warning d-flex justify-content-between align-items-center">
                            <span><i class="bi bi-receipt me-2"></i>Manage Invoices</span>
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </sec:authorize>
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-outline-dark d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-calendar-check me-2"></i>Manage Appointments</span>
                        <i class="bi bi-chevron-right"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/profile" class="btn btn-outline-secondary d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-person-circle me-2"></i>My Profile</span>
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>