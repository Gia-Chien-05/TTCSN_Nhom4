package com.cinemax.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CinemaDTO {
    private Long id;
    private String name;
    private String address;
    private String city;
    private String district;
    private String phone;
    private String email;
    private String openingHours;
    private String priceRange;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private String imageUrl;
    private String status;
    private String description;
    private List<String> features;
}


