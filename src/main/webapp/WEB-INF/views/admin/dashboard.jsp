<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="activePage" value="dashboard" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - DentCare</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .hero { background: linear-gradient(120deg, #0b172a 0%, #0f4f4a 60%, #0f766e 100%); color: #fff; border-radius: 1.2rem; }
        .metric { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; padding: 1rem 1.1rem; height: 100%; transition: transform .16s ease, box-shadow .16s ease; }
        .metric:hover { transform: translateY(-2px); box-shadow: 0 16px 30px -24px rgba(15,31,58,.45); }
        .metric .icon { width: 40px; height: 40px; border-radius: .75rem; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; }
        .metric .num { font-size: 1.45rem; font-weight: 800; line-height: 1.1; }
        .metric .lbl { color: #7b8aa0; font-size: .76rem; font-weight: 600; }
        .panel { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; overflow: hidden; }
        .panel-head { padding: 1rem 1.25rem; border-bottom: 1px solid #eef2f7; }
        .table thead th { color: #7b8aa0; font-size: .72rem; letter-spacing: .05em; text-transform: uppercase; white-space: nowrap; }
        .badge-soft { border-radius: 999px; padding: .2rem .55rem; font-size: .72rem; font-weight: 700; }
        .badge-soft-primary { background: #e8f1ff; color: #1d4ed8; }
        .badge-soft-success { background: #e7f7ef; color: #15803d; }
        .badge-soft-danger { background: #fdecec; color: #b91c1c; }
        .badge-soft-warning { background: #fff6e5; color: #b45309; }
        .badge-soft-info { background: #e6f7fa; color: #0e7490; }
        .quick { display: flex; align-items: center; justify-content: space-between; padding: .8rem .9rem; border: 1px solid #e4ebf3; border-radius: .75rem; color: #24433f; text-decoration: none; font-weight: 600; font-size: .88rem; background: #fff; }
        .quick:hover { border-color: #0f766e; color: #0f766e; background: #f7fcfb; }
        .fee-alert { border: 1px solid #f1dfb6; background: #fffcf4; border-radius: .9rem; padding: 1rem 1.1rem; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-3 px-lg-4">
    <section class="hero p-4 p-lg-5 mb-4">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
            <div>
                <div class="small text-white-50 text-uppercase mb-1" style="letter-spacing:.08em;">Clinic control centre</div>
                <h1 class="h3 fw-bold mb-2">Everything in one place</h1>
                <p class="mb-0 text-white-50">Appointments, patients, doctors, fees, website labels and receipts — fully admin-controlled.</p>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-light fw-semibold"><i class="bi bi-calendar-check me-1"></i>Appointments</a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="btn btn-outline-light fw-semibold"><i class="bi bi-sliders me-1"></i>Website settings</a>
            </div>
        </div>
    </section>

    <c:if test="${pendingFeeCount > 0}">
        <div class="fee-alert d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-4">
            <div><i class="bi bi-hourglass-split me-2" style="color:#b45309;"></i><strong>${pendingFeeCount}</strong> doctor fee request(s) waiting for your approval.</div>
            <a href="${pageContext.request.contextPath}/admin/doctor-fees" class="btn btn-sm btn-teal" style="background:#0f766e;color:#fff;border-color:#0f766e;font-weight:700;">Review fees</a>
        </div>
    </c:if>

    <section class="row g-3 mb-4">
        <div class="col-6 col-md-4 col-xl-2">
            <div class="metric"><div class="d-flex justify-content-between align-items-start"><div><div class="lbl">Doctors</div><div class="num">${doctorCount}</div></div><div class="icon" style="background:#eaf7f4;color:#0f766e;"><i class="bi bi-person-badge"></i></div></div></div>
        </div>
        <div class="col-6 col-md-4 col-xl-2">
            <div class="metric"><div class="d-flex justify-content-between align-items-start"><div><div class="lbl">Patients</div><div class="num">${patientCount}</div></div><div class="icon" style="background:#e8f1ff;color:#1d4ed8;"><i class="bi bi-people"></i></div></div></div>
        </div>
        <div class="col-6 col-md-4 col-xl-2">
            <div class="metric"><div class="d-flex justify-content-between align-items-start"><div><div class="lbl">Appointments</div><div class="num">${appointmentCount}</div></div><div class="icon" style="background:#f1ecff;color:#6d28d9;"><i class="bi bi-calendar2-check"></i></div></div></div>
        </div>
        <div class="col-6 col-md-4 col-xl-2">
            <div class="metric"><div class="d-flex justify-content-between align-items-start"><div><div class="lbl">Today</div><div class="num">${todayCount}</div></div><div class="icon" style="background:#e7f7ef;color:#15803d;"><i class="bi bi-sun"></i></div></div></div>
        </div>
        <div class="col-6 col-md-4 col-xl-2">
            <div class="metric"><div class="d-flex justify-content-between align-items-start"><div><div class="lbl">Revenue</div><div class="num">₹<fmt:formatNumber value="${revenue}" minFractionDigits="0" maxFractionDigits="0" /></div></div><div class="icon" style="background:#fff6e5;color:#b45309;"><i class="bi bi-wallet2"></i></div></div></div>
        </div>
        <div class="col-6 col-md-4 col-xl-2">
            <div class="metric"><div class="d-flex justify-content-between align-items-start"><div><div class="lbl">Pending pay</div><div class="num">${pendingPayments}</div></div><div class="icon" style="background:#fdecec;color:#b91c1c;"><i class="bi bi-hourglass"></i></div></div></div>
        </div>
    </section>

    <div class="row g-4">
        <div class="col-xl-8">
            <section class="panel mb-4">
                <div class="panel-head d-flex flex-column flex-sm-row justify-content-between gap-2">
                    <div><h2 class="h6 fw-bold mb-1">Recent appointments</h2><p class="small text-muted mb-0">Latest bookings in the clinic.</p></div>
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-sm btn-outline-success align-self-sm-center">Manage all</a>
                </div>
                <c:choose>
                    <c:when test="${not empty appointments}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead><tr><th class="ps-4">Patient</th><th>Doctor</th><th>Visit</th><th>Date</th><th>Status</th><th class="text-end pe-4">Fee</th></tr></thead>
                                <tbody>
                                <c:forEach var="a" items="${appointments}" varStatus="s">
                                    <c:if test="${s.index < 8}">
                                        <tr>
                                            <td class="ps-4"><div class="fw-semibold"><c:out value="${a.patientName}" /></div><small class="text-muted"><c:out value="${a.email}" /></small></td>
                                            <td class="small"><c:out value="${a.doctorName}" /></td>
                                            <td><div class="small"><c:out value="${a.service}" /></div><span class="badge-soft badge-soft-primary">${a.appointmentType.label}</span></td>
                                            <td class="small text-muted"><c:out value="${a.appointmentDate}" /><br><c:out value="${a.appointmentTime}" /></td>
                                            <td><span class="badge-soft badge-soft-${a.statusBadgeClass}">${a.status.label}</span></td>
                                            <td class="text-end pe-4 fw-semibold">₹<fmt:formatNumber value="${a.amount}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise><div class="text-center text-muted py-5"><i class="bi bi-calendar2-x fs-1 d-block mb-2"></i>No appointments yet.</div></c:otherwise>
                </c:choose>
            </section>
        </div>

        <div class="col-xl-4">
            <section class="panel mb-4">
                <div class="panel-head"><h2 class="h6 fw-bold mb-1">Quick actions</h2><p class="small text-muted mb-0">Full admin control, one click away.</p></div>
                <div class="p-3 d-grid gap-2">
                    <a class="quick" href="${pageContext.request.contextPath}/admin/appointments"><span><i class="bi bi-calendar3 me-2"></i>Appointments</span><i class="bi bi-chevron-right"></i></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/patients"><span><i class="bi bi-people me-2"></i>Patients</span><i class="bi bi-chevron-right"></i></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/doctors"><span><i class="bi bi-person-badge me-2"></i>Doctors</span><i class="bi bi-chevron-right"></i></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/doctor-fees"><span><i class="bi bi-currency-rupee me-2"></i>Doctor fees</span><c:if test="${pendingFeeCount > 0}"><span class="badge bg-warning text-dark">${pendingFeeCount}</span></c:if><c:if test="${pendingFeeCount == 0}"><i class="bi bi-chevron-right"></i></c:if></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/settings"><span><i class="bi bi-sliders me-2"></i>Website &amp; labels</span><i class="bi bi-chevron-right"></i></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/invoices"><span><i class="bi bi-receipt me-2"></i>Invoices &amp; receipts</span><i class="bi bi-chevron-right"></i></a>
                </div>
            </section>

            <section class="panel">
                <div class="panel-head"><h2 class="h6 fw-bold mb-1">Newest patients</h2><p class="small text-muted mb-0">Registered patient accounts.</p></div>
                <div class="p-3">
                    <c:forEach var="p" items="${patients}" varStatus="s">
                        <c:if test="${s.index < 5}">
                            <div class="d-flex align-items-center gap-2 py-2" style="border-bottom:1px dashed #edf2f8;">
                                <div style="width:34px;height:34px;border-radius:50%;background:#eaf7f4;color:#0f766e;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:.8rem;">${p.name.substring(0,1)}</div>
                                <div class="min-w-0"><div class="fw-semibold small text-truncate"><c:out value="${p.name}" /></div><div class="text-muted" style="font-size:.76rem;"><c:out value="${p.email}" /></div></div>
                            </div>
                        </c:if>
                    </c:forEach>
                    <c:if test="${empty patients}"><div class="small text-muted py-2">No patients registered yet.</div></c:if>
                    <a href="${pageContext.request.contextPath}/admin/patients" class="btn btn-sm btn-outline-success w-100 mt-3">Manage patients</a>
                </div>
            </section>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
