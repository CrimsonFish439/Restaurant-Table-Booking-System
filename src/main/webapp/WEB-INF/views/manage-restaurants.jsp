<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Restaurants</title>
    <link href="<%=request.getContextPath() %>/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath() %>/resources/css/manage-restaurants.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center">Manage Restaurants</h1>
        
        <!-- Add Restaurant Form -->
        <form action="<c:url value='/admin/add-restaurant' />" method="post" class="mb-5">
            <h3>Add New Restaurant</h3>
            <div class="form-group">
                <label for="restaurantName">Restaurant Name</label>
                <input type="text" class="form-control" id="restaurantName" name="restaurantName" required>
            </div>
            <div class="form-group">
                <label for="restaurantAddress">Restaurant Address</label>
                <input type="text" class="form-control" id="restaurantAddress" name="restaurantAddress" required>
            </div>
            <div class="form-group">
                <label for="restaurantPhoneNumber">Phone Number</label>
                <input type="text" class="form-control" id="restaurantPhoneNumber" name="restaurantPhoneNumber" required>
            </div>
            <div class="form-group">
                <label for="restaurantLocation">Location</label>
                <input type="text" class="form-control" id="restaurantLocation" name="restaurantLocation" required>
            </div>
            <div class="form-group">
                <label for="restaurantCategory">Category</label>
                <input type="text" class="form-control" id="restaurantCategory" name="restaurantCategory" required>
            </div>
            <div class="form-group">
                <label for="restaurantImageUrl">Image URL</label>
                <input type="text" class="form-control" id="restaurantImageUrl" name="restaurantImageUrl" placeholder="Enter Image URL">
            </div>
            <button type="submit" class="btn btn-primary">Add Restaurant</button>
        </form>

        <!-- Restaurant List -->
        <!-- Restaurant List -->
<h3>All Restaurants</h3>
<table class="table table-striped">
    <thead>
        <tr>
            <th>Restaurant ID</th>
            <th>Image</th>
            <th>Name</th>
            <th>Address</th>
            <th>Phone</th>
            <th>Location</th>
            <th>Category</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach items="${restaurants}" var="restaurant">
            <tr>
                <td>${restaurant.restaurantId}</td>
                <td><img src="${restaurant.restaurantImageUrl}" alt="${restaurant.restaurantName}" style="width: 100px; height: 70px; object-fit: cover;"></td>
                <td>${restaurant.restaurantName}</td>
                <td>${restaurant.restaurantAddress}</td>
                <td>${restaurant.restaurantPhoneNumber}</td>
                <td>${restaurant.restaurantLocation}</td>
                <td>${restaurant.restaurantCategory}</td>

                <!-- Status column with badge -->
                <td>
                    <span class="badge ${restaurant.restaurantStatus == 'Active' ? 'badge-success' : 'badge-danger'}">
                        ${restaurant.restaurantStatus}
                    </span>
                </td>

                <td>
                    <!-- Edit button -->
                    <a href="<c:url value='/admin/edit-restaurant/${restaurant.restaurantId}' />" class="btn btn-warning">Edit</a>

                    <!-- Toggle status button -->
                    <c:choose>
                        <c:when test="${restaurant.restaurantStatus == 'Active'}">
                            <a href="<c:url value='/admin/disable-restaurant/${restaurant.restaurantId}' />" class="btn btn-danger">Disable</a>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/admin/activate-restaurant/${restaurant.restaurantId}' />" class="btn btn-success">Activate</a>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

    </div>
</body>
</html>
