<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="activePage" value="pricing" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pricing - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f6f8fc; }
        .card { border: none; border-radius: 1rem; box-shadow: 0 40px 70px -50px rgba(15, 31, 58, 0.9); }
        .fee-input { max-width: 160px; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>
<div class="container-fluid py-4 px-4">
    <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mb-4 gap-3">
        <div>
            <h4 class="fw-bold mb-1">Pricing Management</h4>
            <p class="text-muted mb-0">Increase or decrease appointment fees. Changes apply to new bookings immediately.</p>
        </div>
        <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2">
            <i class="bi bi-cash-coin me-1"></i>${servicePrices.size()} services
        </span>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success shadow-sm"><i class="bi bi-check-circle me-2"></i>${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger shadow-sm"><i class="bi bi-exclamation-triangle me-2"></i>${error}</div>
    </c:if>

    <div class="card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                <tr>
                    <th class="text-uppercase small text-muted">Service</th>
                    <th class="text-uppercase small text-muted">Current Fee</th>
                    <th class="text-uppercase small text-muted">Set New Fee</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="sp" items="${servicePrices}">
                    <tr>
                        <td class="fw-semibold">${sp.serviceName}</td>
                        <td class="text-primary fw-bold">
                            ₹<fmt:formatNumber value="${sp.fee}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/pricing/update" method="post" class="d-flex align-items-center gap-2">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="hidden" name="id" value="${sp.id}" />
                                <div class="input-group fee-input">
                                    <span class="input-group-text">₹</span>
                                    <input type="number" class="form-control" name="fee" value="${sp.fee}"
                                           min="0" max="1000000" step="0.01" required>
                                </div>
                                <button type="submit" class="btn btn-sm btn-primary">
                                    <i class="bi bi-check2 me-1"></i>Update
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty servicePrices}">
                    <tr>
                        <td colspan="3" class="text-center py-4 text-muted">No services configured.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <div class="alert alert-info mt-4 mb-0">
        <i class="bi bi-info-circle me-2"></i>
        Existing appointments keep the fee that was charged when they were booked. The public pricing page and the booking form use these fees.
    </div>
</div>
</body>
</html>
