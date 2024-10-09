package com.crimsonlogic.restaurantbookingsystem.service;

import com.crimsonlogic.restaurantbookingsystem.entity.Booking;
import com.crimsonlogic.restaurantbookingsystem.entity.Customer;
import com.crimsonlogic.restaurantbookingsystem.entity.Payment;
import com.crimsonlogic.restaurantbookingsystem.enums.BookingStatus;
import com.crimsonlogic.restaurantbookingsystem.exception.BookingNotFoundException;
import com.crimsonlogic.restaurantbookingsystem.repository.BookingRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Service
public class BookingServiceImpl implements BookingService {

    @Autowired
    private BookingRepository bookingRepository;
    
    @Autowired
    private RestaurantTableService tableService;

    @Override
    public Booking getBookingById(String bookingId) {
        return bookingRepository.findById(bookingId)
                .orElseThrow(() -> new BookingNotFoundException("Booking with ID " + bookingId + " not found"));
    }

    @Override
    public List<Booking> getBookingsByCustomerId(String customerId) {
        return bookingRepository.findByCustomerCustomerId(customerId);
    }

    @Override
    public List<Booking> getBookingsByRestaurantId(String restaurantId) {
        return bookingRepository.findByRestaurantRestaurantId(restaurantId);
    }

    @Override
    public List<Booking> getBookingsByDate(LocalDate bookingDate) {
        return bookingRepository.findByBookingDate(bookingDate);
    }

    @Override
    public Booking createBooking(Booking booking) {
        booking.setBookingStatus(BookingStatus.PENDING); // default status
        return bookingRepository.save(booking);
    }

    @Override
    public void updateBooking(String bookingId, Booking updatedBooking) {
        Booking existingBooking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new BookingNotFoundException("Booking with ID " + bookingId + " not found"));

        existingBooking.setTimeSlotStart(updatedBooking.getTimeSlotStart());
        existingBooking.setTimeSlotEnd(updatedBooking.getTimeSlotEnd());
        existingBooking.setBookingStatus(updatedBooking.getBookingStatus());
        existingBooking.setRestaurant(updatedBooking.getRestaurant());
        existingBooking.setTable(updatedBooking.getTable());

        if (updatedBooking.getPayment() != null) {
            existingBooking.setPayment(updatedBooking.getPayment());
        }

        bookingRepository.save(existingBooking);
    }

    @Override
    public List<Booking> findExpiredBookings(LocalDate currentDate) {
        return bookingRepository.findByBookingStatusAndBookingPaymentTimeoutBefore(BookingStatus.PENDING.name(), currentDate);
    }
    
	/*
	 * public boolean isTableAvailable(String tableId, LocalDateTime startTime,
	 * LocalDateTime endTime) { List<Booking> conflictingBookings =
	 * bookingRepository .findConflictingBookings(tableId, startTime, endTime);
	 * 
	 * return conflictingBookings.isEmpty(); }
	 */

    @Override
    public void confirmBooking(Booking booking, Payment payment) {
        booking.setPayment(payment);
        booking.setBookingStatus(BookingStatus.CONFIRMED);
        
        bookingRepository.save(booking);
        
        tableService.blockTable(booking.getTable().getTableId(), booking.getBookingDate().toString(), booking.getTimeSlotStart().toString());
    }

    @Override
    public boolean isTableAvailable(String tableId, LocalDate bookingDate, LocalTime timeStart, LocalTime timeEnd) {
    	System.out.println("Checking availability for Table ID: " + tableId + " on Date: " + bookingDate + 
    	        " between " + timeStart + " and " + timeEnd);
    	
        List<Booking> conflictingBookings = bookingRepository.findConflictingBookings(
                tableId, bookingDate, timeStart, timeEnd);
        
        System.out.println("Found " + conflictingBookings.size() + " conflicting bookings for Table ID: " + tableId);
        
        for (Booking booking : conflictingBookings) {
            System.out.println("Conflicting Booking ID: " + booking.getBookingId() +
                " Time Start: " + booking.getTimeSlotStart() + " Time End: " + booking.getTimeSlotEnd());
        }

        return conflictingBookings.isEmpty();
    }

    @Override
    public Booking createPendingBooking(Booking booking) {
        booking.setBookingStatus(BookingStatus.PENDING);
        return bookingRepository.save(booking);
    }
    
    @Override
    public List<Booking> getBookingsByDateRange(LocalDate startDate, LocalDate endDate) {
        return bookingRepository.findAllByBookingDateBetween(startDate, endDate);
    }
    
    @Override
    public List<Booking> getBookingsByCustomer(Customer customer) {
        return bookingRepository.findBookingsByCustomer(customer);
    }

    @Override
    public void cancelBooking(String bookingId) {
    	Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new RuntimeException("Booking not found"));
        
        if (booking.getBookingStatus() == BookingStatus.CONFIRMED) {
            booking.setBookingStatus(BookingStatus.CANCELLED);
            bookingRepository.save(booking);
        } else {
            throw new IllegalStateException("Only confirmed bookings can be cancelled.");
        }
    }
    

}
