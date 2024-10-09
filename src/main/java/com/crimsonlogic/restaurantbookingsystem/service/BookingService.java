package com.crimsonlogic.restaurantbookingsystem.service;

import com.crimsonlogic.restaurantbookingsystem.entity.Booking;
import com.crimsonlogic.restaurantbookingsystem.entity.Customer;
import com.crimsonlogic.restaurantbookingsystem.entity.Payment;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface BookingService {
    Booking getBookingById(String bookingId);
    List<Booking> getBookingsByCustomerId(String customerId);
    List<Booking> getBookingsByRestaurantId(String restaurantId);
    List<Booking> getBookingsByDate(LocalDate bookingDate);
    Booking createBooking(Booking booking);
    Booking createPendingBooking(Booking booking);
    void updateBooking(String bookingId, Booking updatedBooking);
    void cancelBooking(String bookingId);
    List<Booking> findExpiredBookings(LocalDate currentDate);
//	void confirmBooking(String restaurantId, String tableId, String bookingDate, String timeSlot, int guestCount,
//			Payment savedPayment);
	void confirmBooking(Booking booking, Payment payment);
	boolean isTableAvailable(String tableId, LocalDate bookingDate, LocalTime timeSlotStart, LocalTime timeSlotEnd);
	List<Booking> getBookingsByDateRange(LocalDate startDate, LocalDate endDate);
	List<Booking> getBookingsByCustomer(Customer customer);
}
