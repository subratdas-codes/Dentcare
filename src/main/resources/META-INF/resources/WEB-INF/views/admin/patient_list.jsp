<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
            <h4 class="fw-bold mb-1">User Management</h4>
            <p class="text-muted mb-0">View, search and manage all registered patients.</p>
        </div>
        <form action="<c:url value='/admin/patients' />" method="get" class="d-flex flex-wrap gap-2">
            <div class="input-group" style="min-width: 280px;">
                <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                <input type="text" class="form-control border-start-0" name="q" value="${q}" placeholder="Search by name, email or phone">
            </div>
            <button class="btn btn-primary" type="submit">Search</button>
            <a class="btn btn-outline-secondary" href="<c:url value='/admin/patients' />">Reset</a>
        </form>
    </div>

    <div class="card card-table">
        <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center py-3">
            <div class="d-flex align-items-center gap-2">
                <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                    <i class="bi bi-people text-primary"></i>
                </div>
                <div>
                    <div class="fw-semibold">Registered Patients</div>
                    <small class="text-muted">${patients.size()} user(s) found</small>
                </div>
            </div>
            <div class="text-muted small">Live updates</div>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                <tr>
                    <th class="text-uppercase small text-muted">#</th>
                    <th class="text-uppercase small text-muted">Patient</th>
                    <th class="text-uppercase small text-muted">Contact</th>
                    <th class="text-uppercase small text-muted">Age / Gender</th>
                    <th class="text-uppercase small text-muted">Address</th>
                    <th class="text-uppercase small text-muted text-center">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${patients}" varStatus="loop">
                    <tr>
                        <td class="text-muted">${loop.index + 1}</td>
                        <td>
                            <div class="d-flex align-items-center gap-3">
                                <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center" style="width:42px;height:42px;">
                                    <i class="fas fa-user text-primary"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold">${p.name}</div>
                                    <div class="text-muted small">${p.email}</div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div><i class="bi bi-telephone me-1 text-muted"></i>${p.phone}</div>
                            <div class="text-muted small"><i class="bi bi-envelope me-1"></i>${p.email}</div>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark border">${p.age} yrs</span>
                            <c:if test="${not empty p.gender}">
                                <span class="badge bg-light text-dark border text-capitalize">${p.gender}</span>
                            </c:if>
                        </td>
                        <td class="text-muted">${p.address}</td>
                        <td class="text-center">
                            <sec:authorize access="hasRole('ADMIN')">
                                <a href="${pageContext.request.contextPath}/admin/patients/edit/${p.id}" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/patients/delete/${p.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this patient?');">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </sec:authorize>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty patients}">
                    <tr>
                        <td colspan="6" class="text-center py-5">
                            <div class="text-muted">
                                <i class="fas fa-users fa-2x mb-3"></i>
                                <div>No patients found for this search.</div>
                            </div>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>