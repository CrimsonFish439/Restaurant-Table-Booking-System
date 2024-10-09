package com.crimsonlogic.restaurantbookingsystem.controller;

import com.crimsonlogic.restaurantbookingsystem.entity.Booking;
import com.crimsonlogic.restaurantbookingsystem.enums.BookingStatus;
import com.crimsonlogic.restaurantbookingsystem.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/bookings")
public class BookingController {

    @Autowired
    private BookingService bookingService;

    // 1. Create a new booking
    @PostMapping("/create")
    public ModelAndView createBooking(@ModelAttribute Booking booking) {
        booking.setBookingStatus(BookingStatus.PENDING); // Set default status
        bookingService.createBooking(booking);
        return new ModelAndView("redirect:/bookings/list");
    }

    // 2. Get booking details by ID
    @GetMapping("/{bookingId}")
    public ModelAndView getBookingById(@PathVariable String bookingId) {
        ModelAndView modelAndView = new ModelAndView("bookingDetails");
        Booking booking = bookingService.getBookingById(bookingId);
        modelAndView.addObject("booking", booking);
        return modelAndView;
    }

    // 3. List all bookings by customer ID
    @GetMapping("/customer/{customerId}")
    public ModelAndView getBookingsByCustomerId(@PathVariable String customerId) {
        ModelAndView modelAndView = new ModelAndView("bookingList");
        List<Booking> bookings = bookingService.getBookingsByCustomerId(customerId);
        modelAndView.addObject("bookings", bookings);
        return modelAndView;
    }

    // 4. Update booking
    @PutMapping("/{bookingId}")
    public ModelAndView updateBooking(@PathVariable String bookingId, @ModelAttribute Booking updatedBooking) {
        bookingService.updateBooking(bookingId, updatedBooking);
        return new ModelAndView("redirect:/bookings/" + bookingId);
    }

    // 5. Cancel a booking
    @PutMapping("/cancel/{bookingId}")
    public ModelAndView cancelBooking(@PathVariable String bookingId) {
        bookingService.cancelBooking(bookingId);
        return new ModelAndView("redirect:/bookings/list");
    }

    // 6. Find expired bookings
    @GetMapping("/expired")
    public ModelAndView findExpiredBookings() {
        ModelAndView modelAndView = new ModelAndView("expiredBookings");
        List<Booking> expiredBookings = bookingService.findExpiredBookings(LocalDate.now());
        modelAndView.addObject("expiredBookings", expiredBookings);
        return modelAndView;
    }
}
