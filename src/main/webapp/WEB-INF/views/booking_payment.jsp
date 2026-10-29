<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Secure Payment - ${site.siteName}</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <style>
        body { background: #f5f8fb; color: #1d2b3f; }
        .dc-summary { background: #0b172a; color: #fff; border-radius: 1rem; }
        .dc-summary .label { color: #c9d6e5; font-size: .74rem; text-transform: uppercase; letter-spacing: .07em; }
        .dc-summary .value { font-weight: 600; }
        .dc-row { display: flex; justify-content: space-between; gap: 1rem; padding: .55rem 0; border-bottom: 1px dashed rgba(255,255,255,.16); font-size: .9rem; }
        .dc-row:last-child { border-bottom: 0; }
        .checkout-card { border: 1px solid #e7ecf3; border-radius: 1rem; background: #fff; }
        .method-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: .7rem; }
        @media (max-width: 575.98px) { .method-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
        .method-tile { position: relative; border: 2px solid #e7ecf3; border-radius: .8rem; padding: .9rem .55rem; text-align: center; cursor: pointer; background: #fff; transition: border-color .12s ease, background .12s ease; }
        .method-tile input { position: absolute; opacity: 0; pointer-events: none; }
        .method-tile i { display: block; font-size: 1.3rem; color: #0f766e; margin-bottom: .35rem; }
        .method-tile span { font-size: .82rem; font-weight: 600; color: #23324a; }
        .method-tile:hover { border-color: #9fd3cc; }
        .method-tile.active { border-color: #0f766e; background: #f1faf8; }
        .pay-section { background: #f8fbfc; border: 1px solid #e7ecf3; border-radius: .8rem; padding: 1rem; }
        .qr-box { width: 160px; height: 160px; border-radius: .75rem; background: #fff; border: 2px dashed #cbd5e1; display: flex; align-items: center; justify-content: center; margin: 0 auto; }
        .qr-box i { font-size: 5.4rem; color: #0b172a; }
        .secure-note { font-size: .78rem; color: #7a879b; }
        .form-control, .form-select { border-color: #dfe6ef; border-radius: .65rem; padding: .65rem .8rem; }
        .form-control:focus, .form-select:focus { border-color: #0f766e; box-shadow: 0 0 0 .18rem rgba(15,118,110,.12); }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; border-radius: .7rem; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .badge-soft { background: #eaf7f4; color: #0f766e; border-radius: 999px; padding: .25rem .6rem; font-size: .74rem; font-weight: 700; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<div class="container py-4 py-lg-5">
    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-4">
        <div>
            <div class="text-uppercase small fw-bold mb-1" style="color:#0f766e;letter-spacing:.07em;">Step 2 of 3 · Payment</div>
            <h1 class="h3 fw-bold mb-1">Secure checkout</h1>
            <p class="text-muted mb-0">Complete payment to confirm your appointment.</p>
        </div>
        <span class="badge-soft"><i class="bi bi-lock me-1"></i>${appointment.paymentReference}</span>
    </div>

    <c:if test="${not empty paymentError}">
        <div class="alert alert-danger border-0 shadow-sm"><c:out value="${paymentError}" /></div>
    </c:if>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="dc-summary p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="h5 fw-bold mb-0"><i class="fas fa-tooth me-2"></i>Visit summary</h2>
                    <span class="badge" style="background:rgba(255,255,255,.18);color:#fff;border:1px solid rgba(255,255,255,.4);">${appointment.appointmentType.label}</span>
                </div>
                <div class="dc-row"><span class="label">Patient</span><span class="value"><c:out value="${appointment.patientName}" /></span></div>
                <div class="dc-row"><span class="label">Doctor</span><span class="value"><c:out value="${appointment.doctorName}" /></span></div>
                <div class="dc-row"><span class="label">Service</span><span class="value"><c:out value="${appointment.service}" /></span></div>
                <div class="dc-row"><span class="label">Date</span><span class="value"><c:out value="${appointment.appointmentDate}" /></span></div>
                <div class="dc-row"><span class="label">Time</span><span class="value"><c:out value="${appointment.appointmentTime}" /></span></div>
                <hr class="border-light opacity-25 my-3">
                <div class="d-flex justify-content-between align-items-center">
                    <span class="label">Amount payable</span>
                    <span class="fs-3 fw-bold">₹<fmt:formatNumber value="${appointment.amount}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span>
                </div>
                <p class="secure-note text-white-50 mt-3 mb-0"><i class="bi bi-shield-check me-1"></i>Your card number and CVV are never stored.</p>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="checkout-card p-4">
                <h2 class="h5 fw-bold mb-1">Choose a payment method</h2>
                <p class="text-muted small mb-4">Online methods are simulated in this demo checkout. Cash bookings are confirmed and paid at the clinic.</p>

                <form action="${pageContext.request.contextPath}/booking/pay/${appointment.paymentReference}" method="post" id="paymentForm" novalidate>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                    <div class="method-grid mb-4">
                        <label class="method-tile active"><input type="radio" name="method" value="NETBANKING" checked><i class="fas fa-university"></i><span>Net Banking</span></label>
                        <label class="method-tile"><input type="radio" name="method" value="QR"><i class="fas fa-qrcode"></i><span>QR Code</span></label>
                        <label class="method-tile"><input type="radio" name="method" value="UPI"><i class="fas fa-mobile-alt"></i><span>UPI</span></label>
                        <label class="method-tile"><input type="radio" name="method" value="DEBIT_CARD"><i class="fas fa-credit-card"></i><span>Debit Card</span></label>
                        <label class="method-tile"><input type="radio" name="method" value="CREDIT_CARD"><i class="far fa-credit-card"></i><span>Credit Card</span></label>
                        <label class="method-tile"><input type="radio" name="method" value="CASH"><i class="fas fa-money-bill-wave"></i><span>Cash</span></label>
                    </div>

                    <div id="paymentError" class="alert alert-danger d-none"></div>

                    <div class="pay-section" id="section-netbanking">
                        <label class="form-label fw-semibold" for="bankName">Select your bank</label>
                        <select class="form-select" name="bankName" id="bankName">
                            <option value="">Choose a bank</option>
                            <option value="State Bank of India">State Bank of India</option>
                            <option value="HDFC Bank">HDFC Bank</option>
                            <option value="ICICI Bank">ICICI Bank</option>
                            <option value="Axis Bank">Axis Bank</option>
                            <option value="Kotak Mahindra Bank">Kotak Mahindra Bank</option>
                            <option value="Punjab National Bank">Punjab National Bank</option>
                            <option value="Other Bank">Other Bank</option>
                        </select>
                        <div class="secure-note mt-2">You would be redirected to your bank's secure page in a live gateway.</div>
                    </div>

                    <div class="pay-section d-none" id="section-qr">
                        <div class="text-center">
                            <div class="qr-box mb-3"><i class="fas fa-qrcode"></i></div>
                            <h3 class="h6 fw-bold mb-1">Scan the QR with any UPI app</h3>
                            <p class="text-muted small mb-1">GPay · PhonePe · Paytm · BHIM</p>
                            <p class="mb-0"><strong>dentcare@upi</strong></p>
                        </div>
                    </div>

                    <div class="pay-section d-none" id="section-upi">
                        <label class="form-label fw-semibold" for="upiId">UPI ID</label>
                        <input type="text" class="form-control" name="upiId" id="upiId" placeholder="yourname@bank" autocomplete="off">
                        <div class="secure-note mt-2">Example: patient@okhdfcbank</div>
                    </div>

                    <div class="pay-section d-none" id="section-card">
                        <div class="row g-3">
                            <div class="col-12"><label class="form-label fw-semibold" for="cardNumber">Card number</label><input type="text" class="form-control" name="cardNumber" id="cardNumber" inputmode="numeric" placeholder="1234 5678 9012 3456" autocomplete="cc-number" maxlength="23"></div>
                            <div class="col-12"><label class="form-label fw-semibold" for="cardName">Name on card</label><input type="text" class="form-control" name="cardName" id="cardName" placeholder="Name as printed on card" autocomplete="cc-name"></div>
                            <div class="col-6"><label class="form-label fw-semibold" for="cardExpiry">Expiry</label><input type="text" class="form-control" name="cardExpiry" id="cardExpiry" placeholder="MM/YY" inputmode="numeric" maxlength="5" autocomplete="cc-exp"></div>
                            <div class="col-6"><label class="form-label fw-semibold" for="cardCvv">CVV</label><input type="password" class="form-control" name="cardCvv" id="cardCvv" placeholder="•••" inputmode="numeric" maxlength="4" autocomplete="cc-csc"></div>
                        </div>
                        <div class="secure-note mt-2"><i class="fas fa-lock me-1"></i>Only the last 4 digits are saved with your booking.</div>
                    </div>

                    <div class="pay-section d-none" id="section-cash">
                        <div class="d-flex align-items-start">
                            <i class="fas fa-info-circle me-2 mt-1" style="color:#0f766e;"></i>
                            <div>
                                <h3 class="h6 fw-bold mb-1">Pay at the clinic</h3>
                                <p class="text-muted small mb-0">Your appointment is confirmed now. Please pay the exact amount at reception before your consultation.</p>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-teal w-100 py-3 mt-4" id="payButton" data-amount="${appointment.amount}">
                        Pay ₹<fmt:formatNumber value="${appointment.amount}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                    </button>
                    <div class="d-flex flex-column flex-sm-row justify-content-between gap-2 secure-note mt-3 mb-0">
                        <span><i class="fas fa-shield-alt me-1"></i>Demo payment gateway — no real transaction.</span>
                        <a href="${pageContext.request.contextPath}/my/appointments" class="text-decoration-none">Cancel and view appointments</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function () {
    var form = document.getElementById('paymentForm');
    var payButton = document.getElementById('payButton');
    var errorBox = document.getElementById('paymentError');
    var sections = { NETBANKING: 'section-netbanking', QR: 'section-qr', UPI: 'section-upi', DEBIT_CARD: 'section-card', CREDIT_CARD: 'section-card', CASH: 'section-cash' };
    var amount = Number(payButton.dataset.amount || 0);
    var amountText = '₹' + amount.toLocaleString('en-IN', {minimumFractionDigits: 2, maximumFractionDigits: 2});
    function selectedMethod() { return document.querySelector('input[name="method"]:checked'); }
    function refreshMethod() {
        var checked = selectedMethod();
        var method = checked ? checked.value : 'NETBANKING';
        document.querySelectorAll('.method-tile').forEach(function (tile) { tile.classList.toggle('active', tile.querySelector('input').checked); });
        Object.keys(sections).forEach(function (key) {
            var section = document.getElementById(sections[key]);
            if (section) section.classList.toggle('d-none', sections[key] !== sections[method]);
        });
        payButton.textContent = method === 'CASH' ? 'Confirm booking' : 'Pay ' + amountText;
    }
    document.querySelectorAll('input[name="method"]').forEach(function (radio) {
        radio.addEventListener('change', function () { errorBox.classList.add('d-none'); refreshMethod(); });
    });
    var cardNumber = document.getElementById('cardNumber');
    cardNumber.addEventListener('input', function () {
        var digits = cardNumber.value.replace(/\D/g, '').slice(0, 19);
        cardNumber.value = digits.replace(/(.{4})/g, '$1 ').trim();
    });
    var cardExpiry = document.getElementById('cardExpiry');
    cardExpiry.addEventListener('input', function () {
        var digits = cardExpiry.value.replace(/\D/g, '').slice(0, 4);
        cardExpiry.value = digits.length > 2 ? digits.slice(0, 2) + '/' + digits.slice(2) : digits;
    });
    var cardCvv = document.getElementById('cardCvv');
    cardCvv.addEventListener('input', function () { cardCvv.value = cardCvv.value.replace(/\D/g, '').slice(0, 4); });
    form.addEventListener('submit', function (event) {
        var checked = selectedMethod();
        var method = checked ? checked.value : '';
        var error = null;
        if (method === 'NETBANKING' && !form.bankName.value.trim()) {
            error = 'Choose your bank to continue with net banking.';
        } else if (method === 'UPI') {
            if (!/^[A-Za-z0-9._-]{2,}@[A-Za-z]{2,}$/.test(form.upiId.value.trim())) error = 'Enter a valid UPI ID, for example name@bank.';
        } else if (method === 'DEBIT_CARD' || method === 'CREDIT_CARD') {
            var digits = form.cardNumber.value.replace(/\D/g, '');
            if (!/^\d{13,19}$/.test(digits)) error = 'Enter a valid card number.';
            else if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(form.cardExpiry.value)) error = 'Enter a valid expiry date in MM/YY format.';
            else if (!/^\d{3,4}$/.test(form.cardCvv.value)) error = 'Enter the 3 or 4 digit CVV.';
            else if (!form.cardName.value.trim()) error = 'Enter the name printed on the card.';
        }
        if (error) {
            event.preventDefault();
            errorBox.textContent = error;
            errorBox.classList.remove('d-none');
            errorBox.scrollIntoView({behavior: 'smooth', block: 'center'});
            return;
        }
        errorBox.classList.add('d-none');
        payButton.disabled = true;
        payButton.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Processing...';
    });
    refreshMethod();
})();
</script>
</body>
</html>
