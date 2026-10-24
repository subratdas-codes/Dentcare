<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="doctors" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${doctor.id == null ? 'Add' : 'Edit'} Doctor - DentCare Admin</title>
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
                    <h5 class="mb-0">
                        <i class="bi bi-person-badge me-2"></i>${doctor.id == null ? 'Add New Doctor' : 'Edit Doctor'}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <form action="<c:url value='/admin/doctors/save'/>" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="id" value="${doctor.id}" />

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Full Name</label>
                                <input type="text" name="name" value="${doctor.name}" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Specialization</label>
                                <input type="text" name="specialization" value="${doctor.specialization}" class="form-control" required placeholder="e.g. Orthodontist" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Email</label>
                                <input type="email" name="email" value="${doctor.email}" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Phone</label>
                                <input type="text" name="phone" value="${doctor.phone}" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Password</label>
                                <input type="password" name="password" class="form-control"
                                       placeholder="${doctor.id == null ? 'Set a login password' : 'Leave blank to keep current'}"
                                       ${doctor.id == null ? 'required' : ''} />
                                <c:if test="${doctor.id != null}">
                                    <div class="form-text">Leave blank to keep the existing password.</div>
                                </c:if>
                            </div>
                            <div class="col-md-6 d-flex align-items-end">
                                <div class="form-check form-switch mb-2">
                                    <input type="checkbox" class="form-check-input" id="adminCheck" name="admin"
                                           <c:if test="${doctor.admin}">checked</c:if> />
                                    <label class="form-check-label" for="adminCheck">Grant admin access</label>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="<c:url value='/admin/doctors'/>" class="btn btn-light border">
                                <i class="bi bi-arrow-left me-1"></i>Back
                            </a>
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check-lg me-1"></i>Save Doctor
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