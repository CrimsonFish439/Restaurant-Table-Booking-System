package com.crimsonlogic.restaurantbookingsystem.repository;

import com.crimsonlogic.restaurantbookingsystem.entity.Payment;
import com.crimsonlogic.restaurantbookingsystem.enums.PaymentStatus;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, String> {

   
    List<Payment> findByCustomerCustomerId(String customerId);

    Payment findByBookingBookingId(String bookingId);

    List<Payment> findByPaymentStatus(String paymentStatus);

	List<Payment> findAllByPaymentDateBetween(LocalDate startDate, LocalDate endDate);
    
    
}
