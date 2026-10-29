<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="loginPortal" value="PATIENT" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>DentCare - Patient Login</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="img/favicon.ico" rel="icon">
    
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet"> 
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <style>
        body { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); min-height: 100vh; }
        .login-card { border-radius: 16px; box-shadow: 0 20px 60px rgba(0,0,0,0.08); border: none; }
        .form-control { border-radius: 12px; padding: 12px 16px; border: 1px solid #dee2e6; transition: all 0.3s ease; }
        .form-control:focus { border-color: #06A3DA; box-shadow: 0 0 0 0.2rem rgba(6, 163, 218, 0.25); }
        .btn-login { border-radius: 12px; padding: 12px; font-weight: 600; transition: all 0.3s ease; }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(6, 163, 218, 0.3); }
        .input-group-text { border-radius: 12px 0 0 12px; background: #f8f9fa; }
        .password-toggle { border-radius: 0 12px 12px 0; cursor: pointer; }
    </style>

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

<div class="container py-5">
    <div class="row justify-content-center align-items-center" style="min-height: 100vh;">
        <div class="col-lg-5 col-md-7">
            <div class="text-center mb-4">
                <h1 class="text-primary mb-2"><i class="fa fa-tooth me-2"></i>DentCare</h1>
                <p class="text-muted">Patient Login Portal</p>
            </div>
            
            <div class="card login-card">
                <div class="card-body p-5">
                    <%@ include file="_portal_login_tabs.jsp" %>
                    <h2 class="text-center mb-4">Welcome Back</h2>

                    <c:if test="${param.error == 'true'}">
                      <div class="alert alert-danger text-center">Invalid credentials. Please try again.</div>
                    </c:if>
                    <c:if test="${param.logout == 'true'}">
                      <div class="alert alert-success text-center">You have been logged out successfully.</div>
                    </c:if>
                    <c:if test="${param.registered == 'true'}">
                      <div class="alert alert-success text-center">Account created successfully! Please login.</div>
                    </c:if>
                    <c:if test="${param.reset == 'true'}">
                      <div class="alert alert-success text-center">Password reset successfully! Please login.</div>
                    </c:if>

                    <form action="login" method="post" id="loginForm">
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                      <input type="hidden" name="portal" value="PATIENT" />

                      <div class="mb-3">
                        <label class="form-label fw-semibold">Email or Mobile Number</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <input type="text" name="username" class="form-control" placeholder="Enter email or mobile number" required />
                        </div>
                      </div>

                      <div class="mb-3">
                        <label class="form-label fw-semibold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <input type="password" id="passwordInput" name="password" class="form-control" placeholder="Enter password" required />
                            <span class="input-group-text password-toggle" onclick="togglePassword()">
                              <i id="eyeIcon" class="fas fa-eye"></i>
                            </span>
                        </div>
                      </div>

                      <div class="d-grid mb-3">
                        <button type="submit" class="btn btn-primary btn-login py-2">Sign In</button>
                      </div>

                      <div class="text-center mb-2">
                        <a href="forgot-password" class="text-decoration-none">Forgot your password?</a>
                      </div>

                      <hr class="my-4">

                      <p class="text-center mb-0">
                        Don't have an account? <a href="register" class="text-decoration-none fw-semibold">Sign Up</a>
                      </p>
                    </form>
                </div>
            </div>
            
            <div class="text-center mt-4">
                <a href="/" class="text-decoration-none text-muted"><i class="fas fa-home me-2"></i>Back to Home</a>
            </div>
        </div>
    </div>
</div>

<a href="#" class="btn btn-lg btn-primary btn-lg-square rounded back-to-top"><i class="bi bi-arrow-up"></i></a>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/main.js"></script>

<script>
document.getElementById('loginForm').addEventListener('submit', function() {
    const btn = this.querySelector('button[type="submit"]');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Signing In...';
});
</script>

</body>
</html>

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
