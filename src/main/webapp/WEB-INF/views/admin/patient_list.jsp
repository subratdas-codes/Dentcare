<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="patients" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Management - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .panel { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; overflow: hidden; }
        .panel-head { padding: 1rem 1.25rem; border-bottom: 1px solid #eef2f7; }
        .table thead th { color: #52627a; font-size: .72rem; letter-spacing: .05em; text-transform: uppercase; white-space: nowrap; }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .avatar { width: 38px; height: 38px; border-radius: 50%; background: #eaf7f4; color: #0f766e; display: flex; align-items: center; justify-content: center; font-weight: 800; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-3 px-lg-4">
    <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mb-4 gap-3">
        <div>
            <h1 class="h4 fw-bold mb-1">Patient accounts</h1>
            <p class="text-muted mb-0">Search, edit, reset passwords or remove patient accounts.</p>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <form action="<c:url value='/admin/patients' />" method="get" class="d-flex gap-2">
                <div class="input-group">
                    <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                    <input type="text" class="form-control" name="q" value="${q}" placeholder="Name, email or phone">
                </div>
                <button class="btn btn-teal" type="submit">Search</button>
            </form>
            <a href="<c:url value='/admin/patients/add' />" class="btn btn-outline-secondary"><i class="bi bi-person-plus me-1"></i>Add patient</a>
        </div>
    </div>

    <c:if test="${not empty success}"><div class="alert alert-success"><i class="bi bi-check-circle me-2"></i><c:out value="${success}" /></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${error}" /></div></c:if>

    <section class="panel">
        <div class="panel-head d-flex justify-content-between align-items-center">
            <div class="fw-semibold">Registered patients</div>
            <span class="text-muted small">${patients.size()} account(s)</span>
        </div>
        <c:choose>
            <c:when test="${not empty patients}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead><tr><th class="ps-4">Patient</th><th>Contact</th><th>Age</th><th class="text-end pe-4">Actions</th></tr></thead>
                        <tbody>
                        <c:forEach var="p" items="${patients}">
                            <tr>
                                <td class="ps-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar">${p.name.substring(0,1)}</div>
                                        <div><div class="fw-semibold"><c:out value="${p.name}" /></div><div class="small text-muted"><c:out value="${p.email}" /></div></div>
                                    </div>
                                </td>
                                <td>
                                    <div class="small"><i class="bi bi-telephone me-1 text-muted"></i><c:out value="${p.phone}" /></div>
                                    <div class="small text-muted"><i class="bi bi-envelope me-1"></i><c:out value="${p.email}" /></div>
                                </td>
                                <td><span class="badge bg-light text-dark border">${p.age} yrs</span></td>
                                <td class="text-end pe-4">
                                    <a href="${pageContext.request.contextPath}/admin/patients/edit/${p.id}" class="btn btn-sm btn-outline-secondary" title="Edit / reset password"><i class="bi bi-pencil"></i></a>
                                    <form action="${pageContext.request.contextPath}/admin/patients/delete/${p.id}" method="post" class="d-inline" onsubmit="return confirm('Delete this patient account? Their appointments will also be removed.');">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete"><i class="bi bi-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center text-muted py-5"><i class="bi bi-people fs-1 d-block mb-2"></i>No patients found for this search.</div>
            </c:otherwise>
        </c:choose>
    </section>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
