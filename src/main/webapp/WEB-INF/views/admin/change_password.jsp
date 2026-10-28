<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="activePage" value="profile" />
<sec:authorize access="hasRole('DOCTOR')"><c:set var="staffRoot" value="/doctor" /></sec:authorize>
<sec:authorize access="hasRole('ADMIN')"><c:set var="staffRoot" value="/admin" /></sec:authorize>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Staff Password - DentCare</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .password-card { max-width: 560px; margin: 2.5rem auto; border: 0; border-radius: 1rem; box-shadow: 0 12px 35px rgba(16,39,73,.08); }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>
<main class="container px-3">
    <section class="card password-card">
        <div class="card-body p-4 p-lg-5">
            <div class="mb-4"><i class="bi bi-shield-lock fs-2 text-primary"></i><h1 class="h4 fw-bold mt-2">Change password</h1><p class="text-muted mb-0">Confirm your current password before choosing a new one.</p></div>
            <c:if test="${not empty error}"><div class="alert alert-danger" role="alert"><c:out value="${error}" /></div></c:if>
            <c:if test="${not empty success}"><div class="alert alert-success" role="status"><c:out value="${success}" /></div></c:if>
            <form action="${pageContext.request.contextPath}${staffRoot}/change-password" method="post" id="passwordForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="mb-3"><label class="form-label" for="currentPassword">Current password</label><input class="form-control" id="currentPassword" name="currentPassword" type="password" autocomplete="current-password" required /></div>
                <div class="mb-3"><label class="form-label" for="newPassword">New password</label><input class="form-control" id="newPassword" name="newPassword" type="password" minlength="8" autocomplete="new-password" required /><div class="form-text">At least 8 characters.</div></div>
                <div class="mb-4"><label class="form-label" for="confirmPassword">Confirm new password</label><input class="form-control" id="confirmPassword" name="confirmPassword" type="password" minlength="8" autocomplete="new-password" required /></div>
                <div class="d-flex justify-content-between gap-2"><a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}${staffRoot}/profile">Back to profile</a><button class="btn btn-primary" type="submit">Update password</button></div>
            </form>
        </div>
    </section>
</main>
<script>
document.getElementById('passwordForm').addEventListener('submit', function (event) {
    const next = document.getElementById('newPassword').value;
    if (next !== document.getElementById('confirmPassword').value) {
        event.preventDefault();
        document.getElementById('confirmPassword').setCustomValidity('Passwords do not match.');
        document.getElementById('confirmPassword').reportValidity();
    }
});
document.getElementById('confirmPassword').addEventListener('input', function () { this.setCustomValidity(''); });
</script>
</body>
</html>
