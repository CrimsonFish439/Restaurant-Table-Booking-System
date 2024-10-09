<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard</title>
    <!-- Bootstrap and FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="<%=request.getContextPath() %>/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath() %>/resources/css/admin-dashboard.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <script src="<%=request.getContextPath() %>/resources/js/jquery-1.11.1.min.js"></script>
    <script src="<%=request.getContextPath() %>/resources/js/bootstrap.min.js"></script>
</head>
<body>

<%@ include file="admin-header.jsp" %>

<!-- Main Content Section -->
<div class="container">
    <div class="dashboard-welcome">
        <h1>Hi, ${firstName}. Welcome to the Manager Dashboard</h1>
        <p>Manage your restaurant efficiently by navigating through the options below.</p>
    </div>

    <div class="row justify-content-center">
        <!-- Manage Restaurants Card -->
        <div class="col-md-4">
            <div class="dashboard-card card shadow-lg p-4">
                <div class="card-icon">
                    <i class="fas fa-utensils fa-3x"></i>
                </div>
                <h4 class="mt-3">Manage Restaurants</h4>
                <p>Manage restaurant details, including adding, updating, and removing.</p>
                <a href="<c:url value='/admin/manage-restaurants' />" class="btn btn-outline-danger">Manage</a>
            </div>
        </div>

        <%-- <!-- View Reports Card -->
        <div class="col-md-4">
            <div class="dashboard-card card shadow-lg p-4">
                <div class="card-icon">
                    <i class="fas fa-chart-line fa-3x"></i>
                </div>
                <h4 class="mt-3">View Reports</h4>
                <p>Analyze booking and restaurant performance reports.</p>
                <a href="<c:url value='/admin/view-reports' />" class="btn btn-outline-success">View</a>
            </div>
        </div> --%>
    </div>
</div>

</body>
</html>
