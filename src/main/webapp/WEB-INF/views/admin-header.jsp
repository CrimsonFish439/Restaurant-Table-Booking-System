<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<nav style="background-color: #E23744; padding: 10px 5%; display: flex; justify-content: space-between; align-items: center; box-shadow: rgba(50, 50, 93, 0.25) 0px 2px 5px -1px, rgba(0, 0, 0, 0.3) 0px 1px 3px -1px;">
    <div class="logo" style="display: flex; align-items: center;">
        <a class="navbar-brand" href="<c:url value='/admin/dashboard' />" style="font-size: 1.8rem; font-family: 'Poppins', sans-serif; font-weight: 700; color: white; text-decoration: none;">
            <i class="fas fa-cog"></i> Manager Dashboard
        </a>
    </div>

	<ul style="list-style: none; display: flex; font-family: 'Poppins', sans-serif; margin-bottom: 0;">
		<li style="margin-left: 1.5rem;"><a class="nav-link" href="<c:url value='manage-restaurants' />"
			style="text-decoration: none; color: white; font-size: 120%; padding: 4px 8px; border-radius: 5px;">
				<i class="fas fa-utensils"></i> Manage Restaurants
		</a></li>
		<!-- <li style="margin-left: 1.5rem;"><a class="nav-link" href="#"
			style="text-decoration: none; color: white; font-size: 120%; padding: 4px 8px; border-radius: 5px;">
				<i class="fas fa-chart-line"></i> View Reports
		</a></li> -->

		<li style="margin-left: 1.5rem;"><a class="nav-link"
			href="<c:url value='/customers/signout' />"
			style="text-decoration: none; color: white; font-size: 120%; padding: 4px 8px; border-radius: 5px;">
				<i class="fas fa-sign-out-alt"></i> Logout
		</a></li>
	</ul>
</nav>
