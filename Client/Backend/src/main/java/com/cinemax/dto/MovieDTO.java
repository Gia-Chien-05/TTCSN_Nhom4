package com.cinemax.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MovieDTO {
    private Long id;
    private String imdbId;
    private String title;
    private String titleVietnamese;
    private String description;
    private String genre;
    private String director;
    private String actors;
    private LocalDate releaseDate;
    private Integer duration;
    private BigDecimal rating;
    private String language;
    private String country;
    private String posterUrl;
    private String trailerUrl;
    private String status;
    private BigDecimal price;
    private BigDecimal vipPrice;
}


