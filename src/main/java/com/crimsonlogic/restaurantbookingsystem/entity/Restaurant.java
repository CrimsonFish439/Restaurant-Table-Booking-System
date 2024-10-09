package com.crimsonlogic.restaurantbookingsystem.entity;

import javax.persistence.*;
import com.crimsonlogic.restaurantbookingsystem.util.IDGenerator;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@ToString(exclude = {"restaurantTables"})
@Table(name = "restaurants")
public class Restaurant {

    @Id
    @Column(name = "restaurant_id", unique = true, nullable = false)
    private String restaurantId;

    @Column(name = "restaurant_name", nullable = false)
    private String restaurantName;

    @Column(name = "restaurant_address", nullable = false)
    private String restaurantAddress;

    @Column(name = "restaurant_phone_number")
    private String restaurantPhoneNumber;

    @Column(name = "restaurant_rating")
    private Double restaurantRating;
    
    @Column(name = "restaurant_location", nullable = false)
    private String restaurantLocation;

    @Column(name = "restaurant_category", nullable = false)
    private String restaurantCategory;
    
    @Column(name = "restaurant_image_url")
    private String restaurantImageUrl;
    
    @Column(name = "restaurant_status", nullable = false)
    private String restaurantStatus = "Active"; // Default to Active

    @Column(name = "restaurant_overview", length = 1000)
    private String restaurantOverview;

    @Column(name = "restaurant_timings", nullable = false)
    private String restaurantTimings;

    //@OneToMany(mappedBy = "restaurant", fetch = FetchType.EAGER)
    //private List<RestaurantReview> restaurantReviews;

    @Column(name = "table_availability", nullable = false)
    private boolean tableAvailability = true;

    @OneToMany(mappedBy = "restaurant", fetch = FetchType.EAGER)
    private List<RestaurantTable> restaurantTables;

    @PrePersist
    public void generateId() {
        this.restaurantId = IDGenerator.generateRestaurantId();
    }
}
