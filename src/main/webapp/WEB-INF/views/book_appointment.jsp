<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Book a Visit - ${site.siteName}</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <style>
        body { background: #f5f8fb; color: #1d2b3f; }
        .dc-page-head { background: #0b172a; color: #fff; padding: 2.4rem 0 2rem; }
        .dc-page-head .eyebrow { color: #a8eadf; text-transform: uppercase; letter-spacing: .08em; font-size: .75rem; font-weight: 700; }
        .dc-card { background: #fff; border: 1px solid #e7ecf3; border-radius: 1rem; }
        .dc-step { font-size: .72rem; text-transform: uppercase; letter-spacing: .07em; color: #52627a; font-weight: 700; margin-bottom: .6rem; }
        .dc-type-grid { display: grid; grid-template-columns: repeat(2, minmax(0,1fr)); gap: .75rem; }
        .dc-type { border: 2px solid #e7ecf3; border-radius: .8rem; padding: .9rem 1rem; cursor: pointer; background: #fff; transition: border-color .12s ease, background .12s ease; }
        .dc-type input { position: absolute; opacity: 0; pointer-events: none; }
        .dc-type .title { font-weight: 700; color: #1d2b3f; display: flex; align-items: center; gap: .5rem; }
        .dc-type .sub { color: #5b6b82; font-size: .82rem; margin-top: .2rem; }
        .dc-type.active { border-color: #0f766e; background: #f3faf8; }
        .dc-doctor-grid { display: grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: .75rem; }
        @media (max-width: 767.98px) { .dc-doctor-grid { grid-template-columns: 1fr; } .dc-type-grid { grid-template-columns: 1fr; } }
        .dc-doctor { border: 2px solid #e7ecf3; border-radius: .85rem; padding: .9rem; cursor: pointer; background: #fff; transition: border-color .12s ease, background .12s ease; position: relative; }
        .dc-doctor input { position: absolute; opacity: 0; pointer-events: none; }
        .dc-doctor .avatar { width: 42px; height: 42px; border-radius: 50%; background: #eef8f6; color: #0b5d57; font-weight: 800; display: flex; align-items: center; justify-content: center; }
        .dc-doctor .name { font-weight: 700; color: #1d2b3f; font-size: .92rem; }
        .dc-doctor .spec { color: #5b6b82; font-size: .78rem; }
        .dc-doctor .fee { color: #0b5d57; font-weight: 700; font-size: .82rem; }
        .dc-doctor.active { border-color: #0f766e; background: #f3faf8; }
        .dc-label { font-weight: 600; color: #34445c; font-size: .9rem; }
        .form-control, .form-select { border-color: #dfe6ef; border-radius: .65rem; padding: .65rem .8rem; }
        .form-control:focus, .form-select:focus { border-color: #0f766e; box-shadow: 0 0 0 .18rem rgba(15,118,110,.12); }
        .dc-summary { position: sticky; top: 110px; border-radius: 1rem; overflow: hidden; border: 1px solid #e7ecf3; background: #fff; }
        .dc-summary-head { background: #0f766e; color: #fff; padding: 1.1rem 1.25rem; }
        .dc-summary-row { display: flex; justify-content: space-between; gap: 1rem; padding: .55rem 0; border-bottom: 1px dashed #e7ecf3; font-size: .9rem; }
        .dc-summary-row:last-child { border-bottom: 0; }
        .dc-fee-total { font-size: 1.8rem; font-weight: 800; color: #0b5d57; }
        .dc-pill { background: #eef8f6; color: #0b5d57; border-radius: 999px; padding: .28rem .65rem; font-size: .75rem; font-weight: 700; }
        .dc-submit { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; border-radius: .7rem; padding: .85rem 1rem; }
        .dc-submit:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .dc-help { color: #5b6b82; font-size: .8rem; }
        .dc-live { display: inline-flex; align-items: center; gap: .35rem; color: #0b5d57; background: #e7f7ef; border: 1px solid #c6e9d8; border-radius: 999px; padding: .2rem .6rem; font-size: .72rem; font-weight: 700; }
        .dc-live .dot { width: 7px; height: 7px; border-radius: 50%; background: #15803d; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<header class="dc-page-head">
    <div class="container">
        <div class="eyebrow mb-2">Step 1 of 3 · Appointment</div>
        <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
            <h1 class="h2 fw-bold mb-0">Book a visit with the right dentist</h1>
            <span class="dc-live"><span class="dot"></span>Live fees</span>
        </div>
        <p class="mb-0" style="color:#d8e5f2;max-width:680px;"><c:out value="${site.bookingNote}" /></p>
    </div>
</header>

<div class="container py-4 py-lg-5">
    <div id="feeNotice" class="alert border-0 shadow-sm d-none" style="background:#eef8f6;color:#0b4f49;">
        <i class="bi bi-arrow-repeat me-2"></i><span id="feeNoticeText">Fees were updated by the clinic. Your total has been refreshed.</span>
    </div>
    <c:if test="${not empty error}">
        <div class="alert alert-danger border-0 shadow-sm"><c:out value="${error}" /></div>
    </c:if>
    <c:if test="${param.error == 'notfound'}">
        <div class="alert alert-danger border-0 shadow-sm">That booking could not be found. Please book again.</div>
    </c:if>

    <div class="row g-4">
        <div class="col-lg-8">
            <form action="${pageContext.request.contextPath}/book" method="post" id="bookingForm" class="dc-card p-4 p-lg-5">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <div class="dc-step">1 · What do you need?</div>
                <div class="dc-type-grid mb-4">
                    <label class="dc-type active">
                        <input type="radio" name="appointmentType" value="CONSULTATION" checked>
                        <div class="title"><i class="bi bi-chat-square-text"></i>Consultation</div>
                        <div class="sub">Talk to a dentist first. Fee from ₹<fmt:formatNumber value="${consultationFee}" minFractionDigits="0" maxFractionDigits="0" />.</div>
                    </label>
                    <label class="dc-type">
                        <input type="radio" name="appointmentType" value="TREATMENT">
                        <div class="title"><i class="bi bi-clipboard2-pulse"></i>Specific treatment</div>
                        <div class="sub">Choose a treatment and see its exact fee.</div>
                    </label>
                </div>

                <div class="dc-step">2 · Choose your doctor</div>
                <div class="dc-doctor-grid mb-4" id="doctorGrid">
                    <c:forEach var="doc" items="${doctors}">
                        <label class="dc-doctor">
                            <input type="radio" name="doctorId" value="${doc.id}" required>
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <div class="avatar">${doc.name.substring(0,1)}</div>
                                <div class="min-w-0">
                                    <div class="name text-truncate"><c:out value="${doc.name}" /></div>
                                    <div class="spec text-truncate"><c:out value="${doc.specialization}" /></div>
                                </div>
                            </div>
                            <div class="fee" data-doctor-fee="${doc.id}" id="doctorFee-${doc.id}">Consultation ₹<fmt:formatNumber value="${consultationFee}" minFractionDigits="0" maxFractionDigits="0" /></div>
                        </label>
                    </c:forEach>
                    <c:if test="${empty doctors}">
                        <div class="alert alert-warning mb-0">No doctors are available right now. Please contact the clinic.</div>
                    </c:if>
                </div>

                <div id="treatmentSection" class="mb-4 d-none">
                    <div class="dc-step">3 · Choose a treatment</div>
                    <label class="dc-label" for="serviceSelect">Treatment</label>
                    <select class="form-select" id="serviceSelect" name="service">
                        <option value="" data-fee="0" disabled selected>Select a treatment</option>
                        <c:forEach var="sp" items="${servicePrices}">
                            <option value="${sp.serviceName}" data-fee="${sp.fee}">
                                ${sp.serviceName} · ₹<fmt:formatNumber value="${sp.fee}" type="number" minFractionDigits="0" maxFractionDigits="2" />
                            </option>
                        </c:forEach>
                    </select>
                    <div class="dc-help mt-2">The fee is frozen when you book, so later price changes will not affect this appointment.</div>
                </div>

                <div class="dc-step">3 · Pick a date and time</div>
                <div class="row g-3 mb-4">
                    <div class="col-sm-6">
                        <label class="dc-label" for="appointmentDate">Preferred date</label>
                        <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" required>
                    </div>
                    <div class="col-sm-6">
                        <label class="dc-label" for="appointmentTime">Preferred time</label>
                        <input type="time" id="appointmentTime" name="appointmentTime" class="form-control" required>
                    </div>
                </div>

                <div class="dc-step">4 · Your details</div>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <label class="dc-label" for="patientName">Full name</label>
                        <input type="text" id="patientName" name="patientName" class="form-control" required
                               value="<c:out value='${booker.name}' />" placeholder="Your full name">
                    </div>
                    <div class="col-sm-6">
                        <label class="dc-label" for="phone">Phone number</label>
                        <input type="tel" id="phone" name="phone" class="form-control" required
                               value="<c:out value='${booker.phone}' />" placeholder="Mobile number">
                    </div>
                    <div class="col-12">
                        <div class="dc-help">Booking for <strong><c:out value="${currentPatient.email}" /></strong>. This appointment will appear in your account.</div>
                    </div>
                </div>

                <button type="submit" class="btn dc-submit w-100 mt-4" id="submitButton">
                    Continue to payment · <span id="inlineFee">₹0</span>
                </button>
                <p class="dc-help text-center mb-0 mt-2">You can choose UPI, QR, net banking, debit/credit card or cash on the next step.</p>
            </form>
        </div>

        <div class="col-lg-4">
            <div class="dc-summary">
                <div class="dc-summary-head">
                    <div class="fw-bold mb-1">Visit summary</div>
                    <div class="small" style="color:#cdeee8;">Clear pricing, no surprises</div>
                </div>
                <div class="p-4">
                    <div class="dc-summary-row"><span class="text-muted">Visit type</span><span class="fw-semibold" id="summaryType">Consultation</span></div>
                    <div class="dc-summary-row"><span class="text-muted">Doctor</span><span class="fw-semibold text-end" id="summaryDoctor">Not selected</span></div>
                    <div class="dc-summary-row" id="summaryTreatmentRow" style="display:none;"><span class="text-muted">Treatment</span><span class="fw-semibold text-end" id="summaryTreatment">—</span></div>
                    <div class="dc-summary-row"><span class="text-muted">Date</span><span class="fw-semibold text-end" id="summaryDate">Not selected</span></div>
                    <div class="mt-3">
                        <div class="text-muted small mb-1">Amount payable</div>
                        <div class="dc-fee-total" id="feePreview">₹0</div>
                    </div>
                    <div class="dc-pill mt-2" id="feeSource">Select a doctor to see the fee</div>
                    <hr>
                    <div class="dc-help mb-2"><i class="bi bi-shield-check me-1"></i>Your card number and CVV are never stored.</div>
                    <div class="dc-help mb-0"><i class="bi bi-clock me-1"></i>Free cancellation from My Appointments before the visit.</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="doctorFeesData" data-fees="<c:out value='${doctorFeesJson}' />" data-consultation="<c:out value='${consultationFee}' />" style="display:none;"></div>

<%@ include file="_user_footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
(function () {
    var feesData = document.getElementById('doctorFeesData');
    var doctorFees = {};
    try { doctorFees = JSON.parse(feesData.dataset.fees || '{}'); } catch (e) { doctorFees = {}; }
    var baseConsultation = Number(feesData.dataset.consultation || 0);
    var form = document.getElementById('bookingForm');
    var dateInput = document.getElementById('appointmentDate');
    var timeInput = document.getElementById('appointmentTime');
    var serviceSelect = document.getElementById('serviceSelect');
    var treatmentSection = document.getElementById('treatmentSection');
    var summaryTreatmentRow = document.getElementById('summaryTreatmentRow');
    var summaryType = document.getElementById('summaryType');
    var summaryDoctor = document.getElementById('summaryDoctor');
    var summaryTreatment = document.getElementById('summaryTreatment');
    var summaryDate = document.getElementById('summaryDate');
    var feePreview = document.getElementById('feePreview');
    var inlineFee = document.getElementById('inlineFee');
    var feeSource = document.getElementById('feeSource');
    var feeNotice = document.getElementById('feeNotice');
    var feeNoticeText = document.getElementById('feeNoticeText');
    var selectedType = 'CONSULTATION';
    var feeUrl = '<c:url value="/api/booking/fees" />';
    var pollTimer = null;

    function money(value) {
        return '₹' + Number(value || 0).toLocaleString('en-IN', {maximumFractionDigits: 2});
    }
    function selectedDoctor() {
        return form.querySelector('input[name="doctorId"]:checked');
    }
    function doctorFee(doctorId, key) {
        var map = doctorFees[String(doctorId)] || doctorFees[doctorId];
        return map && map[key] != null ? Number(map[key]) : null;
    }
    function selectedOption() {
        var option = serviceSelect.options[serviceSelect.selectedIndex];
        return option && option.value ? option : null;
    }
    function serviceFee(name) {
        for (var i = 0; i < serviceSelect.options.length; i++) {
            var option = serviceSelect.options[i];
            if (option.value && option.value.toLowerCase() === String(name).toLowerCase()) {
                return Number(option.dataset.fee || 0);
            }
        }
        return 0;
    }
    function computedFee() {
        var doctor = selectedDoctor();
        if (!doctor) return {fee: 0, source: 'Select a doctor to see the fee'};
        if (selectedType === 'CONSULTATION') {
            var cf = doctorFee(doctor.value, 'CONSULTATION');
            return {fee: cf != null ? cf : baseConsultation, source: cf != null ? 'Doctor consultation fee' : 'Standard consultation fee'};
        }
        var option = selectedOption();
        if (!option) return {fee: 0, source: 'Select a treatment to see the fee'};
        var df = doctorFee(doctor.value, option.value);
        return {fee: df != null ? df : Number(option.dataset.fee || 0), source: df != null ? 'Doctor-specific treatment fee' : 'Standard treatment fee'};
    }
    function refreshDoctorCards() {
        document.querySelectorAll('.dc-doctor').forEach(function (card) {
            var input = card.querySelector('input');
            var label = card.querySelector('.fee');
            if (!input || !label) return;
            if (selectedType === 'CONSULTATION') {
                var cf = doctorFee(input.value, 'CONSULTATION');
                label.textContent = 'Consultation ' + money(cf != null ? cf : baseConsultation);
            } else {
                var option = selectedOption();
                if (!option) {
                    label.textContent = 'Choose a treatment';
                } else {
                    var df = doctorFee(input.value, option.value);
                    label.textContent = 'Treatment ' + money(df != null ? df : Number(option.dataset.fee || 0));
                }
            }
        });
    }
    function refresh() {
        var doctor = selectedDoctor();
        summaryType.textContent = selectedType === 'CONSULTATION' ? 'Consultation' : 'Treatment';
        summaryDoctor.textContent = doctor ? doctor.closest('.dc-doctor').querySelector('.name').textContent.trim() : 'Not selected';
        if (selectedType === 'TREATMENT') {
            var opt = selectedOption();
            summaryTreatment.textContent = opt ? opt.textContent.split('·')[0].trim() : '—';
            summaryTreatmentRow.style.display = '';
        } else {
            summaryTreatmentRow.style.display = 'none';
        }
        summaryDate.textContent = dateInput.value ? new Date(dateInput.value + 'T00:00:00').toLocaleDateString('en-IN', {day:'numeric', month:'short', year:'numeric'}) : 'Not selected';
        var result = computedFee();
        feePreview.textContent = money(result.fee);
        inlineFee.textContent = money(result.fee);
        feeSource.textContent = result.source;
        refreshDoctorCards();
        document.querySelectorAll('.dc-doctor').forEach(function (card) {
            var input = card.querySelector('input');
            card.classList.toggle('active', input.checked);
        });
        document.querySelectorAll('.dc-type').forEach(function (tile) {
            tile.classList.toggle('active', tile.querySelector('input').checked);
        });
    }
    function rebuildServices(services) {
        if (!Array.isArray(services)) return false;
        var current = serviceSelect.value;
        var names = services.map(function (service) { return service.name; });
        var existing = [];
        for (var i = 1; i < serviceSelect.options.length; i++) existing.push(serviceSelect.options[i].value);
        var same = existing.length === names.length && names.every(function (name, index) { return existing[index] === name; });
        if (!same) {
            serviceSelect.innerHTML = '';
            var placeholder = document.createElement('option');
            placeholder.value = '';
            placeholder.disabled = true;
            placeholder.textContent = names.length ? 'Select a treatment' : 'No treatments available right now';
            serviceSelect.appendChild(placeholder);
            services.forEach(function (service) {
                var option = document.createElement('option');
                option.value = service.name;
                option.dataset.fee = service.fee;
                option.textContent = service.name + ' · ' + money(service.fee);
                serviceSelect.appendChild(option);
            });
            if (current && names.some(function (name) { return name === current; })) {
                serviceSelect.value = current;
            } else {
                serviceSelect.value = '';
            }
        } else {
            services.forEach(function (service, index) {
                var option = serviceSelect.options[index + 1];
                if (option) option.dataset.fee = service.fee;
            });
        }
        var missing = current && !names.some(function (name) { return name === current; });
        if (!names.length) {
            serviceSelect.required = false;
        }
        return missing;
    }
    function applyFees(payload, initial) {
        if (!payload) return;
        var before = computedFee().fee;
        if (payload.consultationFee != null) baseConsultation = Number(payload.consultationFee);
        if (payload.doctorFees && typeof payload.doctorFees === 'object') doctorFees = payload.doctorFees;
        var selectedRemoved = rebuildServices(payload.services);
        refresh();
        var after = computedFee().fee;
        if (!initial && (selectedRemoved || after !== before)) {
            feeNoticeText.textContent = selectedRemoved
                ? 'The treatment you selected is no longer offered. Please choose another treatment; your total has been refreshed.'
                : 'Fees were updated by the clinic. Your total is now ' + money(after) + '.';
            feeNotice.classList.remove('d-none');
        }
    }
    function pollFees() {
        if (document.hidden) return;
        fetch(feeUrl, {headers: {'Accept': 'application/json'}, cache: 'no-store'})
            .then(function (response) { return response.ok ? response.json() : null; })
            .then(function (payload) { if (payload) applyFees(payload, false); })
            .catch(function () { /* keep the last known prices if the clinic is briefly offline */ });
    }

    form.querySelectorAll('input[name="appointmentType"]').forEach(function (radio) {
        radio.addEventListener('change', function () {
            selectedType = this.value;
            var consult = selectedType === 'CONSULTATION';
            treatmentSection.classList.toggle('d-none', consult);
            serviceSelect.required = !consult;
            if (consult) serviceSelect.value = '';
            refresh();
        });
    });
    form.querySelectorAll('input[name="doctorId"]').forEach(function (radio) {
        radio.addEventListener('change', refresh);
    });
    serviceSelect.addEventListener('change', refresh);
    dateInput.addEventListener('change', refresh);
    form.addEventListener('submit', function () {
        var button = document.getElementById('submitButton');
        button.disabled = true;
        button.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Preparing checkout...';
    });
    var today = new Date();
    dateInput.min = today.getFullYear() + '-' + String(today.getMonth()+1).padStart(2,'0') + '-' + String(today.getDate()).padStart(2,'0');
    if (!timeInput.value) timeInput.value = '10:00';
    refresh();
    pollFees();
    pollTimer = setInterval(pollFees, 15000);
    document.addEventListener('visibilitychange', function () {
        if (!document.hidden) pollFees();
    });
})();
</script>
</body>
</html>
