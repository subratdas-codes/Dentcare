<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<c:url value='/css/style.css' />" rel="stylesheet">
</head>
<body>

<div class="container py-5">
    <h2 class="text-center mb-4">My Profile</h2>
    <div class="row justify-content-center">
        <div class="col-md-6 bg-light p-4 rounded shadow">
            <p><strong>Name:</strong> ${patient.name}</p>
            <p><strong>Email:</strong> ${patient.email}</p>
            <p><strong>Phone:</strong> ${patient.phone}</p>
        </div>
    </div>

    <div class="row justify-content-center mt-3">
        <div class="col-md-6 text-center">
            <a href="/" class="btn btn-secondary">Back to Home</a>
        </div>
    </div>
</div>

</body>
</html>