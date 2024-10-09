package com.crimsonlogic.restaurantbookingsystem.exception;

public class PaymentNotFoundException extends RuntimeException{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public PaymentNotFoundException(String errMsg) {
		super(errMsg);
	}
}
