<%@page import="com.crimsonlogic.restaurantbookingsystem.entity.Restaurant"%>
<%@page import="com.crimsonlogic.restaurantbookingsystem.entity.RestaurantTable"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Booking</title>
    <link href="<%=request.getContextPath() %>/resources/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7fa;
            font-size: 18px;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
        }
        h2 {
            text-align: center;
            font-size: 2.8rem;
            font-weight: 700;
            color: #E23744;
            margin-bottom: 40px;
        }
        .booking-summary, .price-calculation {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
        }
        .booking-summary h5, .price-calculation h5 {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 20px;
            font-weight: bold;
        }
        p {
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 10px;
        }
        .discount-selection label {
            font-weight: 600;
            color: #555;
        }
        .discount-selection select {
            padding: 12px;
            font-size: 1.1rem;
            border-radius: 5px;
            border: 1px solid #ddd;
            margin-top: 10px;
        }
        .proceed-to-payment {
            text-align: center;
            margin-top: 30px;
        }
        .btn-primary {
            background-color: #E23744;
            border: none;
            padding: 12px 25px;
            font-size: 1.3rem;
            transition: background-color 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #C22A3B;
        }
    </style>
</head>
<body>

<!-- Include customer header -->
<jsp:include page="customer-header.jsp"/>

<div class="container">
    <h2>Confirm Your Booking</h2>

    <!-- Booking Details -->
    <div class="booking-summary">
        <h5>Booking Summary</h5>
        <p><strong>Restaurant:</strong> ${restaurant.restaurantName}</p>
        <p><strong>Date:</strong> ${bookingDate}</p>
        <p><strong>Time Slot:</strong> ${timeStart} - ${timeEnd}</p> <!-- Show start and end time -->
        <p><strong>Number of Guests:</strong> ${guestCount}</p>
        <p><strong>Table:</strong> ${table.tableNumber} (Seats: ${table.tableSeats})</p>
    </div>

    <!-- Price Calculation -->
    <div class="price-calculation">
        <h5>Price Breakdown</h5>
        <p><strong>Base Price:</strong> ₹50 (Assumed)</p>
        
        <!-- Discount Selection -->
        <div class="discount-selection">
            <label for="discount">Select Discount:</label>
            <select id="discount" name="discount" onchange="calculateFinalPrice()">
                <option value="0">No Discount</option>
                <option value="5">5% Discount</option>
                <option value="10">10% Discount</option>
                <option value="15">15% Discount</option>
            </select>
        </div>

        <p><strong>Final Price:</strong> ₹<span id="finalPrice">50</span></p>
        <input type="hidden" id="hiddenFinalPrice" name="finalPrice" value="50">
    </div>

    <!-- Proceed to Payment Section -->
    <div class="proceed-to-payment">
        <form id="paymentForm" action="<%=request.getContextPath() %>/payments/redirectToPayment" method="GET" onsubmit="return updateFinalPrice()">
            <!-- Hidden Fields to Pass Booking Data -->
            <input type="hidden" name="restaurantId" value="${restaurant.restaurantId}">
            <input type="hidden" name="tableId" value="${table.tableId}">
            <input type="hidden" name="bookingDate" value="${bookingDate}">
            <input type="hidden" name="timeStart" value="${timeStart}"> <!-- Pass timeStart -->
            <input type="hidden" name="timeEnd" value="${timeEnd}"> <!-- Pass timeEnd -->
            <input type="hidden" name="guestCount" value="${guestCount}">
            <input type="hidden" name="finalPrice" id="hiddenFinalPrice" value="50"> <!-- Updated by JavaScript -->

            <!-- Proceed Button -->
            <button type="submit" class="btn btn-primary">Proceed to Payment</button>
        </form>
    </div>
</div>

<!-- Include footer -->
<jsp:include page="footer.jsp"/>

<!-- Scripts -->
<script src="<%=request.getContextPath() %>/resources/js/jquery-1.11.1.min.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/bootstrap.min.js"></script>

<script>
// JavaScript to calculate the final price based on selected discount
function calculateFinalPrice() {
    const basePrice = 50; // Assuming base price is ₹50
    const discount = document.getElementById('discount').value;
    const finalPrice = basePrice - (basePrice * (discount / 100));
    
    // Update the final price display
    document.getElementById('finalPrice').innerText = finalPrice.toFixed(2);

    // Update the hidden field to pass the final price to the payment page
    document.getElementById('hiddenFinalPrice').value = finalPrice.toFixed(2);
}

// Ensure that the hidden field gets updated before form submission
function updateFinalPrice() {
    calculateFinalPrice(); // Ensure final price is calculated and set in the hidden field
    
    // Debugging
    console.log("Final Price before submission: " + document.getElementById('hiddenFinalPrice').value);

    return true; // Allow the form to submit
}
</script>

</body>
</html>
