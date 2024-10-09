<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports</title>
    <!-- Bootstrap and Custom Styles -->
    <link href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/resources/css/view-reports.css" rel="stylesheet">
</head>
<body>

<%@ include file="admin-header.jsp" %>

<!-- Main Container -->
<div class="container mt-5">
    <div class="card p-4 shadow report-card">
        <!-- Page Title -->
        <h2 class="text-center text-danger mb-4 card-title">View Reports</h2>

        <!-- Date Range Input -->
        <form action="<%=request.getContextPath() %>/reports/reports" method="post" class="mb-4">
            <div class="form-row justify-content-center">
                <div class="col-md-4">
                    <label for="startDate">Start Date</label>
                    <input type="date" class="form-control" id="startDate" name="startDate" required>
                </div>
                <div class="col-md-4">
                    <label for="endDate">End Date</label>
                    <input type="date" class="form-control" id="endDate" name="endDate" required>
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-danger btn-block generate-report-btn">Generate Report</button>
                </div>
            </div>
        </form>

        <!-- Booking Report Table -->
        <h3 class="report-details">Bookings Report</h3>
        <c:if test="${not empty bookings}">
            <div class="table-responsive mt-4">
                <table class="table table-hover table-bordered table-striped">
                    <thead class="thead-dark">
                        <tr>
                            <th>Booking ID</th>
                            <th>Date</th>
                            <th>Customer</th>
                            <th>Restaurant</th>
                            <th>Table</th>
                            <th>Guests</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${bookings}" var="booking">
                            <tr>
                                <td>${booking.bookingId}</td>
                                <td>${booking.bookingDate}</td>
                                <td>${booking.customer.customerName}</td>
                                <td>${booking.restaurant.restaurantName}</td>
                                <td>${booking.table.tableName}</td>
                                <td>${booking.guestCount}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        <c:if test="${empty bookings}">
            <p class="text-muted text-center">No bookings found for the selected date range.</p>
        </c:if>

        <!-- Payment Report Table -->
        <h3 class="report-details">Payments Report</h3>
        <c:if test="${not empty payments}">
            <div class="table-responsive mt-4">
                <table class="table table-hover table-bordered table-striped">
                    <thead class="thead-dark">
                        <tr>
                            <th>Payment ID</th>
                            <th>Date</th>
                            <th>Customer</th>
                            <th>Amount</th>
                            <th>Payment Type</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${payments}" var="payment">
                            <tr>
                                <td>${payment.paymentId}</td>
                                <td>${payment.paymentDate}</td>
                                <td>${payment.customer.customerName}</td>
                                <td>${payment.amount}</td>
                                <td>${payment.paymentType}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        <c:if test="${empty payments}">
            <p class="text-muted text-center">No payments found for the selected date range.</p>
        </c:if>
    </div>
</div>

<script src="<c:url value='/resources/js/jquery-1.11.1.min.js' />"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js' />"></script>
</body>
</html>
