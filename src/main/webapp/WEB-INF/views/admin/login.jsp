<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>DentCare | Staff Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <style>
        body { background: #0f1f3a; min-height: 100vh; font-family: 'Open Sans', sans-serif; }
        .wrap { min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1rem; }
        .card { width: min(420px, 100%); border: none; border-radius: 12px; overflow: hidden; box-shadow: 0 40px 80px rgba(15, 31, 58, 0.5); }
        .card-header { background: linear-gradient(90deg, #06A3DA 0%, #091E3E 100%); color: #fff; text-align: center; padding: 2rem; border: none; }
        .card-body { padding: 2rem; background: #fff; }
        .btn-role { border-radius: 999px; padding: 0.8rem 1rem; }
        .form-control { border-radius: 10px; padding: 0.8rem 1rem; }
        .btn-submit { border-radius: 999px; padding: 0.9rem 1rem; letter-spacing: 0.3rem; text-transform: uppercase; }
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <div class="card-header">
            <h3 class="mb-1"><i class="fa fa-tooth me-2"></i>DentCare</h3>
            <p class="mb-0">Staff Portal - Admin / Doctor</p>
        </div>
        <div class="card-body">
            <div id="roleSelect" style="display:${empty selectedRole ? 'block' : 'none'};">
                <p class="text-center text-muted mb-3">Select Role</p>
                <div class="d-grid gap-2">
                    <a class="btn btn-primary btn-role" href="<c:url value='/admin/login/admin' />">Login as Admin</a>
                    <a class="btn btn-outline-primary btn-role" href="<c:url value='/doctor/login' />">Login as Doctor</a>
                </div>
            </div>
            <div id="loginBox" style="display:${empty selectedRole ? 'none' : 'block'};">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-muted">Login as <strong id="roleName"><c:choose><c:when test="${selectedRole == 'DOCTOR'}">Doctor</c:when><c:otherwise>Admin</c:otherwise></c:choose></strong></span>
                    <a class="btn btn-link btn-sm p-0" href="<c:url value='/admin/login' />">Change Role</a>
                </div>
                <c:if test="${param.error != null}"><div class="alert alert-danger" role="alert">Invalid credentials or this account does not belong to the selected staff portal.</div></c:if>
                <c:if test="${param.logout != null}"><div class="alert alert-success" role="status">Logged out of this portal successfully.</div></c:if>
                <c:if test="${param.registered == 'true'}"><div class="alert alert-success" role="status">Doctor account created. Sign in to continue.</div></c:if>
                <form action="<c:url value='/login' />" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" name="portal" value="${selectedRole}" />
                    <input type="hidden" name="staffRole" id="staffRole" value="${selectedRole}" />
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="username" required>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <label class="form-label">Password</label>
                            <a href="<c:url value='${selectedRole == "DOCTOR" ? "/doctor/forgot-password" : "/admin/forgot-password"}' />" class="small">Forgot Password?</a>
                        </div>
                        <div class="input-group">
                            <input type="password" id="pwd" class="form-control" name="password" required>
                            <button class="btn btn-outline-secondary" type="button" onclick="togglePwd()"><i class="fas fa-eye" id="eye"></i></button>
                        </div>
                    </div>
                    <button class="btn btn-primary btn-submit w-100" type="submit">Sign In</button>
                </form>
                <div class="text-center mt-3">
                    <a href="<c:url value='${selectedRole == "DOCTOR" ? "/doctor/forgot-password" : "/admin/forgot-password"}' />" class="small">Reset Password</a>
                </div>
                <div id="doctorRegister" class="text-center mt-2" style="display:${selectedRole == 'DOCTOR' ? 'block' : 'none'};">
                    <a href="<c:url value='/doctor/register' />" class="small">Register as New Doctor</a>
                </div>
            </div>
            <div class="text-center mt-3">
                <a href="<c:url value='/' />" class="text-muted small"><i class="fas fa-arrow-left me-1"></i>Back to Website</a>
            </div>
        </div>
    </div>
</div>
<script>
function togglePwd(){ var p=document.getElementById('pwd'); var e=document.getElementById('eye'); if(p.type==='password'){p.type='text';e.classList.remove('fa-eye');e.classList.add('fa-eye-slash');}else{p.type='password';e.classList.remove('fa-eye-slash');e.classList.add('fa-eye');}}
</script>
</body>
</html>
