package com.crimsonlogic.restaurantbookingsystem.data;

import lombok.Data;

@Data
public class PaymentCancelRequest {
    private String paymentId;
    private String tableId;

    // Getters and setters
}

