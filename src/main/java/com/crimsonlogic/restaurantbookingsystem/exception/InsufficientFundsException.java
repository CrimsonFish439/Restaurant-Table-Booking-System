package com.crimsonlogic.restaurantbookingsystem.exception;

public class InsufficientFundsException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public InsufficientFundsException(String errMsg) {
		super(errMsg);
	}

}
