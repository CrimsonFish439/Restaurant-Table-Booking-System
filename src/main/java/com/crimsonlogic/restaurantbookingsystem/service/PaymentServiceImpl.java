package com.crimsonlogic.restaurantbookingsystem.service;

import com.crimsonlogic.restaurantbookingsystem.entity.Booking;
import com.crimsonlogic.restaurantbookingsystem.entity.Customer;
import com.crimsonlogic.restaurantbookingsystem.entity.Payment;
import com.crimsonlogic.restaurantbookingsystem.entity.RestaurantTable;
import com.crimsonlogic.restaurantbookingsystem.enums.BookingStatus;
import com.crimsonlogic.restaurantbookingsystem.enums.PaymentStatus;
import com.crimsonlogic.restaurantbookingsystem.exception.PaymentNotFoundException;
import com.crimsonlogic.restaurantbookingsystem.exception.TableNotFoundException;
import com.crimsonlogic.restaurantbookingsystem.repository.BookingRepository;
import com.crimsonlogic.restaurantbookingsystem.repository.PaymentRepository;
import com.crimsonlogic.restaurantbookingsystem.repository.RestaurantTableRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import javax.servlet.http.HttpSession;

@Service
public class PaymentServiceImpl implements PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;
    
    @Autowired
    private RestaurantTableRepository restaurantTableRepository;
    
    @Autowired
    private BookingRepository bookingRepository;

    @Override
    public Payment getPaymentById(String paymentId) {
        return paymentRepository.findById(paymentId)
                .orElseThrow(() -> new PaymentNotFoundException("Payment with ID " + paymentId + " not found"));
    }

    @Override
    public Payment getPaymentByBookingId(String bookingId) {
        return paymentRepository.findByBookingBookingId(bookingId);
    }

    @Override
    public List<Payment> getPaymentsByCustomerId(String customerId) {
        return paymentRepository.findByCustomerCustomerId(customerId);
    }

    @Override
    public List<Payment> getPaymentsByStatus(String paymentStatus) {
        return paymentRepository.findByPaymentStatus(paymentStatus);
    }

    @Override
    public Payment createPayment(Payment payment, HttpSession session) {
        // Set payment details, like status, amount, etc.
        payment.setPaymentStatus(PaymentStatus.PENDING);

        // Retrieve the customer from session and set it in the payment
        Customer customer = (Customer) session.getAttribute("loggedInCustomer");
        if (customer == null) {
            throw new IllegalStateException("Customer not found in session.");
        }
        payment.setCustomer(customer);

        // Retrieve the booking from session and set it in the payment
        Booking booking = (Booking) session.getAttribute("booking");
        if (booking == null) {
            throw new IllegalStateException("Booking not found in session.");
        }
        payment.setBooking(booking);
        
        payment.setPaymentMethod("Not Selected");

        // Save the payment in the database
        return paymentRepository.save(payment);
    }



    @Override
    public Payment updatePayment(String paymentId, Payment updatedPayment) {
        Payment existingPayment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new PaymentNotFoundException("Payment with ID " + paymentId + " not found"));

        existingPayment.setPaymentAmount(updatedPayment.getPaymentAmount());
        existingPayment.setPaymentMethod(updatedPayment.getPaymentMethod());
        existingPayment.setPaymentStatus(updatedPayment.getPaymentStatus());
        return paymentRepository.save(existingPayment);
    }

    @Transactional(rollbackFor = Exception.class)
    public void cancelPaymentAndReleaseTable(String paymentId, String tableId) throws Exception {
        // Find the payment
        Payment payment = paymentRepository.findById(paymentId).orElseThrow(() -> new Exception("Payment not found"));
        
        // Find the associated booking
        Booking booking = payment.getBooking();
        if (booking == null) {
            throw new Exception("Booking not found for payment");
        }

        // Only cancel if the payment is still pending
        if (payment.getPaymentStatus() == PaymentStatus.PENDING) {
            // Set payment status to cancelled
            payment.setPaymentStatus(PaymentStatus.CANCELLED);
            paymentRepository.save(payment);

            // Set booking status to cancelled
            booking.setBookingStatus(BookingStatus.CANCELLED);
            bookingRepository.save(booking);

            // Optionally release the table (if using table availability flag)
            RestaurantTable table = booking.getTable();
            if (table != null) {
                table.setTableIsAvailable(true);
                restaurantTableRepository.save(table);
            }
        }
    }
    
    @Override
    public List<Payment> getPaymentsByDateRange(LocalDate startDate, LocalDate endDate) {
        return paymentRepository.findAllByPaymentDateBetween(startDate, endDate);
    }



    
//    @Override
//    public Payment processPayment(Payment payment, String restaurantId, String tableId, String bookingDate, String timeSlot, int guestCount) {
//        // Handle wallet or other payment methods
////        if ("wallet".equals(payment.getPaymentMethod())) {
////            walletService.deductFromWallet(payment.getCustomer(), payment.getPaymentAmount());
////        }
//
//        // Save the payment details
//        Payment savedPayment = paymentRepository.save(payment);
//
////        // Confirm the booking after the payment
////        bookingService.confirmBooking(restaurantId, tableId, bookingDate, timeSlot, guestCount, savedPayment);
//
//        return savedPayment;
//    }

}
