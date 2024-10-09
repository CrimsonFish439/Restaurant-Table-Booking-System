<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome - Restaurant Table Booking</title>
    <link href="<c:url value='/resources/css/bootstrap.min.css' />"
          rel="stylesheet">
          <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="<c:url value='/resources/css/welcome.css' />" rel="stylesheet">
    <script src="<c:url value='/resources/js/jquery-1.11.1.min.js' />"></script>
    <script src="<c:url value='/resources/js/bootstrap.min.js' />"></script>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <a class="navbar-brand" href="<c:url value='/' />">BookTables</a>
        <div class="navbar-nav">
            <a class="nav-link" href="<c:url value='/customers/signin' />">Log In</a>
            <a class="nav-link" href="<c:url value='/customers/signup' />">Sign Up</a>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section"
             style="background-image: url('<c:url value='/resources/images/hero_image.jpg' />'); background-size: cover; background-position: center;">
        <div class="container text-center">
            <h1>Discover the best tables and dining experiences</h1>
            <br>
            <br>
            <p>Book a table at your favorite restaurant in just a few clicks</p>
            <div class="action-buttons">
                <a href="<c:url value='/customers/signin' />" class="btn btn-primary">Log In</a>
                <a href="<c:url value='/customers/signup' />" class="btn btn-danger">Sign Up</a>
            </div>
        </div>
    </section>

    <!-- Footer -->	
    <jsp:include page="/WEB-INF/views/footer.jsp" />

    <script src="<c:url value='/resources/js/jquery.min.js' />"></script>
    <script src="<c:url value='/resources/js/bootstrap.min.js' />"></script>
</body>
</html>
