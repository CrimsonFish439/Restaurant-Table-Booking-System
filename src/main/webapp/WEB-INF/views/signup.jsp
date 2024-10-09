<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sign Up - Restaurant Table Booking</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
	rel="stylesheet">
<link
	href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/resources/css/signup.css"
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
	<%-- <a href="<c:url value='/' />" class="back-to-home">← Back to Home</a> --%>

	<!-- Signup Form Section -->
	<div class="container">
		<div class="card">
			<div class="card_title">
				<h1>Create Account</h1>
				<span>Already have an account? <a
					href="<c:url value='/customers/signin' />">Log In</a></span>
			</div>
			<div class="form">
				<form id="signupForm" action="signup" method="post">

					<!-- Two-column row for First Name and Last Name -->
					<div class="form-row">
						<div class="form-group mb-2">
							<input type="text" id="firstName" name="customerFirstName"
								placeholder="First Name" maxlength="30" required /> <small
								id="firstNameError" class="error-message"></small>
						</div>

						<div class="form-group mb-2">
							<input type="text" id="lastName" name="customerLastName"
								placeholder="Last Name" maxlength="30" required /> <small
								id="lastNameError" class="error-message"></small>
						</div>
					</div>

					<!-- Two-column row for Username and Phone Number -->
					<div class="form-row">
						<div class="form-group mb-2">
							<input type="text" id="username" name="customerUsername"
								placeholder="Username" maxlength="15" required /> <small
								id="usernameError" class="error-message"></small>
						</div>

						<div class="form-group mb-2">
							<input type="text" id="phoneNumber" name="customerPhoneNumber"
								placeholder="Phone Number" required /> <small id="phoneError"
								class="error-message"></small>
						</div>
					</div>

					<!-- Single row for Email (full width) -->
					<div class="form-row">
						<div class="form-group mb-2" style="flex: 100%;">
							<input type="email" id="email" name="customerEmail"
								placeholder="Email" required /> <small id="emailError"
								class="error-message"></small>
						</div>
					</div>

					<!-- Two-column row for Password and Confirm Password -->
					<div class="form-row">
						<!-- Password field -->
						<div class="form-group mb-2">
							<div class="password-wrapper">
								<input type="password" id="password" name="customerPassword"
									placeholder="Password"  required /> 
									<span onclick="togglePasswordVisibility()" class="password-toggle"
									> <!-- <i
									class="fa fa-eye"> --></i>
								</span>
							</div>
							<small id="passwordError" class="error-message"></small>
						</div>


						<!-- Confirm Password field -->
						<div class="form-group mb-2">
							<div class="password-wrapper">
								<input type="password" id="confirmPassword"
									placeholder="Confirm Password" required /> 
									
							</div>
							<small id="confirmPasswordError" class="error-message"></small>
						</div>
					</div>



					<!-- Terms of Service -->
					<div class="form-row card_terms">
						<input type="checkbox" id="terms" required> <label
							for="terms">I have read and agree to the <a href="#">Terms
								of Service</a></label>
					</div>

					<!-- Sign Up Button -->
					<div class="form-row">
						<button type="submit">Sign Up</button>
					</div>

				</form>
			</div>
</div>
		</div>

		<!-- Custom Script for client-side validation -->
		<script>
    $(document).ready(function () {
        // On form submit, validate all fields
        $('#signupForm').submit(function (event) {
            clearErrors();

            var isValid = true;

            // Perform full validation on form submission
            if (!validateFirstName()) isValid = false;
            if (!validateLastName()) isValid = false;
            if (!validateUsername()) isValid = false;
            if (!validateEmail()) isValid = false;
            if (!validatePhoneNumber()) isValid = false;
            if (!validatePassword()) isValid = false;
            if (!validateConfirmPassword()) isValid = false;
            if (!validateTerms()) isValid = false;

            // Prevent form submission if validation fails
            if (!isValid) {
                event.preventDefault();
            }
        });

        // Onchange event listeners for real-time validation
        $('#firstName').on('change keyup', validateFirstName);
        $('#lastName').on('change keyup', validateLastName);
        $('#username').on('change keyup', validateUsername);
        $('#email').on('change keyup', validateEmail);
        $('#phoneNumber').on('change keyup', validatePhoneNumber);
        $('#password').on('change keyup', validatePassword);
        $('#confirmPassword').on('change keyup', validateConfirmPassword);
        $('#terms').on('change', validateTerms);

        $('#signupForm').submit(function(event) {
            clearErrors();

            var isValid = true;
            var username = $('#username').val();
            var email = $('#email').val();

            if (username.length === 0) {
                showError('usernameError', 'Username is required.');
                isValid = false;
            }
            if (email.length === 0) {
                showError('emailError', 'Email is required.');
                isValid = false;
            }

            if (isValid) {
                event.preventDefault();  // Prevent form submission until we validate

                $.ajax({
                    url: '<c:url value="/customers/check-username" />',
                    type: 'GET',
                    data: { username: username },
                    success: function(isTaken) {
                        if (isTaken) {
                            showError('usernameError', 'Username is already taken.');
                            isValid = false;
                        } else {
                            $('#usernameError').text('');  // Clear error
                            $('#username').css('border', '1px solid green');
                        }

                        // Now check email availability only if username is valid
                        $.ajax({
                            url: '<c:url value="/customers/check-email" />',
                            type: 'GET',
                            data: { email: email },
                            success: function(isTaken) {
                                if (isTaken) {
                                    showError('emailError', 'Email is already registered.');
                                    isValid = false;
                                } else {
                                    $('#emailError').text('');
                                    $('#email').css('border', '1px solid green');
                                }

                                // If everything is valid, submit the form programmatically
                                if (isValid) {
                                    $('#signupForm')[0].submit();
                                }
                            },
                            error: function() {
                                console.log('Error occurred while checking email.');
                            }
                        });
                    },
                    error: function() {
                        console.log('Error occurred while checking username.');
                    }
                });
            }
        });

        
        


        function togglePasswordVisibility() {
			var passwordInput = document.getElementById("password");
			if (passwordInput.type === "password") {
				passwordInput.type = "text";
			} else {
				passwordInput.type = "password";
			}
		}

        // Show error message function
        function showError(elementId, message) {
            $('#' + elementId).text(message);  // Update the error message
            $('#' + elementId.replace('Error', '')).css('border', '1px solid red');  // Highlight input in red
        }

        // Clear all error messages and reset borders
        function clearErrors() {
            $('.error-message').text('');  // Clear all error messages
            $('input').css('border', '1px solid #e2e2e2');  // Reset border color
        }

        // Individual validation functions
        
        function validateFirstName() {
		    const firstName = $('#firstName').val().trim();
		    const namePattern = /^[A-Za-z]+$/;  // Only letters
		    if (!namePattern.test(firstName)) {
		        showError('firstNameError', 'First name can only contain letters.');
		        return false;
		    }
		    if (firstName.length < 2 || firstName.length > 30) {
		        showError('firstNameError', 'First name must be between 2 and 30 characters.');
		        return false;
		    }
		    $('#firstNameError').text('');  // Clear error if valid
		    $('#firstName').css('border', '1px solid green');  // Change border to green if valid
		    return true;
		}




        function validateLastName() {
            const lastName = $('#lastName').val().trim();
            const namePattern = /^[A-Za-z]+$/;  // Only letters
            if (!namePattern.test(lastName)) {
                showError('lastNameError', 'Last name can only contain letters.');
                return false;
            }
            if (lastName.length < 1 || lastName.length > 30) {
                showError('lastNameError', 'Last name must be between 1 and 30 characters.');
                return false;
            }
            $('#lastNameError').text('');  // Clear error if valid
            $('#lastName').css('border', '1px solid green');  // Change border to green if valid
            return true;
        }


        function validateUsername() {
            const username = $('#username').val().trim();
            if (username.length < 4 || username.length > 15) {
                showError('usernameError', 'Username must be between 4 and 15 characters.');
                return false;
            }
            $('#usernameError').text(''); // Clear error if valid
            $('#username').css('border', '1px solid green'); // Change border to green if valid
            return true;
        }

        function validateEmail() {
            const email = $('#email').val().trim();
            const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
            if (!emailPattern.test(email)) {
                showError('emailError', 'Please enter a valid email address.');
                return false;
            }
            $('#emailError').text(''); // Clear error if valid
            $('#email').css('border', '1px solid green'); // Change border to green if valid
            return true;
        }

        function validatePhoneNumber() {
            const phoneNumber = $('#phoneNumber').val().trim();
            const phonePattern = /^[6-9][0-9]{9}$/;
            if (!phonePattern.test(phoneNumber)) {
                showError('phoneError', 'Phone number must be a 10 digit number');
                return false;
            }
            $('#phoneError').text(''); // Clear error if valid
            $('#phoneNumber').css('border', '1px solid green'); // Change border to green if valid
            return true;
        }

        function validatePassword() {
            const password = $('#password').val();
            const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
            if (!passwordPattern.test(password)) {
                showError('passwordError', 'Password must be at least 8 characters, including uppercase, lowercase, number, and special character.');
                return false;
            }
            $('#passwordError').text(''); // Clear error if valid
            $('#password').css('border', '1px solid green'); // Change border to green if valid
            return true;
        }

        function validateConfirmPassword() {
            const password = $('#password').val();
            const confirmPassword = $('#confirmPassword').val();
            if (confirmPassword !== password) {
                showError('confirmPasswordError', 'Passwords do not match.');
                return false;
            }
            $('#confirmPasswordError').text(''); // Clear error if valid
            $('#confirmPassword').css('border', '1px solid green'); // Change border to green if valid
            return true;
        }

        function validateTerms() {
            const termsChecked = $('#terms').is(':checked');
            if (!termsChecked) {
                showError('termsError', 'Please agree to the terms of service.');
                return false;
            }
            $('#termsError').text(''); // Clear error if valid
            return true;
        }

    });
</script>
</body>
</html>
