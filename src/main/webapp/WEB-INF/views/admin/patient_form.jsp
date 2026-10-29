<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="patients" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${patient.id == null ? 'Add' : 'Edit'} Patient - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .panel { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; }
        .panel-head { padding: 1rem 1.25rem; border-bottom: 1px solid #eef2f7; }
        .form-label { font-weight: 600; color: #3c4c63; font-size: .86rem; }
        .form-control { border-color: #dde5ee; border-radius: .65rem; padding: .6rem .8rem; }
        .form-control:focus { border-color: #0f766e; box-shadow: 0 0 0 .18rem rgba(15,118,110,.12); }
        .btn-teal { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 700; }
        .btn-teal:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
        .note { background: #f4faf8; border: 1px solid #d9ede9; border-radius: .75rem; padding: .85rem 1rem; color: #315b56; font-size: .84rem; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<div class="container py-4 py-lg-5" style="max-width: 900px;">
    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-4">
        <div>
            <h1 class="h4 fw-bold mb-1">${patient.id == null ? 'Add a patient' : 'Edit patient'}</h1>
            <p class="text-muted mb-0">${patient.id == null ? 'Create a patient account with a secure password.' : 'Update contact details or reset the password.'}</p>
        </div>
        <a href="<c:url value='/admin/patients' />" class="btn btn-outline-secondary"><i class="bi bi-arrow-left me-1"></i>Back</a>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}" /></div></c:if>
    <c:if test="${not empty success}"><div class="alert alert-success"><c:out value="${success}" /></div></c:if>

    <section class="panel mb-4">
        <div class="panel-head"><h2 class="h6 fw-bold mb-0">Personal details</h2></div>
        <div class="p-4">
            <form action="<c:url value='/admin/patients/save' />" method="post" class="row g-3">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <c:if test="${patient.id != null}"><input type="hidden" name="id" value="${patient.id}" /></c:if>
                <div class="col-md-7">
                    <label class="form-label" for="patientName">Full name</label>
                    <input id="patientName" name="name" class="form-control" value="<c:out value='${patient.name}' />" maxlength="120" required />
                </div>
                <div class="col-md-5">
                    <label class="form-label" for="patientAge">Age</label>
                    <input id="patientAge" name="age" type="number" min="0" max="120" class="form-control" value="${patient.age}" />
                </div>
                <div class="col-md-7">
                    <label class="form-label" for="patientEmail">Email (login)</label>
                    <input id="patientEmail" name="email" type="email" class="form-control" value="<c:out value='${patient.email}' />" maxlength="120" required />
                </div>
                <div class="col-md-5">
                    <label class="form-label" for="patientPhone">Phone</label>
                    <input id="patientPhone" name="phone" class="form-control" value="<c:out value='${patient.phone}' />" maxlength="40" />
                </div>
                <div class="col-12">
                    <label class="form-label" for="patientPassword">${patient.id == null ? 'Password' : 'New password (optional)'}</label>
                    <input id="patientPassword" name="password" type="password" class="form-control" minlength="8" autocomplete="new-password" ${patient.id == null ? 'required' : ''} />
                    <div class="form-text">At least 8 characters. ${patient.id == null ? '' : 'Leave blank to keep the current password.'}</div>
                </div>
                <div class="col-12 d-flex justify-content-end gap-2 mt-2">
                    <a href="<c:url value='/admin/patients' />" class="btn btn-light border">Cancel</a>
                    <button class="btn btn-teal px-4" type="submit"><i class="bi bi-check2-circle me-1"></i>Save patient</button>
                </div>
            </form>
        </div>
    </section>

    <c:if test="${patient.id != null}">
        <section class="panel">
            <div class="panel-head"><h2 class="h6 fw-bold mb-0">Reset password</h2></div>
            <div class="p-4">
                <div class="note mb-3"><i class="bi bi-shield-lock me-1"></i>Use this when a patient cannot access the reset email. The new password takes effect immediately.</div>
                <form action="${pageContext.request.contextPath}/admin/patients/reset-password/${patient.id}" method="post" class="row g-3 align-items-end">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <div class="col-md-8">
                        <label class="form-label" for="resetPassword">New password</label>
                        <input id="resetPassword" name="newPassword" type="password" class="form-control" minlength="8" autocomplete="new-password" required>
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-outline-secondary w-100"><i class="bi bi-arrow-repeat me-1"></i>Reset password</button>
                    </div>
                </form>
            </div>
        </section>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
