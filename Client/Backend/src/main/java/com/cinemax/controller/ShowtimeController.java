package com.cinemax.controller;

import com.cinemax.dto.CreateShowtimeRequest;
import com.cinemax.dto.SeatDTO;
import com.cinemax.dto.ShowtimeDTO;
import com.cinemax.service.ShowtimeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/showtimes")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ShowtimeController {

    private final ShowtimeService showtimeService;

    @GetMapping("/date/{date}")
    public ResponseEntity<List<ShowtimeDTO>> getShowtimesByDate(@PathVariable LocalDate date) {
        return ResponseEntity.ok(showtimeService.getShowtimesByDate(date));
    }

    @GetMapping("/date/{date}/cinema/{cinemaId}")
    public ResponseEntity<List<ShowtimeDTO>> getShowtimesByDateAndCinema(
            @PathVariable LocalDate date,
            @PathVariable Long cinemaId) {
        return ResponseEntity.ok(showtimeService.getShowtimesByDateAndCinema(date, cinemaId));
    }

    @GetMapping("/date/{date}/movie/{movieId}")
    public ResponseEntity<List<ShowtimeDTO>> getShowtimesByDateAndMovie(
            @PathVariable LocalDate date,
            @PathVariable Long movieId) {
        return ResponseEntity.ok(showtimeService.getShowtimesByDateAndMovie(date, movieId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ShowtimeDTO> getShowtimeById(@PathVariable Long id) {
        return ResponseEntity.ok(showtimeService.getShowtimeById(id));
    }

    @GetMapping("/{id}/seats")
    public ResponseEntity<List<SeatDTO>> getShowtimeSeats(@PathVariable Long id) {
        return ResponseEntity.ok(showtimeService.getShowtimeSeats(id));
    }

    @PostMapping
    public ResponseEntity<ShowtimeDTO> createShowtime(@Valid @RequestBody CreateShowtimeRequest request) {
        return ResponseEntity.ok(showtimeService.createShowtime(request));
    }
}


