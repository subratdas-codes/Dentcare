<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm px-4 py-2">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand fw-bold">
        <i class="bi bi-shield-lock-fill me-2"></i>DentCare Admin
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="adminNav">
        <ul class="navbar-nav ms-auto align-items-lg-center">
            <li class="nav-item">
                <a class="nav-link ${activePage == 'dashboard' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-speedometer2 me-1"></i>Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'doctors' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/doctors">
                    <i class="bi bi-person-badge me-1"></i>Doctors
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'patients' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/patients">
                    <i class="bi bi-people me-1"></i>Patients
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'appointments' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/appointments">
                    <i class="bi bi-calendar-check me-1"></i>Appointments
                </a>
            </li>
            <li class="nav-item ms-lg-3">
                <a class="btn btn-light btn-sm fw-semibold" href="${pageContext.request.contextPath}/">
                    <i class="bi bi-globe me-1"></i>View Website
                </a>
            </li>
            <li class="nav-item ms-lg-2">
                <form action="${pageContext.request.contextPath}/logout" method="post" class="m-0">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit" class="btn btn-outline-light btn-sm fw-semibold">
                        <i class="bi bi-box-arrow-right me-1"></i>Logout
                    </button>
                </form>
            </li>
        </ul>
    </div>
</nav>