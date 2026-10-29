<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>DentCare - Choose Your Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { min-height: 100vh; margin: 0; background: linear-gradient(135deg, #f0f9ff 0%, #e6f7f4 100%); color: #172b4d; font-family: "Open Sans", "Segoe UI", system-ui, -apple-system, sans-serif; }
        .portal-wrap { min-height: 100vh; padding: 3rem 1rem; display: flex; flex-direction: column; justify-content: center; }
        .portal-header { max-width: 980px; margin: 0 auto 2rem; text-align: center; }
        .portal-brand { display: inline-flex; align-items: center; gap: .55rem; font-size: 1.5rem; font-weight: 800; color: #0f766e; text-decoration: none; }
        .portal-brand:hover { color: #0b5d57; }
        .portal-title { font-size: clamp(1.6rem, 3vw, 2.1rem); font-weight: 800; margin: 1rem 0 .4rem; }
        .portal-subtitle { color: #52627a; max-width: 620px; margin: 0 auto; }
        .portal-card { height: 100%; border: 1px solid #dbe7ef; border-radius: 1rem; background: #fff; box-shadow: 0 18px 45px rgba(15, 31, 58, .10); overflow: hidden; display: flex; flex-direction: column; }
        .portal-card-head { padding: 1.35rem 1.4rem .8rem; }
        .portal-icon { width: 52px; height: 52px; border-radius: .85rem; display: inline-flex; align-items: center; justify-content: center; font-size: 1.45rem; margin-bottom: .9rem; }
        .portal-card h2 { font-size: 1.1rem; font-weight: 800; margin-bottom: .35rem; }
        .portal-card p { color: #52627a; font-size: .9rem; margin-bottom: 0; }
        .portal-card-body { padding: 0 1.4rem 1.4rem; margin-top: auto; }
        .portal-btn { border-radius: .65rem; font-weight: 700; padding: .65rem 1rem; }
        .portal-note { max-width: 980px; margin: 1.6rem auto 0; text-align: center; color: #52627a; font-size: .9rem; }
        .portal-note a { color: #0b5d57; font-weight: 700; }
        .patient-icon { background: #e8f1ff; color: #1d4ed8; }
        .doctor-icon { background: #e7f7ef; color: #15803d; }
        .admin-icon { background: #f1edff; color: #6d28d9; }
    </style>
</head>
<body>
<div class="portal-wrap">
    <header class="portal-header">
        <a href="<c:url value='/' />" class="portal-brand"><i class="bi bi-heart-pulse"></i>DentCare</a>
        <h1 class="portal-title">Choose your login</h1>
        <p class="portal-subtitle">Select the portal that matches your account. Each portal signs you in securely and takes you to the right dashboard.</p>
    </header>

    <main class="container" style="max-width: 980px;">
        <div class="row g-4">
            <div class="col-md-4">
                <section class="portal-card">
                    <div class="portal-card-head">
                        <div class="portal-icon patient-icon"><i class="bi bi-person"></i></div>
                        <h2>Patient</h2>
                        <p>Book appointments, view your visit history, download receipts, and manage your profile.</p>
                    </div>
                    <div class="portal-card-body">
                        <a href="<c:url value='/login' />" class="btn btn-primary portal-btn w-100">Patient Login</a>
                    </div>
                </section>
            </div>
            <div class="col-md-4">
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
            <div class="col-md-4">
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

        <p class="portal-note">
            New patient? <a href="<c:url value='/register' />">Create an account</a>.
            New doctor? <a href="<c:url value='/doctor/register' />">Register here</a>.
            <br><a href="<c:url value='/' />">Back to the DentCare website</a>
        </p>
    </main>
</div>
</body>
</html>
