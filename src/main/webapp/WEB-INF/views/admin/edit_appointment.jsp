<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="activePage" value="appointments" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Appointment - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .panel { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; }
        .panel-head { padding: 1rem 1.25rem; border-bottom: 1px solid #eef2f7; }
        .form-label { font-weight: 600; color: #3c4c63; font-size: .86rem; }
        .form-control, .form-select { border-color: #dde5ee; border-radius: .65rem; padding: .6rem .8rem; }
        .form-control:focus, .form-select:focus { border-color: #0f766e; box-shadow: 0 0 0 .18rem rgba(15,118,110,.12); }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .note { background: #f4faf8; border: 1px solid #d9ede9; border-radius: .75rem; padding: .85rem 1rem; color: #315b56; font-size: .84rem; }
        .badge-soft { border-radius: 999px; padding: .2rem .55rem; font-size: .72rem; font-weight: 700; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-3 px-lg-4">
    <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-2 mb-4">
        <div>
            <h1 class="h4 fw-bold mb-1">Edit appointment #${appointment.id}</h1>
            <p class="text-muted mb-0">Update the visit, fee, doctor or status. Existing payment details are preserved.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-outline-secondary"><i class="bi bi-arrow-left me-1"></i>Back to appointments</a>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}" /></div></c:if>

    <div class="row g-4">
        <div class="col-lg-8">
            <section class="panel">
                <div class="panel-head"><h2 class="h6 fw-bold mb-0">Appointment details</h2></div>
                <div class="p-4">
                    <form action="${pageContext.request.contextPath}/admin/appointments/update" method="post" class="row g-3">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="id" value="${appointment.id}" />

                        <div class="col-md-6">
                            <label class="form-label" for="patientName">Patient name</label>
                            <input id="patientName" name="patientName" class="form-control" value="<c:out value='${appointment.patientName}' />" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="email">Patient email</label>
                            <input id="email" name="email" type="email" class="form-control" value="<c:out value='${appointment.email}' />" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="phone">Phone</label>
                            <input id="phone" name="phone" class="form-control" value="<c:out value='${appointment.phone}' />" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="doctorId">Doctor</label>
                            <select id="doctorId" name="doctorId" class="form-select" required>
                                <option value="">Choose a doctor</option>
                                <c:forEach var="doc" items="${doctors}">
                                    <option value="${doc.id}" ${appointment.doctorId == doc.id ? 'selected' : ''}><c:out value="${doc.name}" /> · <c:out value="${doc.specialization}" /></option>
                                </c:forEach>
                            </select>
                            <div class="form-text">Current: <c:out value="${appointment.doctorName}" /></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="appointmentType">Visit type</label>
                            <select id="appointmentType" name="appointmentType" class="form-select">
                                <option value="CONSULTATION" ${appointment.consultation ? 'selected' : ''}>Consultation</option>
                                <option value="TREATMENT" ${appointment.consultation ? '' : 'selected'}>Specific treatment</option>
                            </select>
                        </div>
                        <div class="col-md-6" id="serviceWrap">
                            <label class="form-label" for="service">Treatment</label>
                            <select id="service" name="service" class="form-select">
                                <option value="General Consultation">General Consultation</option>
                                <c:forEach var="sp" items="${servicePrices}">
                                    <option value="${sp.serviceName}" ${appointment.service == sp.serviceName ? 'selected' : ''}><c:out value="${sp.serviceName}" /> · ₹<fmt:formatNumber value="${sp.fee}" minFractionDigits="0" maxFractionDigits="2" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="appointmentDate">Date</label>
                            <input id="appointmentDate" name="appointmentDate" type="date" class="form-control" value="${appointment.appointmentDate}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="appointmentTime">Time</label>
                            <input id="appointmentTime" name="appointmentTime" type="time" class="form-control" value="${appointment.appointmentTime}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="amount">Fee (₹)</label>
                            <input id="amount" name="amount" type="number" min="0" max="1000000" step="0.01" class="form-control" value="${appointment.amount}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="status">Status</label>
                            <select id="status" name="status" class="form-select">
                                <option value="BOOKED" ${appointment.status == 'BOOKED' ? 'selected' : ''}>Booked</option>
                                <option value="COMPLETED" ${appointment.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                <option value="CANCELLED" ${appointment.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <div class="note"><i class="bi bi-info-circle me-1"></i>Changing the visit type to Consultation sets the service to “General Consultation”. The fee is not recalculated automatically — enter the agreed amount above.</div>
                        </div>
                        <div class="col-12 d-flex flex-column flex-sm-row justify-content-between gap-2 mt-2">
                            <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-light border">Cancel</a>
                            <button type="submit" class="btn btn-teal px-4"><i class="bi bi-check2-circle me-1"></i>Save appointment</button>
                        </div>
                    </form>
                </div>
            </section>
        </div>

        <div class="col-lg-4">
            <section class="panel mb-4">
                <div class="panel-head"><h2 class="h6 fw-bold mb-0">Payment record</h2></div>
                <div class="p-3 p-sm-4">
                    <div class="d-flex justify-content-between py-2" style="border-bottom:1px dashed #edf2f8;"><span class="text-muted small">Status</span><span class="badge-soft" style="background:#eef4fb;color:#334e68;">${appointment.paymentStatus.label}</span></div>
                    <div class="d-flex justify-content-between py-2" style="border-bottom:1px dashed #edf2f8;"><span class="text-muted small">Method</span><span class="small fw-semibold"><c:choose><c:when test="${not empty appointment.paymentMethod}">${appointment.paymentMethod.label}</c:when><c:otherwise>—</c:otherwise></c:choose></span></div>
                    <div class="d-flex justify-content-between py-2" style="border-bottom:1px dashed #edf2f8;"><span class="text-muted small">Detail</span><span class="small text-end"><c:out value="${appointment.paymentDetail}" /></span></div>
                    <div class="d-flex justify-content-between py-2" style="border-bottom:1px dashed #edf2f8;"><span class="text-muted small">Reference</span><span class="small font-monospace"><c:out value="${appointment.paymentReference}" /></span></div>
                    <div class="d-flex justify-content-between py-2"><span class="text-muted small">Paid on</span><span class="small"><c:out value="${appointment.paidAtDisplay}" /></span></div>
                    <c:if test="${not empty appointment.paymentReference}">
                        <a href="${pageContext.request.contextPath}/booking/receipt/${appointment.paymentReference}/download" class="btn btn-outline-secondary btn-sm w-100 mt-2"><i class="bi bi-download me-1"></i>Download receipt</a>
                        <a href="${pageContext.request.contextPath}/booking/confirmation/${appointment.paymentReference}" target="_blank" rel="noopener" class="btn btn-outline-secondary btn-sm w-100 mt-2"><i class="bi bi-box-arrow-up-right me-1"></i>Open printable receipt</a>
                    </c:if>
                </div>
            </section>
            <div class="note"><i class="bi bi-shield-lock me-1"></i>The patient's own account shows this appointment and its receipt automatically. Only this clinic admin can change these details.</div>
        </div>
    </div>
</div>

<script>
(function () {
    var type = document.getElementById('appointmentType');
    var wrap = document.getElementById('serviceWrap');
    function toggle() {
        var isConsult = type.value === 'CONSULTATION';
        wrap.style.display = isConsult ? 'none' : '';
    }
    type.addEventListener('change', toggle);
    toggle();
})();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
