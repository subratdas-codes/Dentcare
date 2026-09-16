<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>My Appointments - Dentcare</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg bg-white navbar-light shadow-sm px-5">
    <a href="/" class="navbar-brand p-0">
        <h1 class="m-0 text-primary"><i class="fa fa-tooth me-2"></i>Dentcare</h1>
    </a>
    <div class="ms-auto">
        <a href="/" class="btn btn-light">Home</a>
        <a href="/book_appointment" class="btn btn-primary">Book New</a>
        <form action="/logout" method="post" class="d-inline">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit" class="btn btn-outline-danger">Logout</button>
        </form>
    </div>
</nav>

<div class="container py-5">
    <h2 class="mb-4">My Appointments</h2>

    <div class="alert alert-light">
        Logged in as: <strong><sec:authentication property="name" /></strong>
    </div>

    <c:if test="${not empty appointments}">
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
            <tr>
                <th>#</th>
                <th>Doctor</th>
                <th>Service</th>
                <th>Date</th>
                <th>Time</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="a" items="${appointments}">
                <tr>
                    <td>${a.id}</td>
                    <td>${a.doctorName}</td>
                    <td>${a.service}</td>
                    <td>${a.appointmentDate}</td>
                    <td>${a.appointmentTime}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty appointments}">
        <div class="alert alert-info">You have no appointments yet.
            <a href="/book_appointment">Book one now</a>.
        </div>
    </c:if>
</div>
</body>
</html>