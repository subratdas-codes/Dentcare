<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>DentCare | Admin Portal</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
<link href="<c:url value=/css/bootstrap.min.css />" rel="stylesheet">
<link href="<c:url value=/css/style.css />" rel="stylesheet">
<style>body{background:radial-gradient(circle at top,#0f2239,#051225);min-height:100vh}.admin-login-card{border-radius:16px;overflow:hidden;box-shadow:0 40px 60px -30px rgba(15,34,57,.8)}.admin-login-header{background:linear-gradient(135deg,#06A3DA 0%,#091E3E 100%)}.admin-login-header h1{letter-spacing:6px;text-transform:uppercase;font-size:14px}.form-control{border-radius:12px;padding:14px 18px}.btn-admin{border-radius:999px;padding:14px 30px;letter-spacing:4px;text-transform:uppercase;font-size:12px}.admin-badge{display:inline-flex;align-items:center;gap:10px;padding:10px 18px;border-radius:999px;background:rgba(6,163,218,.25);color:#fff;letter-spacing:6px;text-transform:uppercase;font-size:11px}</style>
</head>
<body>
<div class="container d-flex align-items-center justify-content-center min-vh-100 py-5">
<div class="col-12 col-md-8 col-lg-5">
<div class="text-center mb-5">
<div class="admin-badge mb-3"><i class="fa fa-shield-alt"></i><span>Restricted Access</span></div>
<h1 class="text-white display-5 mb-2"><i class="fa fa-tooth text-primary me-2"></i>DentCare</h1>
<p class="text-white-50 mb-0">Administration Portal</p>
</div>
<div class="card admin-login-card border-0">
<div class="card-header admin-login-header text-center text-white py-4 border-0"><h1 class="mb-1">Admin Sign In</h1><p class="mb-0 text-white-50">Authorized personnel only</p></div>
<div class="card-body bg-white p-4 p-lg-5">
<c:if test="${param.error != null}"><div class="alert alert-danger">Invalid email or password.</div></c:if>
<c:if test="${param.logout != null}"><div class="alert alert-success">You have been logged out successfully.</div></c:if>
<form action="<c:url value=/login />" method="post"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
<div class="mb-4"><label class="form-label text-uppercase small fw-bold text-muted">Admin Email</label><input type="email" class="form-control" name="username" placeholder="Enter admin email" required autofocus></div>
<div class="mb-4"><label class="form-label text-uppercase small fw-bold text-muted">Password</label><input type="password" class="form-control" name="password" placeholder="Enter password" required></div>
<div class="d-grid"><button class="btn btn-primary btn-admin" type="submit">Access Dashboard</button></div>
</form>
<div class="text-center mt-4"><a href="<c:url value=/ />" class="text-decoration-none text-muted"><i class="fa fa-arrow-left me-2"></i>Back to website</a></div>
</div>
</div>
<div class="text-center text-white-50 mt-4 small">&copy; <script>document.write(new Date().getFullYear());</script> DentCare. All rights reserved.</div>
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
