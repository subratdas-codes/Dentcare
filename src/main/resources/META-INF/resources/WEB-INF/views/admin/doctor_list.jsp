<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="doctors" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctors - DentCare Admin</title>
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
            <h4 class="fw-bold mb-1">Doctor Management</h4>
            <p class="text-muted mb-0">${doctors.size()} doctor(s) on staff.</p>
        </div>
        <a href="<c:url value='/admin/doctors/add' />" class="btn btn-primary">
            <i class="bi bi-person-plus me-1"></i>Add New Doctor
        </a>
    </div>

    <c:if test="${not empty doctors}">
        <div class="card shadow-sm border-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Specialization</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th class="text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="doctor" items="${doctors}">
                        <tr>
                            <td>${doctor.id}</td>
                            <td class="fw-semibold">${doctor.name}</td>
                            <td>${doctor.specialization}</td>
                            <td>${doctor.email}</td>
                            <td>${doctor.phone}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${doctor.admin}">
                                        <span class="badge bg-success"><i class="bi bi-shield-check me-1"></i>Admin</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Doctor</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <a href="<c:url value='/admin/doctors/edit/${doctor.id}' />" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil me-1"></i>Edit
                                </a>
                                <form action="<c:url value='/admin/doctors/delete/${doctor.id}' />" method="post" class="d-inline"
                                      onsubmit="return confirm('Delete ${doctor.name}?');">
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

    <c:if test="${empty doctors}">
        <div class="alert alert-info shadow-sm">
            <i class="bi bi-info-circle me-2"></i>No doctors yet. Click "Add New Doctor" to create the first one.
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>