<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>DentCare - Unified Login</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="img/favicon.ico" rel="icon">
    
    <!-- Fonts and Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet"> 
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS Libraries -->
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />
    <link href="lib/twentytwenty/twentytwenty.css" rel="stylesheet" />

    <!-- Bootstrap and Template CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <script>
      function togglePassword() {
        const passwordInput = document.getElementById("passwordInput");
        const eyeIcon = document.getElementById("eyeIcon");

        if (passwordInput.type === "password") {
          passwordInput.type = "text";
          eyeIcon.classList.remove("fa-eye");
          eyeIcon.classList.add("fa-eye-slash");
        } else {
          passwordInput.type = "password";
          eyeIcon.classList.remove("fa-eye-slash");
          eyeIcon.classList.add("fa-eye");
        }
      }
    </script>
</head>
<body>

<!-- Spinner Start -->
<div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
  <div class="spinner-grow text-primary m-1"></div>
  <div class="spinner-grow text-dark m-1"></div>
  <div class="spinner-grow text-secondary m-1"></div>
</div>
<!-- Spinner End -->

<!-- Hero Start -->
<div class="container-fluid bg-primary py-5 hero-header mb-5">
  <div class="row py-3">
    <div class="col-12 text-center">
      <h1 class="display-3 text-white animated zoomIn">Welcome to DentCare</h1>
    </div>
  </div>
</div>
<!-- Hero End -->

<!-- Login Form Start -->
<div class="container-fluid my-5">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-lg-6 bg-white p-5 rounded shadow">
        <h2 class="text-center text-primary mb-4">Login</h2>

        <c:if test="${param.error == 'true'}">
          <div class="alert alert-danger text-center">Invalid email or password!</div>
        </c:if>
        <c:if test="${param.logout == 'true'}">
          <div class="alert alert-success text-center">You have been logged out successfully.</div>
        </c:if>
        <c:if test="${param.registered == 'true'}">
          <div class="alert alert-success text-center">Account created! Please login.</div>
        </c:if>

        <form action="login" method="post">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

          <div class="mb-3">
            <label class="form-label">Email Address</label>
            <input type="email" name="username" class="form-control" placeholder="Enter email" required />
          </div>

          <div class="mb-3 position-relative">
            <label class="form-label">Password</label>
            <input type="password" id="passwordInput" name="password" class="form-control" placeholder="Enter password" required />
            <span class="position-absolute" style="top: 38px; right: 15px; cursor: pointer;" onclick="togglePassword()">
              <i id="eyeIcon" class="fas fa-eye"></i>
            </span>
          </div>

          <div class="d-grid">
            <button type="submit" class="btn btn-primary py-2">Login</button>
          </div>

          <p class="text-center mt-3">
            Don’t have an account? <a href="register">Register as Patient</a>
          </p>
        </form>
      </div>
    </div>
  </div>
</div>
<!-- Login Form End -->

<!-- Back to Top -->
<a href="#" class="btn btn-lg btn-primary btn-lg-square rounded back-to-top"><i class="bi bi-arrow-up"></i></a>

<!-- JS Libraries -->
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
