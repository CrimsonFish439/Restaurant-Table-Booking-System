<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sign In - Restaurant Table Booking</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
	rel="stylesheet">

<link
	href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/resources/css/signin.css"
	rel="stylesheet">
<script
	src="<%=request.getContextPath()%>/resources/js/jquery-1.11.1.min.js"></script>
<script
	src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>
</head>
<body>

	<!-- Transparent Navbar -->
	<nav class="my-navbar">
		<a class="my-navbar-brand" href="<c:url value='/' />">BookTables</a>
		<div class="my-navbar-nav">
			<a class="my-nav-link" href="<c:url value='/customers/signin' />">Log
				In</a> <a class="my-nav-link" href="<c:url value='/customers/signup' />">Sign
				Up</a>
		</div>
	</nav>


	<!-- Sign In Form Section -->
	<div class="container">
		<div class="card">
			<div class="card_title">
				<h1>Welcome</h1>
				<span>Don't have an account? <a
					href="<c:url value='/customers/signup' />">Sign Up</a></span>
			</div>

			<!-- Server-Side Error Message (if credentials are wrong) -->
			<c:if test="${not empty error}">
				<div class="alert alert-danger">
					${error}
					<!-- Display server-side error message -->
				</div>
			</c:if>

			<div class="form">
				<!-- Spring Form Binding for login -->
				<form:form id="signinForm" action="signin" method="post"
					onsubmit="return validateForm();">

					<!-- Email -->
					<input type="email" id="email" name="email" placeholder="Email" />
					<small id="emailError" class="error-message"></small>

					<!-- Password -->
					<div class="password-wrapper">
						<input type="password" id="password" name="password"
							placeholder="Password" /> <span class="password-toggle"
							onclick="togglePasswordVisibility()"> <i class="fa fa-eye"></i>
						</span>
					</div>
					<small id="passwordError" class="error-message"></small>

					<!-- Sign In Button -->
					<button type="submit">Sign In</button>
				</form:form>
			</div>
		</div>
	</div>

	<!-- Client-Side Validation Script -->
	<script>
		function validateForm() {
			clearErrors(); // Clear previous errors

			let isValid = true;

			// Validate Email
			let email = document.getElementById('email').value.trim();
			if (email === '') {
				showError('emailError', 'Email is required');
				isValid = false;
			} else if (!validateEmail(email)) {
				showError('emailError', 'Invalid email format');
				isValid = false;
			}

			// Validate Password
			let password = document.getElementById('password').value.trim();
			if (password === '') {
				showError('passwordError', 'Password is required');
				isValid = false;
			}

			// Return whether the form is valid
			return isValid;
		}

		// Function to show error message
		function showError(errorId, message) {
			document.getElementById(errorId).textContent = message;
			document.getElementById(errorId.replace('Error', '')).style.border = '1px solid red';
		}

		// Function to clear error messages
		function clearErrors() {
			document.querySelectorAll('.error-message').forEach(
					function(error) {
						error.textContent = '';
					});
			document.querySelectorAll('input').forEach(function(input) {
				input.style.border = '1px solid #e2e2e2'; // Reset border color
			});
		}

		function validateEmail(email) {
			const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
			return re.test(email);
		}

		function togglePasswordVisibility() {
		       const passwordInput = document.getElementById('password');
		       if (passwordInput.type === 'password') {
		           passwordInput.type = 'text';
		       } else {
		           passwordInput.type = 'password';
		       }
		   }
		

	</script>
</body>
</html>
