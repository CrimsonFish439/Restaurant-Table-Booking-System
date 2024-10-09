package com.crimsonlogic.restaurantbookingsystem.service;

import com.crimsonlogic.restaurantbookingsystem.entity.Customer;

public interface CustomerService {
	//Customer authenticateCustomer(String username, String password);
	Customer authenticateCustomerByEmail(String email, String password); // New method for email login
    Customer getCustomerByUsername(String username);
    Customer getCustomerByCustomerId(String customerId);
    Customer createCustomer(Customer customer);
    void updateCustomer(String customerId, Customer updatedCustomer);
    boolean isUsernameTaken(String username);
    boolean isEmailTaken(String email);
}


