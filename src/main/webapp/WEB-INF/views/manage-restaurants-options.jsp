<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Restaurants Options</title>

    <!-- Include Bootstrap CSS and custom styles -->
    <link href="<%=request.getContextPath() %>/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath() %>/resources/css/manage-restaurants-options.css" rel="stylesheet"> 
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

    <!-- Custom Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@200;300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<!-- Include the header for consistency -->
<jsp:include page="admin-header.jsp" />

<!-- Main content section -->
<div class="container">
    <div class="card">
        <div class="card_title">
            <h1>Manage Restaurants</h1>
        </div>

        <!-- Add and View restaurant options -->
        <div class="row mt-4">
            <!-- Add Restaurant -->
            <div class="col-md-6">
                <div class="card shadow-sm p-4 mb-4 text-center">
                    <i class="fas fa-plus-circle fa-3x text-danger"></i>
                    <h4 class="mt-3">Add Restaurant</h4>
                    <p>Add new restaurant details to the system.</p>
                    <a href="add-restaurant" class="btn btn-outline-danger">Add</a>
                </div>
            </div>

            <!-- View Restaurants -->
            <div class="col-md-6">
                <div class="card shadow-sm p-4 mb-4 text-center">
                    <i class="fas fa-list fa-3x text-success"></i>
                    <h4 class="mt-3">View Restaurants</h4>
                    <p>View, edit, or disable existing restaurants.</p>
                    <a href="view-restaurants" class="btn btn-outline-success">View</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS and dependencies -->
<script src="<%=request.getContextPath() %>/resources/js/jquery-1.11.1.min.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/bootstrap.min.js"></script>
</body>
</html>
