package com.crimsonlogic.restaurantbookingsystem.service;

import com.crimsonlogic.restaurantbookingsystem.entity.Payment;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.http.HttpSession;

public interface PaymentService {
    Payment getPaymentById(String paymentId);
    Payment getPaymentByBookingId(String bookingId);
    List<Payment> getPaymentsByCustomerId(String customerId);
    List<Payment> getPaymentsByStatus(String paymentStatus);
    Payment createPayment(Payment payment, HttpSession session);
    Payment updatePayment(String paymentId, Payment updatedPayment);
//	Payment processPayment(Payment payment, String restaurantId, String tableId, String bookingDate, String timeSlot,
//			int guestCount);
	void cancelPaymentAndReleaseTable(String paymentId, String tableId) throws Exception;
	List<Payment> getPaymentsByDateRange(LocalDate startDate, LocalDate endDate);
	
}
