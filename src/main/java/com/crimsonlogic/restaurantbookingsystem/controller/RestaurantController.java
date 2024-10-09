package com.crimsonlogic.restaurantbookingsystem.controller;

import com.crimsonlogic.restaurantbookingsystem.entity.Booking;
import com.crimsonlogic.restaurantbookingsystem.entity.Customer;
import com.crimsonlogic.restaurantbookingsystem.entity.Restaurant;
import com.crimsonlogic.restaurantbookingsystem.entity.RestaurantTable;
import com.crimsonlogic.restaurantbookingsystem.enums.BookingStatus;
import com.crimsonlogic.restaurantbookingsystem.service.BookingService;
import com.crimsonlogic.restaurantbookingsystem.service.RestaurantService;
import com.crimsonlogic.restaurantbookingsystem.service.RestaurantTableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/restaurants")
public class RestaurantController {

    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private RestaurantTableService restaurantTableService;
    
    @Autowired
    private BookingService bookingService;

    // 1. Create a new restaurant
    @PostMapping("/create")
    public ModelAndView createRestaurant(@ModelAttribute Restaurant restaurant) {
        restaurantService.createRestaurant(restaurant);
        return new ModelAndView("redirect:/restaurants/list");
    }

    // 2. Show restaurant details using model attribute
    @GetMapping("/details/{restaurantId}")
    public ModelAndView showRestaurantDetails(@PathVariable String restaurantId) {
        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
        ModelAndView modelAndView = new ModelAndView("restaurant-details");
        modelAndView.addObject("restaurant", restaurant); // Add restaurant object to the model
        return modelAndView;
    }

    // 3. List restaurants by location
    @GetMapping("/location/{location}")
    public ModelAndView getRestaurantsByLocation(@PathVariable String location) {
        ModelAndView modelAndView = new ModelAndView("restaurantList");
        List<Restaurant> restaurants = restaurantService.getRestaurantsByLocation(location);
        modelAndView.addObject("restaurants", restaurants);
        return modelAndView;
    }

    // 4. List restaurants by category
    @GetMapping("/category/{category}")
    public ModelAndView getRestaurantsByCategory(@PathVariable String category) {
        ModelAndView modelAndView = new ModelAndView("restaurantList");
        List<Restaurant> restaurants = restaurantService.getRestaurantsByCategory(category);
        modelAndView.addObject("restaurants", restaurants);
        return modelAndView;
    }

    // 5. List restaurants by rating
    @GetMapping("/rating/{rating}")
    public ModelAndView getRestaurantsByRating(@PathVariable Double rating) {
        ModelAndView modelAndView = new ModelAndView("restaurantList");
        List<Restaurant> restaurants = restaurantService.getRestaurantsByRating(rating);
        modelAndView.addObject("restaurants", restaurants);
        return modelAndView;
    }

    // 6. Update restaurant
    @PostMapping("/update/{restaurantId}")
    public ModelAndView updateRestaurant(@PathVariable String restaurantId, @ModelAttribute Restaurant updatedRestaurant) {
        restaurantService.updateRestaurant(restaurantId, updatedRestaurant);
        return new ModelAndView("redirect:/admin/view-restaurants/");
    }
    
    @GetMapping("/search")
    public ModelAndView searchRestaurants(@RequestParam("name") String name) {
        ModelAndView modelAndView = new ModelAndView("customer-home");
        List<Restaurant> restaurants = restaurantService.findByRestaurantNameContaining(name);
        modelAndView.addObject("restaurants", restaurants);
        return modelAndView;
    }

 // Filter restaurants by category
    @GetMapping("/filterByCategory")
    public ModelAndView filterByCategory(@RequestParam("category") String category) {
        ModelAndView modelAndView = new ModelAndView("customer-home");

        // Handle the "All" option
        List<Restaurant> restaurants = category.equalsIgnoreCase("All") 
            ? restaurantService.getAllRestaurants() 
            : restaurantService.getRestaurantsByCategory(category);

        modelAndView.addObject("restaurants", restaurants);
        return modelAndView;
    }

    // Filter restaurants by location
    @GetMapping("/filterByLocation")
    public ModelAndView filterByLocation(@RequestParam("location") String location) {
        ModelAndView modelAndView = new ModelAndView("customer-home");
        List<Restaurant> restaurants = restaurantService.getRestaurantsByLocation(location);
        modelAndView.addObject("restaurants", restaurants);
        return modelAndView;
    }

    // Filter restaurants by rating
    @GetMapping("/filterByRating")
    public ModelAndView filterByRating(@RequestParam("rating") Double rating) {
        ModelAndView modelAndView = new ModelAndView("customer-home");
        List<Restaurant> restaurants = restaurantService.getRestaurantsByRating(rating);
        modelAndView.addObject("restaurants", restaurants);
        return modelAndView;
    }

    
    @GetMapping("/selectTable")
    public ModelAndView selectTable(
        @RequestParam("restaurantId") String restaurantId,
        @RequestParam("guests") int guests,  
        @RequestParam("meal") String meal,
        @RequestParam("date") String date,
        @RequestParam("timeStart") String timeStart,
        @RequestParam("timeEnd") String timeEnd,
        ModelAndView modelAndView) {

        try {
        	// Debugging parameters received
            System.out.println("Restaurant ID: " + restaurantId);
            System.out.println("Guests: " + guests);
            System.out.println("Meal Type: " + meal);
            System.out.println("Date: " + date);
            System.out.println("Time Start: " + timeStart);
            System.out.println("Time End: " + timeEnd);
            
            // Convert timeStart and timeEnd from String to LocalTime
            LocalTime startTime = LocalTime.parse(timeStart);
            LocalTime endTime = LocalTime.parse(timeEnd);
            
            // Convert date from String to LocalDate
            LocalDate bookingDate = LocalDate.parse(date);

            // Add attributes to the model
            modelAndView.setViewName("select-table");
            modelAndView.addObject("restaurantId", restaurantId);
            modelAndView.addObject("guests", guests);  
            modelAndView.addObject("mealType", meal);
            modelAndView.addObject("bookingDate", bookingDate);
            modelAndView.addObject("timeStart", startTime);
            modelAndView.addObject("timeEnd", endTime);

            System.out.println("Parsed Time Start: " + startTime);
            System.out.println("Parsed Time End: " + endTime);
            System.out.println("Parsed Booking Date: " + bookingDate);
            
            // Retrieve tables for the restaurant
            List<RestaurantTable> allTables = restaurantTableService.findAllTablesForRestaurant(restaurantId);
            System.out.println("All Tables Count: " + allTables.size());

            // Check table availability for the selected date and time slot
            Map<String, Boolean> tableAvailability = new HashMap<>();
            for (RestaurantTable table : allTables) {
                boolean isAvailable = bookingService.isTableAvailable(table.getTableId(), bookingDate, startTime, endTime);
                tableAvailability.put(table.getTableId(), isAvailable);
                
                // Debugging table availability
                System.out.println("Table ID: " + table.getTableId() + " is available: " + isAvailable);
            }

            // Add the list of tables and their availability to the model
            modelAndView.addObject("allTables", allTables);
            modelAndView.addObject("tableAvailability", tableAvailability);

        } catch (DateTimeParseException e) {
            // Handle invalid time format error
            modelAndView.setViewName("error-page");
            modelAndView.addObject("errorMessage", "Invalid time format.");
        }

        return modelAndView;
    }




    // Confirm booking endpoint
    @GetMapping("/confirmBooking")
    public ModelAndView confirmBooking(
        @RequestParam("restaurantId") String restaurantId,
        @RequestParam("tableId") String tableId,
        @RequestParam("seats") int seats,
        @RequestParam("bookingDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate bookingDate,
        @RequestParam("guestCount") int guestCount,
        @RequestParam("mealType") String mealType,
        @RequestParam("timeStart") @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime timeStart, 
        @RequestParam("timeEnd") @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime timeEnd,
        HttpSession session, Model model) {

        // Check if the table is available for the selected time slot and date
        boolean isAvailable = bookingService.isTableAvailable(tableId, bookingDate, timeStart, timeEnd);
        if (!isAvailable) {
            // Redirect back to table selection with error message
            ModelAndView modelAndView = new ModelAndView("select-table");
            modelAndView.addObject("errorMessage", "The selected table is already booked for this time slot.");

            // Retrieve the list of tables to show available/unavailable status
            List<RestaurantTable> allTables = restaurantTableService.findAllTablesForRestaurant(restaurantId);
            Map<String, Boolean> tableAvailability = new HashMap<>();
            for (RestaurantTable table : allTables) {
                tableAvailability.put(table.getTableId(), bookingService.isTableAvailable(table.getTableId(), bookingDate, timeStart, timeEnd));
            }

            modelAndView.addObject("allTables", allTables);
            modelAndView.addObject("tableAvailability", tableAvailability);
            modelAndView.addObject("restaurantId", restaurantId);
            modelAndView.addObject("guests", guestCount);
            modelAndView.addObject("mealType", mealType);
            modelAndView.addObject("bookingDate", bookingDate);
            modelAndView.addObject("timeStart", timeStart);
            modelAndView.addObject("timeEnd", timeEnd);
            return modelAndView;
        }

        // Proceed with booking if the table is available
        Booking booking = (Booking) session.getAttribute("booking");
        
        if (booking == null) {
            booking = new Booking();
        }

        // Set booking details
        booking.setBookingDate(bookingDate);
        booking.setGuestCount(guestCount);
        booking.setTimeSlotStart(timeStart);
        booking.setTimeSlotEnd(timeEnd);

        // Retrieve selected table
        RestaurantTable selectedTable = restaurantTableService.getTableById(tableId);
        booking.setTable(selectedTable);

        // Get the customer from the session
        Customer customer = (Customer) session.getAttribute("loggedInCustomer");
        booking.setCustomer(customer);

        // Set booking status to pending
        booking.setBookingStatus(BookingStatus.PENDING);

        // Store the updated booking in the session
        session.setAttribute("booking", booking);

        // Retrieve the restaurant by ID and add to the model
        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);

        // Add booking data to the model to display on the confirmation page
        model.addAttribute("booking", booking);
        model.addAttribute("table", selectedTable);
        model.addAttribute("bookingDate", bookingDate);
        model.addAttribute("guestCount", guestCount);
        model.addAttribute("timeStart", timeStart);
        model.addAttribute("timeEnd", timeEnd);
        model.addAttribute("restaurant", restaurant);

        return new ModelAndView("confirm-booking");
    }





}
