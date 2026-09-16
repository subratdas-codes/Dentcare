<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>All Appointments - Admin Panel</title>
    <link rel="stylesheet" href="/resources/css/admin.css"> <!-- Optional CSS -->
</head>
<body>
    <h1>Appointment Management</h1>
    
    <table border="1" cellpadding="10" cellspacing="0">
        <thead>
            <tr>
                <th>ID</th>
                <th>Patient Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Doctor</th>
                <th>Service</th>
                <th>Date</th>
                <th>Time</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="appointment" items="${appointments}">
            <tr>
                <td>${appointment.id}</td>
                <td>${appointment.patientName}</td>
                <td>${appointment.email}</td>
                <td>${appointment.phone}</td>
                <td>${appointment.doctorName}</td>
                <td>${appointment.service}</td>
                <td>${appointment.appointmentDate}</td>
                <td>${appointment.appointmentTime}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/appointments/edit/${appointment.id}">Edit</a> |
                    <a href="${pageContext.request.contextPath}/admin/appointments/delete/${appointment.id}" onclick="return confirm('Are you sure you want to delete this appointment?');">Delete</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <br/>
    <a href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a>
</body>
</html>
