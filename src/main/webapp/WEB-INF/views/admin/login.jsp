<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>DentCare | Admin Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Jost:wght@500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <style>
        :root {
            --admin-primary: #1f6bff;
            --admin-bg: #0b1026;
        }
        * { font-family: 'Inter', 'Jost', sans-serif; }
        body {
            background: radial-gradient(circle at top, #151b2f, var(--admin-bg));
            min-height: 100vh;
            color: #f8fafc;
            margin: 0;
        }
        .admin-shell { min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1rem; }
        .admin-card {
            position: relative;
            width: min(460px, 100%);
            border-radius: 18px;
            overflow: hidden;
            background: linear-gradient(180deg, rgba(31, 107, 255, 0.22) 0%, rgba(11, 16, 38, 0.98) 55%);
            box-shadow: 0 60px 120px -60px rgba(31, 107, 255, 0.45);
            border: 1px solid rgba(148, 163, 184, 0.25);
        }
        .admin-card::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at top, rgba(59, 130, 246, 0.18), transparent 65%);
            pointer-events: none;
        }
        .admin-card-body { position: relative; padding: clamp(2rem, 4vw, 3.25rem); }
        .brand-row { display: flex; align-items: center; gap: 0.9rem; margin-bottom: 2rem; }
        .brand-mark {
            width: 52px; height: 52px; border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.9), rgba(29, 78, 216, 0.9));
            box-shadow: 0 30px 60px -30px rgba(59, 130, 246, 0.9);
        }
        .brand-text small { display: block; text-transform: uppercase; letter-spacing: 0.6rem; font-size: 0.7rem; color: rgba(226, 232, 255, 0.5); }
        .brand-text strong { display: block; margin-top: 0.4rem; font-size: 1.25rem; letter-spacing: 0.4rem; text-transform: uppercase; }
        .panel-heading { margin-bottom: 2rem; }
        .panel-heading h1 { font-size: clamp(1.8rem, 4vw, 2.6rem); margin-bottom: 0.6rem; }
        .panel-heading p { color: rgba(226, 232, 255, 0.6); margin-bottom: 0; }
        .form-label { font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.3rem; color: rgba(226, 232, 255, 0.6); margin-bottom: 0.8rem; }
        .input-group {
            border-radius: 999px; overflow: hidden;
            border: 1px solid rgba(148, 163, 184, 0.4);
            background: rgba(15, 23, 42, 0.7);
            transition: border 0.2s ease, box-shadow 0.2s ease;
        }
        .input-group:focus-within { border-color: rgba(59, 130, 246, 0.9); box-shadow: 0 0 0 6px rgba(59, 130, 246, 0.12); }
        .input-group-text { background: transparent; border: none; color: rgba(226, 232, 255, 0.6); padding: 0 1.2rem 0 1.6rem; }
        .form-control { background: transparent; border: none; color: #f8fafc; padding: 0.9rem 1.6rem 0.9rem 0; }
        .form-control::placeholder { color: rgba(226, 232, 255, 0.4); }
        .form-control:focus { box-shadow: none; background: transparent; color: #f8fafc; }
        .btn-admin-login {
            width: 100%; border-radius: 999px; border: none; padding: 1rem 2rem;
            text-transform: uppercase; letter-spacing: 0.5rem; font-weight: 600;
            background: linear-gradient(90deg, #3b82f6 0%, #2563eb 100%);
            box-shadow: 0 40px 70px -40px rgba(59, 130, 246, 0.9);
        }
        .btn-admin-login:hover { filter: brightness(1.05); }
        .admin-footer-link { display: inline-flex; align-items: center; gap: 0.6rem; color: rgba(226, 232, 255, 0.5); text-decoration: none; margin-top: 2rem; }
        .admin-footer-link:hover { color: rgba(226, 232, 255, 0.9); }
        .alert { border-radius: 999px; border: none; padding: 0.8rem 1.6rem; }
    </style>
</head>
<body>
<main class="admin-shell">
    <div class="admin-card">
        <div class="admin-card-body">
            <div class="brand-row">
                <div class="brand-mark">
                    <i class="fa fa-tooth text-white fa-lg"></i>
                </div>
                <div class="brand-text">
                    <small>DentCare</small>
                    <strong>Admin Panel</strong>
                </div>
            </div>
            <div class="panel-heading">
                <h1>Administrator Login</h1>
            </div>
            <c:if test="${param.error != null}">
                <div class="alert alert-danger text-center mb-4">Invalid admin credentials. Please try again.</div>
            </c:if>
            <c:if test="${param.logout != null}">
                <div class="alert alert-success text-center mb-4">Signed out successfully.</div>
            </c:if>
            <form action="<c:url value='/login' />" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="mb-4">
                    <label class="form-label">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="far fa-envelope"></i></span>
                        <input type="email" class="form-control" name="username" placeholder="admin@dentcare.in" required autofocus autocomplete="username">
                    </div>
                </div>
                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <label class="form-label mb-0">Password</label>
                        <a href="<c:url value='/forgot-password' />" class="small" style="color: rgba(226,232,255,0.7); text-decoration: none;">Forgot Password?</a>
                    </div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="password" id="adminPassword" class="form-control" name="password" placeholder="Enter your password" required autocomplete="current-password">
                        <span class="input-group-text" id="toggleAdminPassword" style="cursor: pointer;"><i class="fas fa-eye"></i></span>
                    </div>
                </div>
                <button class="btn btn-admin-login text-white" type="submit">Sign In</button>
            </form>
            <div class="text-center">
                <a class="admin-footer-link" href="<c:url value='/' />">
                    <i class="fas fa-long-arrow-alt-left"></i>
                    <span>Return to DentCare Website</span>
                </a>
            </div>
        </div>
    </div>
</main>
<script>
    const toggle = document.getElementById('toggleAdminPassword');
    const pwd = document.getElementById('adminPassword');
    if (toggle && pwd) {
        toggle.addEventListener('click', function () {
            const type = pwd.getAttribute('type') === 'password' ? 'text' : 'password';
            pwd.setAttribute('type', type);
            const icon = this.querySelector('i');
            if (icon) {
                icon.classList.toggle('fa-eye');
                icon.classList.toggle('fa-eye-slash');
            }
        });
    }
</script>
</body>
</html>
