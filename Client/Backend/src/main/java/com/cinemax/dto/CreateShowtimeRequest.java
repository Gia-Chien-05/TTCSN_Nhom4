package com.cinemax.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreateShowtimeRequest {
    
    @NotNull(message = "Movie ID không được để trống")
    private Long movieId;
    
    @NotNull(message = "Cinema ID không được để trống")
    private Long cinemaId;
    
    @NotNull(message = "Room ID không được để trống")
    private Long roomId;
    
    @NotNull(message = "Ngày chiếu không được để trống")
    private LocalDate showDate;
    
    @NotNull(message = "Giờ chiếu không được để trống")
    private LocalTime showTime;
    
    @NotNull(message = "Giá vé không được để trống")
    private BigDecimal price;
    
    private Integer totalSeats; // Nếu null, sẽ lấy từ room
}



