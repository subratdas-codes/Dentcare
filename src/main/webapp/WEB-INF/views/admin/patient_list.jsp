<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="patients" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f6f8fc; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mb-4 gap-3">
        <div>
            <h4 class="fw-bold mb-1">User Management</h4>
            <p class="text-muted mb-0">Manage registered patients from one place.</p>
        </div>
        <form action="<c:url value='/admin/patients' />" method="get" class="d-flex gap-2">
            <div class="input-group">
                <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                <input type="text" class="form-control border-start-0" name="q" value="${q}" placeholder="Search by name, email or phone">
            </div>
            <button class="btn btn-primary" type="submit">Search</button>
            <a class="btn btn-outline-secondary" href="<c:url value='/admin/patients' />">Reset</a>
        </form>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center">
            <div class="fw-semibold">Registered Patients</div>
            <div class="text-muted small">${patients.size()} user(s)</div>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                <tr>
                    <th>#</th>
                    <th>Patient</th>
                    <th>Contact</th>
                    <th>Age / Gender</th>
                    <th>Address</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${patients}" varStatus="loop">
                    <tr>
                        <td class="text-muted">${loop.index + 1}</td>
                        <td>
                            <div class="d-flex align-items-center gap-3">
                                <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                                    <i class="fas fa-user text-primary"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold">${p.name}</div>
                                    <div class="text-muted small">${p.email}</div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div>${p.phone}</div>
                            <div class="text-muted small">${p.email}</div>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark border">${p.age} yrs</span>
                            <c:if test="${not empty p.gender}">
                                <span class="badge bg-light text-dark border">${p.gender}</span>
                            </c:if>
                        </td>
                        <td class="text-muted">${p.address}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty patients}">
                    <tr>
                        <td colspan="5" class="text-center py-5">
                            <div class="text-muted">No users found.</div>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>