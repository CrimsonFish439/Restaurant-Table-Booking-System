package com.crimsonlogic.restaurantbookingsystem.service;

import com.crimsonlogic.restaurantbookingsystem.entity.RestaurantTable;
import java.util.List;

public interface RestaurantTableService {
    RestaurantTable getTableById(String tableId);
    List<RestaurantTable> getTablesByRestaurantId(String restaurantId);
    List<RestaurantTable> getAvailableTablesByRestaurantId(String restaurantId);
    List<RestaurantTable> getTablesBySeats(String restaurantId, int seats);
    RestaurantTable createTable(RestaurantTable table);
    void updateTable(String tableId, RestaurantTable updatedTable);
    void toggleTableAvailability(String tableId, boolean isAvailable);
	List<RestaurantTable> findAllTablesForRestaurant(String restaurantId);
	void blockTable(String tableId, String bookingDate, String timeSlot);
}
