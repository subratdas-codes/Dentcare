<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>DentCare - Patient Registration</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="img/favicon.ico" rel="icon">

    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet"> 
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    
    <style>
        body { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); min-height: 100vh; }
        .register-card { border-radius: 16px; box-shadow: 0 20px 60px rgba(0,0,0,0.08); border: none; }
        .form-control { border-radius: 12px; padding: 12px 16px; border: 1px solid #dee2e6; transition: all 0.3s ease; }
        .form-control:focus { border-color: #06A3DA; box-shadow: 0 0 0 0.2rem rgba(6, 163, 218, 0.25); }
        .btn-register { border-radius: 12px; padding: 12px; font-weight: 600; transition: all 0.3s ease; }
        .btn-register:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(6, 163, 218, 0.3); }
        .input-group-text { border-radius: 12px 0 0 12px; background: #f8f9fa; }
        .password-toggle { border-radius: 0 12px 12px 0; cursor: pointer; }
        .password-strength { height: 4px; border-radius: 2px; transition: all 0.3s ease; }
    </style>
    
    <script>
      function toggleVisibility(fieldId, iconId) {
        const input = document.getElementById(fieldId);
        const icon = document.getElementById(iconId);
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
      
      function checkPasswordStrength() {
        const password = document.getElementById('password').value;
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        
        if (password.length === 0) {
          strengthBar.style.width = '0%';
          strengthBar.className = 'password-strength bg-secondary';
          strengthText.textContent = '';
          return;
        }
        
        let strength = 0;
        if (password.length >= 8) strength++;
        if (/[a-z]/.test(password)) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^A-Za-z0-9]/.test(password)) strength++;
        
        if (strength <= 2) {
          strengthBar.style.width = '33%';
          strengthBar.className = 'password-strength bg-danger';
          strengthText.textContent = 'Weak';
          strengthText.className = 'small text-danger';
        } else if (strength <= 3) {
          strengthBar.style.width = '66%';
          strengthBar.className = 'password-strength bg-warning';
          strengthText.textContent = 'Medium';
          strengthText.className = 'small text-warning';
        } else {
          strengthBar.style.width = '100%';
          strengthBar.className = 'password-strength bg-success';
          strengthText.textContent = 'Strong';
          strengthText.className = 'small text-success';
        }
      }
      
      function validateForm() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        
        if (password !== confirmPassword) {
          alert('Passwords do not match!');
          return false;
        }
        return true;
      }
    </script>
</head>

<body>
    <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
        <div class="spinner-grow text-primary m-1"></div>
        <div class="spinner-grow text-dark m-1"></div>
        <div class="spinner-grow text-secondary m-1"></div>
    </div>

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8">
                <div class="text-center mb-4">
                    <h1 class="text-primary mb-2"><i class="fa fa-tooth me-2"></i>DentCare</h1>
                    <p class="text-muted">Create Your Patient Account</p>
                </div>
                
                <div class="card register-card">
                    <div class="card-body p-5">
                        <h2 class="text-center mb-4">Sign Up</h2>

                        <c:if test="${error != null}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form action="register" method="post" onsubmit="return validateForm()">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" name="name" class="form-control" placeholder="Enter full name" value="${patient.name}" required />
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Email Address <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                    <input type="email" name="email" class="form-control" placeholder="Enter email address" value="${patient.email}" required />
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Mobile Number <small class="text-muted">(Optional)</small></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                    <input type="tel" name="phone" class="form-control" placeholder="Enter mobile number" value="${patient.phone}" />
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Password <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" id="password" name="password" class="form-control" placeholder="Create password" onkeyup="checkPasswordStrength()" required />
                                    <span class="input-group-text password-toggle" onclick="toggleVisibility('password', 'eye1')">
                                        <i id="eye1" class="fas fa-eye"></i>
                                    </span>
                                </div>
                                <div class="mt-2">
                                    <div class="progress" style="height: 4px;">
                                        <div id="strengthBar" class="password-strength bg-secondary" style="width: 0%"></div>
                                    </div>
                                    <small id="strengthText"></small>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Confirm Password <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm password" required />
                                    <span class="input-group-text password-toggle" onclick="toggleVisibility('confirmPassword', 'eye2')">
                                        <i id="eye2" class="fas fa-eye"></i>
                                    </span>
                                </div>
                            </div>

                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-primary btn-register py-2">Create Account</button>
                            </div>

                            <hr class="my-4">

                            <p class="text-center mb-0">
                                Already have an account? <a href="login" class="text-decoration-none fw-semibold">Sign In</a>
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
</body>
</html>

    <!-- Newsletter Start -->
    <div class="container-fluid position-relative pt-5 wow fadeInUp" data-wow-delay="0.1s" style="z-index: 1;">
        <div class="container">
            <div class="bg-primary p-5">
                <div class="text-center mx-auto" style="max-width: 600px;">
                    <a href="register" class="btn btn-dark text-uppercase py-3 px-5">Sign Up</a>
                </div>
            </div>
        </div>
    </div>
    <!-- Newsletter End -->

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
    <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
    <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>
    <script src="lib/twentytwenty/jquery.event.move.js"></script>
    <script src="lib/twentytwenty/jquery.twentytwenty.js"></script>
    <script src="js/main.js"></script>
</body>

</html>
