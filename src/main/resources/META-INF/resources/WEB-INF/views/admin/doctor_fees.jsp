<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="activePage" value="doctorFees" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Fees - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .page-head { background: #0f766e; color: #fff; border-radius: 1.1rem; }
        .soft-card { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; overflow: hidden; }
        .soft-card .card-head { padding: 1rem 1.25rem; border-bottom: 1px solid #eef2f7; }
        .fee-row { display: flex; justify-content: space-between; align-items: center; gap: .75rem; padding: .65rem 0; border-bottom: 1px dashed #e9eef5; font-size: .88rem; }
        .fee-row:last-child { border-bottom: 0; }
        .fee-badge { font-weight: 700; color: #0f766e; background: #eaf7f4; border-radius: 999px; padding: .2rem .55rem; font-size: .78rem; }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .form-control, .form-select { border-color: #dde5ee; border-radius: .6rem; padding: .5rem .65rem; font-size: .88rem; }
        .form-control:focus, .form-select:focus { border-color: #0f766e; box-shadow: 0 0 0 .17rem rgba(15,118,110,.12); }
        .doctor-avatar { width: 42px; height: 42px; border-radius: 50%; background: #eaf7f4; color: #0f766e; display: flex; align-items: center; justify-content: center; font-weight: 800; }
        .pending-card { border: 1px solid #f1dfb6; background: #fffcf4; border-radius: .9rem; padding: 1rem 1.1rem; }
        .stat-pill { border: 1px solid #e4ebf3; background: #fff; border-radius: .85rem; padding: .8rem 1rem; }
        .stat-pill .num { font-size: 1.35rem; font-weight: 800; line-height: 1; }
        .stat-pill .lbl { color: #52627a; font-size: .76rem; font-weight: 600; }
        .table-sm td, .table-sm th { font-size: .84rem; }
        .sticky-fee { position: sticky; top: 96px; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-3 px-lg-4">
    <section class="page-head p-4 p-lg-5 mb-4">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
            <div>
                <div class="small text-white-50 mb-1">APPROVAL WORKFLOW</div>
                <h1 class="h3 fw-bold mb-2">Doctor-specific fees</h1>
                <p class="mb-0 text-white-50">Set fees directly, or approve what doctors request. A doctor's old approved fee stays live while a new request waits for you.</p>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <a href="${pageContext.request.contextPath}/admin/settings" class="btn btn-light fw-semibold"><i class="bi bi-sliders me-1"></i>Website settings</a>
                <a href="${pageContext.request.contextPath}/admin/pricing" class="btn btn-outline-light fw-semibold"><i class="bi bi-tags me-1"></i>Standard treatment fees</a>
            </div>
        </div>
    </section>

    <c:if test="${not empty success}"><div class="alert alert-success shadow-sm"><i class="bi bi-check-circle me-2"></i><c:out value="${success}" /></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger shadow-sm"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${error}" /></div></c:if>

    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3"><div class="stat-pill"><div class="num" style="color:#92400e;">${pendingFees.size()}</div><div class="lbl">Awaiting approval</div></div></div>
        <div class="col-6 col-md-3"><div class="stat-pill"><div class="num">${doctors.size()}</div><div class="lbl">Doctors</div></div></div>
        <div class="col-6 col-md-3"><div class="stat-pill"><div class="num" style="color:#0f766e;">₹<fmt:formatNumber value="${consultationFee}" minFractionDigits="0" maxFractionDigits="2" /></div><div class="lbl">Standard consultation</div></div></div>
        <div class="col-6 col-md-3"><div class="stat-pill"><div class="num" style="color:#0f766e;">${servicePrices.size()}</div><div class="lbl">Standard treatments</div></div></div>
    </div>

    <c:if test="${not empty pendingFees}">
        <section class="mb-4">
            <div class="d-flex align-items-center gap-2 mb-2">
                <h2 class="h6 fw-bold mb-0">Pending requests</h2>
                <span class="badge" style="background:#fdf0d5;color:#9a6400;">${pendingFees.size()}</span>
            </div>
            <div class="row g-3">
                <c:forEach var="fee" items="${pendingFees}">
                    <div class="col-lg-6">
                        <div class="pending-card h-100">
                            <div class="d-flex justify-content-between gap-2 mb-2">
                                <div>
                                    <div class="fw-bold"><c:out value="${fee.doctor.name}" /></div>
                                    <div class="small text-muted"><c:out value="${fee.doctor.specialization}" /> · <c:out value="${fee.label}" /></div>
                                </div>
                                <span class="badge bg-warning text-dark align-self-start">Pending</span>
                            </div>
                            <div class="d-flex align-items-center gap-3 my-3">
                                <div>
                                    <div class="small text-muted">Current approved</div>
                                    <div class="fw-semibold">
                                        <c:choose>
                                            <c:when test="${not empty fee.fee}">₹<fmt:formatNumber value="${fee.fee}" minFractionDigits="2" maxFractionDigits="2" /></c:when>
                                            <c:otherwise>Standard price</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <i class="bi bi-arrow-right text-muted"></i>
                                <div>
                                    <div class="small text-muted">Requested</div>
                                    <div class="fw-bold" style="color:#0f766e;">₹<fmt:formatNumber value="${fee.requestedFee}" minFractionDigits="2" maxFractionDigits="2" /></div>
                                </div>
                            </div>
                            <div class="d-flex gap-2">
                                <form action="${pageContext.request.contextPath}/admin/doctor-fees/approve" method="post" class="flex-fill">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <input type="hidden" name="id" value="${fee.id}" />
                                    <button class="btn btn-teal btn-sm w-100"><i class="bi bi-check2 me-1"></i>Approve</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin/doctor-fees/reject" method="post" class="flex-fill">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <input type="hidden" name="id" value="${fee.id}" />
                                    <button class="btn btn-outline-secondary btn-sm w-100"><i class="bi bi-x me-1"></i>Reject</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </c:if>

    <div class="row g-4">
        <div class="col-lg-8">
            <c:forEach var="doctor" items="${doctors}">
                <c:set var="doctorFees" value="${feesByDoctor[doctor.id]}" />
                <section class="soft-card mb-4">
                    <div class="card-head d-flex flex-column flex-sm-row justify-content-between gap-2">
                        <div class="d-flex align-items-center gap-3">
                            <div class="doctor-avatar">${doctor.name.substring(0,1)}</div>
                            <div>
                                <div class="fw-bold"><c:out value="${doctor.name}" /></div>
                                <div class="small text-muted"><c:out value="${doctor.specialization}" /> · <c:out value="${doctor.email}" /></div>
                            </div>
                        </div>
                        <span class="badge bg-light text-dark border align-self-sm-center">${doctorFees.size()} custom fee(s)</span>
                    </div>
                    <div class="p-3 p-sm-4">
                        <c:choose>
                            <c:when test="${not empty doctorFees}">
                                <div class="mb-3">
                                    <c:forEach var="fee" items="${doctorFees}">
                                        <div class="fee-row">
                                            <div>
                                                <div class="fw-semibold"><c:out value="${fee.label}" /></div>
                                                <div class="small text-muted">
                                                    <span class="badge bg-${fee.status.badgeClass} bg-opacity-10 text-${fee.status.badgeClass}">${fee.status.label}</span>
                                                    <c:if test="${fee.pending and not empty fee.requestedFee}">
                                                        · requested ₹<fmt:formatNumber value="${fee.requestedFee}" minFractionDigits="2" maxFractionDigits="2" />
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="fee-badge">
                                                    <c:choose>
                                                        <c:when test="${not empty fee.displayFee}">₹<fmt:formatNumber value="${fee.displayFee}" minFractionDigits="2" maxFractionDigits="2" /></c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <form action="${pageContext.request.contextPath}/admin/doctor-fees/delete" method="post" onsubmit="return confirm('Remove this override? The standard price will apply again.');">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                    <input type="hidden" name="id" value="${fee.id}" />
                                                    <button class="btn btn-sm btn-outline-danger" title="Remove override"><i class="bi bi-trash"></i></button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise><p class="text-muted small mb-3">No custom fees yet. This doctor uses the standard consultation and treatment fees.</p></c:otherwise>
                        </c:choose>

                        <form action="${pageContext.request.contextPath}/admin/doctor-fees/set" method="post" class="row g-2 align-items-end">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <input type="hidden" name="doctorId" value="${doctor.id}" />
                            <div class="col-sm-6">
                                <label class="form-label small fw-semibold mb-1">Service</label>
                                <select name="serviceName" class="form-select" required>
                                    <option value="CONSULTATION">Consultation</option>
                                    <c:forEach var="sp" items="${servicePrices}">
                                        <option value="${sp.serviceName}"><c:out value="${sp.serviceName}" /></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-sm-4">
                                <label class="form-label small fw-semibold mb-1">Approved fee (₹)</label>
                                <input type="number" name="fee" class="form-control" min="0" max="1000000" step="0.01" required placeholder="0.00">
                            </div>
                            <div class="col-sm-2">
                                <button class="btn btn-teal w-100" type="submit"><i class="bi bi-plus-lg"></i> Set</button>
                            </div>
                        </form>
                    </div>
                </section>
            </c:forEach>

            <c:if test="${empty doctors}">
                <div class="soft-card p-5 text-center text-muted">
                    <i class="bi bi-person-badge fs-1 d-block mb-3"></i>
                    No doctors yet. <a href="${pageContext.request.contextPath}/admin/doctors/add">Add a doctor</a> first.
                </div>
            </c:if>
        </div>

        <div class="col-lg-4">
            <div class="sticky-fee">
                <div class="soft-card mb-4">
                    <div class="card-head"><h2 class="h6 fw-bold mb-1">How pricing resolves</h2><p class="text-muted small mb-0">The patient always sees one clear amount.</p></div>
                    <div class="p-3 p-sm-4">
                        <ol class="small text-muted ps-3 mb-3">
                            <li class="mb-2">Consultation uses the doctor's approved consultation fee.</li>
                            <li class="mb-2">If the doctor has no override, the standard consultation fee (₹<fmt:formatNumber value="${consultationFee}" minFractionDigits="0" maxFractionDigits="2" />) applies.</li>
                            <li class="mb-2">Treatments use the doctor's approved treatment fee, else the standard treatment price.</li>
                            <li>While a request is pending, the last approved amount remains live.</li>
                        </ol>
                        <div class="small text-muted"><i class="bi bi-shield-check me-1"></i>Only admins can approve or set fees directly.</div>
                    </div>
                </div>
                <div class="soft-card">
                    <div class="card-head"><h2 class="h6 fw-bold mb-1">Quick set</h2><p class="text-muted small mb-0">Choose a doctor and service.</p></div>
                    <div class="p-3 p-sm-4">
                        <form action="${pageContext.request.contextPath}/admin/doctor-fees/set" method="post" class="row g-2">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <div class="col-12">
                                <label class="form-label small fw-semibold mb-1">Doctor</label>
                                <select name="doctorId" class="form-select" required>
                                    <c:forEach var="doctor" items="${doctors}">
                                        <option value="${doctor.id}"><c:out value="${doctor.name}" /></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-semibold mb-1">Service</label>
                                <select name="serviceName" class="form-select" required>
                                    <option value="CONSULTATION">Consultation</option>
                                    <c:forEach var="sp" items="${servicePrices}">
                                        <option value="${sp.serviceName}"><c:out value="${sp.serviceName}" /></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-semibold mb-1">Fee (₹)</label>
                                <input type="number" name="fee" class="form-control" min="0" max="1000000" step="0.01" required>
                            </div>
                            <div class="col-12"><button class="btn btn-teal w-100" type="submit">Save approved fee</button></div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
