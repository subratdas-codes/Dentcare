<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
            <h4 class="fw-bold mb-1">Doctor Management</h4>
            <p class="text-muted mb-0">Add, edit, delete and assign roles to doctors.</p>
        </div>
        <sec:authorize access="hasRole('ADMIN')">
            <a href="<c:url value='/admin/doctors/add' />" class="btn btn-primary">
                <i class="bi bi-person-plus me-1"></i>Add New Doctor
            </a>
        </sec:authorize>
    </div>

    <c:if test="${param.error == 'duplicate'}">
        <div class="alert alert-danger">A staff account with this email already exists.</div>
    </c:if>
    <c:if test="${param.error == 'duplicatePatient'}">
        <div class="alert alert-danger">A patient account already uses this email. Choose a different email.</div>
    </c:if>
    <c:if test="${param.error == 'email'}">
        <div class="alert alert-danger">Email address is required.</div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="alert alert-success"><i class="bi bi-check-circle me-2"></i><c:out value="${success}" /></div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${error}" /></div>
    </c:if>

    <c:if test="${not empty doctors}">
        <div class="card card-table">
            <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center py-3">
                <div class="fw-semibold">Staff List</div>
                <div class="text-muted small">${doctors.size()} doctor(s)</div>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                    <tr>
                        <th class="text-uppercase small text-muted">#</th>
                        <th class="text-uppercase small text-muted">Doctor</th>
                        <th class="text-uppercase small text-muted">Specialization</th>
                        <th class="text-uppercase small text-muted">Contact</th>
                        <th class="text-uppercase small text-muted">Role</th>
                        <th class="text-uppercase small text-muted text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="doctor" items="${doctors}">
                        <tr>
                            <td class="text-muted">${doctor.id}</td>
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                    <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center" style="width:42px;height:42px;">
                                        <i class="bi bi-person-badge text-primary"></i>
                                    </div>
                                    <div class="fw-semibold">${doctor.name}</div>
                                </div>
                            </td>
                            <td>${doctor.specialization}</td>
                            <td>
                                <div><i class="bi bi-envelope me-1 text-muted"></i>${doctor.email}</div>
                                <div class="text-muted small"><i class="bi bi-telephone me-1"></i>${doctor.phone}</div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${doctor.admin}">
                                        <span class="badge bg-success"><i class="bi bi-shield-check me-1"></i>Administrator</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Doctor</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <sec:authorize access="hasRole('ADMIN')">
                                    <a href="<c:url value='/admin/doctors/edit/${doctor.id}' />" class="btn btn-sm btn-outline-primary" title="Edit doctor">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="<c:url value='/admin/doctor-fees' />" class="btn btn-sm btn-outline-success" title="Manage this doctor's fees">
                                        <i class="bi bi-currency-rupee"></i>
                                    </a>
                                    <form action="<c:url value='/admin/doctors/delete/${doctor.id}' />" method="post" class="d-inline"
                                          onsubmit="return confirm('Delete ${doctor.name}?');">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete doctor">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </sec:authorize>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <c:if test="${empty doctors}">
        <div class="card card-table">
            <div class="card-body text-center py-5 text-muted">
                <i class="bi bi-person-badge fs-1 mb-3"></i>
                <div>No doctors yet. Add your first doctor.</div>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>