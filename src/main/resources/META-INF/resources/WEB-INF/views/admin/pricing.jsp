<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>
<div class="container-fluid py-4 px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Pricing Management</h4>
            <p class="text-muted mb-0">Manage clinic service pricing.</p>
        </div>
    </div>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-body text-center py-5">
                    <h5>Teeth Whitening</h5>
                    <h2 class="text-primary">₹ 2999</h2>
                    <p class="text-muted">Current Price</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-body text-center py-5">
                    <h5>Dental Implants</h5>
                    <h2 class="text-primary">₹ 4999</h2>
                    <p class="text-muted">Current Price</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-body text-center py-5">
                    <h5>Root Canal Treatment</h5>
                    <h2 class="text-primary">₹ 8999</h2>
                    <p class="text-muted">Current Price</p>
                </div>
            </div>
        </div>
    </div>
    <div class="alert alert-info mt-4">Prices are updated on the website. Contact system admin to change pricing values.</div>
</div>
</body>
</html>
