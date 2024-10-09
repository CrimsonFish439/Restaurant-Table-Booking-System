package com.crimsonlogic.restaurantbookingsystem.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.crimsonlogic.restaurantbookingsystem.entity.Booking;
import com.crimsonlogic.restaurantbookingsystem.enums.BookingStatus;
import com.crimsonlogic.restaurantbookingsystem.repository.BookingRepository;

@Component
public class BookingTimeoutScheduler {

    @Autowired
    private BookingRepository bookingRepository;

    @Scheduled(fixedRate = 120000) // Run every 120 seconds
    public void cancelPendingBookings() {
    	List<Booking> pendingBookings = bookingRepository.findPendingBookings();

        LocalDateTime now = LocalDateTime.now();

        for (Booking booking : pendingBookings) {
            // Combine booking date and time to form a LocalDateTime
            LocalDateTime bookingTimeEnd = LocalDateTime.of(booking.getBookingDate(), booking.getTimeSlotEnd());

            // Check if the booking's time has passed by 5 minutes
            if (bookingTimeEnd.plusMinutes(5).isBefore(now)) {
                booking.setBookingStatus(BookingStatus.CANCELLED);
                bookingRepository.save(booking);
            }
        }
    }
    
	/*
	 * @Scheduled(fixedRate = 120000) // 120 seconds public void
	 * handleExpiredBookings() { System.out.println("Scheduler Running");
	 * List<Booking> confirmedBookings = bookingRepository.findConfirmedBookings();
	 * // Finds bookings with status "CONFIRMED"
	 * 
	 * LocalDateTime now = LocalDateTime.now();
	 * 
	 * for (Booking booking : confirmedBookings) { LocalDateTime bookingEndTime =
	 * LocalDateTime.of(booking.getBookingDate(), booking.getTimeSlotEnd());
	 * 
	 * // If the booking's time slot has passed, mark the booking as COMPLETED if
	 * (bookingEndTime.isBefore(now)) {
	 * booking.setBookingStatus(BookingStatus.COMPLETED); // Mark booking as
	 * completed after time slot ends bookingRepository.save(booking); // Save the
	 * updated booking } } }
	 */
}
