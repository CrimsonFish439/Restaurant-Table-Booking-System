<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Restaurants</title>
    <!-- Bootstrap and Custom Styles -->
    <link href="<%=request.getContextPath() %>/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath() %>/resources/css/view-restaurants.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="admin-header.jsp" %>
<!-- Main Container -->
<div class="container mt-5">
    <div class="card p-4 shadow">
        <!-- Page Title -->
        <h1 class="text-center mb-4">Restaurants Overview</h1>

        <!-- Restaurant List -->
        <h3 class="text-muted text-center">Restaurants Listed in BookTables</h3>
        <div class="table-responsive mt-4">
            <table class="table table-hover table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>ID</th>
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
                            <td>
                                <img src="${restaurant.restaurantImageUrl}" alt="${restaurant.restaurantName}" class="restaurant-image"
                                     data-toggle="modal" data-target="#restaurantModal${restaurant.restaurantId}" style="cursor: pointer;">
                            </td>
                            <td>${restaurant.restaurantName}</td>
                            <td>${restaurant.restaurantAddress}</td>
                            <td>${restaurant.restaurantPhoneNumber}</td>
                            <td>${restaurant.restaurantLocation}</td>
                            <td>${restaurant.restaurantCategory}</td>
                            <!-- Status with badge -->
                            <td>
                                <span class="badge ${restaurant.restaurantStatus == 'Active' ? 'badge-success' : 'badge-danger'}">
                                    ${restaurant.restaurantStatus}
                                </span>
                            </td>
                            <td>
                                <!-- Edit and Disable/Activate icons -->
                                <a href="<c:url value='/admin/edit-restaurant/${restaurant.restaurantId}' />" class="text-warning mr-3">
                                    <i class="fas fa-edit" title="Edit"></i>
                                </a>
                                <c:choose>
                                    <c:when test="${restaurant.restaurantStatus == 'Active'}">
                                        <a href="<c:url value='/admin/disable-restaurant/${restaurant.restaurantId}' />" class="text-danger">
                                            <i class="fas fa-ban" title="Disable"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<c:url value='/admin/activate-restaurant/${restaurant.restaurantId}' />" class="text-success">
                                            <i class="fas fa-check-circle" title="Activate"></i>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <!-- Modal for restaurant details -->
                        <div class="modal fade" id="restaurantModal${restaurant.restaurantId}" tabindex="-1" role="dialog" aria-labelledby="restaurantModalLabel${restaurant.restaurantId}" aria-hidden="true">
                            <div class="modal-dialog modal-lg" role="document">
                                <div class="modal-content">
                                    <div class="modal-header" style="background-color: #E23744; color: white;">
                                        <h2 class="modal-title" id="restaurantModalLabel${restaurant.restaurantId}">${restaurant.restaurantName}</h2>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <img src="${restaurant.restaurantImageUrl}" class="img-fluid" alt="${restaurant.restaurantName}">
                                            </div>
                                            <div class="col-md-8">
                                                <h6><strong>Address:</strong> ${restaurant.restaurantAddress}</h6>
                                                <h6><strong>Phone:</strong> ${restaurant.restaurantPhoneNumber}</h6>
                                                <h6><strong>Rating:</strong> ${restaurant.restaurantRating}</h6>
                                                <h6><strong>Category:</strong> ${restaurant.restaurantCategory}</h6>
                                                <h6><strong>Overview:</strong></h6>
                                                <p>${restaurant.restaurantOverview}</p>
                                                <h6><strong>Timings:</strong> ${restaurant.restaurantTimings}</h6>
                                                <h6><strong>Status:</strong> 
                                                    <span class="badge ${restaurant.restaurantStatus == 'Active' ? 'badge-success' : 'badge-danger'}">
                                                        ${restaurant.restaurantStatus}
                                                    </span>
                                                </h6>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                        <a href="<c:url value='/admin/edit-restaurant/${restaurant.restaurantId}' />" class="btn btn-warning">Edit Restaurant</a>
                                    </div>	
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Bootstrap JS and Custom Scripts -->
<script src="<%=request.getContextPath() %>/resources/js/jquery-1.11.1.min.js"></script>
<script src="<%=request.getContextPath() %>/resources/js/bootstrap.min.js"></script>
</body>
</html>
