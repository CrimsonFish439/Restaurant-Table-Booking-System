<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Payment Successful</title>
	<link href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="font-family: 'Poppins', sans-serif; background-color: #f4f7fa;">

	<div class="container" style="max-width: 600px; margin: 100px auto; padding: 20px; background-color: #ffffff; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); border-radius: 8px; text-align: center;">
		<!-- Checkmark Icon -->
		<div class="icon-checkmark" style="color: #28a745; font-size: 60px; margin-bottom: 20px;">
			<i class="fas fa-check-circle"></i>
		</div>
		
		<!-- Payment Success Message -->
		<h1 style="color: #28a745; font-size: 36px; font-weight: bold; margin-bottom: 20px;">Payment Successful</h1>
		<p style="font-size: 18px; color: #333; margin-bottom: 40px;">Your payment has been successfully processed. Thank you for booking with us!</p>

		<!-- Download PDF Receipt Button -->
		<a href="<%=request.getContextPath()%>/payments/downloadReceipt?paymentId=${payment.paymentId}" 
		   class="btn btn-primary" style="font-size: 16px; padding: 10px 20px; border-radius: 5px; background-color: #007bff; border-color: #007bff; font-weight: bold; text-decoration: none; color: white;">
		   Download Payment Receipt
		</a>

		<!-- Option to go back to booking -->
		<a href="<%=request.getContextPath()%>/customers/home" class="btn btn-primary mt-3" style="font-size: 16px; padding: 10px 20px; border-radius: 5px; background-color: #007bff; border-color: #007bff; font-weight: bold; text-decoration: none; color: white; display: inline-block;">
		   Go Back to Bookings
		</a>
	</div>

	<!-- Include footer -->
	<jsp:include page="footer.jsp"/>

	<!-- Scripts -->
	<script src="<%=request.getContextPath()%>/resources/js/jquery-1.11.1.min.js"></script>
	<script src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
</body>
</html>
