<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - BookTables</title>
    
    <!-- Bootstrap and Custom CSS -->
    <link href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/resources/css/payment.css" rel="stylesheet">

    <style>
        body {
            background-color: #f9f9f9;
            font-family: 'Poppins', sans-serif;
        }
        .container {
            margin-top: 40px;
        }
        .card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            border: none;
        }
        .card h5 {
            font-size: 1.3rem;
            color: #333;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .booking-summary p {
            font-size: 1.1rem;
            color: #555;
        }
        .booking-summary strong {
            color: #E23744;
        }
        .payment-method {
            margin-top: 30px;
        }
        .payment-method label {
            font-size: 1.2rem;
            color: #444;
        }
        .payment-method input[type="radio"] {
            margin-right: 10px;
        }
        .btn-primary {
            background-color: #E23744;
            border-color: #E23744;
            font-size: 1.2rem;
            font-weight: 600;
            padding: 10px 15px;
            border-radius: 30px;
        }
        .btn-primary:hover {
            background-color: #c72b3d;
            border-color: #c72b3d;
        }
        .insufficient-balance {
            color: red;
            font-weight: bold;
            margin-top: 10px;
        }
        .final-price {
            color: #E23744;
            font-size: 1.3rem;
            font-weight: bold;
        }
        .wallet-balance {
            color: #444;
            font-size: 1.2rem;
            margin-top: 10px;
        }
    </style>
</head>
<body>

    <!-- Include customer header -->
    <jsp:include page="customer-header.jsp" />

    <div class="container">
        <!-- Payment Section -->
        <div class="card">
            <h5>Booking Summary</h5>
            <div class="booking-summary">
                <p><strong>Restaurant:</strong> ${restaurant.restaurantName}</p>
                <p><strong>Date:</strong> ${bookingDate}</p>
                <p><strong>Time Slot:</strong> ${timeStart} - ${timeEnd}</p>
                <p><strong>Number of Guests:</strong> ${guestCount}</p>
                <p><strong class="final-price">Final Price:</strong> $<span id="finalPrice">${finalPrice}</span></p>
            </div>

            <!-- Payment Method Section -->
            <div class="payment-method">
                <h5>Select Payment Method</h5>
                <form action="<%=request.getContextPath()%>/payments/processPayment" method="POST">

                    <!-- Hidden Fields to Pass Payment ID and Booking Data -->
                    <input type="hidden" name="paymentId" value="${payment.paymentId}">
                    <input type="hidden" name="restaurantId" value="${restaurant.restaurantId}">
                    <input type="hidden" name="tableId" value="${table.tableId}">
                    <input type="hidden" name="bookingDate" value="${bookingDate}">
                    <input type="hidden" name="timeStart" value="${timeStart}">
                    <input type="hidden" name="timeEnd" value="${timeEnd}">
                    <input type="hidden" name="guestCount" value="${guestCount}">
                    <input type="hidden" name="finalPrice" value="${finalPrice}">

                    <!-- Payment Methods -->
                    <div class="form-group">
                        <label for="paymentMethod">Choose Payment Method:</label><br>
                        <input type="radio" id="wallet" name="paymentMethod" value="wallet" checked> Wallet<br>
                        <input type="radio" id="card" name="paymentMethod" value="card"> Credit/Debit Card<br>
                        <input type="radio" id="other" name="paymentMethod" value="other"> Other<br>
                    </div>

                    <!-- Discounts -->
                    <div class="form-group">
                        <label for="discount">Apply Discount:</label><br>
                        <c:if test="${selectedOffer != null}">
                            <p><strong>Discount Applied:</strong> ${selectedOffer}% OFF</p>
                        </c:if>
                    </div>

                    <!-- Wallet Balance -->
                    <c:if test="${walletBalance != null}">
                        <p class="wallet-balance"><strong>Wallet Balance:</strong> $${walletBalance}</p>
                        <c:if test="${walletBalance lt finalPrice}">
                            <p class="insufficient-balance">Insufficient Wallet Balance</p>
                        </c:if>
                    </c:if>

                    <!-- Confirm Payment Button -->
                    <button type="submit" class="btn btn-primary btn-block">Confirm Payment</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Include footer -->
    <jsp:include page="footer.jsp" />

    <!-- Scripts -->
    <script src="<%=request.getContextPath()%>/resources/js/jquery-1.11.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>

</body>
</html>
