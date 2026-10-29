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
        .metric { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; padding: 1rem 1.1rem; height: 100%; transition: transform .16s ease, box-shadow .16s ease, border-color .16s ease; }
        a.metric { display: block; color: inherit; text-decoration: none; }
        a.metric:hover { transform: translateY(-2px); box-shadow: 0 16px 30px -24px rgba(15,31,58,.45); border-color: #0f766e; color: inherit; }
        .metric .icon { width: 40px; height: 40px; border-radius: .75rem; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; flex: 0 0 40px; }
        .metric .num { font-size: 1.45rem; font-weight: 800; line-height: 1.1; color: #10243e; }
        .metric .lbl { color: #52627a; font-size: .76rem; font-weight: 700; }
        .metric .hint { color: #6b7c93; font-size: .7rem; }
        .panel { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; overflow: hidden; }
        .panel-head { padding: 1rem 1.25rem; border-bottom: 1px solid #eef2f7; }
        .table thead th { color: #52627a; font-size: .72rem; letter-spacing: .05em; text-transform: uppercase; white-space: nowrap; }
        .badge-soft { border-radius: 999px; padding: .2rem .55rem; font-size: .72rem; font-weight: 700; }
        .badge-soft-primary { background: #e8f1ff; color: #1d4ed8; }
        .badge-soft-success { background: #e7f7ef; color: #15803d; }
        .badge-soft-danger { background: #fdecec; color: #b91c1c; }
        .badge-soft-warning { background: #fff6e5; color: #92400e; }
        .badge-soft-info { background: #e6f7fa; color: #0e7490; }
        .quick { display: flex; align-items: center; justify-content: space-between; padding: .8rem .9rem; border: 1px solid #e4ebf3; border-radius: .75rem; color: #24433f; text-decoration: none; font-weight: 600; font-size: .88rem; background: #fff; }
        .quick:hover { border-color: #0f766e; color: #0b5d57; background: #f7fcfb; }
        .fee-alert { border: 1px solid #f1dfb6; background: #fffcf4; border-radius: .9rem; padding: 1rem 1.1rem; color: #5c3d00; }
        .msg-item { border-bottom: 1px dashed #edf2f8; padding: .7rem 0; }
        .msg-item:last-child { border-bottom: 0; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: #eaf7f4; color: #0b5d57; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: .8rem; flex: 0 0 34px; }
        .muted { color: #5b6b82; }
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
                <p class="mb-0" style="color:#cdeee8;">Appointments, patients, doctors, fees, public content and branded receipts - fully admin-controlled.</p>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <a href="${pageContext.request.contextPath}/admin/appointments?date=today" class="btn btn-light fw-semibold"><i class="bi bi-calendar-check me-1"></i>Today's schedule</a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="btn btn-outline-light fw-semibold"><i class="bi bi-sliders me-1"></i>Website settings</a>
            </div>
        </div>
    </section>

    <c:if test="${pendingFeeCount > 0}">
        <div class="fee-alert d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-4">
            <div><i class="bi bi-hourglass-split me-2" style="color:#92400e;"></i><strong>${pendingFeeCount}</strong> doctor fee request(s) waiting for your approval. Approved fees go live on booking immediately.</div>
            <a href="${pageContext.request.contextPath}/admin/doctor-fees" class="btn btn-sm text-white" style="background:#0f766e;border-color:#0f766e;font-weight:700;">Review fees</a>
        </div>
    </c:if>

    <c:if test="${unreadMessages > 0}">
        <div class="alert d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-4" style="background:#eef6ff;border:1px solid #cfe2ff;color:#123c69;border-radius:.9rem;">
            <div><i class="bi bi-envelope-exclamation me-2"></i><strong>${unreadMessages}</strong> unread contact message(s) in the inbox.</div>
            <a href="${pageContext.request.contextPath}/admin/messages?view=unread" class="btn btn-sm text-white" style="background:#1d4ed8;border-color:#1d4ed8;font-weight:700;">Open inbox</a>
        </div>
    </c:if>

    <section class="row g-3 mb-4">
        <div class="col-6 col-md-4 col-xl-3">
            <a class="metric" href="${pageContext.request.contextPath}/admin/doctors">
                <div class="d-flex justify-content-between align-items-start">
                    <div><div class="lbl">Doctors</div><div class="num">${doctorCount}</div><div class="hint">Manage team accounts</div></div>
                    <div class="icon" style="background:#eaf7f4;color:#0b5d57;"><i class="bi bi-person-badge"></i></div>
                </div>
            </a>
        </div>
        <div class="col-6 col-md-4 col-xl-3">
            <a class="metric" href="${pageContext.request.contextPath}/admin/patients">
                <div class="d-flex justify-content-between align-items-start">
                    <div><div class="lbl">Patients</div><div class="num">${patientCount}</div><div class="hint">Patient accounts</div></div>
                    <div class="icon" style="background:#e8f1ff;color:#1d4ed8;"><i class="bi bi-people"></i></div>
                </div>
            </a>
        </div>
        <div class="col-6 col-md-4 col-xl-3">
            <a class="metric" href="${pageContext.request.contextPath}/admin/appointments">
                <div class="d-flex justify-content-between align-items-start">
                    <div><div class="lbl">Appointments</div><div class="num">${appointmentCount}</div><div class="hint">All bookings</div></div>
                    <div class="icon" style="background:#f1ecff;color:#6d28d9;"><i class="bi bi-calendar2-check"></i></div>
                </div>
            </a>
        </div>
        <div class="col-6 col-md-4 col-xl-3">
            <a class="metric" href="${pageContext.request.contextPath}/admin/appointments?date=today">
                <div class="d-flex justify-content-between align-items-start">
                    <div><div class="lbl">Today</div><div class="num">${todayCount}</div><div class="hint">Today's schedule</div></div>
                    <div class="icon" style="background:#e7f7ef;color:#15803d;"><i class="bi bi-sun"></i></div>
                </div>
            </a>
        </div>
        <div class="col-6 col-md-4 col-xl-3">
            <a class="metric" href="${pageContext.request.contextPath}/admin/invoices">
                <div class="d-flex justify-content-between align-items-start">
                    <div><div class="lbl">Revenue</div><div class="num">₹<fmt:formatNumber value="${revenue}" minFractionDigits="0" maxFractionDigits="0" /></div><div class="hint">Paid receipts</div></div>
                    <div class="icon" style="background:#fff6e5;color:#92400e;"><i class="bi bi-wallet2"></i></div>
                </div>
            </a>
        </div>
        <div class="col-6 col-md-4 col-xl-3">
            <a class="metric" href="${pageContext.request.contextPath}/admin/appointments?payment=PENDING">
                <div class="d-flex justify-content-between align-items-start">
                    <div><div class="lbl">Pending pay</div><div class="num">${pendingPayments}</div><div class="hint">Collect or follow up</div></div>
                    <div class="icon" style="background:#fdecec;color:#b91c1c;"><i class="bi bi-hourglass"></i></div>
                </div>
            </a>
        </div>
        <div class="col-6 col-md-4 col-xl-3">
            <a class="metric" href="${pageContext.request.contextPath}/admin/doctor-fees">
                <div class="d-flex justify-content-between align-items-start">
                    <div><div class="lbl">Fee approvals</div><div class="num">${pendingFeeCount}</div><div class="hint">Awaiting review</div></div>
                    <div class="icon" style="background:#fff6e5;color:#92400e;"><i class="bi bi-cash-coin"></i></div>
                </div>
            </a>
        </div>
        <div class="col-6 col-md-4 col-xl-3">
            <a class="metric" href="${pageContext.request.contextPath}/admin/messages?view=unread">
                <div class="d-flex justify-content-between align-items-start">
                    <div><div class="lbl">Messages</div><div class="num">${unreadMessages}</div><div class="hint">Unread enquiries</div></div>
                    <div class="icon" style="background:#e6f7fa;color:#0e7490;"><i class="bi bi-envelope"></i></div>
                </div>
            </a>
        </div>
    </section>

    <div class="row g-4">
        <div class="col-xl-8">
            <section class="panel mb-4">
                <div class="panel-head d-flex flex-column flex-sm-row justify-content-between gap-2">
                    <div><h2 class="h6 fw-bold mb-1">Today at the clinic</h2><p class="small muted mb-0">Scheduled visits for <c:out value="${todayCount}" /> patient(s).</p></div>
                    <a href="${pageContext.request.contextPath}/admin/appointments?date=today" class="btn btn-sm btn-outline-success align-self-sm-center">Full schedule</a>
                </div>
                <c:choose>
                    <c:when test="${not empty todayAppointments}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead><tr><th class="ps-4">Patient</th><th>Doctor</th><th>Time</th><th>Visit</th><th>Status</th><th class="text-end pe-4">Fee</th></tr></thead>
                                <tbody>
                                <c:forEach var="a" items="${todayAppointments}">
                                    <tr>
                                        <td class="ps-4"><a class="fw-semibold text-decoration-none" style="color:#0b5d57;" href="${pageContext.request.contextPath}/admin/appointments/edit/${a.id}"><c:out value="${a.patientName}" /></a><small class="d-block muted"><c:out value="${a.phone}" /></small></td>
                                        <td class="small"><c:out value="${a.doctorName}" /></td>
                                        <td class="small fw-semibold"><c:out value="${a.appointmentTime}" /></td>
                                        <td><div class="small"><c:out value="${a.service}" /></div><span class="badge-soft badge-soft-primary">${a.appointmentType.label}</span></td>
                                        <td><span class="badge-soft badge-soft-${a.statusBadgeClass}">${a.status.label}</span></td>
                                        <td class="text-end pe-4 fw-semibold">₹<fmt:formatNumber value="${a.amount}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise><div class="text-center muted py-5"><i class="bi bi-calendar2-x fs-1 d-block mb-2"></i>No visits scheduled for today.</div></c:otherwise>
                </c:choose>
            </section>

            <section class="panel">
                <div class="panel-head d-flex flex-column flex-sm-row justify-content-between gap-2">
                    <div><h2 class="h6 fw-bold mb-1">Recent bookings</h2><p class="small muted mb-0">Latest appointments across all doctors.</p></div>
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-sm btn-outline-success align-self-sm-center">Manage all</a>
                </div>
                <c:choose>
                    <c:when test="${not empty recentAppointments}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead><tr><th class="ps-4">Patient</th><th>Doctor</th><th>Date</th><th>Visit</th><th>Payment</th><th class="text-end pe-4">Fee</th></tr></thead>
                                <tbody>
                                <c:forEach var="a" items="${recentAppointments}">
                                    <tr>
                                        <td class="ps-4"><a class="fw-semibold text-decoration-none" style="color:#0b5d57;" href="${pageContext.request.contextPath}/admin/appointments/edit/${a.id}"><c:out value="${a.patientName}" /></a><small class="d-block muted"><c:out value="${a.paymentReference}" /></small></td>
                                        <td class="small"><c:out value="${a.doctorName}" /></td>
                                        <td class="small muted"><c:out value="${a.appointmentDate}" /><br><c:out value="${a.appointmentTime}" /></td>
                                        <td class="small"><c:out value="${a.service}" /></td>
                                        <td><span class="badge-soft badge-soft-${a.paymentStatus.badgeClass}">${a.paymentStatus.label}</span></td>
                                        <td class="text-end pe-4 fw-semibold">₹<fmt:formatNumber value="${a.amount}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise><div class="text-center muted py-5"><i class="bi bi-calendar2-x fs-1 d-block mb-2"></i>No appointments yet.</div></c:otherwise>
                </c:choose>
            </section>
        </div>

        <div class="col-xl-4">
            <section class="panel mb-4">
                <div class="panel-head"><h2 class="h6 fw-bold mb-1">Quick actions</h2><p class="small muted mb-0">Full admin control, one click away.</p></div>
                <div class="p-3 d-grid gap-2">
                    <a class="quick" href="${pageContext.request.contextPath}/admin/appointments?date=today"><span><i class="bi bi-calendar3 me-2"></i>Today's appointments</span><i class="bi bi-chevron-right"></i></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/appointments?payment=PENDING"><span><i class="bi bi-credit-card me-2"></i>Pending payments</span><i class="bi bi-chevron-right"></i></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/pricing"><span><i class="bi bi-tags me-2"></i>Treatments &amp; prices</span><i class="bi bi-chevron-right"></i></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/doctor-fees"><span><i class="bi bi-currency-rupee me-2"></i>Doctor fees</span><c:if test="${pendingFeeCount > 0}"><span class="badge" style="background:#92400e;color:#fff;">${pendingFeeCount}</span></c:if><c:if test="${pendingFeeCount == 0}"><i class="bi bi-chevron-right"></i></c:if></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/testimonials"><span><i class="bi bi-chat-quote me-2"></i>Testimonials</span><i class="bi bi-chevron-right"></i></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/messages"><span><i class="bi bi-envelope me-2"></i>Contact inbox</span><c:if test="${unreadMessages > 0}"><span class="badge" style="background:#1d4ed8;color:#fff;">${unreadMessages}</span></c:if><c:if test="${unreadMessages == 0}"><i class="bi bi-chevron-right"></i></c:if></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/settings"><span><i class="bi bi-sliders me-2"></i>Website &amp; labels</span><i class="bi bi-chevron-right"></i></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/invoices"><span><i class="bi bi-receipt me-2"></i>Invoices &amp; receipts</span><i class="bi bi-chevron-right"></i></a>
                </div>
            </section>

            <section class="panel mb-4">
                <div class="panel-head d-flex justify-content-between align-items-center">
                    <div><h2 class="h6 fw-bold mb-1">Public content</h2><p class="small muted mb-0">What patients see right now.</p></div>
                    <a href="${pageContext.request.contextPath}/" target="_blank" rel="noopener" class="btn btn-sm btn-outline-success"><i class="bi bi-box-arrow-up-right me-1"></i>View site</a>
                </div>
                <div class="p-3 d-grid gap-2">
                    <a class="quick" href="${pageContext.request.contextPath}/admin/pricing"><span><i class="bi bi-bandaid me-2"></i>Active treatments</span><span class="fw-bold">${activeServiceCount}</span></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/testimonials"><span><i class="bi bi-star me-2"></i>Published testimonials</span><span class="fw-bold">${activeTestimonialCount}</span></a>
                    <a class="quick" href="${pageContext.request.contextPath}/admin/settings"><span><i class="bi bi-pencil-square me-2"></i>Edit page copy</span><i class="bi bi-chevron-right"></i></a>
                </div>
            </section>

            <section class="panel">
                <div class="panel-head d-flex justify-content-between align-items-center">
                    <div><h2 class="h6 fw-bold mb-1">Newest messages</h2><p class="small muted mb-0">Contact form enquiries.</p></div>
                    <a href="${pageContext.request.contextPath}/admin/messages" class="small fw-semibold text-decoration-none" style="color:#0b5d57;">Inbox</a>
                </div>
                <div class="px-3 pb-2">
                    <c:forEach var="m" items="${recentMessages}">
                        <a class="msg-item d-flex gap-2 text-decoration-none" style="color:inherit;" href="${pageContext.request.contextPath}/admin/messages">
                            <div class="avatar"><c:out value="${m.name.substring(0,1)}" /></div>
                            <div class="min-w-0 flex-grow-1">
                                <div class="d-flex justify-content-between gap-2">
                                    <span class="fw-semibold small text-truncate"><c:out value="${m.name}" /></span>
                                    <c:if test="${not m.read}"><span class="badge-soft badge-soft-info">New</span></c:if>
                                </div>
                                <div class="small muted text-truncate"><c:out value="${m.subject}" /></div>
                            </div>
                        </a>
                    </c:forEach>
                    <c:if test="${empty recentMessages}"><div class="small muted py-2">No contact messages yet.</div></c:if>
                </div>
            </section>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
