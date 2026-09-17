<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>DentCare - Reset Password</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="img/favicon.ico" rel="icon">

    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />
    <link href="lib/twentytwenty/twentytwenty.css" rel="stylesheet" />

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <script>
      function togglePassword(id) {
        const input = document.getElementById(id);
        const icon = document.getElementById(id + "Icon");
        if (input.type === "password") {
          input.type = "text";
          icon.classList.remove("fa-eye");
          icon.classList.add("fa-eye-slash");
        } else {
          input.type = "password";
          icon.classList.remove("fa-eye-slash");
          icon.classList.add("fa-eye");
        }
      }
    </script>
</head>
<body>

<div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
  <div class="spinner-grow text-primary m-1"></div>
  <div class="spinner-grow text-dark m-1"></div>
  <div class="spinner-grow text-secondary m-1"></div>
</div>

<div class="container-fluid bg-primary py-5 hero-header mb-5">
  <div class="row py-3">
    <div class="col-12 text-center">
      <h1 class="display-3 text-white animated zoomIn">Reset Password</h1>
    </div>
  </div>
</div>

<div class="container-fluid my-5">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-lg-6 bg-white p-5 rounded shadow">
        <h2 class="text-center text-primary mb-4">Choose a New Password</h2>

        <c:if test="${not empty error}">
          <div class="alert alert-danger text-center">${error}</div>
        </c:if>

        <form action="reset-password" method="post">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
          <input type="hidden" name="token" value="${token}" />

          <div class="mb-3 position-relative">
            <label class="form-label">New Password</label>
            <input type="password" id="newPassword" name="newPassword" class="form-control" placeholder="Enter new password" required minlength="4" />
            <span class="position-absolute" style="top: 38px; right: 15px; cursor: pointer;" onclick="togglePassword('newPassword')">
              <i id="newPasswordIcon" class="fas fa-eye"></i>
            </span>
          </div>

          <div class="mb-3 position-relative">
            <label class="form-label">Confirm New Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Re-enter new password" required minlength="4" />
            <span class="position-absolute" style="top: 38px; right: 15px; cursor: pointer;" onclick="togglePassword('confirmPassword')">
              <i id="confirmPasswordIcon" class="fas fa-eye"></i>
            </span>
          </div>

          <div class="d-grid">
            <button type="submit" class="btn btn-primary py-2">Reset Password</button>
          </div>

          <p class="text-center mt-3">
            Remembered your password? <a href="login">Back to Login</a>
          </p>
        </form>
      </div>
    </div>
  </div>
</div>

<a href="#" class="btn btn-lg btn-primary btn-lg-square rounded back-to-top"><i class="bi bi-arrow-up"></i></a>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="lib/wow/wow.min.js"></script>
<script src="lib/easing/easing.min.js"></script>
<script src="lib/waypoints/waypoints.min.js"></script>
<script src="lib/owlcarousel/owl.carousel.min.js"></script>
<script src="lib/tempusdominus/js/moment.min.js"></script>
<script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>
<script src="js/main.js"></script>

</body>
</html>