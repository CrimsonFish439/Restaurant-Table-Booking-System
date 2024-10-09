package com.crimsonlogic.restaurantbookingsystem.service;

import com.crimsonlogic.restaurantbookingsystem.entity.Restaurant;
import java.util.List;

public interface RestaurantService {
    Restaurant getRestaurantById(String restaurantId);
    List<Restaurant> getRestaurantsByLocation(String location);
    List<Restaurant> getRestaurantsByCategory(String category);
    List<Restaurant> getRestaurantsByRating(Double rating);
    List<Restaurant> getAllRestaurants();
    void createRestaurant(Restaurant restaurant);
    void updateRestaurant(String restaurantId, Restaurant updatedRestaurant);
	void disableRestaurant(String restaurantId);
	void activateRestaurant(String restaurantId);
	Restaurant getRestaurantWithDetails(String restaurantId);
	List<Restaurant> getActiveRestaurants();
	List<Restaurant> findByRestaurantNameContaining(String name);
}
