<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="activePage" value="testimonials" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Testimonials - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .page-head { background: #0f766e; color: #fff; border-radius: 1.1rem; }
        .panel { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; overflow: hidden; }
        .panel-head { padding: 1rem 1.25rem; border-bottom: 1px solid #eef2f7; }
        .soft-label { font-size: .72rem; font-weight: 700; letter-spacing: .05em; text-transform: uppercase; color: #52627a; }
        .review { border: 1px solid #e4ebf3; border-radius: .9rem; padding: 1rem; height: 100%; background: #fff; }
        .review.hidden { background: #f8fafc; border-style: dashed; }
        .avatar { width: 42px; height: 42px; border-radius: 50%; background: #eaf7f4; color: #0b5d57; display: flex; align-items: center; justify-content: center; font-weight: 800; }
        .stars { color: #b45309; font-size: .85rem; letter-spacing: .05em; }
        .pill { border-radius: 999px; font-size: .72rem; font-weight: 700; padding: .22rem .6rem; }
        .pill-on { background: #e7f7ef; color: #15803d; }
        .pill-off { background: #eef1f5; color: #52627a; }
        .muted { color: #5b6b82; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>
<div class="container-fluid py-4 px-3 px-lg-4">
    <section class="page-head p-4 mb-4">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
            <div>
                <h1 class="h4 fw-bold mb-1">Patient testimonials</h1>
                <p class="mb-0" style="color:#cdeee8;">Publish, edit, reorder or hide reviews. Visible reviews appear on the home and testimonials pages instantly.</p>
            </div>
            <div class="d-flex gap-2">
                <span class="pill" style="background:#ffffff;color:#0b5d57;"><i class="bi bi-eye me-1"></i>${activeTestimonialCount} visible</span>
                <a href="${pageContext.request.contextPath}/testimonial" target="_blank" rel="noopener" class="btn btn-sm btn-light fw-semibold"><i class="bi bi-box-arrow-up-right me-1"></i>View public page</a>
            </div>
        </div>
    </section>

    <c:if test="${not empty success}">
        <div class="alert alert-success shadow-sm"><i class="bi bi-check-circle me-2"></i><c:out value="${success}" /></div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger shadow-sm"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${error}" /></div>
    </c:if>

    <div class="row g-4">
        <div class="col-xl-4">
            <section class="panel">
                <div class="panel-head">
                    <h2 class="h6 fw-bold mb-1">Add a testimonial</h2>
                    <p class="small mb-0 muted">Use the patient's own words with their permission.</p>
                </div>
                <div class="p-4">
                    <form action="${pageContext.request.contextPath}/admin/testimonials/save" method="post" class="row g-3">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="col-12">
                            <label class="soft-label d-block mb-1">Patient name</label>
                            <input type="text" class="form-control" name="patientName" maxlength="90" required placeholder="e.g. Ananya M.">
                        </div>
                        <div class="col-12">
                            <label class="soft-label d-block mb-1">Treatment (optional)</label>
                            <input type="text" class="form-control" name="treatment" maxlength="120" placeholder="e.g. Teeth Cleaning">
                        </div>
                        <div class="col-12">
                            <label class="soft-label d-block mb-1">Review</label>
                            <textarea class="form-control" name="message" rows="4" maxlength="1000" required placeholder="What did the patient say about their visit?"></textarea>
                        </div>
                        <div class="col-6">
                            <label class="soft-label d-block mb-1">Rating</label>
                            <select class="form-select" name="rating">
                                <option value="5" selected>5 stars</option>
                                <option value="4">4 stars</option>
                                <option value="3">3 stars</option>
                                <option value="2">2 stars</option>
                                <option value="1">1 star</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="soft-label d-block mb-1">Display order</label>
                            <input type="number" class="form-control" name="displayOrder" value="0" min="0" max="999">
                        </div>
                        <div class="col-12 d-flex justify-content-between align-items-center">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="active" value="true" id="newReviewActive" checked>
                                <label class="form-check-label small fw-semibold" for="newReviewActive">Publish now</label>
                            </div>
                            <button type="submit" class="btn text-white fw-semibold" style="background:#0f766e;border-color:#0f766e;"><i class="bi bi-plus-lg me-1"></i>Add review</button>
                        </div>
                    </form>
                </div>
            </section>
        </div>

        <div class="col-xl-8">
            <section class="panel">
                <div class="panel-head d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="h6 fw-bold mb-1">All testimonials</h2>
                        <p class="small mb-0 muted">${fn:length(testimonials)} review(s). Lower display order appears first.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/testimonial" target="_blank" rel="noopener" class="small fw-semibold text-decoration-none" style="color:#0b5d57;">Preview</a>
                </div>
                <div class="p-3">
                    <div class="row g-3">
                        <c:forEach var="t" items="${testimonials}">
                            <div class="col-md-6">
                                <article class="review ${t.active ? '' : 'hidden'}">
                                    <div class="d-flex justify-content-between align-items-start gap-2 mb-2">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="avatar"><c:out value="${t.initial}" /></div>
                                            <div>
                                                <div class="fw-semibold"><c:out value="${t.patientName}" /></div>
                                                <div class="small muted"><c:out value="${empty t.treatment ? 'General visit' : t.treatment}" /></div>
                                            </div>
                                        </div>
                                        <c:choose>
                                            <c:when test="${t.active}"><span class="pill pill-on">Visible</span></c:when>
                                            <c:otherwise><span class="pill pill-off">Hidden</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="stars mb-2">
                                        <c:forEach begin="1" end="${t.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                                        <span class="muted ms-1">Order ${t.displayOrder}</span>
                                    </div>
                                    <p class="small mb-3" style="color:#33445c;"><c:out value="${t.message}" /></p>
                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#review-${t.id}"><i class="bi bi-pencil me-1"></i>Edit</button>
                                        <form action="${pageContext.request.contextPath}/admin/testimonials/toggle" method="post">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <input type="hidden" name="id" value="${t.id}" />
                                            <button type="submit" class="btn btn-sm ${t.active ? 'btn-outline-warning' : 'btn-outline-success'}"><i class="bi ${t.active ? 'bi-eye-slash' : 'bi-eye'} me-1"></i>${t.active ? 'Hide' : 'Publish'}</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/testimonials/delete" method="post" onsubmit="return confirm('Delete this testimonial permanently?');">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <input type="hidden" name="id" value="${t.id}" />
                                            <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </div>
                                </article>
                            </div>
                        </c:forEach>
                    </div>
                    <c:if test="${empty testimonials}">
                        <div class="text-center py-5 muted"><i class="bi bi-chat-quote fs-1 d-block mb-2"></i>No testimonials yet. Add the first review on the left.</div>
                    </c:if>
                </div>
            </section>
        </div>
    </div>
</div>

<c:forEach var="t" items="${testimonials}">
    <div class="modal fade" id="review-${t.id}" tabindex="-1" aria-labelledby="reviewLabel-${t.id}" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius:1rem;">
                <form action="${pageContext.request.contextPath}/admin/testimonials/save" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" name="id" value="${t.id}" />
                    <div class="modal-header">
                        <h5 class="modal-title h6 fw-bold" id="reviewLabel-${t.id}">Edit testimonial</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="soft-label d-block mb-1">Patient name</label>
                            <input type="text" class="form-control" name="patientName" value="<c:out value='${t.patientName}' />" maxlength="90" required>
                        </div>
                        <div class="mb-3">
                            <label class="soft-label d-block mb-1">Treatment</label>
                            <input type="text" class="form-control" name="treatment" value="<c:out value='${t.treatment}' />" maxlength="120">
                        </div>
                        <div class="mb-3">
                            <label class="soft-label d-block mb-1">Review</label>
                            <textarea class="form-control" name="message" rows="4" maxlength="1000" required><c:out value="${t.message}" /></textarea>
                        </div>
                        <div class="row g-2">
                            <div class="col-6">
                                <label class="soft-label d-block mb-1">Rating</label>
                                <select class="form-select" name="rating">
                                    <c:forEach begin="1" end="5" var="star">
                                        <option value="${6 - star}" ${t.rating == (6 - star) ? 'selected' : ''}>${6 - star} star${star == 5 ? '' : 's'}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-6">
                                <label class="soft-label d-block mb-1">Display order</label>
                                <input type="number" class="form-control" name="displayOrder" value="${t.displayOrder}" min="0" max="999">
                            </div>
                        </div>
                        <div class="form-check mt-3">
                            <input class="form-check-input" type="checkbox" name="active" value="true" id="activeReview-${t.id}" ${t.active ? 'checked' : ''}>
                            <label class="form-check-label small fw-semibold" for="activeReview-${t.id}">Visible on public site</label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn text-white fw-semibold" style="background:#0f766e;border-color:#0f766e;">Save changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
