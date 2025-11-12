package com.cinemax.controller;

import com.cinemax.dto.CinemaDTO;
import com.cinemax.service.CinemaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cinemas")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CinemaController {

    private final CinemaService cinemaService;

    @GetMapping
    public ResponseEntity<List<CinemaDTO>> getAllCinemas() {
        return ResponseEntity.ok(cinemaService.getAllCinemas());
    }

    @GetMapping("/{id}")
    public ResponseEntity<CinemaDTO> getCinemaById(@PathVariable Long id) {
        return ResponseEntity.ok(cinemaService.getCinemaById(id));
    }

    @GetMapping("/city/{city}")
    public ResponseEntity<List<CinemaDTO>> getCinemasByCity(@PathVariable String city) {
        return ResponseEntity.ok(cinemaService.getCinemasByCity(city));
    }

    @GetMapping("/cities")
    public ResponseEntity<List<String>> getAllCities() {
        return ResponseEntity.ok(cinemaService.getAllCities());
    }

    @GetMapping("/filter")
    public ResponseEntity<List<CinemaDTO>> getFilteredCinemas(
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String district) {
        return ResponseEntity.ok(cinemaService.getFilteredCinemas(city, district));
    }
}


