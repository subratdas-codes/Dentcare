<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>My Appointments - ${site.siteName}</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <style>
        body { background: #f5f8fb; color: #1d2b3f; }
        .dc-stat { border: 1px solid #e7ecf3; border-radius: .9rem; background: #fff; padding: 1rem 1.1rem; height: 100%; }
        .dc-stat .num { font-size: 1.45rem; font-weight: 800; color: #10243e; line-height: 1.1; }
        .dc-stat .lbl { color: #7a8aa0; font-size: .78rem; font-weight: 600; }
        .dc-tabs { border-bottom: 1px solid #e7ecf3; gap: .25rem; }
        .dc-tabs .nav-link { border: 0; border-bottom: 2px solid transparent; color: #64748b; font-weight: 600; padding: .75rem 1rem; border-radius: 0; }
        .dc-tabs .nav-link.active { color: #0f766e; border-bottom-color: #0f766e; background: transparent; }
        .dc-tabs .nav-link:hover { color: #0f766e; }
        .dc-appt { border: 1px solid #e7ecf3; border-radius: 1rem; background: #fff; padding: 1.15rem 1.25rem; }
        .dc-appt + .dc-appt { margin-top: .9rem; }
        .dc-appt .doc-avatar { width: 44px; height: 44px; border-radius: 50%; background: #eef8f6; color: #0f766e; display: flex; align-items: center; justify-content: center; font-weight: 800; }
        .dc-appt .service { color: #64748b; font-size: .86rem; }
        .dc-meta { color: #64748b; font-size: .82rem; }
        .dc-ref { font-family: ui-monospace, SFMono-Regular, Menlo, monospace; font-size: .78rem; color: #64748b; }
        .badge-soft-primary { background: #e8f1ff; color: #1d4ed8; }
        .badge-soft-success { background: #e7f7ef; color: #15803d; }
        .badge-soft-danger { background: #fdecec; color: #b91c1c; }
        .badge-soft-warning { background: #fff6e5; color: #b45309; }
        .badge-soft-info { background: #e6f7fa; color: #0e7490; }
        .dc-empty { border: 1px dashed #d8e2ee; border-radius: 1rem; padding: 3rem 1rem; text-align: center; background: #fff; }
        .dc-action { border-radius: .55rem; font-weight: 600; font-size: .8rem; }
        .dc-account-wrap { position: sticky; top: 110px; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<div class="container py-4 py-lg-5">
    <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-2 mb-4">
        <div>
            <div class="text-uppercase small fw-bold mb-1" style="color:#0f766e;letter-spacing:.07em;">Patient account</div>
            <h1 class="h3 fw-bold mb-1">My appointments</h1>
            <p class="text-muted mb-0">Upcoming visits, treatment history and cancellations in one place.</p>
        </div>
        <a href="${pageContext.request.contextPath}/book_appointment" class="btn text-white fw-semibold" style="background:#0f766e;border-radius:.65rem;">
            <i class="bi bi-calendar-plus me-1"></i><c:out value="${site.bookButton}" />
        </a>
    </div>

    <c:if test="${not empty success}"><div class="alert alert-success border-0 shadow-sm"><c:out value="${success}" /></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger border-0 shadow-sm"><c:out value="${error}" /></div></c:if>

    <div class="row g-4">
        <div class="col-lg-3">
            <div class="dc-account-wrap">
                <c:set var="activeAccount" value="appointments" />
                <%@ include file="_account_sidebar.jsp" %>
            </div>
        </div>
        <div class="col-lg-9">
            <div class="row g-3 mb-4">
                <div class="col-6 col-md-3"><div class="dc-stat"><div class="num">${upcoming.size()}</div><div class="lbl">Upcoming</div></div></div>
                <div class="col-6 col-md-3"><div class="dc-stat"><div class="num">${history.size()}</div><div class="lbl">History</div></div></div>
                <div class="col-6 col-md-3"><div class="dc-stat"><div class="num">${cancelled.size()}</div><div class="lbl">Cancelled</div></div></div>
                <div class="col-6 col-md-3"><div class="dc-stat"><div class="num">₹<fmt:formatNumber value="${totalPaid}" minFractionDigits="0" maxFractionDigits="2" /></div><div class="lbl">Paid online</div></div></div>
            </div>

            <ul class="nav nav-tabs dc-tabs mb-3">
                <li class="nav-item"><a class="nav-link ${selectedView == 'upcoming' ? 'active' : ''}" href="?view=upcoming">Upcoming <span class="text-muted small">(${upcoming.size()})</span></a></li>
                <li class="nav-item"><a class="nav-link ${selectedView == 'history' ? 'active' : ''}" href="?view=history">History <span class="text-muted small">(${history.size()})</span></a></li>
                <li class="nav-item"><a class="nav-link ${selectedView == 'cancelled' ? 'active' : ''}" href="?view=cancelled">Cancelled <span class="text-muted small">(${cancelled.size()})</span></a></li>
            </ul>

            <c:if test="${not empty appointments}">
                <c:forEach var="a" items="${appointments}">
                    <article class="dc-appt">
                        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
                            <div class="d-flex gap-3">
                                <div class="doc-avatar"><c:out value="${a.doctorName.substring(0,1)}" /></div>
                                <div>
                                    <div class="d-flex flex-wrap align-items-center gap-2 mb-1">
                                        <h2 class="h6 fw-bold mb-0"><c:out value="${a.doctorName}" /></h2>
                                        <span class="badge badge-soft-${a.statusBadgeClass}">${a.status.label}</span>
                                        <span class="badge badge-soft-primary">${a.appointmentType.label}</span>
                                    </div>
                                    <div class="service mb-2"><c:out value="${a.service}" /></div>
                                    <div class="d-flex flex-wrap gap-3 dc-meta">
                                        <span><i class="bi bi-calendar3 me-1"></i><c:out value="${a.appointmentDate}" /></span>
                                        <span><i class="bi bi-clock me-1"></i><c:out value="${a.appointmentTime}" /></span>
                                        <span><i class="bi bi-geo-alt me-1"></i>Patia, Bhubaneswar</span>
                                    </div>
                                </div>
                            </div>
                            <div class="text-md-end">
                                <div class="fw-bold fs-5">₹<fmt:formatNumber value="${a.amount}" minFractionDigits="2" maxFractionDigits="2" /></div>
                                <span class="badge badge-soft-${a.paymentStatus.badgeClass}">${a.paymentStatus.label}</span>
                                <c:if test="${not empty a.paymentReference}">
                                    <div class="dc-ref mt-1"><c:out value="${a.paymentReference}" /></div>
                                </c:if>
                            </div>
                        </div>
                        <div class="d-flex flex-wrap gap-2 mt-3 pt-3" style="border-top:1px solid #f0f3f7;">
                            <c:if test="${a.paymentPending and not a.cancelled and not empty a.paymentReference}">
                                <a class="btn btn-sm text-white dc-action" style="background:#0f766e;" href="${pageContext.request.contextPath}/booking/pay/${a.paymentReference}">
                                    <i class="bi bi-wallet2 me-1"></i>Pay now
                                </a>
                            </c:if>
                            <c:if test="${not a.paymentPending and not empty a.paymentReference}">
                                <a class="btn btn-sm btn-outline-dark dc-action" href="${pageContext.request.contextPath}/booking/confirmation/${a.paymentReference}">
                                    <i class="bi bi-receipt me-1"></i>View receipt
                                </a>
                            </c:if>
                            <c:if test="${not a.cancelled}">
                                <a class="btn btn-sm btn-outline-secondary dc-action" href="${pageContext.request.contextPath}/my/appointments/${a.id}/chat">
                                    <i class="bi bi-chat-dots me-1"></i>Message doctor
                                </a>
                            </c:if>
                            <c:if test="${a.upcoming}">
                                <form action="${pageContext.request.contextPath}/my/appointments/cancel/${a.id}" method="post" class="d-inline"
                                      onsubmit="return confirm('Cancel this appointment? It will move to your cancelled list.');">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="btn btn-sm btn-outline-danger dc-action"><i class="bi bi-x-circle me-1"></i>Cancel</button>
                                </form>
                            </c:if>
                            <c:if test="${a.cancelled}">
                                <a class="btn btn-sm btn-outline-secondary dc-action" href="${pageContext.request.contextPath}/book_appointment">
                                    <i class="bi bi-arrow-repeat me-1"></i>Book again
                                </a>
                            </c:if>
                        </div>
                    </article>
                </c:forEach>
            </c:if>

            <c:if test="${empty appointments}">
                <div class="dc-empty">
                    <i class="bi bi-calendar2-x fs-1" style="color:#94a3b8;"></i>
                    <h2 class="h6 fw-bold mt-3">
                        <c:choose>
                            <c:when test="${selectedView == 'history'}">No past visits yet</c:when>
                            <c:when test="${selectedView == 'cancelled'}">No cancelled appointments</c:when>
                            <c:otherwise>No upcoming appointments</c:otherwise>
                        </c:choose>
                    </h2>
                    <p class="text-muted mb-3">
                        <c:choose>
                            <c:when test="${selectedView == 'history'}">Completed visits will appear here after your appointment date.</c:when>
                            <c:when test="${selectedView == 'cancelled'}">Appointments you cancel are kept here for your records.</c:when>
                            <c:otherwise>Book a consultation or treatment whenever you are ready.</c:otherwise>
                        </c:choose>
                    </p>
                    <a href="${pageContext.request.contextPath}/book_appointment" class="btn text-white fw-semibold" style="background:#0f766e;border-radius:.6rem;">Book a visit</a>
                </div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="_user_footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
