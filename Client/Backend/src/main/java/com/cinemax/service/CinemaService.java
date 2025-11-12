package com.cinemax.service;

import com.cinemax.dto.CinemaDTO;
import com.cinemax.entity.Cinema;
import com.cinemax.repository.CinemaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CinemaService {

    private final CinemaRepository cinemaRepository;

    public List<CinemaDTO> getAllCinemas() {
        return cinemaRepository.findAll().stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    public List<CinemaDTO> getCinemasByCity(String city) {
        return cinemaRepository.findByCity(city).stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    public CinemaDTO getCinemaById(Long id) {
        Cinema cinema = cinemaRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy rạp chiếu"));
        return convertToDTO(cinema);
    }

    public List<String> getAllCities() {
        return cinemaRepository.findAllDistinctCities();
    }

    public List<CinemaDTO> getFilteredCinemas(String city, String district) {
        return cinemaRepository.findFilteredCinemas(city, district).stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    private CinemaDTO convertToDTO(Cinema cinema) {
        CinemaDTO dto = new CinemaDTO();
        dto.setId(cinema.getId());
        dto.setName(cinema.getName());
        dto.setAddress(cinema.getAddress());
        dto.setCity(cinema.getCity());
        dto.setDistrict(cinema.getDistrict());
        dto.setPhone(cinema.getPhone());
        dto.setEmail(cinema.getEmail());
        dto.setOpeningHours(cinema.getOpeningHours());
        dto.setPriceRange(cinema.getPriceRange());
        dto.setLatitude(cinema.getLatitude());
        dto.setLongitude(cinema.getLongitude());
        dto.setImageUrl(cinema.getImageUrl());
        dto.setStatus(cinema.getStatus() != null ? cinema.getStatus().name() : null);
        dto.setDescription(cinema.getDescription());
        
        if (cinema.getFeatures() != null) {
            dto.setFeatures(cinema.getFeatures().stream()
                .map(f -> f.getFeatureName())
                .collect(Collectors.toList()));
        }
        
        return dto;
    }
}

