<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="patients" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Patient - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .form-card { border: 0; border-radius: 1rem; box-shadow: 0 12px 35px rgba(16, 39, 73, .08); }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>
<main class="container py-4 py-lg-5" style="max-width: 760px">
    <section class="card form-card">
        <div class="card-body p-4 p-lg-5">
            <div class="d-flex justify-content-between align-items-start gap-3 mb-4">
                <div>
                    <h1 class="h4 fw-bold mb-1">Edit patient</h1>
                    <p class="text-muted mb-0">Update the patient's contact details.</p>
                </div>
                <a href="<c:url value='/admin/patients' />" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i>Back
                </a>
            </div>

            <c:if test="${not empty error}"><div class="alert alert-danger" role="alert"><c:out value="${error}" /></div></c:if>

            <form action="<c:url value='/admin/patients/save' />" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input type="hidden" name="id" value="${patient.id}" />
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label" for="patientName">Full name</label>
                        <input id="patientName" name="name" class="form-control" value="<c:out value='${patient.name}' />" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="patientEmail">Email</label>
                        <input id="patientEmail" name="email" type="email" class="form-control" value="<c:out value='${patient.email}' />" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="patientPhone">Phone</label>
                        <input id="patientPhone" name="phone" class="form-control" value="<c:out value='${patient.phone}' />" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="patientAge">Age</label>
                        <input id="patientAge" name="age" type="number" min="0" max="150" class="form-control" value="${patient.age}" />
                    </div>
                    <div class="col-12">
                        <label class="form-label" for="patientPassword">New password</label>
                        <input id="patientPassword" name="password" type="password" class="form-control" minlength="8" autocomplete="new-password" />
                        <div class="form-text">Leave blank to keep the current password.</div>
                    </div>
                </div>
                <div class="d-flex justify-content-end gap-2 mt-4">
                    <a href="<c:url value='/admin/patients' />" class="btn btn-light border">Cancel</a>
                    <button class="btn btn-primary" type="submit"><i class="bi bi-check2-circle me-1"></i>Save patient</button>
                </div>
            </form>
        </div>
    </section>
</main>
</body>
</html>
