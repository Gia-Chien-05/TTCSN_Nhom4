package com.cinemax.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingDTO {
    private Long id;
    private String bookingCode;
    private Long userId;
    private String userName;
    private Long showtimeId;
    private ShowtimeDTO showtime;
    private List<Long> seatIds;
    private List<String> seatNames;
    private BigDecimal totalAmount;
    private BigDecimal discountAmount;
    private BigDecimal finalAmount;
    private String paymentMethod;
    private String paymentStatus;
    private String bookingStatus;
    private LocalDateTime bookingDate;
    private LocalDateTime paymentDate;
    private String notes;
}
