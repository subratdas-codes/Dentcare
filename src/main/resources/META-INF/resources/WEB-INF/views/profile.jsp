<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Personal Details - ${site.siteName}</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <style>
        body { background: #f5f8fb; color: #1d2b3f; }
        .dc-card { border: 1px solid #e7ecf3; border-radius: 1rem; background: #fff; }
        .dc-card-head { padding: 1.1rem 1.4rem; border-bottom: 1px solid #eef2f7; }
        .dc-label { font-weight: 600; color: #34445c; font-size: .88rem; }
        .form-control { border-color: #dfe6ef; border-radius: .65rem; padding: .68rem .8rem; }
        .form-control:focus { border-color: #0f766e; box-shadow: 0 0 0 .18rem rgba(15,118,110,.12); }
        .form-control:disabled { background: #f8fafc; color: #64748b; }
        .dc-save { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; border-radius: .6rem; }
        .dc-save:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .dc-tabs { border-bottom: 1px solid #e7ecf3; gap: .25rem; }
        .dc-tabs .nav-link { border: 0; border-bottom: 2px solid transparent; color: #64748b; font-weight: 600; padding: .75rem 1rem; border-radius: 0; }
        .dc-tabs .nav-link.active { color: #0f766e; border-bottom-color: #0f766e; background: transparent; }
        .dc-account-wrap { position: sticky; top: 110px; }
        .dc-note { background: #f3faf8; border: 1px solid #d7ede9; border-radius: .75rem; padding: .85rem 1rem; color: #315b56; font-size: .86rem; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<div class="container py-4 py-lg-5">
    <div class="mb-4">
        <div class="text-uppercase small fw-bold mb-1" style="color:#0f766e;letter-spacing:.07em;">Patient account</div>
        <h1 class="h3 fw-bold mb-1">Profile &amp; security</h1>
        <p class="text-muted mb-0">Keep your contact details current and protect your account.</p>
    </div>

    <div class="row g-4">
        <div class="col-lg-3">
            <div class="dc-account-wrap">
                <c:set var="activeAccount" value="${param.tab == 'security' ? 'security' : 'profile'}" />
                <%@ include file="_account_sidebar.jsp" %>
            </div>
        </div>
        <div class="col-lg-9">
            <ul class="nav nav-tabs dc-tabs mb-3">
                <li class="nav-item"><a class="nav-link ${param.tab == 'security' ? '' : 'active'}" href="${pageContext.request.contextPath}/profile">Personal details</a></li>
                <li class="nav-item"><a class="nav-link ${param.tab == 'security' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile?tab=security">Password &amp; security</a></li>
            </ul>

            <c:choose>
                <c:when test="${param.tab == 'security'}">
                    <c:if test="${not empty passwordError}"><div class="alert alert-danger border-0"><c:out value="${passwordError}" /></div></c:if>
                    <c:if test="${not empty passwordSuccess}"><div class="alert alert-success border-0"><c:out value="${passwordSuccess}" /></div></c:if>
                    <div class="dc-card">
                        <div class="dc-card-head">
                            <h2 class="h6 fw-bold mb-1">Change password</h2>
                            <p class="text-muted small mb-0">Use at least 8 characters. You will stay signed in on this device.</p>
                        </div>
                        <div class="p-4">
                            <form action="${pageContext.request.contextPath}/profile/password" method="post" class="row g-3">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <div class="col-12">
                                    <label class="dc-label" for="oldPassword">Current password</label>
                                    <input type="password" id="oldPassword" name="oldPassword" class="form-control" required autocomplete="current-password">
                                </div>
                                <div class="col-md-6">
                                    <label class="dc-label" for="newPassword">New password</label>
                                    <input type="password" id="newPassword" name="newPassword" class="form-control" minlength="8" required autocomplete="new-password">
                                </div>
                                <div class="col-md-6">
                                    <label class="dc-label" for="confirmPassword">Confirm new password</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" minlength="8" required autocomplete="new-password">
                                </div>
                                <div class="col-12 d-flex flex-wrap justify-content-between align-items-center gap-2 mt-2">
                                    <a href="${pageContext.request.contextPath}/forgot-password" class="small text-decoration-none">Forgot your current password? Reset by email</a>
                                    <button type="submit" class="btn dc-save px-4">Update password</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="dc-note mt-3">
                        <i class="bi bi-shield-check me-1"></i>If the reset email does not arrive, ask the clinic admin to reset your password from the admin portal.
                    </div>
                </c:when>
                <c:otherwise>
                    <c:if test="${not empty error}"><div class="alert alert-danger border-0"><c:out value="${error}" /></div></c:if>
                    <c:if test="${not empty success}"><div class="alert alert-success border-0"><c:out value="${success}" /></div></c:if>
                    <div class="dc-card">
                        <div class="dc-card-head">
                            <h2 class="h6 fw-bold mb-1">Personal details</h2>
                            <p class="text-muted small mb-0">This name and phone number are used for your appointments and receipts.</p>
                        </div>
                        <div class="p-4">
                            <form action="${pageContext.request.contextPath}/profile" method="post" class="row g-3">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <div class="col-md-7">
                                    <label class="dc-label" for="name">Full name</label>
                                    <input type="text" id="name" name="name" class="form-control" value="<c:out value='${patient.name}' />" required maxlength="120">
                                </div>
                                <div class="col-md-5">
                                    <label class="dc-label" for="age">Age</label>
                                    <input type="number" id="age" name="age" class="form-control" value="${patient.age}" min="0" max="120">
                                </div>
                                <div class="col-md-7">
                                    <label class="dc-label" for="email">Email address</label>
                                    <input type="email" id="email" class="form-control" value="<c:out value='${patient.email}' />" disabled>
                                    <div class="form-text">Email is your login ID. Contact the clinic to change it.</div>
                                </div>
                                <div class="col-md-5">
                                    <label class="dc-label" for="phone">Phone number</label>
                                    <input type="tel" id="phone" name="phone" class="form-control" value="<c:out value='${patient.phone}' />" maxlength="40">
                                </div>
                                <div class="col-12 d-flex justify-content-end mt-2">
                                    <button type="submit" class="btn dc-save px-4">Save changes</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="row g-3 mt-1">
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/my/appointments" class="dc-card d-block p-3 text-decoration-none text-dark h-100">
                                <div class="fw-bold mb-1"><i class="bi bi-calendar-check me-1" style="color:#0f766e;"></i>My appointments</div>
                                <div class="small text-muted">Upcoming, history and cancelled visits.</div>
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/my/receipts" class="dc-card d-block p-3 text-decoration-none text-dark h-100">
                                <div class="fw-bold mb-1"><i class="bi bi-receipt me-1" style="color:#0f766e;"></i>Receipts</div>
                                <div class="small text-muted">Print or download past payment receipts.</div>
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="_user_footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
