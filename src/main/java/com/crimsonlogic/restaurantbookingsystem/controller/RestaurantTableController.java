package com.crimsonlogic.restaurantbookingsystem.controller;

import com.crimsonlogic.restaurantbookingsystem.entity.RestaurantTable;
import com.crimsonlogic.restaurantbookingsystem.service.RestaurantTableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
@RequestMapping("/restaurantTables")
public class RestaurantTableController {

    @Autowired
    private RestaurantTableService restaurantTableService;

    // 1. Create a new table
    @PostMapping("/create")
    public ModelAndView createTable(@ModelAttribute RestaurantTable table) {
        restaurantTableService.createTable(table);
        return new ModelAndView("redirect:/restaurantTables/list");
    }

    // 2. Get table by ID
    @GetMapping("/{tableId}")
    public ModelAndView getTableById(@PathVariable String tableId) {
        ModelAndView modelAndView = new ModelAndView("tableDetails");
        RestaurantTable table = restaurantTableService.getTableById(tableId);
        modelAndView.addObject("table", table);
        return modelAndView;
    }

    // 3. List all tables in a restaurant by restaurant ID
    @GetMapping("/restaurant/{restaurantId}")
    public ModelAndView getTablesByRestaurantId(@PathVariable String restaurantId) {
        ModelAndView modelAndView = new ModelAndView("tableList");
        List<RestaurantTable> tables = restaurantTableService.getTablesByRestaurantId(restaurantId);
        modelAndView.addObject("tables", tables);
        return modelAndView;
    }

    // 4. List all available tables in a restaurant
    @GetMapping("/restaurant/{restaurantId}/available")
    public ModelAndView getAvailableTablesByRestaurantId(@PathVariable String restaurantId) {
        ModelAndView modelAndView = new ModelAndView("tableList");
        List<RestaurantTable> availableTables = restaurantTableService.getAvailableTablesByRestaurantId(restaurantId);
        modelAndView.addObject("tables", availableTables);
        return modelAndView;
    }

    // 5. List tables by seats in a restaurant
    @GetMapping("/restaurant/{restaurantId}/seats/{seats}")
    public ModelAndView getTablesBySeats(@PathVariable String restaurantId, @PathVariable int seats) {
        ModelAndView modelAndView = new ModelAndView("tableList");
        List<RestaurantTable> tables = restaurantTableService.getTablesBySeats(restaurantId, seats);
        modelAndView.addObject("tables", tables);
        return modelAndView;
    }

    // 6. Update a table
    @PutMapping("/{tableId}")
    public ModelAndView updateTable(@PathVariable String tableId, @ModelAttribute RestaurantTable updatedTable) {
        restaurantTableService.updateTable(tableId, updatedTable);
        return new ModelAndView("redirect:/restaurantTables/" + tableId);
    }

    // 7. Toggle table availability
    @PutMapping("/toggleAvailability/{tableId}")
    public ModelAndView toggleTableAvailability(@PathVariable String tableId, @RequestParam boolean isAvailable) {
        restaurantTableService.toggleTableAvailability(tableId, isAvailable);
        return new ModelAndView("redirect:/restaurantTables/restaurant/" + tableId);
    }
}
