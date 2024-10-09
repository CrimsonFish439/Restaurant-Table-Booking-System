package com.crimsonlogic.restaurantbookingsystem.controller;

import java.util.List;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import com.crimsonlogic.restaurantbookingsystem.entity.Customer;
import com.crimsonlogic.restaurantbookingsystem.entity.Restaurant;
import com.crimsonlogic.restaurantbookingsystem.entity.RestaurantTable;
import com.crimsonlogic.restaurantbookingsystem.service.RestaurantService;
import com.crimsonlogic.restaurantbookingsystem.service.RestaurantTableService;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private RestaurantTableService restaurantTableService;
    
    private static final Logger LOG = LoggerFactory.getLogger(AdminController.class);
    
 // Admin dashboard
    @GetMapping("/dashboard")
    public ModelAndView showAdminDashboard(HttpSession session) {
        Customer loggedInCustomer = (Customer) session.getAttribute("loggedInCustomer");

        // Check if the logged-in user is admin
        if (loggedInCustomer != null && "ADMIN".equals(loggedInCustomer.getCustomerRole())) {
            // Create a new ModelAndView and pass the admin's first name to the model
            ModelAndView modelAndView = new ModelAndView("admin-dashboard");
            modelAndView.addObject("firstName", loggedInCustomer.getCustomerFirstName()); // Pass the first name
            return modelAndView;
        } else {
            return new ModelAndView("redirect:/customers/signin"); // Redirect to signin if not admin
        }
    }


    // Page with options to Add or View/Manage restaurants
    @GetMapping("/manage-restaurants")
    public ModelAndView manageRestaurantsOptions() {
        return new ModelAndView("manage-restaurants-options");
    }
    
 // Page with options to Add or View/Manage restaurants
    @GetMapping("/view-reports")
    public ModelAndView viewReports() {
        return new ModelAndView("view-reports");
    }

    // Show the form to add a new restaurant
    @GetMapping("/add-restaurant")
    public ModelAndView showAddRestaurantForm() {
        ModelAndView modelAndView = new ModelAndView("add-restaurant");
        modelAndView.addObject("restaurant", new Restaurant()); // Blank Restaurant object for form binding
        return modelAndView;
    }

    @PostMapping("/add-restaurant")
    public ModelAndView addRestaurant(
        @ModelAttribute("restaurant") Restaurant restaurant,
        @RequestParam("twoSeaterTables") int twoSeaterTables,
        @RequestParam("fourSeaterTables") int fourSeaterTables,
        @RequestParam("eightSeaterTables") int eightSeaterTables,
        @RequestParam("twelveSeaterTables") int twelveSeaterTables) {

        // Create and save the restaurant
        restaurantService.createRestaurant(restaurant);

        // Add 2-seater tables
        for (int i = 1; i <= twoSeaterTables; i++) {
            RestaurantTable table = new RestaurantTable();
            table.setTableNumber("2-Seater Table " + i);
            table.setTableSeats(2);
            table.setRestaurant(restaurant);
            restaurantTableService.createTable(table);
        }

        // Add 4-seater tables
        for (int i = 1; i <= fourSeaterTables; i++) {
            RestaurantTable table = new RestaurantTable();
            table.setTableNumber("4-Seater Table " + i);
            table.setTableSeats(4);
            table.setRestaurant(restaurant);
            restaurantTableService.createTable(table);
        }

        // Add 8-seater tables
        for (int i = 1; i <= eightSeaterTables; i++) {
            RestaurantTable table = new RestaurantTable();
            table.setTableNumber("8-Seater Table " + i);
            table.setTableSeats(8);
            table.setRestaurant(restaurant);
            restaurantTableService.createTable(table);
        }

        // Add 12-seater tables
        for (int i = 1; i <= twelveSeaterTables; i++) {
            RestaurantTable table = new RestaurantTable();
            table.setTableNumber("12-Seater Table " + i);
            table.setTableSeats(12);
            table.setRestaurant(restaurant);
            restaurantTableService.createTable(table);
        }

        // Redirect after successfully adding the restaurant and tables
        return new ModelAndView("redirect:/admin/manage-restaurants");
    }



    // List all restaurants for view, edit, or disable actions
    @GetMapping("/view-restaurants")
    public ModelAndView viewRestaurants() {
        List<Restaurant> restaurants = restaurantService.getAllRestaurants(); // Fetch list of restaurants
        ModelAndView modelAndView = new ModelAndView("view-restaurants");
        modelAndView.addObject("restaurants", restaurants);
        return modelAndView;
    }

    // Show the form to edit a restaurant
    @GetMapping("/edit-restaurant/{restaurantId}")
    public ModelAndView showEditRestaurantForm(@PathVariable String restaurantId) {
        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId); // Fetch restaurant by ID
        ModelAndView modelAndView = new ModelAndView("edit-restaurants");
        modelAndView.addObject("restaurant", restaurant);
        return modelAndView;
    }

 // Update restaurant details
    @PostMapping("/edit-restaurant")
    public ModelAndView updateRestaurant(@RequestParam("restaurantId") String restaurantId, 
                                         @ModelAttribute("restaurant") Restaurant updatedRestaurant) {
        restaurantService.updateRestaurant(restaurantId, updatedRestaurant); // Pass both ID and updated restaurant object
        return new ModelAndView("redirect:/admin/view-restaurants"); // Redirect back to view page after update
    }


    // Disable a restaurant
    @GetMapping("/disable-restaurant/{restaurantId}")
    public String disableRestaurant(@PathVariable String restaurantId) {
        restaurantService.disableRestaurant(restaurantId); // Service method to disable restaurant
        return "redirect:/admin/view-restaurants";
    }

    // Activate a restaurant
    @GetMapping("/activate-restaurant/{restaurantId}")
    public String activateRestaurant(@PathVariable String restaurantId) {
        restaurantService.activateRestaurant(restaurantId); // Service method to activate restaurant
        return "redirect:/admin/view-restaurants";
    }

}
