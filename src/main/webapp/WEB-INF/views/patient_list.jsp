<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient List - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4 text-center">Patient Management</h2>

    <div class="text-end mb-3">
        <a href="<c:url value='/admin/dashboard' />" class="btn btn-secondary">Back to Dashboard</a>
    </div>

    <c:if test="${not empty patients}">
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Age</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${patients}">
                <tr>
                    <td>${p.id}</td>
                    <td>${p.name}</td>
                    <td>${p.email}</td>
                    <td>${p.phone}</td>
                    <td>${p.age}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty patients}">
        <div class="alert alert-info">No patients registered yet.</div>
    </c:if>
</div>

</body>
</html>