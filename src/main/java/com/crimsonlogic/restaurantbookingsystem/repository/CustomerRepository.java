package com.crimsonlogic.restaurantbookingsystem.repository;

import com.crimsonlogic.restaurantbookingsystem.entity.Customer;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, String> {

    Customer findByCustomerUsername(String username);
    
    Customer findByCustomerEmail(String email);

    List<Customer> findByCustomerRole(String role);

    boolean existsByCustomerEmail(String email);
    
    boolean existsByCustomerUsername(String username);
    
    @Query("SELECT c FROM Customer c WHERE c.customerEmail = :email AND c.customerPassword = :password")
    Customer findByCustomerEmail(@Param("email") String email, @Param("password") String password);

}



