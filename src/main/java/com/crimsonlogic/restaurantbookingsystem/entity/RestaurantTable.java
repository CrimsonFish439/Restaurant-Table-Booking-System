package com.crimsonlogic.restaurantbookingsystem.entity;

import javax.persistence.*;
import com.crimsonlogic.restaurantbookingsystem.util.IDGenerator;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "restaurant_tables")
public class RestaurantTable {

	@Id
    @Column(name = "table_id", unique = true, nullable = false)
    private String tableId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;

    @Column(name = "table_number", nullable = false)
    private String tableNumber;

    @Column(name = "table_seats", nullable = false)
    private int tableSeats;

    @Column(name = "table_is_available", nullable = false)
    private boolean tableIsAvailable = true;

    @PrePersist
    public void generateId() {
        this.tableId = IDGenerator.generateTableId();
    }
}
