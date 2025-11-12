package com.cinemax.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SeatDTO {
    private Long id;
    private String rowNumber;
    private Integer seatNumber;
    private String seatType; // NORMAL, VIP, COUPLE
    private String status; // AVAILABLE, BOOKED, RESERVED, BLOCKED
    private String seatName; // e.g., "A1", "B5"
}



