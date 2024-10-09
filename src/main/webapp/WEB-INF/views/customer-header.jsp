<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" session="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Responsive Navbar</title>
    <!-- Import Poppins Font from Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for Logout Icon -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  </head>
  <body>
    <nav style="background-color: #E23744; padding: 20px 5%; display: flex; justify-content: space-between; align-items: center; box-shadow: rgba(50, 50, 93, 0.25) 0px 2px 5px -1px, rgba(0, 0, 0, 0.3) 0px 1px 3px -1px;">
      <div class="logo" style="font-size: 2.2rem;font-family: 'Poppins', sans-serif;font-weight: 600;color: white;">
        <a href="<c:url value='/customers/home' />" style="color: white; text-decoration: none;">BookTables</a>
      </div>
      <ul style="list-style: none; display: flex; align-items: center; font-family: 'Poppins', sans-serif; margin: 0;">
        <li style="margin-left: 1.5rem;">
          <a href="<c:url value='/customers/home' />" style="text-decoration: none; color: white; font-size: 120%; padding: 4px 8px; border-radius: 5px;">Home</a>
        </li>
        <li style="margin-left: 1.5rem;">
          <a href="#" style="text-decoration: none; color: white; font-size: 120%; padding: 4px 8px; border-radius: 5px;">Services</a>
        </li>
        <li style="margin-left: 1.5rem;">
          <a href="#" style="text-decoration: none; color: white; font-size: 120%; padding: 4px 8px; border-radius: 5px;">Blog</a>
        </li>
        <li style="margin-left: 1.5rem;">
          <a href="#" style="text-decoration: none; color: white; font-size: 120%; padding: 4px 8px; border-radius: 5px;">Contact Us</a>
        </li>

        <%-- Check if the user is logged in or not --%>
        <c:choose>
          <c:when test="${not empty sessionScope.loggedInCustomer}">
            <li class="nav-item dropdown" style="position: relative; margin-left: 1.5rem;">
              <span class="dropdown-toggle" id="userDropdown" style="cursor: pointer; font-size: 120%; color: white; padding: 4px 8px; border-radius: 5px;">
                Hi, ${sessionScope.loggedInCustomer.customerFirstName} <i class="fas fa-caret-down"></i>
              </span>
              <div class="dropdown-menu" style="position: absolute; top: 100%; right: 0; background-color: #E23744; box-shadow: rgba(50, 50, 93, 0.25) 0px 2px 5px -1px, rgba(0, 0, 0, 0.3) 0px 1px 3px -1px; display: none; min-width: 150px;">
                <a class="dropdown-item" href="<c:url value='/customers/profile' />" style="color: white; font-family: 'Poppins', sans-serif; padding: 10px 15px; display: block; text-decoration: none;">Profile</a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="<c:url value='/customers/signout' />" style="color: white; font-family: 'Poppins', sans-serif; padding: 10px 15px; display: block; text-decoration: none;">Logout</a>
              </div>
            </li>
          </c:when>
          <c:otherwise>
            <li style="margin-left: 1.5rem;">
              <a href="<c:url value='/customers/signin' />" style="text-decoration: none; color: white; font-size: 120%; padding: 4px 8px; border-radius: 5px;">Sign In</a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </nav>

    <!-- Include necessary JS files for dropdown functionality -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
      // Custom dropdown toggle functionality
      document.addEventListener('DOMContentLoaded', function () {
        const dropdownToggle = document.querySelector('.dropdown-toggle');
        const dropdownMenu = document.querySelector('.dropdown-menu');

        dropdownToggle.addEventListener('click', function (e) {
          e.stopPropagation(); // Prevent event from bubbling up
          dropdownMenu.style.display = dropdownMenu.style.display === 'block' ? 'none' : 'block';
        });

        // Close dropdown if clicking outside
        window.addEventListener('click', function (e) {
          if (!dropdownToggle.contains(e.target)) {
            dropdownMenu.style.display = 'none';
          }
        });
      });
    </script>
  </body>
</html>
