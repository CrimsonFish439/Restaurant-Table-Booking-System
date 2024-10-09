package com.crimsonlogic.restaurantbookingsystem.repository;

import com.crimsonlogic.restaurantbookingsystem.entity.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RestaurantRepository extends JpaRepository<Restaurant, String> {

    List<Restaurant> findByRestaurantLocation(String location);

    List<Restaurant> findByRestaurantCategory(String category);

    List<Restaurant> findByRestaurantRatingGreaterThanEqual(Double rating);
    
    List<Restaurant> findByRestaurantNameContainingIgnoreCase(String name);
    
    // Fetch basic restaurant details
    @Query("SELECT r FROM Restaurant r WHERE r.id = :restaurantId")
    Restaurant findBasicRestaurantDetails(@Param("restaurantId") String restaurantId);
    
//    // Fetch restaurant reviews
//    @Query("SELECT r FROM Restaurant r JOIN FETCH r.restaurantReviews WHERE r.id = :restaurantId")
//    Restaurant findRestaurantWithReviews(@Param("restaurantId") String restaurantId);        
    
    @Query("SELECT r FROM Restaurant r JOIN FETCH r.restaurantTables WHERE r.restaurantId = :restaurantId")
    Restaurant findRestaurantWithTables(@Param("restaurantId") String restaurantId);
    
    @Query("SELECT r FROM Restaurant r WHERE r.restaurantStatus = 'Active'")
    List<Restaurant> findActiveRestaurants();

}


