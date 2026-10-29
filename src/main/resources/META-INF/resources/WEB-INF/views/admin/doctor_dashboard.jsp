<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="activePage" value="dashboard" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - DentCare</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f3f8f7; color: #17312e; }
        .hero { background: radial-gradient(1200px 300px at 85% -20%, #1fa99b 0%, transparent 60%), linear-gradient(120deg, #0a2e2b 0%, #0f5f58 60%, #0f766e 100%); color: #fff; border-radius: 1.25rem; overflow: hidden; position: relative; }
        .hero:after { content: ""; position: absolute; width: 320px; height: 320px; border: 1px solid rgba(255,255,255,.14); border-radius: 50%; right: -80px; bottom: -160px; }
        .hero-avatar { width: 64px; height: 64px; border-radius: 1rem; background: rgba(255,255,255,.16); border: 1px solid rgba(255,255,255,.24); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 1.4rem; }
        .metric { border: 1px solid #dcebe8; border-radius: 1rem; background: #fff; padding: 1rem 1.1rem; height: 100%; transition: transform .16s ease, box-shadow .16s ease; }
        .metric:hover { transform: translateY(-2px); box-shadow: 0 16px 30px -24px rgba(10,46,43,.55); }
        .metric .icon { width: 38px; height: 38px; border-radius: .7rem; display: flex; align-items: center; justify-content: center; background: #eaf7f4; color: #0f766e; font-size: 1.05rem; }
        .metric .num { font-size: 1.55rem; font-weight: 800; line-height: 1; }
        .metric .lbl { color: #7b8f8a; font-size: .76rem; font-weight: 600; }
        .panel { border: 1px solid #dcebe8; border-radius: 1rem; background: #fff; overflow: hidden; }
        .panel-head { padding: 1rem 1.25rem; border-bottom: 1px solid #edf4f2; }
        .appt { display: flex; gap: .9rem; padding: .85rem 0; border-bottom: 1px dashed #e8f1ef; }
        .appt:last-child { border-bottom: 0; }
        .appt-time { min-width: 78px; font-weight: 800; color: #0f766e; font-size: .9rem; }
        .appt-name { font-weight: 700; }
        .soft-badge { background: #eaf7f4; color: #0f766e; border-radius: 999px; padding: .18rem .5rem; font-size: .7rem; font-weight: 700; }
        .status-booked { background: #e8f1ff; color: #1d4ed8; }
        .status-completed { background: #e7f7ef; color: #15803d; }
        .status-cancelled { background: #fdecec; color: #b91c1c; }
        .table thead th { color: #7b8f8a; font-size: .72rem; letter-spacing: .05em; text-transform: uppercase; white-space: nowrap; }
        .quick { display: flex; align-items: center; justify-content: space-between; padding: .8rem .9rem; border: 1px solid #e1eeeb; border-radius: .75rem; color: #24433f; text-decoration: none; font-weight: 600; font-size: .88rem; background: #fff; }
        .quick:hover { border-color: #0f766e; color: #0f766e; background: #f7fcfb; }
        .fee-line { display: flex; justify-content: space-between; padding: .5rem 0; border-bottom: 1px dashed #e8f1ef; font-size: .86rem; }
        .fee-line:last-child { border-bottom: 0; }
        .empty-mini { text-align: center; color: #8ba09b; padding: 2rem 1rem; }
        @media (prefers-reduced-motion: reduce) { .metric { transition: none; } }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<main class="container-fluid px-3 px-lg-4 py-4">
    <section class="hero p-4 p-lg-5 mb-4">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-4 position-relative" style="z-index:1;">
            <div class="d-flex align-items-center gap-3">
                <div class="hero-avatar"><c:out value="${doctor.name.substring(0,1)}" /></div>
                <div>
                    <div class="small text-white-50 text-uppercase" style="letter-spacing:.08em;">Doctor workspace</div>
                    <h1 class="h3 fw-bold mb-1">Good day, <c:out value="${doctor.name}" /></h1>
                    <div class="text-white-50 small"><c:out value="${doctor.specialization}" /> · your assigned patients only</div>
                </div>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-light fw-semibold"><i class="bi bi-calendar-week me-1"></i>My patients</a>
                <a href="${pageContext.request.contextPath}/doctor/fees" class="btn btn-outline-light fw-semibold"><i class="bi bi-currency-rupee me-1"></i>My fees</a>
            </div>
        </div>
    </section>

    <c:if test="${not empty success}"><div class="alert alert-success shadow-sm"><i class="bi bi-check-circle me-2"></i><c:out value="${success}" /></div></c:if>

    <section class="row g-3 mb-4" aria-label="Practice statistics">
        <div class="col-6 col-md-4 col-xl">
            <div class="metric"><div class="d-flex justify-content-between align-items-start"><div><div class="lbl">Today</div><div class="num"><c:out value="${todayCount}" /></div><div class="small text-muted">appointment(s)</div></div><div class="icon"><i class="bi bi-sun"></i></div></div></div>
        </div>
        <div class="col-6 col-md-4 col-xl">
            <div class="metric"><div class="d-flex justify-content-between align-items-start"><div><div class="lbl">Upcoming</div><div class="num"><c:out value="${upcomingCount}" /></div><div class="small text-muted">booked visits</div></div><div class="icon"><i class="bi bi-calendar-check"></i></div></div></div>
        </div>
        <div class="col-6 col-md-4 col-xl">
            <div class="metric"><div class="d-flex justify-content-between align-items-start"><div><div class="lbl">Patients</div><div class="num"><c:out value="${patientCount}" /></div><div class="small text-muted">assigned</div></div><div class="icon"><i class="bi bi-people"></i></div></div></div>
        </div>
        <div class="col-6 col-md-4 col-xl">
            <div class="metric"><div class="d-flex justify-content-between align-items-start"><div><div class="lbl">Completed</div><div class="num"><c:out value="${completedCount}" /></div><div class="small text-muted">visits</div></div><div class="icon"><i class="bi bi-check2-circle"></i></div></div></div>
        </div>
        <div class="col-12 col-md-4 col-xl">
            <div class="metric"><div class="d-flex justify-content-between align-items-start"><div><div class="lbl">Collected</div><div class="num">₹<fmt:formatNumber value="${earnings}" minFractionDigits="0" maxFractionDigits="0" /></div><div class="small text-muted">paid online</div></div><div class="icon"><i class="bi bi-wallet2"></i></div></div></div>
        </div>
    </section>

    <div class="row g-4">
        <div class="col-xl-8">
            <section class="panel mb-4">
                <div class="panel-head d-flex justify-content-between align-items-center">
                    <div><h2 class="h6 fw-bold mb-1">Today's schedule</h2><p class="small text-muted mb-0"><c:out value="${todayCount}" /> patient(s) · <c:out value="${doctor.specialization}" /></p></div>
                    <span class="soft-badge"><i class="bi bi-clock me-1"></i>Live</span>
                </div>
                <div class="px-3 px-sm-4 py-2">
                    <c:choose>
                        <c:when test="${not empty todayAppointments}">
                            <c:forEach var="a" items="${todayAppointments}">
                                <div class="appt">
                                    <div class="appt-time"><c:out value="${a.appointmentTime}" /></div>
                                    <div class="flex-fill">
                                        <div class="d-flex flex-wrap align-items-center gap-2">
                                            <div class="appt-name"><c:out value="${a.patientName}" /></div>
                                            <span class="soft-badge">${a.appointmentType.label}</span>
                                            <span class="soft-badge ${a.status == 'BOOKED' ? 'status-booked' : a.status == 'COMPLETED' ? 'status-completed' : 'status-cancelled'}">${a.status.label}</span>
                                        </div>
                                        <div class="small text-muted"><c:out value="${a.service}" /> · ₹<fmt:formatNumber value="${a.amount}" minFractionDigits="2" maxFractionDigits="2" /></div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/doctor/appointments/${a.id}/chat" class="btn btn-sm btn-outline-success align-self-center" title="Message patient"><i class="bi bi-chat-dots"></i></a>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-mini"><i class="bi bi-cup-hot fs-2 d-block mb-2"></i>No appointments scheduled for today.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <section class="panel">
                <div class="panel-head d-flex flex-column flex-sm-row justify-content-between gap-2">
                    <div><h2 class="h6 fw-bold mb-1">My assigned patients</h2><p class="small text-muted mb-0">Only appointments assigned to your account appear here.</p></div>
                    <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-sm btn-outline-success align-self-sm-center">View all</a>
                </div>
                <c:choose>
                    <c:when test="${not empty appointments}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead><tr><th class="ps-4">Patient</th><th>Visit</th><th>Date</th><th>Status</th><th class="text-end pe-4">Chat</th></tr></thead>
                                <tbody>
                                <c:forEach var="appointment" items="${appointments}" varStatus="s">
                                    <c:if test="${s.index < 7}">
                                        <tr>
                                            <td class="ps-4"><div class="fw-semibold"><c:out value="${appointment.patientName}" /></div><small class="text-muted"><c:out value="${appointment.email}" /></small></td>
                                            <td><div class="small"><c:out value="${appointment.service}" /></div><span class="soft-badge">${appointment.appointmentType.label}</span></td>
                                            <td class="small text-muted"><c:out value="${appointment.appointmentDate}" /><br><c:out value="${appointment.appointmentTime}" /></td>
                                            <td><span class="soft-badge ${appointment.status == 'BOOKED' ? 'status-booked' : appointment.status == 'COMPLETED' ? 'status-completed' : 'status-cancelled'}">${appointment.status.label}</span></td>
                                            <td class="text-end pe-4"><a class="btn btn-sm btn-outline-success" href="${pageContext.request.contextPath}/doctor/appointments/${appointment.id}/chat"><i class="bi bi-chat-dots"></i></a></td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise><div class="empty-mini"><i class="bi bi-calendar2-x fs-2 d-block mb-2"></i>No assigned patients yet. New bookings for you will appear here.</div></c:otherwise>
                </c:choose>
            </section>
        </div>

        <div class="col-xl-4">
            <section class="panel mb-4">
                <div class="panel-head"><h2 class="h6 fw-bold mb-1">Quick actions</h2><p class="small text-muted mb-0">Everything you need, one click away.</p></div>
                <div class="p-3 d-grid gap-2">
                    <a class="quick" href="${pageContext.request.contextPath}/doctor/appointments"><span><i class="bi bi-people me-2"></i>My assigned patients</span><i class="bi bi-chevron-right"></i></a>
                    <a class="quick" href="${pageContext.request.contextPath}/doctor/fees"><span><i class="bi bi-currency-rupee me-2"></i>Request a fee change</span><c:if test="${pendingFeeRequests > 0}"><span class="badge bg-warning text-dark">${pendingFeeRequests}</span></c:if><c:if test="${pendingFeeRequests == 0}"><i class="bi bi-chevron-right"></i></c:if></a>
                    <a class="quick" href="${pageContext.request.contextPath}/doctor/profile"><span><i class="bi bi-person-circle me-2"></i>Edit my profile</span><i class="bi bi-chevron-right"></i></a>
                    <a class="quick" href="${pageContext.request.contextPath}/doctor/change-password"><span><i class="bi bi-shield-lock me-2"></i>Change password</span><i class="bi bi-chevron-right"></i></a>
                </div>
            </section>

            <section class="panel mb-4">
                <div class="panel-head"><h2 class="h6 fw-bold mb-1">My fee snapshot</h2><p class="small text-muted mb-0">Approved amounts are live for new bookings.</p></div>
                <div class="px-3 px-sm-4 py-2">
                    <div class="fee-line"><span class="text-muted">Standard consultation</span><strong>₹<fmt:formatNumber value="${consultationFee}" minFractionDigits="0" maxFractionDigits="2" /></strong></div>
                    <c:forEach var="fee" items="${fees}" varStatus="s">
                        <c:if test="${s.index < 5}">
                            <div class="fee-line"><span class="text-muted"><c:out value="${fee.label}" /></span><strong>₹<fmt:formatNumber value="${fee.displayFee}" minFractionDigits="0" maxFractionDigits="2" />
                                <c:if test="${fee.pending}"><span class="badge bg-warning text-dark ms-1">pending</span></c:if>
                            </strong></div>
                        </c:if>
                    </c:forEach>
                    <c:if test="${empty fees}"><div class="small text-muted py-2">No custom fees yet. Standard clinic prices apply.</div></c:if>
                    <a href="${pageContext.request.contextPath}/doctor/fees" class="btn btn-sm btn-outline-success w-100 mt-3">Manage my fees</a>
                </div>
            </section>

            <div class="small text-muted px-1"><i class="bi bi-shield-check me-1"></i>Your account only shows your own assigned appointments — never other doctors' patients.</div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
