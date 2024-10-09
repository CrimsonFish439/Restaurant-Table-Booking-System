package com.crimsonlogic.restaurantbookingsystem.util;

import java.util.UUID;

public class IDGenerator {
    public static String generateCustomerId() {
        return "CUS" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }

    public static String generateBookingId() {
        return "BKG" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }

    public static String generatePaymentId() {
        return "PAY" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }

    public static String generateRestaurantId() {
        return "RST" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }

    public static String generateTableId() {
        return "TBL" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }

    public static String generateTransactionId() {
        return "TRX" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }

	public static String generateReviewId() {
		return "RVW" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
	}
}

