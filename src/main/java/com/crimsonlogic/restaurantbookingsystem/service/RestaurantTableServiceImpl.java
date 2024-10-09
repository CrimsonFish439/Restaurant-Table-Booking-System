package com.crimsonlogic.restaurantbookingsystem.service;

import com.crimsonlogic.restaurantbookingsystem.entity.RestaurantTable;
import com.crimsonlogic.restaurantbookingsystem.exception.TableNotFoundException;
import com.crimsonlogic.restaurantbookingsystem.repository.RestaurantTableRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RestaurantTableServiceImpl implements RestaurantTableService {

    @Autowired
    private RestaurantTableRepository restaurantTableRepository;

    @Override
    public RestaurantTable getTableById(String tableId) {
        return restaurantTableRepository.findById(tableId)
                .orElseThrow(() -> new TableNotFoundException("Table with ID " + tableId + " not found"));
    }

    @Override
    public List<RestaurantTable> getTablesByRestaurantId(String restaurantId) {
        return restaurantTableRepository.findByRestaurantRestaurantId(restaurantId);
    }

    @Override
    public List<RestaurantTable> getAvailableTablesByRestaurantId(String restaurantId) {
        return restaurantTableRepository.findByRestaurantRestaurantIdAndTableIsAvailable(restaurantId, true);
    }

    @Override
    public List<RestaurantTable> getTablesBySeats(String restaurantId, int seats) {
        return restaurantTableRepository.findByRestaurantRestaurantIdAndTableSeatsGreaterThanEqual(restaurantId, seats);
    }

    @Override
    public RestaurantTable createTable(RestaurantTable table) {
        return restaurantTableRepository.save(table);
    }

    @Override
    public void updateTable(String tableId, RestaurantTable updatedTable) {
        RestaurantTable existingTable = restaurantTableRepository.findById(tableId)
                .orElseThrow(() -> new TableNotFoundException("Table with ID " + tableId + " not found"));

        existingTable.setTableNumber(updatedTable.getTableNumber());
        existingTable.setTableSeats(updatedTable.getTableSeats());
        //existingTable.setTableIsAvailable(updatedTable.isTableIsAvailable());

        restaurantTableRepository.save(existingTable);
    }

    @Override
    public void toggleTableAvailability(String tableId, boolean isAvailable) {
        RestaurantTable existingTable = restaurantTableRepository.findById(tableId)
                .orElseThrow(() -> new TableNotFoundException("Table with ID " + tableId + " not found"));
        //existingTable.setTableIsAvailable(isAvailable);
        restaurantTableRepository.save(existingTable);
    }
    
 // Fetch all tables for the restaurant
    public List<RestaurantTable> findAllTablesForRestaurant(String restaurantId) {
        return restaurantTableRepository.findByRestaurantRestaurantId(restaurantId);
    }

    @Override
    public void blockTable(String tableId, String bookingDate, String timeSlot) {
        // Find the table by ID
        RestaurantTable table = restaurantTableRepository.findById(tableId).orElseThrow(() -> new TableNotFoundException("Table not found"));
        
        // Block the table for the specific date and time slot
        // Save the blocked time slot information in your database (you may need a separate table for time slots)
        // E.g., you can update the table availability status or create a new `TableAvailability` entity.
        
        table.setTableIsAvailable(false); // or store this info elsewhere based on your schema
        restaurantTableRepository.save(table);
    }

    
    
}
