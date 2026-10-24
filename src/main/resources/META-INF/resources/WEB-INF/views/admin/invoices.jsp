<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="invoices" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoices - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f6f8fc; }
        .card { border: none; border-radius: 1rem; overflow: hidden; box-shadow: 0 40px 70px -50px rgba(15, 31, 58, 0.9); }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>
<div class="container-fluid py-4 px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Invoice Management</h4>
            <p class="text-muted mb-0">Generate and track invoices for appointments.</p>
        </div>
    </div>
    <div class="card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                <tr>
                    <th class="text-uppercase small text-muted">Appointment ID</th>
                    <th class="text-uppercase small text-muted">Patient</th>
                    <th class="text-uppercase small text-muted">Doctor</th>
                    <th class="text-uppercase small text-muted">Service</th>
                    <th class="text-uppercase small text-muted">Date</th>
                    <th class="text-uppercase small text-muted">Status</th>
                    <th class="text-uppercase small text-muted text-center">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="a" items="${appointments}">
                    <tr>
                        <td>#${a.id}</td>
                        <td>${a.patientName}</td>
                        <td>${a.doctorName}</td>
                        <td>${a.service}</td>
                        <td>${a.appointmentDate}</td>
                        <td><span class="badge bg-warning bg-opacity-10 text-warning">Pending</span></td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-primary" disabled>Generate Invoice</button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty appointments}">
                    <tr>
                        <td colspan="7" class="text-center py-4 text-muted">No appointments to invoice.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
