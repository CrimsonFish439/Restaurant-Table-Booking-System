package com.crimsonlogic.restaurantbookingsystem.service;

import com.crimsonlogic.restaurantbookingsystem.entity.Customer;
import com.crimsonlogic.restaurantbookingsystem.exception.CustomerExistsException;
import com.crimsonlogic.restaurantbookingsystem.exception.CustomerNotFoundException;
import com.crimsonlogic.restaurantbookingsystem.repository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerRepository customerRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;

//    @Override
//    public Customer authenticateCustomer(String username, String password) {
//        Customer customer = customerRepository.findByCustomerUsername(username);
//        if (customer != null && customer.getCustomerPassword().equals(password)) {
//            return customer;
//        }
//        throw new CustomerNotFoundException("Invalid username or password.");
//    }

    @Override
    public Customer authenticateCustomerByEmail(String email, String password) {
        // Debug statement: Log email lookup
        System.out.println("Looking up customer by email: " + email);
        boolean isValid = BCrypt.checkpw("Savita@123", "$2a$10$ugnePYRoMmbki1YB1ySIqOBO08qBrH7MTIdoWXoXgHuVQAIsJvY4G");
        System.out.println("Manual check: " + isValid);
        // Find the customer by email
        Customer customer = customerRepository.findByCustomerEmail(email);

        // Debug statement: Log if the customer is found
        if (customer != null) {
            System.out.println("Customer found in database with email: " + customer.getCustomerEmail());
            System.out.println("Entered password: " + password);  // Raw password entered by the user
            System.out.println("Stored hashed password: " + customer.getCustomerPassword());  // Stored hashed password

            // Check if the password matches
            if (BCrypt.checkpw(password, customer.getCustomerPassword())) {
                // Debug statement: Log successful password match
                System.out.println("Password matches for customer: " + customer.getCustomerEmail());
                return customer;
            } else {
                // Debug statement: Log if password does not match
                System.out.println("Password mismatch for customer: " + customer.getCustomerEmail());
                System.out.println("Entered password: " + password);
                System.out.println("Stored hashed password: " + customer.getCustomerPassword());
            }
        } else {
            // Debug statement: Log if customer not found
            System.out.println("No customer found with email: " + email);
        }

        // Throw exception if no match
        throw new CustomerNotFoundException("Invalid email or password.");
    }



    @Override
    public Customer getCustomerByUsername(String username) {
        return customerRepository.findByCustomerUsername(username);
    }

    @Override
    public Customer getCustomerByCustomerId(String customerId) {
        return customerRepository.findById(customerId)
                .orElseThrow(() -> new CustomerNotFoundException("Customer with ID " + customerId + " not found"));
    }

    @Override
    public Customer createCustomer(Customer customer) {
        if (customerRepository.existsByCustomerEmail(customer.getCustomerEmail())) {
            throw new CustomerExistsException("Email " + customer.getCustomerEmail() + " is already in use");
        }
        if (customerRepository.existsByCustomerUsername(customer.getCustomerUsername())) {
            throw new CustomerExistsException("Username " + customer.getCustomerUsername() + " is already in use");
        }
        
        // Hash the password before saving
        //String hashedPassword = BCrypt.hashpw(customer.getCustomerPassword(), BCrypt.gensalt());
        System.out.println("Raw password: " + customer.getCustomerPassword());
        String hashedPassword = BCrypt.hashpw(customer.getCustomerPassword(), BCrypt.gensalt());
        System.out.println("Hashed password: " + hashedPassword);

        
        return customerRepository.save(customer);
    }

    @Override
    public void updateCustomer(String customerId, Customer updatedCustomer) {
        Customer existingCustomer = customerRepository.findById(customerId)
                .orElseThrow(() -> new CustomerNotFoundException("Customer with ID " + customerId + " not found"));

        existingCustomer.setCustomerFirstName(updatedCustomer.getCustomerFirstName());
        existingCustomer.setCustomerLastName(updatedCustomer.getCustomerLastName());
        existingCustomer.setCustomerPhoneNumber(updatedCustomer.getCustomerPhoneNumber());

        if (updatedCustomer.getCustomerPassword() != null && !updatedCustomer.getCustomerPassword().isEmpty()) {
            // Encode the updated password
            existingCustomer.setCustomerPassword(passwordEncoder.encode(updatedCustomer.getCustomerPassword()));
        }

        customerRepository.save(existingCustomer);
    }

    @Override
    public boolean isUsernameTaken(String username) {
        return customerRepository.findByCustomerUsername(username) != null;
    }

    @Override
    public boolean isEmailTaken(String email) {
        return customerRepository.findByCustomerEmail(email) != null;
    }
}
