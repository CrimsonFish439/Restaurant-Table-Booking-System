<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select a Table</title>
    <link href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/resources/css/select-table.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7fa;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        h1 {
            font-size: 2.5rem;
            color: #333;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        p {
            font-size: 1.1rem;
            color: #777;
            text-align: center;
            margin-bottom: 2rem;
        }

        /* Table Layout Grid */
        .table-layout-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            justify-content: center;
        }

        /* Table Box Styles */
        .table-box {
            border: 2px solid #28a745;
            padding: 20px;
            text-align: center;
            font-size: 1.2rem;
            border-radius: 10px;
            background-color: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .table-box.unavailable {
            border-color: gray;
            background-color: #dcdcdc;
            cursor: not-allowed;
        }

        .table-box.selected {
            border-color: #007bff;
            background-color: #e6f0ff;
        }

        .table-box:hover {
            border-color: #007bff;
        }

        /* Legend Styles */
        .legend-container {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .legend-color-box {
            width: 20px;
            height: 20px;
            border-radius: 3px;
        }

        .legend-text {
            font-size: 16px;
            color: #333;
        }

        /* Button Styling */
        .proceed-button-container {
            margin-top: 30px;
            text-align: center;
        }

        .proceed-button-container button {
            padding: 10px 20px;
            font-size: 1.1rem;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
        }

        .proceed-button-container button:disabled {
            background-color: #d3d3d3;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .table-layout-grid {
                grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
            }

            .legend-container {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>

    <!-- Include the header -->
    <jsp:include page="customer-header.jsp" />

    <div class="container">
        <h1>Select a Table</h1>
        <p>Please choose a table based on the number of guests.</p>

        <!-- Table Layout Grid -->
        <div class="table-layout-grid">
            <c:forEach var="table" items="${allTables}">
                <!-- Retrieve the availability of the table -->
                <c:set var="isAvailable" value="${tableAvailability[table.tableId]}" />

                <!-- Apply available/unavailable classes based on table availability -->
                <div id="${table.tableId}" 
                     class="table-box ${isAvailable ? 'available' : 'unavailable'}"
                     data-seats="${table.tableSeats}"
                     onclick="selectTable('${table.tableId}', ${table.tableSeats}, ${isAvailable})"
                     style="${isAvailable ? '' : 'cursor:not-allowed;'}">
                    ${table.tableNumber}<br>(${table.tableSeats} seats)
                </div>
            </c:forEach>
        </div>

        <!-- Legend for Table Status -->
        <div class="legend-container">
            <div class="legend-item">
                <div class="legend-color-box" style="background-color: #28a745;"></div>
                <span class="legend-text">Available</span>
            </div>
            <div class="legend-item">
                <div class="legend-color-box" style="background-color: #dcdcdc;"></div>
                <span class="legend-text">Unavailable</span>
            </div>
            <div class="legend-item">
                <div class="legend-color-box" style="background-color: #007bff;"></div>
                <span class="legend-text">Selected</span>
            </div>
        </div>

        <!-- Proceed Button -->
        <div class="proceed-button-container">
            <form id="selectTableForm" method="GET" action="${pageContext.request.contextPath}/restaurants/confirmBooking">
                <input type="hidden" id="selectedTableId" name="tableId">
                <input type="hidden" id="selectedSeats" name="seats">
                <input type="hidden" name="restaurantId" value="<%=request.getParameter("restaurantId") %>">
                <input type="hidden" name="bookingDate" value="<%=request.getParameter("date") %>">
                <input type="hidden" name="guestCount" value="<%=request.getParameter("guests") %>">
                <input type="hidden" name="mealType" value="<%=request.getParameter("meal") %>">
                <input type="hidden" name="timeStart" value="<%=request.getParameter("timeStart") %>">
                <input type="hidden" name="timeEnd" value="<%=request.getParameter("timeEnd") %>">

                <button type="submit" class="btn btn-primary" id="proceedButton" disabled>Proceed to Booking</button>
            </form>
        </div>
    </div>

    <!-- Include the footer -->
    <jsp:include page="footer.jsp" />

    <script>
    let selectedTable = null;
    
    function formatTimeToAMPM(time24) {
        // Convert 24-hour format time (HH:MM) to 12-hour format with AM/PM
        let [hours, minutes] = time24.split(':');
        hours = parseInt(hours);

        const ampm = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12 || 12; // Convert hour to 12-hour format
        return `${hours}:${minutes} ${ampm}`;
    }

    function selectTable(tableId, seats, isAvailable) {
        // Check if table is available
        if (!isAvailable) {
            alert("This table is already booked for the selected time slot. Please choose a different table.");
            return;
        }

        // Reset previously selected table
        if (selectedTable) {
            document.getElementById(selectedTable).classList.remove('selected');
        }

        // Mark the clicked table as selected
        selectedTable = tableId;
        document.getElementById(tableId).classList.add('selected');

        // Enable the proceed button
        document.getElementById("proceedButton").disabled = false;

        // Set hidden form fields with formatted time (AM/PM)
        const timeStart = "<%= request.getParameter("timeStart") %>"; // Assuming you're fetching time from server
        const timeEnd = "<%= request.getParameter("timeEnd") %>";

        const formattedTimeStart = formatTimeToAMPM(timeStart);
        const formattedTimeEnd = formatTimeToAMPM(timeEnd);

        // Set the formatted times in hidden inputs for next steps
        document.getElementById("selectedTableId").value = tableId;
        document.getElementById("selectedSeats").value = seats;
        document.getElementById("hiddenTimeStart").value = formattedTimeStart;
        document.getElementById("hiddenTimeEnd").value = formattedTimeEnd;
    }

    </script>

</body>
</html>
