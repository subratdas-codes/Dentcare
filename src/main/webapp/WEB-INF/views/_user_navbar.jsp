<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
<style>
    .dc-nav { background: #ffffff; border-bottom: 1px solid #e7ecf3; position: sticky; top: 0; z-index: 1030; }
    .dc-nav .navbar-brand { color: #10243e; font-weight: 800; letter-spacing: -0.02em; }
    .dc-nav .navbar-brand span { color: #0f766e; }
    .dc-nav .nav-link { color: #44546a; font-weight: 600; font-size: .95rem; }
    .dc-nav .nav-link:hover, .dc-nav .nav-link:focus { color: #0f766e; }
    .dc-nav .navbar-toggler { border: 1px solid #cfdae6; border-radius: .55rem; padding: .38rem .55rem; }
    .dc-nav .navbar-toggler:focus { box-shadow: 0 0 0 .2rem rgba(15, 118, 110, .2); }
    .dc-nav .navbar-toggler-icon { width: 1.4em; height: 1.4em; background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='%2310243e' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e"); background-repeat: no-repeat; background-position: center; background-size: 100%; }
    .dc-nav .btn-book { background: #0f766e; border-color: #0f766e; color: #fff; font-weight: 600; border-radius: .65rem; }
    .dc-nav .btn-book:hover { background: #0b5d57; border-color: #0b5d57; color: #fff; }
    .dc-avatar { width: 34px; height: 34px; border-radius: 50%; background: #e6f4f1; color: #0f766e; display: inline-flex; align-items: center; justify-content: center; font-weight: 800; font-size: .9rem; }
    .dc-user-name { color: #10243e; font-weight: 700; max-width: 170px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    .dc-dropdown { border: 1px solid #e7ecf3; border-radius: .8rem; box-shadow: 0 18px 40px -24px rgba(16, 36, 62, .55); padding: .45rem; min-width: 230px; }
    .dc-dropdown .dropdown-item { border-radius: .55rem; padding: .55rem .75rem; font-weight: 500; color: #34445c; }
    .dc-dropdown .dropdown-item:hover { background: #f2f8f7; color: #0f766e; }
    .dc-dropdown .dropdown-header { color: #52627a; font-size: .72rem; text-transform: uppercase; letter-spacing: .06em; }
    .dc-announce { background: #0f766e; color: #ffffff; font-size: .82rem; text-align: center; padding: .35rem .75rem; }
    @media (max-width: 991.98px) {
        .dc-nav .navbar-collapse { background: #ffffff; border: 1px solid #e7ecf3; border-radius: .85rem; box-shadow: 0 18px 40px -24px rgba(16, 36, 62, .45); margin-top: .65rem; padding: .35rem .9rem .9rem; }
        .dc-nav .navbar-nav .nav-item { border-top: 1px solid #eef2f7; }
        .dc-nav .navbar-nav .nav-item:first-child { border-top: 0; }
        .dc-nav .navbar-nav .nav-link { padding: .7rem .15rem; }
        .dc-nav .navbar-nav .btn { width: 100%; margin-top: .4rem; }
    }
</style>
<c:if test="${not empty site.announcement}">
    <div class="dc-announce"><c:out value="${site.announcement}" /></div>
</c:if>
<nav class="navbar navbar-expand-lg dc-nav px-3 px-lg-4 py-2">
    <a href="${pageContext.request.contextPath}/" class="navbar-brand p-0 fs-4">
        <i class="fa fa-tooth me-1"></i><span><c:out value="${site.siteName}" /></span>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#userNav" aria-controls="userNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="userNav">
        <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-1">
            <li class="nav-item"><a href="${pageContext.request.contextPath}/" class="nav-link"><c:out value="${site.navHome}" /></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/service" class="nav-link"><c:out value="${site.navServices}" /></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/team" class="nav-link"><c:out value="${site.navDoctors}" /></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/price" class="nav-link"><c:out value="${site.navPricing}" /></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/contact" class="nav-link"><c:out value="${site.navContact}" /></a></li>
            <sec:authorize access="hasRole('USER')">
                <li class="nav-item ms-lg-2 mt-2 mt-lg-0">
                    <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-book btn-sm px-3 py-2">
                        <c:out value="${site.bookButton}" />
                    </a>
                </li>
                <li class="nav-item dropdown ms-lg-2 mt-2 mt-lg-0">
                    <a href="#" class="nav-link dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown" aria-expanded="false">
                        <span class="dc-avatar">${currentPatientInitial}</span>
                        <span class="dc-user-name"><c:out value="${currentPatientName}" /></span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-end dc-dropdown">
                        <div class="dropdown-header"><c:out value="${site.accountLabel}" /></div>
                        <a href="${pageContext.request.contextPath}/my/appointments" class="dropdown-item">My Appointments</a>
                        <a href="${pageContext.request.contextPath}/my/receipts" class="dropdown-item">Receipts &amp; Payments</a>
                        <a href="${pageContext.request.contextPath}/profile" class="dropdown-item">Personal Details</a>
                        <a href="${pageContext.request.contextPath}/profile?tab=security" class="dropdown-item">Change Password</a>
                        <div class="dropdown-divider"></div>
                        <form action="${pageContext.request.contextPath}/logout" method="post" class="m-0">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <input type="hidden" name="portal" value="PATIENT" />
                            <button type="submit" class="dropdown-item text-danger">Logout</button>
                        </form>
                    </div>
                </li>
            </sec:authorize>
            <sec:authorize access="!isAuthenticated()">
                <li class="nav-item ms-lg-2 mt-2 mt-lg-0"><a href="${pageContext.request.contextPath}/login" class="nav-link">Login</a></li>
                <li class="nav-item ms-lg-2 mt-2 mt-lg-0"><a href="${pageContext.request.contextPath}/register" class="btn btn-outline-secondary btn-sm px-3 py-2" style="border-radius:.65rem;font-weight:600;">Register</a></li>
            </sec:authorize>
        </ul>
    </div>
</nav>
