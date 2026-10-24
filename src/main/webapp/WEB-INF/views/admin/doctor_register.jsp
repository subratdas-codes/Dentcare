<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Registration - DentCare</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #0f1f3a; min-height: 100vh; }
        .wrap { min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1rem; }
        .card { width: min(480px, 100%); border: none; border-radius: 12px; overflow: hidden; box-shadow: 0 40px 80px rgba(15, 31, 58, 0.5); }
        .card-header { background: linear-gradient(90deg, #06A3DA 0%, #091E3E 100%); color: #fff; text-align: center; padding: 2rem; border: none; }
        .card-body { padding: 2rem; background: #fff; }
        .form-control { border-radius: 10px; padding: 0.8rem 1rem; }
        .btn-submit { border-radius: 999px; padding: 0.9rem 1rem; letter-spacing: 0.3rem; text-transform: uppercase; }
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <div class="card-header">
            <h3 class="mb-1"><i class="fa fa-tooth me-2"></i>DentCare</h3>
            <p class="mb-0">Doctor Registration</p>
        </div>
        <div class="card-body">
            <form action="<c:url value='/admin/register' />" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="mb-3">
                    <label class="form-label">Full Name</label>
                    <input type="text" class="form-control" name="name" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Phone</label>
                    <input type="text" class="form-control" name="phone">
                </div>
                <div class="mb-3">
                    <label class="form-label">Specialization</label>
                    <input type="text" class="form-control" name="specialization" placeholder="e.g. Orthodontist">
                </div>
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" class="form-control" name="password" required>
                </div>
                <button class="btn btn-primary btn-submit w-100" type="submit">Register</button>
            </form>
            <div class="text-center mt-3">
                <a href="<c:url value='/admin/login' />" class="small">Back to Login</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
