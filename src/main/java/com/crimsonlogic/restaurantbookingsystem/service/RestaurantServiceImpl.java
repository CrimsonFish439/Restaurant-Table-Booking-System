package com.crimsonlogic.restaurantbookingsystem.service;

import com.crimsonlogic.restaurantbookingsystem.entity.Restaurant;
import com.crimsonlogic.restaurantbookingsystem.exception.RestaurantNotFoundException;
import com.crimsonlogic.restaurantbookingsystem.repository.RestaurantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RestaurantServiceImpl implements RestaurantService {

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Override
    public Restaurant getRestaurantById(String restaurantId) {
        return restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RestaurantNotFoundException("Restaurant with ID " + restaurantId + " not found"));
    }

    @Override
    public List<Restaurant> getRestaurantsByLocation(String location) {
        return restaurantRepository.findByRestaurantLocation(location);
    }

    @Override
    public List<Restaurant> getRestaurantsByCategory(String category) {
        return restaurantRepository.findByRestaurantCategory(category);
    }

    @Override
    public List<Restaurant> getRestaurantsByRating(Double rating) {
        return restaurantRepository.findByRestaurantRatingGreaterThanEqual(rating);
    }
    
    @Override
    public List<Restaurant> getAllRestaurants() {
        return restaurantRepository.findAll();
    }

    @Override
    public void createRestaurant(Restaurant restaurant) {
        restaurantRepository.save(restaurant);
    }

    

    @Override
    public void updateRestaurant(String restaurantId, Restaurant updatedRestaurant) {
        Restaurant existingRestaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RestaurantNotFoundException("Restaurant with ID " + restaurantId + " not found"));

        existingRestaurant.setRestaurantName(updatedRestaurant.getRestaurantName());
        existingRestaurant.setRestaurantAddress(updatedRestaurant.getRestaurantAddress());
        existingRestaurant.setRestaurantPhoneNumber(updatedRestaurant.getRestaurantPhoneNumber());
        existingRestaurant.setRestaurantRating(updatedRestaurant.getRestaurantRating());
        existingRestaurant.setRestaurantLocation(updatedRestaurant.getRestaurantLocation());
        existingRestaurant.setRestaurantCategory(updatedRestaurant.getRestaurantCategory());

        restaurantRepository.save(existingRestaurant);
    }
    
    @Override
    public void disableRestaurant(String restaurantId) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId).orElseThrow(() -> new RuntimeException("Restaurant not found"));
        restaurant.setRestaurantStatus("Disabled");
        restaurantRepository.save(restaurant);
    }

    @Override
    public void activateRestaurant(String restaurantId) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId).orElseThrow(() -> new RuntimeException("Restaurant not found"));
        restaurant.setRestaurantStatus("Active");
        restaurantRepository.save(restaurant);
    }

    @Override
    @Transactional(readOnly = true)
    public Restaurant getRestaurantWithDetails(String restaurantId) {
        // Fetch basic restaurant details
        Restaurant restaurant = restaurantRepository.findBasicRestaurantDetails(restaurantId);

//        Restaurant restaurantWithReviews = restaurantRepository.findRestaurantWithReviews(restaurantId);
//        restaurant.setRestaurantReviews(restaurantWithReviews.getRestaurantReviews());

        Restaurant restaurantWithTables = restaurantRepository.findRestaurantWithTables(restaurantId);
        restaurant.setRestaurantTables(restaurantWithTables.getRestaurantTables());
        
        restaurant.getRestaurantTables().size();

        return restaurant;
    }

 // Get only active restaurants
    @Override
    public List<Restaurant> getActiveRestaurants() {
        return restaurantRepository.findActiveRestaurants();
    }
    
    @Override
    public List<Restaurant> findByRestaurantNameContaining(String name) {
        return restaurantRepository.findByRestaurantNameContainingIgnoreCase(name);
    }

}
