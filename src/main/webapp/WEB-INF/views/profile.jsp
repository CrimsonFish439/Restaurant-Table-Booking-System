<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - BookTables</title>
    <!-- Include Bootstrap for styling -->
    <link href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/resources/css/profile.css" rel="stylesheet">
    <!-- Additional Custom Styling -->
    <style>
        .profile-header {
            background-color: #E23744;
            color: white;
            padding: 20px;
            border-radius: 8px 8px 0 0;
        }

        .profile-card {
            margin-top: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            border: none;
            border-radius: 8px;
            background-color: white;
        }

        .profile-card h4 {
            font-family: 'Poppins', sans-serif;
            font-weight: bold;
            margin-bottom: 15px;
            color: #333;
        }

        .form-control-static {
            background-color: #f9f9f9;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            padding: 10px;
            color: #555;
        }

        .btn-primary {
            background-color: #E23744;
            border-color: #E23744;
            color: white;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #c62e3b;
        }

        .table {
            margin-top: 20px;
        }

        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }

        .modal-header {
            background-color: #E23744;
            color: white;
            border-radius: 8px 8px 0 0;
        }

        .modal-footer .btn-primary {
            background-color: #E23744;
        }

        .modal-footer .btn-secondary {
            background-color: #6c757d;
        }

        .alert {
            margin-top: 15px;
            border-radius: 5px;
        }
    </style>
</head>
<body>

    <!-- Include customer header -->
    <jsp:include page="customer-header.jsp" />

    <!-- Profile Section -->
    <div class="container mt-5">
        <div class="profile-card card shadow-sm">
            <div class="profile-header text-center">
                <h2>Your Profile</h2>
            </div>
            <div class="p-4">
                <h4>Personal Information</h4>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label>First Name</label>
                        <p class="form-control-static">${customer.customerFirstName}</p>
                    </div>
                    <div class="form-group col-md-6">
                        <label>Last Name</label>
                        <p class="form-control-static">${customer.customerLastName}</p>
                    </div>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <p class="form-control-static">${customer.customerEmail}</p>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <p class="form-control-static">${customer.customerPhoneNumber}</p>
                </div>
                <!-- Trigger Edit Modal -->
                <button class="btn btn-primary" data-toggle="modal" data-target="#editProfileModal">Edit Profile</button>
            </div>
        </div>

        <!-- Success Message Section -->
        <c:if test="${not empty message}">
            <div class="alert alert-success" role="alert">${message}</div>
        </c:if>

        <!-- Booking Details Section -->
        <div class="profile-card card shadow-sm p-4 mt-5">
            <h4>Your Bookings</h4>
            <c:if test="${not empty bookings}">
                <table class="table table-bordered">
                    <thead class="thead-dark">
                        <tr>
                            <th>Booking ID</th>
                            <th>Restaurant</th>
                            <th>Date</th>
                            <th>Time Slot</th>
                            <th>Guest Count</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${bookings}">
                            <tr>
                                <td>${booking.bookingId}</td>
                                <td>${booking.restaurant.restaurantName}</td>
                                <td>${booking.bookingDate}</td>
                                <td>${booking.timeSlotStart} - ${booking.timeSlotEnd}</td>
                                <td>${booking.guestCount}</td>
                                <td>${booking.bookingStatus}</td>
                                <td>
                                    <c:if test="${booking.bookingStatus == 'CONFIRMED'}">
                                        <form id="cancelForm${booking.bookingId}" action="<c:url value='/customers/cancelBooking/${booking.bookingId}' />" method="post">
                                            <button type="button" class="btn btn-danger" onclick="confirmCancellation('${booking.bookingId}')">Cancel</button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty bookings}">
                <p>No bookings found.</p>
            </c:if>
        </div>
    </div>

    <!-- Modal for Editing Profile -->
    <div class="modal fade" id="editProfileModal" tabindex="-1" role="dialog" aria-labelledby="editProfileModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editProfileModalLabel">Edit Profile</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- Edit profile form -->
                    <form:form action="updateProfile" method="post" modelAttribute="customer">
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="customerFirstName">First Name</label>
                                <form:input path="customerFirstName" class="form-control" required="true"/>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="customerLastName">Last Name</label>
                                <form:input path="customerLastName" class="form-control" required="true"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="customerPhoneNumber">Phone Number</label>
                            <form:input path="customerPhoneNumber" class="form-control"/>
                        </div>

                        <!-- Commented out password update section -->
                        <!--
                        <h5 class="mt-3">Change Password</h5>
                        <div class="form-group">
                            <label for="currentPassword">Current Password</label>
                            <input type="password" id="currentPassword" name="currentPassword" class="form-control"/>
                        </div>
                        <div class="form-group">
                            <label for="newPassword">New Password</label>
                            <input type="password" id="newPassword" name="newPassword" class="form-control"/>
                        </div>
                        <div class="form-group">
                            <label for="confirmNewPassword">Confirm New Password</label>
                            <input type="password" id="confirmNewPassword" name="confirmNewPassword" class="form-control"/>
                            <small id="passwordError" class="text-danger"></small>
                        </div>
                        -->

                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary" id="saveChangesBtn">Save changes</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript to handle cancellation confirmation -->
    <script>
        function confirmCancellation(bookingId) {
            const confirmAction = confirm("Are you sure you want to cancel this booking?");
            if (confirmAction) {
                document.getElementById('cancelForm' + bookingId).submit();
            }
        }
    </script>

    <!-- Include necessary JS and Bootstrap -->
    <script src="<%=request.getContextPath()%>/resources/js/jquery-1.11.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>
</body>
</html>
