<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .dc-account-card { border: 1px solid #e7ecf3; border-radius: 1rem; background: #fff; overflow: hidden; }
    .dc-account-head { background: #0f766e; color: #fff; padding: 1.25rem; }
    .dc-account-avatar { width: 48px; height: 48px; border-radius: 50%; background: rgba(255,255,255,.18); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 1.1rem; }
    .dc-account-link { display: flex; align-items: center; justify-content: space-between; padding: .8rem 1rem; color: #44546a; font-weight: 600; text-decoration: none; border-left: 3px solid transparent; }
    .dc-account-link:hover { background: #f6faf9; color: #0f766e; }
    .dc-account-link.active { background: #eef8f6; border-left-color: #0f766e; color: #0f766e; }
    .dc-account-link + .dc-account-link { border-top: 1px solid #f0f3f7; }
</style>
<div class="dc-account-card mb-4">
    <div class="dc-account-head d-flex align-items-center gap-3">
        <div class="dc-account-avatar">${currentPatientInitial}</div>
        <div class="min-w-0">
            <div class="fw-bold text-truncate"><c:out value="${currentPatientName}" /></div>
            <div class="small text-white-50 text-truncate"><c:out value="${currentPatient.email}" /></div>
        </div>
    </div>
    <a href="${pageContext.request.contextPath}/my/appointments" class="dc-account-link ${activeAccount == 'appointments' ? 'active' : ''}">
        <span>My Appointments</span><span>&rsaquo;</span>
    </a>
    <a href="${pageContext.request.contextPath}/my/receipts" class="dc-account-link ${activeAccount == 'receipts' ? 'active' : ''}">
        <span>Receipts &amp; Payments</span><span>&rsaquo;</span>
    </a>
    <a href="${pageContext.request.contextPath}/profile" class="dc-account-link ${activeAccount == 'profile' ? 'active' : ''}">
        <span>Personal Details</span><span>&rsaquo;</span>
    </a>
    <a href="${pageContext.request.contextPath}/profile?tab=security" class="dc-account-link ${activeAccount == 'security' ? 'active' : ''}">
        <span>Password &amp; Security</span><span>&rsaquo;</span>
    </a>
</div>
<a href="${pageContext.request.contextPath}/book_appointment" class="btn w-100 fw-semibold text-white mb-4" style="background:#0f766e;border-radius:.75rem;padding:.75rem;">
    <c:out value="${site.bookButton}" />
</a>
