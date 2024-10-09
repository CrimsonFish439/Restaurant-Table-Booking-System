<%@page
	import="com.crimsonlogic.restaurantbookingsystem.entity.Restaurant"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${restaurant.restaurantName}-RestaurantDetails</title>
<link
	href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="<%=request.getContextPath()%>/resources/css/restaurant-details.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
	rel="stylesheet">
</head>
<body>

	<!-- Include the customer header -->
	<jsp:include page="customer-header.jsp" />

	<!-- Hero Image -->
	<div class="restaurant-hero">
		<img src="${restaurant.restaurantImageUrl}"
			alt="${restaurant.restaurantName}" class="img-fluid">
	</div>

	<!-- Restaurant Information Section -->
	<div class="container mt-4 restaurant-info">
		<h1 class="restaurant-name">${restaurant.restaurantName}</h1>
		<div class="d-flex justify-content-between align-items-center">
			<div class="restaurant-info-left">
				<p class="restaurant-category">${restaurant.restaurantCategory}</p>
				<p class="restaurant-address">${restaurant.restaurantLocation}</p>
			</div>

			<!-- Rating -->
			<div class="restaurant-rating-container text-right">
				<span class="restaurant-rating ${ratingClass}">${restaurant.restaurantRating}
					★</span>
			</div>
		</div>
	</div>

	<!-- Tabs Section -->
	<div class="container mt-4">
		<ul class="nav nav-tabs" id="restaurantTabs" role="tablist">
			<li class="nav-item"><a class="nav-link active"
				id="overview-tab" data-toggle="tab" href="#overview" role="tab"
				aria-controls="overview" aria-selected="true">Overview</a></li>
			<li class="nav-item"><a class="nav-link" id="book-table-tab"
				data-toggle="tab" href="#bookTable" role="tab"
				aria-controls="bookTable" aria-selected="false">Book a Table</a></li>
		</ul>

		<div class="tab-content" id="restaurantTabContent">
			<!-- Overview Tab Content -->
			<div class="tab-pane fade active" id="overview" role="tabpanel"
				aria-labelledby="overview-tab">
				<h3>About ${restaurant.restaurantName}</h3>
				<p class="restaurant-description">${restaurant.restaurantOverview}</p>
			</div>

			<!-- Book a Table Tab Content -->
			<div class="tab-pane fade" id="bookTable" role="tabpanel"
				aria-labelledby="book-table-tab">
				<h3>Book a Table at ${restaurant.restaurantName}</h3>

				<!-- Booking Details Section -->
				<div class="booking-details">
					<h5>Select your booking details</h5>
					<div class="booking-filters">
						<!-- Date Picker -->
						<span class="filter-item"> <i class="fas fa-calendar-alt"></i>
							<input type="date" id="booking-date" name="booking-date"
							min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>"
							value="">
						</span>

						<!-- Guest Count Dropdown -->
						<span class="filter-item"> <i class="fas fa-user-friends"></i>
							<select id="guest-count" name="guest-count">
								<option value="2" selected>2 guests</option>
								<option value="3">3 guests</option>
								<option value="4">4 guests</option>
								<option value="5">5 guests</option>
								<option value="6">6 guests</option>
								<option value="7">7 guests</option>
								<option value="8">8 guests</option>
								<option value="9">9 guests</option>
								<option value="10">10 guests</option>
								<option value="11">11 guests</option>
								<option value="12">12 guests</option>
						</select>
						</span>

						<!-- Meal Type Dropdown -->
						<span class="filter-item"> <i class="fas fa-utensils"></i>
							<select id="meal-type" name="meal-type" onchange="changeSlots()">
								<option value="" disabled selected>Select a meal type</option>
								<option value="breakfast">Breakfast</option>
								<option value="lunch">Lunch</option>
								<option value="dinner">Dinner</option>
						</select>
						</span>
					</div>
				</div>

				<!-- Select Slot Section -->
				<div class="slot-selection">
					<h5>Select Slot</h5>
					<div class="slot-grid" id="slot-grid">
						<!-- Time slots will be dynamically added -->
					</div>
				</div>

				<!-- Proceed to Select Table Button -->
				<div class="proceed-button-container text-left mt-3">
					<form id="bookTableForm"
						action="<%=request.getContextPath()%>/restaurants/selectTable"
						method="GET">
						<input type="hidden" name="date" id="hiddenDate"> <input
							type="hidden" name="guests" id="hiddenGuests"> <input
							type="hidden" name="meal" id="hiddenMeal"> <input
							type="hidden" name="timeStart" id="hiddenTimeStart"> <input
							type="hidden" name="timeEnd" id="hiddenTimeEnd"> <input
							type="hidden" name="restaurantId"
							value="${restaurant.restaurantId}">

						<button type="submit" class="btn btn-primary"
							id="proceedToTableButton" disabled>Proceed to Select
							Table</button>
					</form>
				</div>
			</div>
		</div>
	</div>

	<!-- Include the footer -->
	<jsp:include page="footer.jsp" />

	<!-- Scripts -->
	<script
		src="<%=request.getContextPath()%>/resources/js/jquery-1.11.1.min.js"></script>
	<script
		src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>

	<script>
		$(document).ready(function () {
			// Ensure that the overview tab is active when the page loads
			$('#restaurantTabs a[href="#overview"]').tab('show');
		});

		// Set today's date in the Date input field by default
		document.addEventListener('DOMContentLoaded', function() {
			const today = new Date().toISOString().split('T')[0];
			document.getElementById('booking-date').value = today;
		});

		// JavaScript for dynamic slot selection
		function changeSlots() {
		    const mealType = document.getElementById("meal-type").value;
		    const slotGrid = document.getElementById("slot-grid");
		    const selectedDate = document.getElementById("booking-date").value;
		    
		    // Get current date and time
		    const now = new Date();
		    const currentTime = now.toTimeString().split(' ')[0]; // Current time in HH:MM:SS format
		    const currentDate = now.toISOString().split('T')[0];  // Current date in YYYY-MM-DD format

		    // Clear the current slots
		    slotGrid.innerHTML = '';

		    // Define slots based on meal type (start time - end time)
		    let slots = [];
		    if (mealType === "breakfast") {
		        slots = [
		            {start: "06:00", end: "07:00", display: "6:00 AM - 7:00 AM"},
		            {start: "07:00", end: "08:00", display: "7:00 AM - 8:00 AM"},
		            {start: "08:00", end: "09:00", display: "8:00 AM - 9:00 AM"},
		            {start: "09:00", end: "10:00", display: "9:00 AM - 10:00 AM"}
		        ];
		    } else if (mealType === "lunch") {
		        slots = [
		            {start: "12:00", end: "13:00", display: "12:00 PM - 1:00 PM"},
		            {start: "13:00", end: "14:00", display: "1:00 PM - 2:00 PM"},
		            {start: "14:00", end: "15:00", display: "2:00 PM - 3:00 PM"}
		        ];
		    } else if (mealType === "dinner") {
		        slots = [
		            {start: "19:00", end: "20:00", display: "7:00 PM - 8:00 PM"},
		            {start: "20:00", end: "21:00", display: "8:00 PM - 9:00 PM"}
		        ];
		    }

		    // Populate the slots and add click event listener to each slot button
		    slots.forEach(slot => {
		        const button = document.createElement("button");
		        button.classList.add("slot-button");
		        button.type = "button";
		        button.innerText = slot.display;

		        // Disable slot if it has already passed (only for today's date)
		        if (selectedDate === currentDate && slot.end < currentTime) {
		            button.disabled = true; // Disable past slots
		            button.classList.add("disabled-slot"); // Add disabled style
		        }

		        // Add click event listener to set hidden start and end time values
		        button.addEventListener('click', function() {
		            if (!button.disabled) {
		                document.getElementById('hiddenTimeStart').value = slot.start;
		                document.getElementById('hiddenTimeEnd').value = slot.end;

		                // Visually mark the selected button
		                document.querySelectorAll('.slot-button').forEach(btn => btn.classList.remove('selected'));
		                this.classList.add('selected');

		                // Enable the proceed button
		                document.getElementById('proceedToTableButton').disabled = false;
		            }
		        });

		        slotGrid.appendChild(button);
		    });
		}


		document.getElementById('proceedToTableButton').addEventListener('click', function(event) {
			// Capture form data
			const selectedDate = document.getElementById('booking-date').value;
			const selectedGuests = document.getElementById('guest-count').value;
			const selectedMeal = document.getElementById('meal-type').value;
			const selectedTimeStart = document.getElementById('hiddenTimeStart').value;
			const selectedTimeEnd = document.getElementById('hiddenTimeEnd').value;

			// Validate time slot selection
			if (!selectedTimeStart || !selectedTimeEnd) {
				event.preventDefault(); // Prevent form submission
				alert('Please select a time slot.');
			} else {
				// Set hidden inputs
				document.getElementById('hiddenDate').value = selectedDate;
				document.getElementById('hiddenGuests').value = selectedGuests;
				document.getElementById('hiddenMeal').value = selectedMeal;
			}
		});
    </script>

</body>
</html>
