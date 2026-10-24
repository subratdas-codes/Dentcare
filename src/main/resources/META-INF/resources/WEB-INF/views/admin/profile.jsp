<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="profile" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - DentCare Portal</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f6f8fc; }
        .card { border: none; border-radius: 1rem; box-shadow: 0 40px 70px -50px rgba(15, 31, 58, 0.9); }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>
<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="card">
                <div class="card-header bg-white border-0 text-center py-4">
                    <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center mx-auto mb-3" style="width:80px;height:80px;">
                        <i class="bi bi-person-circle text-primary fs-1"></i>
                    </div>
                    <h4 class="fw-bold mb-1">${doctor.name}</h4>
                    <p class="text-muted mb-0">${doctor.email}</p>
                </div>
                <div class="card-body px-4 px-lg-5">
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <div class="p-3 bg-light rounded-3">
                                <small class="text-muted">Specialization</small>
                                <div class="fw-semibold">${doctor.specialization}</div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="p-3 bg-light rounded-3">
                                <small class="text-muted">Phone</small>
                                <div class="fw-semibold">${doctor.phone}</div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="p-3 bg-light rounded-3">
                                <small class="text-muted">Role</small>
                                <div class="fw-semibold">${doctor.admin ? 'Administrator' : 'Doctor'}</div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="p-3 bg-light rounded-3">
                                <small class="text-muted">Account Status</small>
                                <div class="fw-semibold text-success">Active</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-footer bg-white border-0 text-center py-4">
                    <a href="${pageContext.request.contextPath}/change-password" class="btn btn-primary">Change Password</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
