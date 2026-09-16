<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor List - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4 text-center">Doctor Management</h2>

    <div class="text-end mb-3">
        <a href="<c:url value='/admin/doctors/add' />" class="btn btn-primary">+ Add New Doctor</a>
    </div>

    <c:if test="${not empty doctors}">
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Specialization</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="doctor" items="${doctors}">
                <tr>
                    <td>${doctor.id}</td>
                    <td>${doctor.name}</td>
                    <td>${doctor.specialization}</td>
                    <td>${doctor.email}</td>
                    <td>${doctor.phone}</td>
                    <td>
                        <c:choose>
                            <c:when test="${doctor.admin}">
                                <span class="badge bg-success">Admin</span>
                            </c:when>
                            <c:otherwise>
                                Doctor
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="<c:url value='/admin/doctors/edit/${doctor.id}' />" class="btn btn-sm btn-warning">Edit</a>
                        <a href="<c:url value='/admin/doctors/delete/${doctor.id}' />" 
                           class="btn btn-sm btn-danger" 
                           onclick="return confirm('Are you sure you want to delete this doctor?');">Delete</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty doctors}">
        <div class="alert alert-info">No doctors available.</div>
    </c:if>
</div>

</body>
</html>
