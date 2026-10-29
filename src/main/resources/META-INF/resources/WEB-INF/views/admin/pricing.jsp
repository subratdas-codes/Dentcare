<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="activePage" value="pricing" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Treatments &amp; Prices - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .page-head { background: #0f766e; color: #fff; border-radius: 1.1rem; }
        .panel { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; overflow: hidden; }
        .panel-head { padding: 1rem 1.25rem; border-bottom: 1px solid #eef2f7; }
        .table thead th { color: #52627a; font-size: .72rem; letter-spacing: .05em; text-transform: uppercase; white-space: nowrap; }
        .table td { vertical-align: middle; }
        .fee-input { max-width: 170px; }
        .soft-label { font-size: .72rem; font-weight: 700; letter-spacing: .05em; text-transform: uppercase; color: #52627a; }
        .pill { border-radius: 999px; font-size: .72rem; font-weight: 700; padding: .22rem .6rem; }
        .pill-on { background: #e7f7ef; color: #15803d; }
        .pill-off { background: #eef1f5; color: #52627a; }
        .desc { color: #5b6b82; font-size: .82rem; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>
<div class="container-fluid py-4 px-3 px-lg-4">
    <section class="page-head p-4 mb-4">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
            <div>
                <h1 class="h4 fw-bold mb-1">Treatments &amp; prices</h1>
                <p class="mb-0" style="color:#cdeee8;">Add, edit, hide or remove treatments. Every change is live on the public site and booking form immediately.</p>
            </div>
            <div class="d-flex gap-2">
                <span class="pill" style="background:#ffffff;color:#0b5d57;"><i class="bi bi-eye me-1"></i>${activeServiceCount} active</span>
                <a href="${pageContext.request.contextPath}/price" target="_blank" rel="noopener" class="btn btn-sm btn-light fw-semibold"><i class="bi bi-box-arrow-up-right me-1"></i>View public page</a>
            </div>
        </div>
    </section>

    <c:if test="${not empty success}">
        <div class="alert alert-success shadow-sm"><i class="bi bi-check-circle me-2"></i><c:out value="${success}" /></div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger shadow-sm"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${error}" /></div>
    </c:if>

    <div class="row g-4 mb-4">
        <div class="col-lg-6">
            <section class="panel h-100">
                <div class="panel-head">
                    <h2 class="h6 fw-bold mb-1">Standard consultation fee</h2>
                    <p class="small mb-0" style="color:#5b6b82;">Used when no doctor-specific consultation fee is approved.</p>
                </div>
                <div class="p-4">
                    <form action="${pageContext.request.contextPath}/admin/pricing/consultation" method="post" class="d-flex flex-column flex-sm-row align-items-sm-end gap-3">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div>
                            <label class="soft-label d-block mb-1">Amount (INR)</label>
                            <div class="input-group fee-input">
                                <span class="input-group-text">₹</span>
                                <input type="number" class="form-control" name="consultationFee" value="${consultationFee}" min="0" max="1000000" step="0.01" required>
                            </div>
                        </div>
                        <button type="submit" class="btn text-white fw-semibold" style="background:#0f766e;border-color:#0f766e;"><i class="bi bi-check2 me-1"></i>Save fee</button>
                    </form>
                </div>
            </section>
        </div>
        <div class="col-lg-6">
            <section class="panel h-100">
                <div class="panel-head">
                    <h2 class="h6 fw-bold mb-1">Add a treatment</h2>
                    <p class="small mb-0" style="color:#5b6b82;">New treatments appear on the home, services, pricing and booking pages.</p>
                </div>
                <div class="p-4">
                    <form action="${pageContext.request.contextPath}/admin/pricing/save" method="post" class="row g-2">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="col-sm-6">
                            <label class="soft-label d-block mb-1">Treatment name</label>
                            <input type="text" class="form-control" name="serviceName" maxlength="120" required placeholder="e.g. Wisdom Tooth Removal">
                        </div>
                        <div class="col-sm-6">
                            <label class="soft-label d-block mb-1">Fee (INR)</label>
                            <div class="input-group">
                                <span class="input-group-text">₹</span>
                                <input type="number" class="form-control" name="fee" min="0" max="1000000" step="0.01" required placeholder="2500">
                            </div>
                        </div>
                        <div class="col-12">
                            <label class="soft-label d-block mb-1">Short description</label>
                            <textarea class="form-control" name="description" rows="2" maxlength="600" placeholder="What the treatment includes and who it is for."></textarea>
                        </div>
                        <div class="col-12 d-flex justify-content-between align-items-center">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="active" value="true" id="newActive" checked>
                                <label class="form-check-label small fw-semibold" for="newActive">Show on public site</label>
                            </div>
                            <button type="submit" class="btn text-white fw-semibold" style="background:#0f766e;border-color:#0f766e;"><i class="bi bi-plus-lg me-1"></i>Add treatment</button>
                        </div>
                    </form>
                </div>
            </section>
        </div>
    </div>

    <section class="panel">
        <div class="panel-head d-flex flex-column flex-sm-row justify-content-between gap-2">
            <div>
                <h2 class="h6 fw-bold mb-1">Treatment catalogue</h2>
                <p class="small mb-0" style="color:#5b6b82;">Hidden treatments stay in your records but disappear from patient pages and the booking form.</p>
            </div>
            <span class="small fw-semibold" style="color:#52627a;">${fn:length(servicePrices)} treatment(s)</span>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th class="ps-4">Treatment</th>
                    <th>Fee</th>
                    <th>Visibility</th>
                    <th>Last updated</th>
                    <th class="text-end pe-4">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="sp" items="${servicePrices}">
                    <tr>
                        <td class="ps-4" style="min-width:230px;">
                            <div class="fw-semibold"><c:out value="${sp.serviceName}" /></div>
                            <c:if test="${not empty sp.description}"><div class="desc"><c:out value="${sp.description}" /></div></c:if>
                        </td>
                        <td class="fw-bold" style="color:#0b5d57;white-space:nowrap;">
                            ₹<fmt:formatNumber value="${sp.fee}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${sp.active}"><span class="pill pill-on"><i class="bi bi-eye me-1"></i>Visible</span></c:when>
                                <c:otherwise><span class="pill pill-off"><i class="bi bi-eye-slash me-1"></i>Hidden</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="small" style="color:#5b6b82;">
                            <c:choose>
                                <c:when test="${not empty sp.updatedAt}"><c:out value="${sp.updatedAt}" /></c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end pe-4" style="white-space:nowrap;">
                            <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#edit-${sp.id}" title="Edit treatment"><i class="bi bi-pencil"></i></button>
                            <form action="${pageContext.request.contextPath}/admin/pricing/toggle" method="post" class="d-inline">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="hidden" name="id" value="${sp.id}" />
                                <button type="submit" class="btn btn-sm ${sp.active ? 'btn-outline-warning' : 'btn-outline-success'}" title="${sp.active ? 'Hide' : 'Show'}">
                                    <i class="bi ${sp.active ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin/pricing/delete" method="post" class="d-inline" onsubmit="return confirm('Remove this treatment from the catalogue? Existing appointments are not changed.');">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="hidden" name="id" value="${sp.id}" />
                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete"><i class="bi bi-trash"></i></button>
                            </form>
                        </td>
                    </tr>

                </c:forEach>
                <c:if test="${empty servicePrices}">
                    <tr><td colspan="5" class="text-center py-5" style="color:#5b6b82;">No treatments yet. Add your first treatment above.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </section>

    <c:forEach var="sp" items="${servicePrices}">
            <div class="modal fade" id="edit-${sp.id}" tabindex="-1" aria-labelledby="editLabel-${sp.id}" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content" style="border-radius:1rem;">
                                <form action="${pageContext.request.contextPath}/admin/pricing/save" method="post">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <input type="hidden" name="id" value="${sp.id}" />
                                    <div class="modal-header">
                                        <h5 class="modal-title h6 fw-bold" id="editLabel-${sp.id}">Edit treatment</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label class="soft-label d-block mb-1">Treatment name</label>
                                            <input type="text" class="form-control" name="serviceName" value="<c:out value='${sp.serviceName}' />" maxlength="120" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="soft-label d-block mb-1">Fee (INR)</label>
                                            <div class="input-group fee-input">
                                                <span class="input-group-text">₹</span>
                                                <input type="number" class="form-control" name="fee" value="${sp.fee}" min="0" max="1000000" step="0.01" required>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="soft-label d-block mb-1">Short description</label>
                                            <textarea class="form-control" name="description" rows="3" maxlength="600"><c:out value="${sp.description}" /></textarea>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="active" value="true" id="active-${sp.id}" ${sp.active ? 'checked' : ''}>
                                            <label class="form-check-label small fw-semibold" for="active-${sp.id}">Show on public site</label>
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

    <div class="alert mt-4 mb-0" style="background:#eef6ff;border:1px solid #cfe2ff;color:#123c69;">
        <i class="bi bi-info-circle me-2"></i>
        Doctor-specific approved fees override these standard prices. Existing appointments keep the amount charged when they were booked; pending unpaid bookings are refreshed automatically when a doctor fee is approved.
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
