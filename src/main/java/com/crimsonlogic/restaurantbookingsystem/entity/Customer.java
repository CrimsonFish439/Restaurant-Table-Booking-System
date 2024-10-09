package com.crimsonlogic.restaurantbookingsystem.entity;

import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.Pattern;

import com.crimsonlogic.restaurantbookingsystem.util.IDGenerator;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "customers")
public class Customer {

	@Id
    @Column(name = "customer_id", unique = true, nullable = false)
    private String customerId;
	
	@Column(name = "customer_first_name", nullable = false)
    private String customerFirstName;

    @Column(name = "customer_last_name", nullable = false)
    private String customerLastName;

    @Column(name = "customer_username", nullable = false)
    private String customerUsername;

    @Column(name = "customer_password", nullable = false, length = 255)
    private String customerPassword;

    @Column(name = "customer_email", nullable = false)
    @Email(message = "Please provide a valid email")
    private String customerEmail;

    @Column(name = "customer_phone_number", nullable = false)
    @Pattern(regexp = "^\\d{10}$", message = "Please provide a valid 10-digit phone number")
    private String customerPhoneNumber;

    @Column(name = "customer_wallet_balance", nullable = false)
    private BigDecimal customerWalletBalance = BigDecimal.ZERO;

    @Column(name = "customer_role", nullable = false)
    private String customerRole = "USER";

    @PrePersist
    public void generateId() {
        this.customerId = IDGenerator.generateCustomerId();
    }
    
}
