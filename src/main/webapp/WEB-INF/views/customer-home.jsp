<%@page import="com.crimsonlogic.restaurantbookingsystem.entity.Customer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Home - Restaurant Table Booking</title>
    <link href="<%=request.getContextPath() %>/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath() %>/resources/css/customer-home.css" rel="stylesheet">
</head>
<body>

<jsp:include page="customer-header.jsp" />
<h1 class="text-center">Restaurants</h1>

<!-- Filter Section -->
<div class="container mt-4">
    <div class="row justify-content-center">
        <!-- Filter by Category -->
        <div class="col-md-12 text-center mb-3">
            <form action="<c:url value='/restaurants/filterByCategory' />" method="GET" style="display:inline;">
                <span class="filter-label"><b>Category:</b></span>
                <button class="btn btn-secondary filter-button" name="category" value="All">All</button>
                <button class="btn btn-secondary filter-button" name="category" value="Fast Food">Fast Food</button>
                <button class="btn btn-secondary filter-button" name="category" value="Fine Dining">Fine Dining</button>
                <button class="btn btn-secondary filter-button" name="category" value="Casual Dining">Casual Dining</button>
            </form>
        </div>

        <!-- Filter by Location -->
        <div class="col-md-12 text-center mb-3">
            <form action="<c:url value='/restaurants/filterByLocation' />" method="GET" style="display:inline;">
                <span class="filter-label"><b>Location:</b></span>
                <button class="btn btn-secondary filter-button" name="location" value="Cityville">Cityville</button>
                <button class="btn btn-secondary filter-button" name="location" value="Mahadevapura">Mahadevapura</button>
                <button class="btn btn-secondary filter-button" name="location" value="Speedtown">Speedtown</button>
            </form>
        </div>

        <!-- Filter by Rating -->
        <div class="col-md-12 text-center">
            <form action="<c:url value='/restaurants/filterByRating' />" method="GET" style="display:inline;">
                <span class="filter-label"><b>Rating:</b></span>
                <button class="btn btn-secondary filter-button" name="rating" value="3.0">3.0 and above</button>
                <button class="btn btn-secondary filter-button" name="rating" value="4.0">4.0 and above</button>
                <button class="btn btn-secondary filter-button" name="rating" value="4.5">4.5 and above</button>
            </form>
        </div>
    </div>
</div>

<!-- Restaurant Cards Section -->
<div class="container mt-4">
    <div class="row">
        <c:forEach items="${restaurants}" var="restaurant">
            <div class="col-md-4">
                <!-- Determine the CSS class for rating -->
                <c:set var="ratingClass">
                    <c:choose>
                        <c:when test="${restaurant.restaurantRating >= 4.5}">
                            dark-green-rating
                        </c:when>
                        <c:when test="${restaurant.restaurantRating >= 4.0}">
                            green-rating
                        </c:when>
                        <c:when test="${restaurant.restaurantRating >= 3.5}">
                            light-green-rating
                        </c:when>
                        <c:when test="${restaurant.restaurantRating >= 3.0}">
                            yellow-rating
                        </c:when>
                        <c:otherwise>
                            low-rating
                        </c:otherwise>
                    </c:choose>
                </c:set>
                <div class="card mb-4 shadow-sm restaurant-card" 
                     onclick="window.location.href='<c:url value='/restaurants/details/${restaurant.restaurantId}' />'">
                    <!-- Restaurant Image -->
                    <img src="${restaurant.restaurantImageUrl}" class="card-img-top" alt="${restaurant.restaurantName}" style="height: 200px; object-fit: cover;">
                    <div class="card-body d-flex justify-content-between">
                        <!-- First column: restaurant details -->
                        <div>
                            <h5 class="card-title">${restaurant.restaurantName}</h5>
                            <p class="card-category">${restaurant.restaurantCategory}</p>
                            <p class="card-address">${restaurant.restaurantLocation}</p>
                        </div>
                        <!-- Second column: rating -->
                        <div class="rating-container">
                            <span class="badge restaurant-rating ${ratingClass}">
                                ${restaurant.restaurantRating} ★
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="footer.jsp" />

<!-- Scripts -->
<script src="<%=request.getContextPath() %>/resources/js/jquery-1.11.1.min.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/bootstrap.min.js"></script>
</body>
</html>
