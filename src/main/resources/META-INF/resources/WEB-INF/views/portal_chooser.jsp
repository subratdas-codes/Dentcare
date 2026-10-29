<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>DentCare - Staff Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { min-height: 100vh; margin: 0; background: linear-gradient(135deg, #f0f9ff 0%, #e6f7f4 100%); color: #172b4d; font-family: "Open Sans", "Segoe UI", system-ui, -apple-system, sans-serif; }
        .portal-wrap { min-height: 100vh; padding: 3rem 1rem; display: flex; flex-direction: column; justify-content: center; }
        .portal-header { max-width: 720px; margin: 0 auto 2rem; text-align: center; }
        .portal-brand { display: inline-flex; align-items: center; gap: .55rem; font-size: 1.5rem; font-weight: 800; color: #0f766e; text-decoration: none; }
        .portal-brand:hover { color: #0b5d57; }
        .portal-title { font-size: clamp(1.6rem, 3vw, 2.1rem); font-weight: 800; margin: 1rem 0 .4rem; }
        .portal-subtitle { color: #52627a; max-width: 560px; margin: 0 auto; }
        .portal-card { height: 100%; border: 1px solid #dbe7ef; border-radius: 1rem; background: #fff; box-shadow: 0 18px 45px rgba(15, 31, 58, .10); overflow: hidden; display: flex; flex-direction: column; }
        .portal-card-head { padding: 1.5rem 1.5rem .9rem; }
        .portal-icon { width: 52px; height: 52px; border-radius: .85rem; display: inline-flex; align-items: center; justify-content: center; font-size: 1.45rem; margin-bottom: .9rem; }
        .portal-card h2 { font-size: 1.15rem; font-weight: 800; margin-bottom: .35rem; }
        .portal-card p { color: #52627a; font-size: .9rem; margin-bottom: 0; }
        .portal-card-body { padding: 0 1.5rem 1.5rem; margin-top: auto; }
        .portal-btn { border-radius: .65rem; font-weight: 700; padding: .7rem 1rem; }
        .portal-note { max-width: 720px; margin: 1.8rem auto 0; text-align: center; color: #3d4b5f; font-size: .92rem; }
        .portal-note a { color: #0b5d57; font-weight: 700; }
        .patient-note { background: #fff; border: 1px solid #dbe7ef; border-radius: .85rem; padding: .9rem 1.1rem; margin: 0 auto 1.8rem; max-width: 720px; color: #334155; font-size: .92rem; }
        .patient-note i { color: #0f766e; }
        .doctor-icon { background: #e7f7ef; color: #15803d; }
        .admin-icon { background: #f1edff; color: #6d28d9; }
    </style>
</head>
<body>
<div class="portal-wrap">
    <header class="portal-header">
        <a href="<c:url value='/' />" class="portal-brand"><i class="bi bi-heart-pulse"></i>DentCare</a>
        <h1 class="portal-title">Staff Login</h1>
        <p class="portal-subtitle">This portal is for clinic staff only. Choose Doctor or Admin to sign in to your dashboard.</p>
    </header>

    <main class="container" style="max-width: 720px;">
        <div class="row g-4 justify-content-center">
            <div class="col-md-6">
                <section class="portal-card">
                    <div class="portal-card-head">
                        <div class="portal-icon doctor-icon"><i class="bi bi-person-badge"></i></div>
                        <h2>Doctor</h2>
                        <p>Review your schedule, manage appointments, and request updates to your service fees.</p>
                    </div>
                    <div class="portal-card-body">
                        <a href="<c:url value='/doctor/login' />" class="btn portal-btn w-100" style="background:#0f766e;border-color:#0f766e;color:#fff;">Doctor Login</a>
                    </div>
                </section>
            </div>
            <div class="col-md-6">
                <section class="portal-card">
                    <div class="portal-card-head">
                        <div class="portal-icon admin-icon"><i class="bi bi-shield-lock"></i></div>
                        <h2>Admin</h2>
                        <p>Manage doctors, fees, appointments, website content, and clinic-wide settings.</p>
                    </div>
                    <div class="portal-card-body">
                        <a href="<c:url value='/admin/login' />" class="btn btn-dark portal-btn w-100">Admin Login</a>
                    </div>
                </section>
            </div>
        </div>

        <p class="patient-note mt-4 text-center">
            <i class="bi bi-person-circle me-1"></i>
            Looking for your patient account? <a href="<c:url value='/login' />">Go to Patient Login</a>.
        </p>

        <p class="portal-note">
            New patient? <a href="<c:url value='/register' />">Create an account</a>.
            New doctor? <a href="<c:url value='/doctor/register' />">Register here</a>.
            <br><a href="<c:url value='/' />">Back to the DentCare website</a>
        </p>
    </main>
</div>
</body>
</html>
