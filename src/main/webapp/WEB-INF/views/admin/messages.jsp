<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="activePage" value="messages" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Inbox - DentCare Admin</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .page-head { background: #0f766e; color: #fff; border-radius: 1.1rem; }
        .panel { border: 1px solid #e4ebf3; border-radius: 1rem; background: #fff; overflow: hidden; }
        .msg { border: 1px solid #e4ebf3; border-radius: .9rem; padding: 1rem; background: #fff; }
        .msg.unread { border-left: 4px solid #1d4ed8; background: #fbfdff; }
        .avatar { width: 42px; height: 42px; border-radius: 50%; background: #eaf7f4; color: #0b5d57; display: flex; align-items: center; justify-content: center; font-weight: 800; flex: 0 0 42px; }
        .pill { border-radius: 999px; font-size: .72rem; font-weight: 700; padding: .22rem .6rem; }
        .pill-new { background: #e8f1ff; color: #1d4ed8; }
        .pill-read { background: #eef1f5; color: #52627a; }
        .muted { color: #5b6b82; }
        .filter-link { border-radius: 999px; padding: .4rem .85rem; font-weight: 700; font-size: .82rem; text-decoration: none; color: #33445c; background: #fff; border: 1px solid #dbe3ec; }
        .filter-link.active { background: #0f766e; color: #fff; border-color: #0f766e; }
        .message-body { white-space: pre-line; color: #33445c; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>
<div class="container-fluid py-4 px-3 px-lg-4">
    <section class="page-head p-4 mb-4">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
            <div>
                <h1 class="h4 fw-bold mb-1">Contact inbox</h1>
                <p class="mb-0" style="color:#cdeee8;">Every message sent through the website contact form is stored here. Reply by email with one click.</p>
            </div>
            <div class="d-flex gap-2">
                <span class="pill" style="background:#ffffff;color:#0b5d57;"><i class="bi bi-envelope me-1"></i>${messageCount} total</span>
                <span class="pill" style="background:#fff6e5;color:#92400e;"><i class="bi bi-envelope-exclamation me-1"></i>${unreadMessages} unread</span>
            </div>
        </div>
    </section>

    <c:if test="${not empty success}">
        <div class="alert alert-success shadow-sm"><i class="bi bi-check-circle me-2"></i><c:out value="${success}" /></div>
    </c:if>

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
        <div class="d-flex gap-2">
            <a class="filter-link ${selectedView == 'all' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/messages">All messages</a>
            <a class="filter-link ${selectedView == 'unread' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/messages?view=unread">Unread only</a>
        </div>
        <div class="small muted">${fn:length(messages)} shown</div>
    </div>

    <section class="panel">
        <div class="p-3">
            <c:forEach var="m" items="${messages}">
                <article class="msg ${m.read ? '' : 'unread'} mb-3">
                    <div class="d-flex flex-column flex-lg-row justify-content-between gap-3">
                        <div class="d-flex gap-3">
                            <div class="avatar"><c:out value="${m.name.substring(0,1)}" /></div>
                            <div>
                                <div class="d-flex flex-wrap align-items-center gap-2">
                                    <span class="fw-bold"><c:out value="${m.name}" /></span>
                                    <c:choose>
                                        <c:when test="${m.read}"><span class="pill pill-read">Read</span></c:when>
                                        <c:otherwise><span class="pill pill-new">New</span></c:otherwise>
                                    </c:choose>
                                    <span class="small muted"><c:out value="${m.createdAt}" /></span>
                                </div>
                                <a class="small text-decoration-none" style="color:#0b5d57;" href="mailto:<c:out value='${m.email}' />"><c:out value="${m.email}" /></a>
                                <h2 class="h6 fw-bold mt-2 mb-1"><c:out value="${m.subject}" /></h2>
                            </div>
                        </div>
                        <div class="d-flex flex-wrap gap-2 align-items-start">
                            <a class="btn btn-sm btn-outline-success" href="mailto:<c:out value='${m.email}' />?subject=Re%3A%20<c:out value='${m.subject}' />"><i class="bi bi-reply me-1"></i>Reply</a>
                            <form action="${pageContext.request.contextPath}/admin/messages/toggle" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="hidden" name="id" value="${m.id}" />
                                <input type="hidden" name="view" value="${selectedView}" />
                                <button type="submit" class="btn btn-sm ${m.read ? 'btn-outline-secondary' : 'btn-outline-primary'}">
                                    <i class="bi ${m.read ? 'bi-envelope' : 'bi-check2'} me-1"></i>${m.read ? 'Mark unread' : 'Mark read'}
                                </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin/messages/delete" method="post" onsubmit="return confirm('Delete this message permanently?');">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="hidden" name="id" value="${m.id}" />
                                <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                            </form>
                        </div>
                    </div>
                    <p class="message-body mt-3 mb-0"><c:out value="${m.message}" /></p>
                </article>
            </c:forEach>
            <c:if test="${empty messages}">
                <div class="text-center py-5 muted">
                    <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                    <c:choose>
                        <c:when test="${selectedView == 'unread'}">No unread messages. You are all caught up.</c:when>
                        <c:otherwise>No contact messages yet. New enquiries will appear here.</c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>
    </section>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
