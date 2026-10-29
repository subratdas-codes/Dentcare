<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<nav class="navbar navbar-expand-xl navbar-dark shadow-sm px-4 py-2" style="background: linear-gradient(90deg, #0f1f3a 0%, #0b6f8f 100%);">
    <sec:authorize access="hasRole('ADMIN')"><a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand fw-bold d-flex align-items-center gap-2"><i class="fa fa-tooth"></i><span>DentCare Admin</span></a></sec:authorize>
    <sec:authorize access="hasRole('DOCTOR')"><a href="${pageContext.request.contextPath}/doctor/dashboard" class="navbar-brand fw-bold d-flex align-items-center gap-2"><i class="fa fa-tooth"></i><span>DentCare Doctor</span></a></sec:authorize>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="adminNav">
        <ul class="navbar-nav ms-auto align-items-xl-center gap-xl-1">
            <li class="nav-item">
                <sec:authorize access="hasRole('ADMIN')"><a class="nav-link px-3 ${activePage == 'dashboard' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-1"></i>Dashboard</a></sec:authorize>
                <sec:authorize access="hasRole('DOCTOR')"><a class="nav-link px-3 ${activePage == 'dashboard' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/doctor/dashboard"><i class="bi bi-speedometer2 me-1"></i>Dashboard</a></sec:authorize>
            </li>
            <sec:authorize access="hasRole('ADMIN')">
                <li class="nav-item"><a class="nav-link px-3 ${activePage == 'doctors' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/doctors"><i class="bi bi-person-badge me-1"></i>Doctors</a></li>
                <li class="nav-item"><a class="nav-link px-3 ${activePage == 'patients' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/patients"><i class="bi bi-people me-1"></i>Patients</a></li>
            </sec:authorize>
            <li class="nav-item">
                <sec:authorize access="hasRole('ADMIN')"><a class="nav-link px-3 ${activePage == 'appointments' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/appointments"><i class="bi bi-calendar-check me-1"></i>Appointments</a></sec:authorize>
                <sec:authorize access="hasRole('DOCTOR')"><a class="nav-link px-3 ${activePage == 'appointments' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/doctor/appointments"><i class="bi bi-calendar-check me-1"></i>My Patients</a></sec:authorize>
            </li>
            <sec:authorize access="hasRole('ADMIN')">
                <li class="nav-item"><a class="nav-link px-3 ${activePage == 'pricing' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/pricing"><i class="bi bi-currency-rupee me-1"></i>Treatment Fees</a></li>
                <li class="nav-item">
                    <a class="nav-link px-3 ${activePage == 'doctorFees' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/doctor-fees">
                        <i class="bi bi-clipboard2-check me-1"></i>Doctor Fees
                        <c:if test="${pendingFeeCount > 0}"><span class="badge bg-warning text-dark ms-1">${pendingFeeCount}</span></c:if>
                    </a>
                </li>
                <li class="nav-item"><a class="nav-link px-3 ${activePage == 'invoices' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/invoices"><i class="bi bi-receipt me-1"></i>Invoices</a></li>
                <li class="nav-item"><a class="nav-link px-3 ${activePage == 'settings' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/admin/settings"><i class="bi bi-sliders me-1"></i>Website</a></li>
            </sec:authorize>
            <sec:authorize access="hasRole('DOCTOR')">
                <li class="nav-item"><a class="nav-link px-3 ${activePage == 'fees' ? 'active fw-semibold' : ''}" href="${pageContext.request.contextPath}/doctor/fees"><i class="bi bi-currency-rupee me-1"></i>My Fees</a></li>
            </sec:authorize>
            <li class="nav-item">
                <sec:authorize access="hasRole('ADMIN')"><a class="nav-link px-3" href="${pageContext.request.contextPath}/admin/profile"><i class="bi bi-person-circle me-1"></i>My Profile</a></sec:authorize>
                <sec:authorize access="hasRole('DOCTOR')"><a class="nav-link px-3" href="${pageContext.request.contextPath}/doctor/profile"><i class="bi bi-person-circle me-1"></i>My Profile</a></sec:authorize>
            </li>
            <li class="nav-item ms-xl-2">
                <a class="btn btn-light btn-sm fw-semibold" href="${pageContext.request.contextPath}/" target="_blank" rel="noopener">
                    <i class="bi bi-globe me-1"></i>Website
                </a>
            </li>
            <li class="nav-item ms-xl-2">
                <form action="${pageContext.request.contextPath}/logout" method="post" class="m-0">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <sec:authorize access="hasRole('ADMIN')"><input type="hidden" name="portal" value="ADMIN" /></sec:authorize>
                    <sec:authorize access="hasRole('DOCTOR')"><input type="hidden" name="portal" value="DOCTOR" /></sec:authorize>
                    <button type="submit" class="btn btn-outline-light btn-sm fw-semibold">
                        <i class="bi bi-box-arrow-right me-1"></i>Logout
                    </button>
                </form>
            </li>
        </ul>
    </div>
</nav>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
