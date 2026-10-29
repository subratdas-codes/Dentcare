<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${portal == 'ADMIN'}">
        <c:set var="portalName" value="Admin" />
        <c:set var="forgotAction" value="/admin/forgot-password" />
        <c:set var="loginAction" value="/admin/login" />
    </c:when>
    <c:when test="${portal == 'DOCTOR'}">
        <c:set var="portalName" value="Doctor" />
        <c:set var="forgotAction" value="/doctor/forgot-password" />
        <c:set var="loginAction" value="/doctor/login" />
    </c:when>
    <c:otherwise>
        <c:set var="portalName" value="Patient" />
        <c:set var="forgotAction" value="/forgot-password" />
        <c:set var="loginAction" value="/login" />
    </c:otherwise>
</c:choose>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>DentCare - ${portalName} Forgot Password</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { min-height: 100vh; margin: 0; background: linear-gradient(135deg, #f0f9ff 0%, #e6f7f4 100%); color: #172b4d; font-family: "Open Sans", "Segoe UI", system-ui, -apple-system, sans-serif; }
        .auth-wrap { min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1rem; }
        .auth-card { width: min(460px, 100%); border: 1px solid #dbe7ef; border-radius: 1rem; background: #fff; box-shadow: 0 22px 55px rgba(15, 31, 58, .14); overflow: hidden; }
        .auth-head { background: linear-gradient(100deg, #06a3da 0%, #0f766e 100%); color: #fff; padding: 1.6rem 1.8rem; }
        .auth-head .brand { font-size: 1.35rem; font-weight: 700; }
        .auth-body { padding: 1.8rem; }
        .form-label { font-weight: 600; color: #26364d; }
        .form-control { border-radius: .65rem; padding: .7rem .85rem; border-color: #cbd8e4; }
        .form-control:focus { border-color: #0f766e; box-shadow: 0 0 0 .2rem rgba(15, 118, 110, .15); }
        .btn-brand { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; border-radius: .65rem; padding: .7rem 1rem; }
        .btn-brand:hover, .btn-brand:focus { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .muted { color: #52627a; }
        .auth-card a { color: #0b5d57; font-weight: 600; }
        .alert { border-radius: .65rem; }
    </style>
</head>
<body>
<div class="auth-wrap">
    <main class="auth-card">
        <header class="auth-head">
            <div class="brand"><i class="bi bi-heart-pulse me-2"></i>DentCare</div>
            <div class="mt-1">${portalName} password reset</div>
        </header>
        <div class="auth-body">
            <h1 class="h4 fw-bold mb-2">Forgot your password?</h1>
            <p class="muted mb-4">Enter the email address registered to your ${portalName} account. We will email you a secure link to choose a new password.</p>

            <c:if test="${not empty success}">
                <div class="alert alert-success" role="status"><c:out value="${success}" /></div>
                <p class="small muted mb-4">It may take a minute to arrive. Please check your spam or junk folder too.</p>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert"><c:out value="${error}" /></div>
            </c:if>

            <form action="<c:url value='${forgotAction}' />" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="mb-3">
                    <label class="form-label" for="email">Email address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="you@example.com" autocomplete="email" required />
                </div>
                <button type="submit" class="btn btn-brand w-100">Send reset link</button>
            </form>

            <p class="text-center mt-4 mb-0 muted">
                Remembered it? <a href="<c:url value='${loginAction}' />">Back to ${portalName} login</a>
            </p>
        </div>
    </main>
</div>
</body>
</html>
