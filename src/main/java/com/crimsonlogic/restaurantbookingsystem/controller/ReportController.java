package com.crimsonlogic.restaurantbookingsystem.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.crimsonlogic.restaurantbookingsystem.entity.Booking;
import com.crimsonlogic.restaurantbookingsystem.entity.Payment;
import com.crimsonlogic.restaurantbookingsystem.service.BookingService;
import com.crimsonlogic.restaurantbookingsystem.service.PaymentService;

import java.util.List;

@Controller
@RequestMapping("/reports")
public class ReportController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private PaymentService paymentService;

    @GetMapping
    public String showReportPage() {
        return "view-reports";
    }

    @PostMapping("/reports")
    public ModelAndView getReports(@RequestParam("startDate") String startDateStr, 
                                   @RequestParam("endDate") String endDateStr) {
        
        // Parse the input strings to LocalDate
        LocalDate startDate = LocalDate.parse(startDateStr);
        LocalDate endDate = LocalDate.parse(endDateStr);

        // Fetch bookings and payments within the date range
        List<Booking> bookings = bookingService.getBookingsByDateRange(startDate, endDate);
        List<Payment> payments = paymentService.getPaymentsByDateRange(startDate, endDate);

        // Create ModelAndView and add attributes
        ModelAndView modelAndView = new ModelAndView("view-reports"); // 'view-reports' is the JSP page name
        modelAndView.addObject("bookings", bookings);
        modelAndView.addObject("payments", payments);

        return modelAndView; // Return the ModelAndView object
    }
}

