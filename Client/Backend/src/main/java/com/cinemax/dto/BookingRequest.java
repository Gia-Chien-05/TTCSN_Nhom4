package com.cinemax.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingRequest {
    
    @NotNull(message = "Showtime ID không được để trống")
    private Long showtimeId;
    
    @NotEmpty(message = "Phải chọn ít nhất một ghế")
    private List<Long> seatIds;
    
    @NotNull(message = "Phương thức thanh toán không được để trống")
    private String paymentMethod;
    
    private String promotionCode;
    private String notes;
}


