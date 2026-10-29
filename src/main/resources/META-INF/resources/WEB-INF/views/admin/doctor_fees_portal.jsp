<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="activePage" value="fees" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Fees - DentCare Doctor</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f3f8f7; color: #17312e; }
        .hero { background: linear-gradient(120deg, #0b3b37 0%, #0f766e 65%, #159a8e 100%); color: #fff; border-radius: 1.2rem; position: relative; overflow: hidden; }
        .hero:after { content: ""; position: absolute; width: 260px; height: 260px; border-radius: 50%; background: rgba(255,255,255,.08); right: -60px; top: -90px; }
        .panel { border: 1px solid #dcebe8; border-radius: 1rem; background: #fff; }
        .panel-head { padding: 1rem 1.25rem; border-bottom: 1px solid #edf4f2; }
        .fee-tile { border: 1px solid #e1eeeb; border-radius: .9rem; padding: .95rem 1rem; background: #fff; height: 100%; }
        .fee-tile .amount { font-size: 1.3rem; font-weight: 800; color: #0f766e; }
        .fee-tile .name { font-weight: 700; font-size: .92rem; }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .form-control, .form-select { border-color: #d6e5e2; border-radius: .6rem; padding: .55rem .7rem; }
        .form-control:focus, .form-select:focus { border-color: #0f766e; box-shadow: 0 0 0 .17rem rgba(15,118,110,.13); }
        .pending-pill { background: #fff6e5; color: #9a6400; border-radius: 999px; padding: .18rem .5rem; font-size: .7rem; font-weight: 700; }
        .approved-pill { background: #e7f7ef; color: #15803d; border-radius: 999px; padding: .18rem .5rem; font-size: .7rem; font-weight: 700; }
        .rejected-pill { background: #fdecec; color: #b91c1c; border-radius: 999px; padding: .18rem .5rem; font-size: .7rem; font-weight: 700; }
        .note { background: #eef8f6; border: 1px solid #d5eae6; color: #315b56; border-radius: .75rem; padding: .8rem 1rem; font-size: .84rem; }
        .step-dot { width: 26px; height: 26px; border-radius: 50%; background: #eaf7f4; color: #0f766e; display: inline-flex; align-items: center; justify-content: center; font-size: .78rem; font-weight: 800; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<main class="container-fluid px-3 px-lg-4 py-4">
    <section class="hero p-4 p-lg-5 mb-4">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3 position-relative" style="z-index:1;">
            <div>
                <div class="small text-white-50 mb-1 text-uppercase" style="letter-spacing:.08em;">Doctor portal · pricing</div>
                <h1 class="h3 fw-bold mb-2">My consultation &amp; treatment fees</h1>
                <p class="mb-0 text-white-50" style="max-width:680px;">Request a fee for a service. Your current approved fee stays active until the clinic admin approves the new amount.</p>
            </div>
            <a href="${pageContext.request.contextPath}/doctor/dashboard" class="btn btn-light fw-semibold"><i class="bi bi-speedometer2 me-1"></i>Dashboard</a>
        </div>
    </section>

    <c:if test="${not empty success}"><div class="alert alert-success shadow-sm"><i class="bi bi-check-circle me-2"></i><c:out value="${success}" /></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger shadow-sm"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${error}" /></div></c:if>

    <div class="row g-4">
        <div class="col-lg-8">
            <section class="panel mb-4">
                <div class="panel-head d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="h6 fw-bold mb-1">My approved fees</h2>
                        <p class="small text-muted mb-0">These amounts are used on the patient booking page.</p>
                    </div>
                    <span class="badge bg-light text-dark border">${fees.size()} custom fee(s)</span>
                </div>
                <div class="p-3 p-sm-4">
                    <div class="row g-3 mb-1">
                        <div class="col-sm-6">
                            <div class="fee-tile">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="name">Consultation</div>
                                    <span class="approved-pill">Standard default</span>
                                </div>
                                <div class="amount mt-2">₹<fmt:formatNumber value="${consultationFee}" minFractionDigits="0" maxFractionDigits="2" /></div>
                                <div class="small text-muted">Applies only if you have no approved consultation override.</div>
                            </div>
                        </div>
                        <c:forEach var="fee" items="${fees}">
                            <div class="col-sm-6">
                                <div class="fee-tile">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="name"><c:out value="${fee.label}" /></div>
                                        <c:choose>
                                            <c:when test="${fee.pending}"><span class="pending-pill">Pending</span></c:when>
                                            <c:when test="${fee.status == 'REJECTED'}"><span class="rejected-pill">Rejected</span></c:when>
                                            <c:otherwise><span class="approved-pill">Approved</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="amount mt-2">
                                        <c:choose>
                                            <c:when test="${not empty fee.displayFee}">₹<fmt:formatNumber value="${fee.displayFee}" minFractionDigits="2" maxFractionDigits="2" /></c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="small text-muted">
                                        <c:choose>
                                            <c:when test="${fee.pending and not empty fee.requestedFee}">
                                                Requested ₹<fmt:formatNumber value="${fee.requestedFee}" minFractionDigits="2" maxFractionDigits="2" />
                                                <c:if test="${not empty fee.fee}"> · active ₹<fmt:formatNumber value="${fee.fee}" minFractionDigits="2" maxFractionDigits="2" /></c:if>
                                            </c:when>
                                            <c:otherwise>Approved by the admin</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <c:if test="${empty fees}">
                        <div class="note mt-3"><i class="bi bi-info-circle me-1"></i>You have no custom fees yet. The standard clinic prices apply to your bookings.</div>
                    </c:if>
                </div>
            </section>
        </div>

        <div class="col-lg-4">
            <section class="panel mb-4">
                <div class="panel-head">
                    <h2 class="h6 fw-bold mb-1">Request a new fee</h2>
                    <p class="small text-muted mb-0">The admin reviews every request.</p>
                </div>
                <div class="p-3 p-sm-4">
                    <form action="${pageContext.request.contextPath}/doctor/fees" method="post" class="row g-3">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="col-12">
                            <label class="form-label small fw-semibold" for="serviceName">Service</label>
                            <select id="serviceName" name="serviceName" class="form-select" required>
                                <option value="CONSULTATION">Consultation</option>
                                <c:forEach var="sp" items="${servicePrices}">
                                    <option value="${sp.serviceName}"><c:out value="${sp.serviceName}" /> · standard ₹<fmt:formatNumber value="${sp.fee}" minFractionDigits="0" maxFractionDigits="2" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold" for="fee">Your proposed fee (₹)</label>
                            <div class="input-group">
                                <span class="input-group-text">₹</span>
                                <input id="fee" name="fee" type="number" class="form-control" min="0" max="1000000" step="0.01" required placeholder="0.00">
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="note mb-0">
                                <div class="d-flex gap-2 mb-1"><span class="step-dot">1</span><span>Send the request.</span></div>
                                <div class="d-flex gap-2 mb-1"><span class="step-dot">2</span><span>Admin approves or rejects it.</span></div>
                                <div class="d-flex gap-2"><span class="step-dot">3</span><span>Approved fee goes live for new bookings.</span></div>
                            </div>
                        </div>
                        <div class="col-12"><button class="btn btn-teal w-100" type="submit"><i class="bi bi-send me-1"></i>Send for approval</button></div>
                    </form>
                </div>
            </section>
            <div class="small text-muted px-1"><i class="bi bi-shield-lock me-1"></i>You can only request fees. Only the clinic admin can approve them.</div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
