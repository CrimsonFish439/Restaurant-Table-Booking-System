<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add New Restaurant</title>
<!-- Bootstrap and External CSS -->
<link
	href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="<%=request.getContextPath()%>/resources/css/add-restaurant.css"
	rel="stylesheet">
<script
	src="<%=request.getContextPath()%>/resources/js/jquery-1.11.1.min.js"></script>
</head>
<body>
	<%@ include file="admin-header.jsp"%>
	<div class="container">
		<div class="card">
			<div class="card_title">
				<h1>Add New Restaurant</h1>
			</div>

			<!-- Restaurant Form -->
			<form:form id="addRestaurantForm" action="add-restaurant"
				method="post" modelAttribute="restaurant">

				<!-- Two-column row for Restaurant Name and Address -->
				<div class="form-row">
					<div class="form-group mb-2">
						<label for="restaurantName">Restaurant Name</label>
						<form:input path="restaurantName" class="form-control"
							placeholder="Enter restaurant name" required="true" />
						<small id="nameError" class="error-message text-danger"></small>
					</div>

					<div class="form-group mb-2">
						<label for="restaurantAddress">Address</label>
						<form:input path="restaurantAddress" class="form-control"
							placeholder="Enter address" required="true" />
						<small id="addressError" class="error-message text-danger"></small>
					</div>
				</div>

				<!-- Two-column row for Phone Number and Rating -->
				<div class="form-row">
					<div class="form-group mb-2">
						<label for="restaurantPhoneNumber">Phone Number</label>
						<form:input path="restaurantPhoneNumber" class="form-control"
							placeholder="Enter phone number" />
						<small id="phoneError" class="error-message text-danger"></small>
					</div>

					<div class="form-group mb-2">
						<label for="restaurantRating">Rating</label>
						<form:input path="restaurantRating" class="form-control"
							placeholder="Enter rating (1-5)" />
						<small id="ratingError" class="error-message text-danger"></small>
					</div>
				</div>

				<!-- Two-column row for Location and Category -->
				<div class="form-row">
					<div class="form-group mb-2">
						<label for="restaurantLocation">Location</label>
						<form:input path="restaurantLocation" class="form-control"
							placeholder="Enter location" required="true" />
						<small id="locationError" class="error-message text-danger"></small>
					</div>

					<div class="form-group mb-2">
						<label for="restaurantCategory">Category</label>
						<form:select path="restaurantCategory" class="form-control"
							required="true">
							<form:option value="" label="Select Category" />
							<form:option value="Fast Food" label="Fast Food" />
							<form:option value="Casual Dining" label="Casual Dining" />
							<form:option value="Fine Dining" label="Fine Dining" />
							<form:option value="Café" label="Café" />
							<form:option value="Buffet" label="Buffet" />
							<form:option value="Bakery" label="Bakery" />
						</form:select>
						<small id="categoryError" class="error-message text-danger"></small>
					</div>
				</div>

				<!-- Single row for Image URL -->
				<div class="form-row">
					<div class="form-group mb-2" style="flex: 100%;">
						<label for="restaurantImageUrl">Image URL</label>
						<form:input path="restaurantImageUrl" class="form-control"
							placeholder="Enter image URL" />
						<small id="imageUrlError" class="error-message text-danger"></small>
					</div>
				</div>

				<!-- Single row for Overview -->
				<div class="form-row">
					<div class="form-group mb-2" style="flex: 100%;">
						<label for="restaurantOverview">Overview</label>
						<form:textarea path="restaurantOverview" class="form-control"
							rows="4"
							placeholder="Enter a brief overview about the restaurant" />
						<small id="overviewError" class="error-message text-danger"></small>
					</div>
				</div>

				<!-- Single row for Restaurant Timings -->
				<div class="form-row">
					<div class="form-group mb-2" style="flex: 100%;">
						<label for="restaurantTimings">Restaurant Timings</label>
						<form:input path="restaurantTimings" class="form-control"
							placeholder="Enter restaurant timings (e.g., 9 AM - 9 PM)"
							required="true" />
						<small id="timingsError" class="error-message text-danger"></small>
					</div>
				</div>

				<!-- Add fields for table types and number of tables -->
                <div class="form-row">
                    <div class="form-group mb-2">
                        <label for="twoSeaterTables">Number of 2-Seater Tables</label>
                        <input type="number" id="twoSeaterTables" name="twoSeaterTables"
                               class="form-control" placeholder="Enter number of 2-seater tables" min="0">
                    </div>

                    <div class="form-group mb-2">
                        <label for="fourSeaterTables">Number of 4-Seater Tables</label>
                        <input type="number" id="fourSeaterTables" name="fourSeaterTables"
                               class="form-control" placeholder="Enter number of 4-seater tables" min="0">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group mb-2">
                        <label for="eightSeaterTables">Number of 8-Seater Tables</label>
                        <input type="number" id="eightSeaterTables" name="eightSeaterTables"
                               class="form-control" placeholder="Enter number of 8-seater tables" min="0">
                    </div>

                    <div class="form-group mb-2">
                        <label for="twelveSeaterTables">Number of 12-Seater Tables</label>
                        <input type="number" id="twelveSeaterTables" name="twelveSeaterTables"
                               class="form-control" placeholder="Enter number of 12-seater tables" min="0">
                    </div>
                </div>


				<!-- Submit Button -->
				<div class="form-row">
					<button type="submit" class="btn btn-primary">Add
						Restaurant</button>
				</div>

			</form:form>
		</div>
	</div>

	<script>
    $(document).ready(function () {
        // Validate on form submit
        $('#addRestaurantForm').submit(function (event) {
            clearErrors();
            var isValid = true;

            // Validate each field
            if (!validateName()) isValid = false;
            if (!validateAddress()) isValid = false;
            if (!validatePhone()) isValid = false;
            if (!validateRating()) isValid = false;
            if (!validateLocation()) isValid = false;
            if (!validateCategory()) isValid = false;
            if (!validateTimings()) isValid = false;

            // Prevent form submission if validation fails
            if (!isValid) {
                event.preventDefault();
            }
        });

        // On change validation for each field
        $('#restaurantName').on('change keyup', validateName);
        $('#restaurantAddress').on('change keyup', validateAddress);
        $('#restaurantPhoneNumber').on('change keyup', validatePhone);
        $('#restaurantRating').on('change keyup', validateRating);
        $('#restaurantLocation').on('change keyup', validateLocation);
        $('#restaurantCategory').on('change', validateCategory);
        $('#restaurantTimings').on('change keyup', validateTimings);

        // Individual validation functions
        function validateName() {
            const name = $('#restaurantName').val().trim();
            if (name.length < 2 || name.length > 50) {
                showError('nameError', 'Restaurant name must be between 2 and 50 characters.');
                return false;
            }
            clearError('nameError');
            return true;
        }

        function validateAddress() {
            const address = $('#restaurantAddress').val().trim();
            if (address.length < 5) {
                showError('addressError', 'Address must be at least 5 characters long.');
                return false;
            }
            clearError('addressError');
            return true;
        }

        function validatePhone() {
            const phone = $('#restaurantPhoneNumber').val().trim();
            const phonePattern = /^[6-9][0-9]{9}$/;
            if (phone && !phonePattern.test(phone)) {
                showError('phoneError', 'Please enter a valid 10-digit phone number.');
                return false;
            }
            clearError('phoneError');
            return true;
        }

        function validateRating() {
            const rating = $('#restaurantRating').val();
            if (rating && (rating < 1 || rating > 5)) {
                showError('ratingError', 'Rating must be between 1 and 5.');
                return false;
            }
            clearError('ratingError');
            return true;
        }

        function validateLocation() {
            const location = $('#restaurantLocation').val().trim();
            if (location.length < 3) {
                showError('locationError', 'Location must be at least 3 characters long.');
                return false;
            }
            clearError('locationError');
            return true;
        }

        function validateCategory() {
            const category = $('#restaurantCategory').val();
            if (!category) {
                showError('categoryError', 'Please select a category.');
                return false;
            }
            clearError('categoryError');
            return true;
        }

        function validateTimings() {
            const timings = $('#restaurantTimings').val().trim();
            if (timings.length === 0) {
                showError('timingsError', 'Please enter restaurant timings.');
                return false;
            }
            clearError('timingsError');
            return true;
        }

        // Show error message function
        function showError(elementId, message) {
            $('#' + elementId).text(message);
            $('#' + elementId.replace('Error', '')).css('border', '1px solid red');
        }

        // Clear error message function
        function clearError(elementId) {
            $('#' + elementId).text('');
            $('#' + elementId.replace('Error', '')).css('border', '1px solid #ccc');
        }

        // Clear all error messages and reset borders
        function clearErrors() {
            $('.error-message').text('');
            $('input').css('border', '1px solid #ccc');
        }
    });
</script>

</body>
</html>
