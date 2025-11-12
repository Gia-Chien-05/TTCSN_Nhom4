package com.cinemax.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ShowtimeDTO {
    private Long id;
    private Long movieId;
    private String movieTitle;
    private String movieTitleVietnamese;
    private String moviePoster;
    private Long cinemaId;
    private String cinemaName;
    private Long roomId;
    private String roomName;
    private LocalDate showDate;
    private LocalTime showTime;
    private BigDecimal price;
    private Integer availableSeats;
    private Integer totalSeats;
    private String status;
}


