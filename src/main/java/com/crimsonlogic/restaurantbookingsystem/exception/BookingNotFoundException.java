package com.crimsonlogic.restaurantbookingsystem.exception;

public class BookingNotFoundException extends RuntimeException {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public BookingNotFoundException(String errMsg) {
		super(errMsg);
	}
}
