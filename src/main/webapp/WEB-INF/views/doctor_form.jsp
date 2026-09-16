<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${doctor.id == null ? "Add" : "Edit"} Doctor</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<c:url value='/css/style.css' />" rel="stylesheet">
</head>
<body>

<div class="container mt-5">
    <h2 class="text-center mb-4">${doctor.id == null ? "Add" : "Edit"} Doctor</h2>

    <form action="<c:url value='/admin/doctors/save'/>" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="id" value="${doctor.id}" />

        <div class="mb-3">
            <label class="form-label">Name</label>
            <input type="text" name="name" value="${doctor.name}" class="form-control" required />
        </div>

        <div class="mb-3">
            <label class="form-label">Specialization</label>
            <input type="text" name="specialization" value="${doctor.specialization}" class="form-control" required />
        </div>

        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" value="${doctor.email}" class="form-control" required />
        </div>

        <div class="mb-3">
            <label class="form-label">Phone</label>
            <input type="text" name="phone" value="${doctor.phone}" class="form-control" required />
        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" value="${doctor.password}" class="form-control" required />
        </div>

        <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="adminCheck" name="admin"
                   <c:if test="${doctor.admin}">checked</c:if> />
            <label class="form-check-label" for="adminCheck">Is Admin</label>
        </div>

        <div class="text-end">
            <button type="submit" class="btn btn-success">Save</button>
            <a href="<c:url value='/admin/doctors'/>" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

</body>
</html>
