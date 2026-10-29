<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="activePage" value="settings" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Website &amp; Settings - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .page-head { background: #0f766e; color: #fff; border-radius: 1.1rem; }
        .settings-nav { position: sticky; top: 96px; border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; overflow: hidden; }
        .settings-nav a { display: block; padding: .75rem 1rem; color: #4b5b73; font-weight: 600; font-size: .9rem; text-decoration: none; border-left: 3px solid transparent; }
        .settings-nav a:hover { background: #f2faf8; color: #0f766e; border-left-color: #0f766e; }
        .settings-nav a + a { border-top: 1px solid #f1f4f8; }
        .settings-card { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; }
        .settings-card .card-head { padding: 1.1rem 1.4rem; border-bottom: 1px solid #eef2f7; }
        .form-label { font-weight: 600; color: #3c4c63; font-size: .86rem; }
        .form-control, .form-select { border-color: #dde5ee; border-radius: .65rem; padding: .62rem .8rem; }
        .form-control:focus, .form-select:focus { border-color: #0f766e; box-shadow: 0 0 0 .18rem rgba(15,118,110,.12); }
        .form-text { font-size: .78rem; }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .preview-bar { background: #0f766e; color: #eafffb; font-size: .8rem; padding: .35rem .7rem; text-align: center; border-radius: .5rem .5rem 0 0; }
        .preview-nav { border: 1px solid #e4ebf3; border-top: 0; border-radius: 0 0 .5rem .5rem; background: #fff; padding: .75rem .9rem; }
        .preview-nav .brand { font-weight: 800; color: #10243e; }
        .preview-nav .brand span { color: #0f766e; }
        .preview-link { color: #53657d; font-size: .78rem; font-weight: 600; }
        .preview-book { background: #0f766e; color: #fff; font-size: .72rem; font-weight: 700; border-radius: .45rem; padding: .28rem .55rem; }
        .preview-head { background: #0b172a; color: #fff; border-radius: .5rem; padding: 1rem; margin-top: .75rem; }
        .preview-head .eyebrow { color: #8fd8ce; font-size: .6rem; letter-spacing: .08em; text-transform: uppercase; font-weight: 700; }
        .preview-head h6 { font-size: .9rem; margin: .25rem 0; }
        .preview-head p { color: #b9c6d8; font-size: .7rem; margin: 0; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-3 px-lg-4">
    <section class="page-head p-4 p-lg-5 mb-4">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
            <div>
                <div class="small text-white-50 mb-1">ADMIN CONTROL CENTRE</div>
                <h1 class="h3 fw-bold mb-2">Website, labels &amp; receipt settings</h1>
                <p class="mb-0 text-white-50">Change every public label, fee, footer line and receipt message. Updates are live immediately.</p>
            </div>
            <button type="submit" form="settingsForm" class="btn btn-light fw-semibold px-4">
                <i class="bi bi-check2-circle me-1"></i>Save all changes
            </button>
        </div>
    </section>

    <c:if test="${not empty success}"><div class="alert alert-success shadow-sm"><i class="bi bi-check-circle me-2"></i><c:out value="${success}" /></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger shadow-sm"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${error}" /></div></c:if>

    <div class="row g-4">
        <div class="col-lg-3 col-xl-2">
            <nav class="settings-nav" aria-label="Settings sections">
                <a href="#brand"><i class="bi bi-shop me-2"></i>Brand &amp; homepage</a>
                <a href="#navigation"><i class="bi bi-list-nested me-2"></i>Navigation labels</a>
                <a href="#booking"><i class="bi bi-calendar2-check me-2"></i>Booking &amp; fees</a>
                <a href="#footer"><i class="bi bi-layout-text-window-reverse me-2"></i>Footer &amp; contact</a>
                <a href="#receipts"><i class="bi bi-receipt me-2"></i>Receipts</a>
            </nav>
        </div>

        <div class="col-lg-9 col-xl-7">
            <form id="settingsForm" action="${pageContext.request.contextPath}/admin/settings" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <section id="brand" class="settings-card mb-4">
                    <div class="card-head"><h2 class="h6 fw-bold mb-1">Brand &amp; homepage</h2><p class="text-muted small mb-0">The public name and hero copy patients see first.</p></div>
                    <div class="p-4 row g-3">
                        <div class="col-md-6">
                            <label class="form-label" for="siteName">Clinic name</label>
                            <input id="siteName" name="siteName" class="form-control" maxlength="80" value="${fn:escapeXml(siteSettings['siteName'])}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="siteTagline">Tagline</label>
                            <input id="siteTagline" name="siteTagline" class="form-control" maxlength="120" value="${fn:escapeXml(siteSettings['siteTagline'])}">
                        </div>
                        <div class="col-12">
                            <label class="form-label" for="announcement">Announcement strip</label>
                            <input id="announcement" name="announcement" class="form-control" maxlength="160" value="${fn:escapeXml(siteSettings['announcement'])}">
                            <div class="form-text">Shown above the patient navbar. Leave blank to hide it.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="homeEyebrow">Homepage eyebrow</label>
                            <input id="homeEyebrow" name="homeEyebrow" class="form-control" maxlength="80" value="${fn:escapeXml(siteSettings['homeEyebrow'])}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="homeHeading">Homepage heading</label>
                            <input id="homeHeading" name="homeHeading" class="form-control" maxlength="140" value="${fn:escapeXml(siteSettings['homeHeading'])}">
                        </div>
                        <div class="col-12">
                            <label class="form-label" for="homeText">Homepage supporting line</label>
                            <textarea id="homeText" name="homeText" class="form-control" rows="2" maxlength="220"><c:out value="${siteSettings['homeText']}" /></textarea>
                        </div>
                    </div>
                </section>

                <section id="navigation" class="settings-card mb-4">
                    <div class="card-head"><h2 class="h6 fw-bold mb-1">Navigation labels</h2><p class="text-muted small mb-0">Rename the patient-facing menu without touching code.</p></div>
                    <div class="p-4 row g-3">
                        <div class="col-md-4"><label class="form-label" for="navHome">Home</label><input id="navHome" name="navHome" class="form-control" maxlength="40" value="${fn:escapeXml(siteSettings['navHome'])}"></div>
                        <div class="col-md-4"><label class="form-label" for="navServices">Services</label><input id="navServices" name="navServices" class="form-control" maxlength="40" value="${fn:escapeXml(siteSettings['navServices'])}"></div>
                        <div class="col-md-4"><label class="form-label" for="navDoctors">Doctors</label><input id="navDoctors" name="navDoctors" class="form-control" maxlength="40" value="${fn:escapeXml(siteSettings['navDoctors'])}"></div>
                        <div class="col-md-4"><label class="form-label" for="navPricing">Pricing</label><input id="navPricing" name="navPricing" class="form-control" maxlength="40" value="${fn:escapeXml(siteSettings['navPricing'])}"></div>
                        <div class="col-md-4"><label class="form-label" for="navContact">Contact</label><input id="navContact" name="navContact" class="form-control" maxlength="40" value="${fn:escapeXml(siteSettings['navContact'])}"></div>
                        <div class="col-md-4"><label class="form-label" for="bookButton">Book button</label><input id="bookButton" name="bookButton" class="form-control" maxlength="40" value="${fn:escapeXml(siteSettings['bookButton'])}"></div>
                        <div class="col-md-6"><label class="form-label" for="accountLabel">Account label</label><input id="accountLabel" name="accountLabel" class="form-control" maxlength="40" value="${fn:escapeXml(siteSettings['accountLabel'])}"></div>
                    </div>
                </section>

                <section id="booking" class="settings-card mb-4">
                    <div class="card-head"><h2 class="h6 fw-bold mb-1">Booking &amp; fees</h2><p class="text-muted small mb-0">Default consultation price and the note shown on the booking page.</p></div>
                    <div class="p-4 row g-3">
                        <div class="col-md-5">
                            <label class="form-label" for="consultationFee">Standard consultation fee (₹)</label>
                            <div class="input-group">
                                <span class="input-group-text">₹</span>
                                <input id="consultationFee" name="consultationFee" type="number" class="form-control" min="0" max="1000000" step="0.01" value="${fn:escapeXml(siteSettings['consultationFee'])}" required>
                            </div>
                            <div class="form-text">Doctor-specific approved fees override this amount. Current: ₹<fmt:formatNumber value="${siteSettings['consultationFee']}" minFractionDigits="0" maxFractionDigits="2" /></div>
                        </div>
                        <div class="col-md-7">
                            <label class="form-label" for="bookingNote">Booking page introduction</label>
                            <textarea id="bookingNote" name="bookingNote" class="form-control" rows="4" maxlength="500"><c:out value="${siteSettings['bookingNote']}" /></textarea>
                        </div>
                    </div>
                </section>

                <section id="footer" class="settings-card mb-4">
                    <div class="card-head"><h2 class="h6 fw-bold mb-1">Footer &amp; contact</h2><p class="text-muted small mb-0">Address, phone, email, hours and copyright line.</p></div>
                    <div class="p-4 row g-3">
                        <div class="col-12"><label class="form-label" for="footerAbout">Footer introduction</label><textarea id="footerAbout" name="footerAbout" class="form-control" rows="3" maxlength="400"><c:out value="${siteSettings['footerAbout']}" /></textarea></div>
                        <div class="col-md-8"><label class="form-label" for="footerAddress">Address</label><input id="footerAddress" name="footerAddress" class="form-control" maxlength="200" value="${fn:escapeXml(siteSettings['footerAddress'])}"></div>
                        <div class="col-md-4"><label class="form-label" for="footerHours">Opening hours</label><input id="footerHours" name="footerHours" class="form-control" maxlength="160" value="${fn:escapeXml(siteSettings['footerHours'])}"></div>
                        <div class="col-md-6"><label class="form-label" for="footerPhone">Phone</label><input id="footerPhone" name="footerPhone" class="form-control" maxlength="60" value="${fn:escapeXml(siteSettings['footerPhone'])}"></div>
                        <div class="col-md-6"><label class="form-label" for="footerEmail">Email</label><input id="footerEmail" name="footerEmail" type="email" class="form-control" maxlength="120" value="${fn:escapeXml(siteSettings['footerEmail'])}"></div>
                        <div class="col-12"><label class="form-label" for="footerCopyright">Copyright line</label><input id="footerCopyright" name="footerCopyright" class="form-control" maxlength="160" value="${fn:escapeXml(siteSettings['footerCopyright'])}"></div>
                    </div>
                </section>

                <section id="receipts" class="settings-card mb-4">
                    <div class="card-head"><h2 class="h6 fw-bold mb-1">Receipts</h2><p class="text-muted small mb-0">Text used on the printable and downloadable receipt.</p></div>
                    <div class="p-4 row g-3">
                        <div class="col-md-6"><label class="form-label" for="receiptTitle">Receipt title</label><input id="receiptTitle" name="receiptTitle" class="form-control" maxlength="80" value="${fn:escapeXml(siteSettings['receiptTitle'])}"></div>
                        <div class="col-md-6"><label class="form-label" for="receiptNote">Receipt note</label><input id="receiptNote" name="receiptNote" class="form-control" maxlength="220" value="${fn:escapeXml(siteSettings['receiptNote'])}"></div>
                        <div class="col-12"><label class="form-label" for="receiptFooter">Receipt footer</label><textarea id="receiptFooter" name="receiptFooter" class="form-control" rows="2" maxlength="300"><c:out value="${siteSettings['receiptFooter']}" /></textarea></div>
                    </div>
                </section>

                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-5">
                    <span class="text-muted small"><i class="bi bi-lightning-charge me-1"></i>Changes are applied without a restart.</span>
                    <button type="submit" class="btn btn-teal px-4"><i class="bi bi-check2-circle me-1"></i>Save all changes</button>
                </div>
            </form>
        </div>

        <div class="col-xl-3 d-none d-xl-block">
            <div class="position-sticky" style="top:96px;">
                <div class="text-muted small fw-bold text-uppercase mb-2">Live preview</div>
                <div class="preview-bar" id="pvAnnouncement"><c:out value="${siteSettings['announcement']}" /></div>
                <div class="preview-nav">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="brand"><i class="bi bi-heart-pulse me-1"></i><span id="pvName"><c:out value="${siteSettings['siteName']}" /></span></div>
                        <div class="preview-book" id="pvBook"><c:out value="${siteSettings['bookButton']}" /></div>
                    </div>
                    <div class="d-flex flex-wrap gap-2">
                        <span class="preview-link" id="pvHome"><c:out value="${siteSettings['navHome']}" /></span>
                        <span class="preview-link" id="pvServices"><c:out value="${siteSettings['navServices']}" /></span>
                        <span class="preview-link" id="pvDoctors"><c:out value="${siteSettings['navDoctors']}" /></span>
                        <span class="preview-link" id="pvPricing"><c:out value="${siteSettings['navPricing']}" /></span>
                        <span class="preview-link" id="pvContact"><c:out value="${siteSettings['navContact']}" /></span>
                    </div>
                </div>
                <div class="preview-head">
                    <div class="eyebrow" id="pvEyebrow"><c:out value="${siteSettings['homeEyebrow']}" /></div>
                    <h6 id="pvHeading"><c:out value="${siteSettings['homeHeading']}" /></h6>
                    <p id="pvText"><c:out value="${siteSettings['homeText']}" /></p>
                </div>
                <div class="small text-muted mt-3"><i class="bi bi-info-circle me-1"></i>Doctor-specific fees are managed under <a href="${pageContext.request.contextPath}/admin/doctor-fees">Doctor Fees</a>.</div>
            </div>
        </div>
    </div>
</div>

<script>
(function () {
    var pairs = [
        ['siteName','pvName'], ['bookButton','pvBook'], ['announcement','pvAnnouncement'],
        ['navHome','pvHome'], ['navServices','pvServices'], ['navDoctors','pvDoctors'],
        ['navPricing','pvPricing'], ['navContact','pvContact'], ['homeEyebrow','pvEyebrow'],
        ['homeHeading','pvHeading'], ['homeText','pvText']
    ];
    pairs.forEach(function (pair) {
        var input = document.getElementById(pair[0]);
        var target = document.getElementById(pair[1]);
        if (!input || !target) return;
        input.addEventListener('input', function () { target.textContent = input.value; });
    });
})();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
