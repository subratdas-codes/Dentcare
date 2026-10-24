<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="dashboard" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - DentCare</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .welcome { background: linear-gradient(120deg, #102749, #087fa8); color: #fff; border-radius: 1.25rem; }
        .metric, .appointments { border: 0; border-radius: 1rem; box-shadow: 0 12px 35px rgba(16, 39, 73, .08); }
        .metric-icon { width: 3rem; height: 3rem; display: grid; place-items: center; border-radius: .9rem; font-size: 1.25rem; }
        .table thead th { white-space: nowrap; color: #61718a; font-size: .75rem; letter-spacing: .04em; text-transform: uppercase; }
        @media (prefers-reduced-motion: no-preference) {
            .metric { transition: transform .18s ease, box-shadow .18s ease; }
            .metric:hover { transform: translateY(-3px); box-shadow: 0 16px 38px rgba(16, 39, 73, .12); }
        }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>

<main class="container-fluid px-3 px-lg-4 py-4">
    <section class="welcome p-4 p-lg-5 mb-4">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
            <div>
                <div class="text-white-50 small mb-2">DOCTOR PORTAL</div>
                <h1 class="h3 fw-bold mb-2">Welcome, Dr. <c:out value="${doctor.name}" /></h1>
                <p class="mb-0 text-white-50"><c:out value="${doctor.specialization}" /> · Your assigned appointments and patients</p>
            </div>
            <a class="btn btn-light fw-semibold" href="<c:url value='/admin/appointments' />">
                <i class="bi bi-calendar-week me-2"></i>View assigned appointments
            </a>
        </div>
    </section>

    <section class="row g-3 mb-4" aria-label="Doctor statistics">
        <div class="col-sm-6 col-xl-4">
            <div class="card metric h-100"><div class="card-body d-flex align-items-center gap-3">
                <div class="metric-icon bg-primary bg-opacity-10 text-primary"><i class="bi bi-calendar-check"></i></div>
                <div><div class="text-muted small">Assigned appointments</div><div class="h3 fw-bold mb-0"><c:out value="${appointmentCount}" /></div></div>
            </div></div>
        </div>
        <div class="col-sm-6 col-xl-4">
            <div class="card metric h-100"><div class="card-body d-flex align-items-center gap-3">
                <div class="metric-icon bg-success bg-opacity-10 text-success"><i class="bi bi-people"></i></div>
                <div><div class="text-muted small">Assigned patients</div><div class="h3 fw-bold mb-0"><c:out value="${patientCount}" /></div></div>
            </div></div>
        </div>
        <div class="col-sm-6 col-xl-4">
            <div class="card metric h-100"><div class="card-body d-flex align-items-center gap-3">
                <div class="metric-icon bg-info bg-opacity-10 text-info"><i class="bi bi-person-badge"></i></div>
                <div><div class="text-muted small">Specialization</div><div class="fw-bold"><c:out value="${doctor.specialization}" /></div></div>
            </div></div>
        </div>
    </section>

    <section class="card appointments">
        <div class="card-header bg-white border-0 p-4 d-flex flex-column flex-sm-row justify-content-between gap-2">
            <div><h2 class="h5 fw-bold mb-1">My assigned patients</h2><p class="text-muted small mb-0">Only appointments assigned to your doctor account are shown.</p></div>
            <span class="badge bg-primary bg-opacity-10 text-primary align-self-sm-center"><c:out value="${appointmentCount}" /> appointment(s)</span>
        </div>
        <c:choose>
            <c:when test="${not empty appointments}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light"><tr>
                            <th class="ps-4">Patient</th><th>Contact</th><th>Service</th><th>Date</th><th>Time</th><th>Conversation</th>
                        </tr></thead>
                        <tbody>
                        <c:forEach var="appointment" items="${appointments}">
                            <tr>
                                <td class="ps-4"><div class="fw-semibold"><c:out value="${appointment.patientName}" /></div><small class="text-muted">Ref #<c:out value="${appointment.id}" /></small></td>
                                <td><div><c:out value="${appointment.phone}" /></div><small class="text-muted"><c:out value="${appointment.email}" /></small></td>
                                <td><c:out value="${appointment.service}" /></td>
                                <td><c:out value="${appointment.appointmentDate}" /></td>
                                <td><c:out value="${appointment.appointmentTime}" /></td>
                                <td><a class="btn btn-sm btn-outline-primary" href="<c:url value='/admin/doctor/appointments/${appointment.id}/chat' />"><i class="bi bi-chat-dots me-1"></i>Message</a></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 px-3">
                    <i class="bi bi-calendar2-x display-5 text-muted" aria-hidden="true"></i>
                    <h3 class="h6 fw-bold mt-3">No assigned appointments yet</h3>
                    <p class="text-muted mb-0">New appointments assigned to your doctor account will appear here.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>
</body>
</html>
