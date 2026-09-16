<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit Appointment - Admin Panel</title>
</head>
<body>
    <h1>Edit Appointment</h1>

    <form action="${pageContext.request.contextPath}/admin/appointments/update" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="id" value="${appointment.id}" />

        <label>Patient Name:</label>
        <input type="text" name="patientName" value="${appointment.patientName}" required /><br/><br/>

        <label>Email:</label>
        <input type="email" name="email" value="${appointment.email}" required /><br/><br/>

        <label>Phone:</label>
        <input type="text" name="phone" value="${appointment.phone}" required /><br/><br/>

        <label>Doctor Name:</label>
        <input type="text" name="doctorName" value="${appointment.doctorName}" required /><br/><br/>

        <label>Service:</label>
        <input type="text" name="service" value="${appointment.service}" required /><br/><br/>

        <label>Date:</label>
        <input type="date" name="appointmentDate" value="${appointment.appointmentDate}" required /><br/><br/>

        <label>Time:</label>
        <input type="time" name="appointmentTime" value="${appointment.appointmentTime}" required /><br/><br/>

        <button type="submit">Update Appointment</button>
    </form>

    <br/>
    <a href="${pageContext.request.contextPath}/admin/appointments">Back to Appointment List</a>
</body>
</html>
