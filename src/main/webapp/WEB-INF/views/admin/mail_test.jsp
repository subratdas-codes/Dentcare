<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="mail" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mail Test - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6fb; }
        .card { border: none; border-radius: 0.9rem; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Mail Test</h4>
            <p class="text-muted mb-0">Verify email sending (used by forgot-password & contact form).</p>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-6">
            <div class="card shadow-sm p-4">
                <h5 class="fw-bold mb-3">Configuration Status</h5>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item d-flex justify-content-between">
                        <span>SMTP configured</span>
                        <c:choose>
                            <c:when test="${configured}">
                                <span class="badge bg-success">YES</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger">NO</span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                        <span>Sender username</span>
                        <span class="text-break">${mailUsername}</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                        <span>Replies / test target</span>
                        <span>dentcare.support@gmail.com</span>
                    </li>
                </ul>
                <p class="text-muted small mt-3 mb-0">
                    If <strong>SMTP configured = NO</strong>, add <code>MAIL_USERNAME</code> and
                    <code>MAIL_PASSWORD</code> (a Google <strong>App Password</strong>, not the Gmail login
                    password) to the Render environment and re-deploy.
                </p>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card shadow-sm p-4">
                <h5 class="fw-bold mb-3">Send Test Email</h5>
                <c:if test="${not empty sendResult}">
                    <div class="alert ${sendResult.startsWith('Sent OK') ? 'alert-success' : 'alert-danger'} p-3">
                        <i class="bi ${sendResult.startsWith('Sent OK') ? 'bi-check-circle' : 'bi-exclamation-triangle'} me-1"></i>
                        ${sendResult}
                    </div>
                </c:if>
                <p class="text-muted">Sends a test mail to dentcare.support@gmail.com so you can confirm Gmail SMTP works from Render.</p>
                <form action="${pageContext.request.contextPath}/admin/mail-test/send" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-send me-1"></i>Send Test Mail
                    </button>
                </form>

                <hr class="my-4">

                <h5 class="fw-bold mb-1">Network Connectivity Check</h5>
                <p class="text-muted small mb-2">Probes which email hosts/servers this server can actually reach. Helps if emails never arrive.</p>
                <c:if test="${not empty connectResult}">
                    <div class="bg-dark text-light small p-3 rounded mb-3" style="white-space: pre-wrap; word-break: break-all;">
                        ${connectResult}
                    </div>
                </c:if>
                <form action="${pageContext.request.contextPath}/admin/mail-test/connect" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit" class="btn btn-outline-primary">
                        <i class="bi bi-plug me-1"></i>Run Connectivity Check
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>