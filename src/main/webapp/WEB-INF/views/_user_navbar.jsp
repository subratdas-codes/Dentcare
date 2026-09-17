<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<nav class="navbar navbar-expand-lg bg-white navbar-light shadow-sm px-4 px-lg-5 py-2">
    <a href="${pageContext.request.contextPath}/" class="navbar-brand p-0">
        <h1 class="m-0 text-primary fs-3 fw-bold"><i class="fa fa-tooth me-2"></i>DentCare</h1>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#userNav">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="userNav">
        <div class="navbar-nav ms-auto align-items-lg-center">
            <a href="${pageContext.request.contextPath}/" class="nav-link me-lg-2 fw-semibold">Home</a>
            <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-sm btn-outline-primary me-lg-2 mb-2 mb-lg-0 mt-2 mt-lg-0">
                <i class="fa fa-calendar-plus me-1"></i>Book Appointment
            </a>
            <sec:authorize access="isAuthenticated()">
                <c:choose>
                    <c:when test="${hasAdminRole}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-primary me-lg-2 mb-2 mb-lg-0 mt-2 mt-lg-0">
                            <i class="fa fa-lock me-1"></i>Admin Dashboard
                        </a>
                    </c:when>
                    <c:otherwise>
                        <div class="nav-item dropdown">
                            <a href="#" class="nav-link dropdown-toggle fw-semibold" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle me-1"></i><sec:authentication property="name" />
                            </a>
                            <div class="dropdown-menu dropdown-menu-end shadow">
                                <a href="${pageContext.request.contextPath}/profile" class="dropdown-item">Profile</a>
                                <a href="${pageContext.request.contextPath}/my/appointments" class="dropdown-item">My Appointments</a>
                                <a href="${pageContext.request.contextPath}/change-password" class="dropdown-item">Change Password</a>
                                <div class="dropdown-divider"></div>
                                <form action="${pageContext.request.contextPath}/logout" method="post" class="m-0">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="dropdown-item text-danger">Logout</button>
                                </form>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </sec:authorize>
            
        </div>
    </div>
</nav>