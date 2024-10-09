package com.crimsonlogic.restaurantbookingsystem.repository;

import com.crimsonlogic.restaurantbookingsystem.entity.RestaurantTable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RestaurantTableRepository extends JpaRepository<RestaurantTable, String> {

    List<RestaurantTable> findByRestaurantRestaurantId(String restaurantId);

    List<RestaurantTable> findByRestaurantRestaurantIdAndTableIsAvailable(String restaurantId, boolean isAvailable);

    List<RestaurantTable> findByRestaurantRestaurantIdAndTableSeatsGreaterThanEqual(String restaurantId, int seats);
}
