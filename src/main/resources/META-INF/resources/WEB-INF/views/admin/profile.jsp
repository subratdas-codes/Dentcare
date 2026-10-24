<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activePage" value="profile" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Staff Profile - DentCare</title>
    <link href="<c:url value='/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f8fc; color: #172b4d; }
        .profile-card { border: 0; border-radius: 1rem; box-shadow: 0 12px 35px rgba(16,39,73,.08); }
        .avatar { width: 104px; height: 104px; border-radius: 50%; object-fit: cover; border: 4px solid #fff; box-shadow: 0 4px 20px #142d4c22; }
    </style>
</head>
<body>
<%@ include file="_navbar.jsp" %>
<main class="container py-4 py-lg-5" style="max-width: 900px">
    <c:if test="${not empty success}"><div class="alert alert-success" role="status"><c:out value="${success}" /></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger" role="alert"><c:out value="${error}" /></div></c:if>

    <section class="card profile-card mb-4">
        <div class="card-body p-4 p-lg-5">
            <div class="d-flex flex-column flex-sm-row align-items-center gap-3 mb-4">
                <c:choose>
                    <c:when test="${not empty doctor.profileImagePath}">
                        <img id="photoPreview" class="avatar" src="<c:out value='${pageContext.request.contextPath}${doctor.profileImagePath}' />" alt="Profile photo of ${doctor.name}" />
                    </c:when>
                    <c:otherwise><div id="photoPlaceholder" class="avatar bg-primary bg-opacity-10 text-primary d-grid place-items-center"><i class="bi bi-person-fill fs-1 m-auto"></i></div></c:otherwise>
                </c:choose>
                <div class="text-center text-sm-start">
                    <h1 class="h3 fw-bold mb-1"><c:out value="${doctor.name}" /></h1>
                    <div class="text-muted"><c:out value="${doctor.email}" /></div>
                    <span class="badge bg-primary bg-opacity-10 text-primary mt-2"><c:out value="${doctor.admin ? 'Administrator' : 'Doctor'}" /></span>
                </div>
            </div>

            <h2 class="h5 fw-bold mb-3">Edit profile</h2>
            <form action="<c:url value='/admin/profile' />" method="post" enctype="multipart/form-data">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label" for="profileName">Name</label>
                        <input id="profileName" class="form-control" value="${doctor.name}" readonly aria-describedby="nameHelp" />
                        <div id="nameHelp" class="form-text">Ask an administrator to change your login identity/name.</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="profileEmail">Login email</label>
                        <input id="profileEmail" class="form-control" value="${doctor.email}" readonly />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="phone">Phone</label>
                        <input id="phone" name="phone" class="form-control" value="${doctor.phone}" maxlength="40" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="specialization">Specialization</label>
                        <input id="specialization" name="specialization" class="form-control" value="${doctor.specialization}" maxlength="120" required />
                    </div>
                    <div class="col-12">
                        <label class="form-label" for="description">About / professional description</label>
                        <textarea id="description" name="description" class="form-control" rows="4" maxlength="2000" placeholder="Share your qualifications, approach, and areas of care"><c:out value="${doctor.description}" /></textarea>
                        <div class="form-text">Maximum 2,000 characters.</div>
                    </div>
                    <div class="col-12">
                        <label class="form-label" for="photo">Profile photo</label>
                        <input id="photo" name="photo" type="file" class="form-control" accept="image/jpeg,image/png" />
                        <div class="form-text">JPEG or PNG, up to 5 MB.</div>
                    </div>
                </div>
                <div class="d-flex flex-column flex-sm-row justify-content-between gap-2 mt-4">
                    <a class="btn btn-outline-secondary" href="<c:url value='/admin/change-password' />"><i class="bi bi-shield-lock me-1"></i>Change password</a>
                    <button class="btn btn-primary" type="submit"><i class="bi bi-check2-circle me-1"></i>Save profile</button>
                </div>
            </form>
        </div>
    </section>
</main>
<script>
document.getElementById('photo').addEventListener('change', function (event) {
    const file = event.target.files && event.target.files[0];
    if (!file) return;
    const preview = document.getElementById('photoPreview');
    if (preview) {
        preview.src = URL.createObjectURL(file);
    } else {
        const image = document.createElement('img');
        image.id = 'photoPreview'; image.className = 'avatar'; image.alt = 'Selected profile photo preview';
        image.src = URL.createObjectURL(file);
        document.getElementById('photoPlaceholder').replaceWith(image);
    }
});
</script>
</body>
</html>
