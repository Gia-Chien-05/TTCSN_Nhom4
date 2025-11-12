package com.cinemax.controller;

import com.cinemax.dto.BookingDTO;
import com.cinemax.dto.BookingRequest;
import com.cinemax.service.BookingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/bookings")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class BookingController {

    private final BookingService bookingService;

    @PostMapping
    public ResponseEntity<BookingDTO> createBooking(
            @Valid @RequestBody BookingRequest request,
            @RequestParam(required = false) Long userId) {
        return ResponseEntity.ok(bookingService.createBooking(request, userId));
    }

    @GetMapping("/code/{bookingCode}")
    public ResponseEntity<BookingDTO> getBookingByCode(@PathVariable String bookingCode) {
        return ResponseEntity.ok(bookingService.getBookingByCode(bookingCode));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<BookingDTO>> getUserBookings(@PathVariable Long userId) {
        return ResponseEntity.ok(bookingService.getUserBookings(userId));
    }

    @PutMapping("/{bookingCode}/confirm-payment")
    public ResponseEntity<BookingDTO> confirmPayment(@PathVariable String bookingCode) {
        return ResponseEntity.ok(bookingService.confirmPayment(bookingCode));
    }
}


