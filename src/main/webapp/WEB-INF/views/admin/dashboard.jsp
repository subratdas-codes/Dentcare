<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center mb-4">Welcome Admin (Doctor)</h2>

    <div class="row text-center">
        <div class="col-md-4">
            <div class="card p-3">
                <h4>Total Doctors</h4>
                <p>${doctorCount}</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3">
                <h4>Total Patients</h4>
                <p>${patientCount}</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3">
                <h4>Total Appointments</h4>
                <p>${appointmentCount}</p>
            </div>
        </div>
    </div>

    <div class="mt-4 text-center">
        <a href="<c:url value='/admin/doctors'/>" class="btn btn-primary">Manage Doctors</a>
        <a href="<c:url value='/admin/patients'/>" class="btn btn-secondary">Manage Patients</a>
        <a href="<c:url value='/admin/appointments'/>" class="btn btn-success">View Appointments</a>
    </div>
</div>
</body>
</html>
