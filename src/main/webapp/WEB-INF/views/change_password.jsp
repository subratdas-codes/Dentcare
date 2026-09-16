<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<c:url value='/css/style.css' />" rel="stylesheet">
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4 text-center">Change Password</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <div class="row justify-content-center">
        <div class="col-md-6">
            <form method="post" action="<c:url value='/change-password' />">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="mb-3">
                    <label>Old Password</label>
                    <input type="password" class="form-control" name="oldPassword" required />
                </div>
                <div class="mb-3">
                    <label>New Password</label>
                    <input type="password" class="form-control" name="newPassword" required />
                </div>
                <div class="mb-3">
                    <label>Confirm New Password</label>
                    <input type="password" class="form-control" name="confirmPassword" required />
                </div>
                <button type="submit" class="btn btn-primary">Change Password</button>
                <a href="/" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </div>
</div>

</body>
</html>