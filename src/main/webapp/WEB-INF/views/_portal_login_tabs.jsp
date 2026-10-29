<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activeLoginPortal" value="${not empty loginPortal ? loginPortal : (not empty selectedRole ? selectedRole : 'ADMIN')}" />
<div class="dc-portal-switch" role="group" aria-label="Choose staff portal">
    <a href="<c:url value='/doctor/login' />" class="dc-portal-switch-link ${activeLoginPortal == 'DOCTOR' ? 'active' : ''}">
        <i class="fas fa-user-md" aria-hidden="true"></i><span>Doctor</span>
    </a>
    <a href="<c:url value='/admin/login' />" class="dc-portal-switch-link ${activeLoginPortal == 'ADMIN' ? 'active' : ''}">
        <i class="fas fa-user-shield" aria-hidden="true"></i><span>Admin</span>
    </a>
</div>
<style>
    .dc-portal-switch { display: grid; grid-template-columns: repeat(2, 1fr); gap: .35rem; background: #eef4f8; border: 1px solid #d7e3ec; border-radius: .8rem; padding: .3rem; margin-bottom: 1.35rem; }
    .dc-portal-switch-link { display: block; text-align: center; padding: .5rem .3rem; border-radius: .6rem; color: #334155; font-weight: 700; font-size: .85rem; line-height: 1.2; text-decoration: none; }
    .dc-portal-switch-link i { display: block; font-size: 1rem; margin-bottom: .18rem; }
    .dc-portal-switch-link:hover, .dc-portal-switch-link:focus { background: #e2e8f0; color: #0f766e; }
    .dc-portal-switch-link.active { background: #0f766e; color: #fff; box-shadow: 0 4px 10px rgba(15, 118, 110, .25); }
    .dc-portal-switch-link.active:hover, .dc-portal-switch-link.active:focus { background: #0b5d57; color: #fff; }
</style>
