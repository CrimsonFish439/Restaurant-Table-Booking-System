package com.crimsonlogic.restaurantbookingsystem.controller;

import com.crimsonlogic.restaurantbookingsystem.entity.Booking;
import com.crimsonlogic.restaurantbookingsystem.entity.Customer;
import com.crimsonlogic.restaurantbookingsystem.entity.Restaurant;
import com.crimsonlogic.restaurantbookingsystem.exception.CustomerNotFoundException;
import com.crimsonlogic.restaurantbookingsystem.service.BookingService;
import com.crimsonlogic.restaurantbookingsystem.service.CustomerService;
import com.crimsonlogic.restaurantbookingsystem.service.RestaurantService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/customers")
public class CustomerController {
	
	private static final Logger LOG = LoggerFactory.getLogger(CustomerController.class);

    @Autowired
    private CustomerService customerService;

    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private BookingService bookingService;

    // Populating the customer object from the session
    @ModelAttribute("customer")
    public Customer populateCustomer(HttpSession session) {
        return (Customer) session.getAttribute("loggedInCustomer");
    }

    // Show signup page
    @GetMapping("/signup")
    public ModelAndView showSignupForm() {
        ModelAndView modelAndView = new ModelAndView("signup");
        modelAndView.addObject("customer", new Customer());
        return modelAndView;
    }

    // Signup a new customer
    @PostMapping("/signup")
    public ModelAndView signUpCustomer(HttpSession session, @RequestParam String customerFirstName, 
                                       @RequestParam String customerLastName, 
                                       @RequestParam String customerUsername,
                                       @RequestParam String customerEmail,
                                       @RequestParam String customerPhoneNumber, 
                                       @RequestParam String customerPassword) {
        ModelAndView modelAndView = new ModelAndView("signup");

        

        if (customerService.isUsernameTaken(customerUsername)) {
            modelAndView.addObject("usernameError", "Username is already taken.");
            return modelAndView;
        }

        if (customerService.isEmailTaken(customerEmail)) {
            modelAndView.addObject("emailError", "Email is already registered.");
            return modelAndView;
        }
        
        Customer customer = new Customer();
        customer.setCustomerFirstName(customerFirstName);
        customer.setCustomerLastName(customerLastName);
        customer.setCustomerUsername(customerUsername);
        customer.setCustomerEmail(customerEmail);
        customer.setCustomerPhoneNumber(customerPhoneNumber);
        
        String hashedPassword = BCrypt.hashpw(customerPassword, BCrypt.gensalt());
        LOG.debug("Hashed password for user " + customer.getCustomerEmail() + ": " + hashedPassword);

        customer.setCustomerPassword(hashedPassword);

        customerService.createCustomer(customer);
        session.setAttribute("loggedInCustomer", customer);
        return new ModelAndView("redirect:/customers/signin");
    }

    // Show signin page
    @GetMapping("/signin")
    public ModelAndView showSigninForm() {
        return new ModelAndView("signin");
    }

    @PostMapping("/signin")
    public ModelAndView signInCustomer(@RequestParam String email, @RequestParam String password, HttpSession session) {
        ModelAndView modelAndView;
        try {
            // Log email entered by the user
        	LOG.debug("Attempting to log in with email: " + email);

            // Retrieve the customer by email
            Customer customer = customerService.authenticateCustomerByEmail(email, password);

            // Log if the customer is found
            LOG.debug("Customer found: " + customer.getCustomerEmail());

            // Compare the raw password entered by the user with the hashed password in the database using BCrypt.checkpw
            if (BCrypt.checkpw(password, customer.getCustomerPassword())) {
                // Log if the password matches
            	LOG.debug("Password matches for customer: " + customer.getCustomerEmail());

                // Password matches, proceed with login
                session.setAttribute("loggedInCustomer", customer);

                // Redirect based on the role
                modelAndView = customer.getCustomerRole().equals("ADMIN") ? 
                    new ModelAndView("redirect:/admin/dashboard") : 
                    new ModelAndView("redirect:/customers/home");
            } else {
                // Log if the password does not match
            	LOG.debug("Password does not match for customer: " + customer.getCustomerEmail());

                // Password does not match
                modelAndView = new ModelAndView("signin");
                modelAndView.addObject("error", "Invalid email or password.");
            }
        } catch (CustomerNotFoundException e) {
            // Log if the email is not found or any other error occurs
        	LOG.debug("Customer not found or error occurred: " + e.getMessage());

            modelAndView = new ModelAndView("signin");
            modelAndView.addObject("error", "Invalid email or password.");
        }
        return modelAndView;
    }






    // Show profile page
    @GetMapping("/profile")
    public ModelAndView showProfile(HttpSession session) {
        // Retrieve the logged-in customer from the session
        Customer loggedInCustomer = (Customer) session.getAttribute("loggedInCustomer");

        // Initialize ModelAndView
        ModelAndView modelAndView = new ModelAndView("profile"); // This should map to the profile JSP page

        // Fetch the customer’s bookings
        List<Booking> bookings = bookingService.getBookingsByCustomer(loggedInCustomer);

        // Add customer and booking data to the model
        modelAndView.addObject("customer", loggedInCustomer);
        modelAndView.addObject("bookings", bookings);

        return modelAndView;
    }
    
    @PostMapping("/cancelBooking/{bookingId}")
    public ModelAndView cancelBooking(@PathVariable String bookingId, RedirectAttributes redirectAttributes) {
        // Call the service to cancel the booking using bookingId only
        bookingService.cancelBooking(bookingId);

        // Add success message to redirect attributes
        redirectAttributes.addFlashAttribute("message", "Booking cancellation successful!");

        // Redirect to the profile page with a success message
        return new ModelAndView("redirect:/customers/profile");
    }



    // Sign out customer (invalidate session)
    @GetMapping("/signout")
    public ModelAndView signOutCustomer(HttpSession session) {
        session.invalidate();
        return new ModelAndView("redirect:/");
    }

    // Fetch and display the customer home page after login
    @GetMapping("/home")
    public ModelAndView showCustomerHome(@ModelAttribute("customer") Customer customer) {
        if (customer != null) {
            List<Restaurant> restaurants = restaurantService.getActiveRestaurants();
            return new ModelAndView("customer-home")
                    .addObject("restaurants", restaurants)
                    .addObject("customer", customer);
        }
        return new ModelAndView("redirect:/customers/signin");
    }

    // Check if username is taken (for async validation)
    @GetMapping("/check-username")
    @ResponseBody
    public boolean isUsernameTaken(@RequestParam("username") String username) {
        return customerService.isUsernameTaken(username);
    }

    // Check if email is taken (for async validation)
    @GetMapping("/check-email")
    @ResponseBody
    public boolean isEmailTaken(@RequestParam("email") String email) {
        return customerService.isEmailTaken(email);
    }
}
