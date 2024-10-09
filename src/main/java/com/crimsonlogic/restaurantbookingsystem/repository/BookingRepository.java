package com.crimsonlogic.restaurantbookingsystem.repository;

import com.crimsonlogic.restaurantbookingsystem.entity.Booking;
import com.crimsonlogic.restaurantbookingsystem.entity.Customer;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, String> {

    List<Booking> findByCustomerCustomerId(String customerId);
    List<Booking> findByRestaurantRestaurantId(String restaurantId);
    List<Booking> findByBookingDate(LocalDate bookingDate);
    List<Booking> findByBookingStatusAndBookingPaymentTimeoutBefore(String bookingStatus, LocalDate paymentTimeoutDate);
    
	/*
	 * @Query("SELECT b FROM Booking b WHERE b.table.tableId = :tableId AND (b.timeSlotStart < :endTime AND b.timeSlotEnd > :startTime)"
	 * ) List<Booking> findConflictingBookings(@Param("tableId") String
	 * tableId, @Param("startTime") LocalDateTime startTime, @Param("endTime")
	 * LocalDateTime endTime);
	 */
	
	
	@Query("SELECT b FROM Booking b WHERE b.table.tableId = :tableId AND b.bookingDate = :date")
	List<Booking> findByTableIdAndBookingDate(@Param("tableId") String tableId, @Param("date") LocalDate date);
	
	@Query("SELECT b FROM Booking b WHERE b.table.tableId = :tableId AND b.bookingDate = :bookingDate AND "
	        + "(b.timeSlotStart < :timeEnd AND b.timeSlotEnd > :timeStart) "
	        + "AND (b.bookingStatus = 'CONFIRMED' OR b.bookingStatus = 'COMPLETED')")
	List<Booking> findConflictingBookings(
	        @Param("tableId") String tableId, 
	        @Param("bookingDate") LocalDate bookingDate, 
	        @Param("timeStart") LocalTime timeStart, 
	        @Param("timeEnd") LocalTime timeEnd);

	
	@Query("SELECT b FROM Booking b WHERE b.bookingStatus = 'PENDING'")
	List<Booking> findPendingBookings();
	
	@Query("SELECT b FROM Booking b WHERE b.bookingStatus = 'CONFIRMED'")
	List<Booking> findConfirmedBookings();
	
	List<Booking> findAllByBookingDateBetween(LocalDate startDate, LocalDate endDate);
	
	List<Booking> findBookingsByCustomer(Customer customer);
	
	


 	       
}
