package com.crimsonlogic.restaurantbookingsystem.controller;

import com.crimsonlogic.restaurantbookingsystem.data.PaymentCancelRequest;
import com.crimsonlogic.restaurantbookingsystem.entity.Booking;
import com.crimsonlogic.restaurantbookingsystem.entity.Customer;
import com.crimsonlogic.restaurantbookingsystem.entity.Payment;
import com.crimsonlogic.restaurantbookingsystem.entity.Restaurant;
import com.crimsonlogic.restaurantbookingsystem.entity.RestaurantTable;
import com.crimsonlogic.restaurantbookingsystem.enums.BookingStatus;
import com.crimsonlogic.restaurantbookingsystem.enums.PaymentStatus;
import com.crimsonlogic.restaurantbookingsystem.service.BookingService;
import com.crimsonlogic.restaurantbookingsystem.service.PaymentService;
import com.crimsonlogic.restaurantbookingsystem.service.PdfService;
import com.crimsonlogic.restaurantbookingsystem.service.RestaurantService;
import com.crimsonlogic.restaurantbookingsystem.service.RestaurantTableService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/payments")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;
    
    @Autowired
    private BookingService bookingService;
    
    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private RestaurantTableService tableService;
    
    @Autowired
    private PdfService pdfService;

    @GetMapping("/redirectToPayment")
    public ModelAndView redirectToPayment(
            @RequestParam("restaurantId") String restaurantId,
            @RequestParam("tableId") String tableId,
            @RequestParam("bookingDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate bookingDate,
            @RequestParam("timeStart") String timeStart,
            @RequestParam("timeEnd") String timeEnd,
            @RequestParam("guestCount") int guestCount,
            @RequestParam("finalPrice") BigDecimal finalPrice,
            HttpSession session) {

        ModelAndView modelAndView = new ModelAndView("payments");

        // Retrieve customer and booking from session
        Customer customer = (Customer) session.getAttribute("loggedInCustomer");
        Booking booking = (Booking) session.getAttribute("booking");

        if (customer == null) {
            System.out.println("Customer session is null");
            modelAndView.setViewName("redirect:/errorPage");
            return modelAndView;
        } else if (booking == null) {
            System.out.println("Booking session is null");
            modelAndView.setViewName("redirect:/errorPage");
            return modelAndView;
        }

        // Set up booking details
        booking.setCustomer(customer);
        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
        RestaurantTable table = tableService.getTableById(tableId);
        booking.setRestaurant(restaurant);
        booking.setTable(table);
        booking.setGuestCount(guestCount);
        booking.setTimeSlotStart(LocalTime.parse(timeStart));
        booking.setTimeSlotEnd(LocalTime.parse(timeEnd));
        booking.setBookingDate(bookingDate);
        booking.setBookingStatus(BookingStatus.PENDING);
        booking.setBookingPaymentTimeout(bookingDate.plusDays(1));

        // Save the booking
        booking = bookingService.createBooking(booking);

        // Create the Payment object
        Payment newPayment = new Payment();
        newPayment.setCustomer(customer);
        newPayment.setBooking(booking);
        newPayment.setPaymentAmount(finalPrice);
        newPayment.setPaymentStatus(PaymentStatus.PENDING);
        newPayment.setPaymentMethod("Not Selected");

        // Save the payment entity
        Payment savedPayment = paymentService.createPayment(newPayment, session);

        if (savedPayment == null || savedPayment.getPaymentId() == null) {
            System.out.println("Payment not saved");
            modelAndView.setViewName("redirect:/errorPage");
            return modelAndView;
        }

        // Add attributes to the model to pass to the JSP
        modelAndView.addObject("payment", savedPayment);
        modelAndView.addObject("restaurant", restaurant);
        modelAndView.addObject("table", table);
        modelAndView.addObject("guestCount", guestCount);
        modelAndView.addObject("finalPrice", finalPrice);
        modelAndView.addObject("timeStart", timeStart);
        modelAndView.addObject("timeEnd", timeEnd);
        modelAndView.addObject("bookingDate", bookingDate);

        return modelAndView;
    }

    // Process the payment after confirming
    @PostMapping("/processPayment")
    public ModelAndView processPayment(
            @RequestParam("paymentId") String paymentId,
            @RequestParam("paymentMethod") String paymentMethod,
            HttpSession session) {
        
        ModelAndView modelAndView = new ModelAndView();

        // Retrieve the payment and booking from the session
        Customer customer = (Customer) session.getAttribute("loggedInCustomer");
        if (customer == null) {
            System.out.println("Customer session is null");
            modelAndView.setViewName("redirect:/errorPage");
            return modelAndView;
        }

        // Find the payment by paymentId
        Payment payment = paymentService.getPaymentById(paymentId);
        if (payment == null) {
            System.out.println("Payment not found");
            modelAndView.setViewName("redirect:/errorPage");
            return modelAndView;
        }

        // Find the associated booking
        Booking booking = payment.getBooking();
        if (booking == null) {
            System.out.println("Booking not found for payment");
            modelAndView.setViewName("redirect:/errorPage");
            return modelAndView;
        }
        
        

        // Update payment details
        payment.setPaymentMethod(paymentMethod);
        payment.setPaymentStatus(PaymentStatus.COMPLETED); // Update the payment status to completed
        // Update the payment with the provided ID
        paymentService.updatePayment(paymentId, payment);// Save the updated payment

        // Update booking status to CONFIRMED
        booking.setBookingStatus(BookingStatus.CONFIRMED);
        booking.setPayment(payment); // Associate the payment with the booking
        bookingService.updateBooking(booking.getBookingId(), booking); // Save the updated booking

        // Set view for payment success page
        modelAndView.setViewName("payment-success");
        modelAndView.addObject("booking", booking);
        modelAndView.addObject("payment", payment);
        
        return modelAndView;
    }

    // Payment success page
    @GetMapping("/paymentSuccess")
    public ModelAndView paymentSuccess() {
        return new ModelAndView("payment-success");
    }
    
    @GetMapping("/downloadReceipt")
    public void downloadReceipt(HttpServletResponse response, @RequestParam("paymentId") String paymentId) {
        try {
            // Find the payment by paymentId
            Payment payment = paymentService.getPaymentById(paymentId);
            if (payment == null) {
                throw new IllegalArgumentException("Payment not found");
            }

            // Get the associated booking
            Booking booking = payment.getBooking();
            if (booking == null) {
                throw new IllegalArgumentException("Booking not found");
            }

            // Generate the PDF receipt
            pdfService.generatePaymentReceipt(response, payment, booking);
        } catch (Exception e) {
            System.out.println("Error generating PDF receipt: " + e.getMessage());
        }
    }
    
    @PostMapping("/cancel")
    public ResponseEntity<String> cancelPayment(@RequestBody PaymentCancelRequest request) {
        try {
            // Cancel the payment and release the table
            paymentService.cancelPaymentAndReleaseTable(request.getPaymentId(), request.getTableId());
            return ResponseEntity.ok("Payment cancelled and table released.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error cancelling payment.");
        }
    }

    @GetMapping("/payment-timeout")
    public ModelAndView paymentTimeout() {
        return new ModelAndView("payment-timeout"); // Redirect to a custom JSP page for timeout
    }

}
