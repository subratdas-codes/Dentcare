<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Messages - DentCare</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .chat-card { max-width: 850px; margin: 2rem auto; border: 0; border-radius: 1rem; box-shadow: 0 12px 35px rgba(16,39,73,.08); }
        .messages { min-height: 240px; max-height: 55vh; overflow-y: auto; background: #f8fafc; }
        .message { max-width: 82%; border-radius: 1rem; white-space: pre-wrap; overflow-wrap: anywhere; }
        .message.doctor { background: #e4f4fb; }
        .message.patient { background: #fff; border: 1px solid #e5eaf0; }
    </style>
</head>
<body>
<main class="container px-3">
    <section class="card chat-card">
        <header class="card-header bg-white border-0 p-4 d-flex justify-content-between align-items-start gap-3">
            <div>
                <div class="text-muted small">Appointment #<c:out value="${appointment.id}" /></div>
                <h1 class="h5 fw-bold mb-1"><c:choose><c:when test="${staffConversation}">Conversation with <c:out value="${appointment.patientName}" /></c:when><c:otherwise>Message <c:out value="${appointment.doctorName}" /></c:otherwise></c:choose></h1>
                <div class="text-muted small"><c:out value="${appointment.service}" /> · <c:out value="${appointment.appointmentDate}" /> at <c:out value="${appointment.appointmentTime}" /></div>
            </div>
            <a href="<c:url value='${backUrl}' />" class="btn btn-sm btn-outline-secondary">Back</a>
        </header>
        <c:if test="${param.sent == 'true'}"><div class="alert alert-success mx-4 mb-0" role="status">Message sent.</div></c:if>
        <c:if test="${param.error == 'message'}"><div class="alert alert-danger mx-4 mb-0" role="alert">Enter a message up to 2,000 characters.</div></c:if>
        <div class="messages p-4" id="messages" aria-live="polite">
            <c:choose>
                <c:when test="${not empty messages}">
                    <c:forEach var="message" items="${messages}">
                        <div class="message p-3 mb-3 ${message.senderRole == 'DOCTOR' ? 'doctor ms-auto' : 'patient'}">
                            <div class="small text-muted mb-1"><c:out value="${message.senderRole == 'DOCTOR' ? 'Doctor' : 'Patient'}" /> · <c:out value="${message.sentAt}" /></div>
                            <div><c:out value="${message.body}" /></div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center text-muted py-5"><i class="bi bi-chat-square-text fs-2"></i><p class="mb-0 mt-2">No messages yet. Start the conversation below.</p></div>
                </c:otherwise>
            </c:choose>
        </div>
        <form class="card-footer bg-white border-0 p-4" action="<c:url value='${postUrl}' />" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <label class="form-label fw-semibold" for="body">Message</label>
            <div class="d-flex flex-column flex-sm-row gap-2">
                <textarea class="form-control" id="body" name="body" rows="2" maxlength="2000" required placeholder="Write a message about this appointment"></textarea>
                <button class="btn btn-primary align-self-sm-end" type="submit"><i class="bi bi-send me-1"></i>Send</button>
            </div>
            <small class="text-muted">Messages are visible only to the patient and the doctor assigned to this appointment.</small>
        </form>
    </section>
</main>
<script>
const messagePanel = document.getElementById('messages');
messagePanel.scrollTop = messagePanel.scrollHeight;
</script>
</body>
</html>
