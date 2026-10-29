<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Contact Us - ${site.siteName}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<c:url value='/css/style.css' />" rel="stylesheet">
    <style>
        body { background: #f5f8fb; color: #1d2b3f; }
        .dc-hero { background: linear-gradient(120deg, #0b172a 0%, #0f4f4a 60%, #0f766e 100%); color: #fff; padding: 3.2rem 0 2.6rem; }
        .dc-hero .eyebrow { color: #a8eadf; text-transform: uppercase; letter-spacing: .09em; font-size: .74rem; font-weight: 700; }
        .dc-hero p { color: #d8e5f2; }
        .dc-panel { background: #fff; border: 1px solid #e4ebf3; border-radius: 1rem; overflow: hidden; }
        .dc-info { background: #fff; border: 1px solid #e4ebf3; border-radius: 1rem; padding: 1.2rem; height: 100%; }
        .dc-info .icon { width: 40px; height: 40px; border-radius: .7rem; background: #eaf7f4; color: #0b5d57; display: flex; align-items: center; justify-content: center; font-size: 1.05rem; margin-bottom: .8rem; }
        .dc-muted { color: #52627a; }
        .form-label { font-weight: 600; color: #34445c; font-size: .9rem; }
        .form-control { border-color: #dfe6ef; border-radius: .65rem; padding: .65rem .8rem; }
        .form-control:focus { border-color: #0f766e; box-shadow: 0 0 0 .18rem rgba(15,118,110,.12); }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; border-radius: .65rem; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .dc-social a { width: 38px; height: 38px; border-radius: 50%; background: #eaf7f4; color: #0b5d57; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; }
        .dc-social a:hover { background: #0f766e; color: #fff; }
        .dc-map { border: 0; width: 100%; height: 340px; }
        .dc-hours { background: #eef8f6; border: 1px solid #c6e9d8; border-radius: .9rem; padding: 1rem 1.1rem; color: #0b4f49; }
    </style>
</head>
<body>
<%@ include file="_user_navbar.jsp" %>

<header class="dc-hero">
    <div class="container">
        <div class="eyebrow mb-2">Contact</div>
        <h1 class="display-5 fw-bold mb-3"><c:out value="${site.contactHeading}" /></h1>
        <p class="mb-0" style="max-width:720px;"><c:out value="${site.contactText}" /></p>
    </div>
</header>

<main class="container py-5">
    <c:if test="${not empty success}">
        <div class="alert alert-success border-0 shadow-sm"><i class="bi bi-check-circle me-2"></i><c:out value="${success}" /></div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger border-0 shadow-sm"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${error}" /></div>
    </c:if>

    <div class="row g-3 mb-4">
        <div class="col-md-6 col-xl-3">
            <div class="dc-info">
                <div class="icon"><i class="bi bi-geo-alt"></i></div>
                <h2 class="h6 fw-bold mb-1">Visit the clinic</h2>
                <p class="small dc-muted mb-0"><c:out value="${site.footerAddress}" /></p>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="dc-info">
                <div class="icon"><i class="bi bi-telephone"></i></div>
                <h2 class="h6 fw-bold mb-1">Call us</h2>
                <a class="small text-decoration-none" style="color:#0b5d57;" href="tel:<c:out value='${site.footerPhone}' />"><c:out value="${site.footerPhone}" /></a>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="dc-info">
                <div class="icon"><i class="bi bi-envelope"></i></div>
                <h2 class="h6 fw-bold mb-1">Email us</h2>
                <a class="small text-decoration-none" style="color:#0b5d57;" href="mailto:<c:out value='${site.footerEmail}' />"><c:out value="${site.footerEmail}" /></a>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="dc-info">
                <div class="icon"><i class="bi bi-clock"></i></div>
                <h2 class="h6 fw-bold mb-1">Opening hours</h2>
                <p class="small dc-muted mb-0"><c:out value="${site.hoursWeekday}" /></p>
                <p class="small dc-muted mb-0"><c:out value="${site.hoursSaturday}" /></p>
                <p class="small dc-muted mb-0"><c:out value="${site.hoursSunday}" /></p>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-7">
            <section class="dc-panel">
                <div class="p-4 border-bottom" style="border-color:#eef2f7;">
                    <h2 class="h5 fw-bold mb-1">Send us a message</h2>
                    <p class="small dc-muted mb-0">Your message goes straight to the clinic inbox. We reply during opening hours.</p>
                </div>
                <div class="p-4">
                    <form action="${pageContext.request.contextPath}/contact" method="post" class="row g-3">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="col-md-6">
                            <label class="form-label" for="contactName">Your name</label>
                            <input id="contactName" type="text" class="form-control" name="name" maxlength="90" required placeholder="e.g. Ananya Mohapatra">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="contactEmail">Email address</label>
                            <input id="contactEmail" type="email" class="form-control" name="email" maxlength="160" required placeholder="you@example.com">
                        </div>
                        <div class="col-12">
                            <label class="form-label" for="contactSubject">Subject</label>
                            <input id="contactSubject" type="text" class="form-control" name="subject" maxlength="140" required placeholder="How can we help?">
                        </div>
                        <div class="col-12">
                            <label class="form-label" for="contactMessage">Message</label>
                            <textarea id="contactMessage" class="form-control" name="message" rows="5" maxlength="2000" required placeholder="Tell us about your concern or question."></textarea>
                        </div>
                        <div class="col-12 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3">
                            <span class="small dc-muted"><i class="bi bi-shield-lock me-1"></i>We never share your details.</span>
                            <button type="submit" class="btn btn-teal px-4 py-2"><i class="bi bi-send me-1"></i>Send message</button>
                        </div>
                    </form>
                </div>
            </section>
        </div>
        <div class="col-lg-5">
            <section class="dc-panel h-100">
                <div class="p-4">
                    <h2 class="h5 fw-bold mb-2">Find us</h2>
                    <p class="small dc-muted mb-3"><c:out value="${site.footerAddress}" /></p>
                    <div class="dc-hours mb-3">
                        <div class="fw-bold small mb-1"><i class="bi bi-clock-history me-1"></i>Today at a glance</div>
                        <div class="small"><c:out value="${site.hoursWeekday}" /></div>
                        <div class="small"><c:out value="${site.hoursSaturday}" /></div>
                        <div class="small"><c:out value="${site.hoursSunday}" /></div>
                    </div>
                    <c:if test="${not empty site.socialFacebook or not empty site.socialInstagram or not empty site.socialTwitter or not empty site.socialLinkedin}">
                        <div class="dc-social d-flex gap-2 mb-3">
                            <c:if test="${not empty site.socialFacebook}">
                                <a href="${fn:escapeXml(site.socialFacebook)}" target="_blank" rel="noopener" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                            </c:if>
                            <c:if test="${not empty site.socialInstagram}">
                                <a href="${fn:escapeXml(site.socialInstagram)}" target="_blank" rel="noopener" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                            </c:if>
                            <c:if test="${not empty site.socialTwitter}">
                                <a href="${fn:escapeXml(site.socialTwitter)}" target="_blank" rel="noopener" aria-label="X"><i class="fab fa-twitter"></i></a>
                            </c:if>
                            <c:if test="${not empty site.socialLinkedin}">
                                <a href="${fn:escapeXml(site.socialLinkedin)}" target="_blank" rel="noopener" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                            </c:if>
                        </div>
                    </c:if>
                    <div class="rounded overflow-hidden border" style="border-color:#e4ebf3 !important;">
                        <iframe class="dc-map" title="DentCare location map" loading="lazy" referrerpolicy="no-referrer-when-downgrade"
                                src="https://maps.google.com/maps?q=<c:out value='${site.mapQuery}' />&amp;output=embed"></iframe>
                    </div>
                </div>
            </section>
        </div>
    </div>
</main>

<%@ include file="_user_footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
