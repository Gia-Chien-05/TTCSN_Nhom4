package com.cinemax.service;

import com.cinemax.dto.MovieDTO;
import com.cinemax.entity.Movie;
import com.cinemax.repository.MovieRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MovieService {

    private final MovieRepository movieRepository;

    public List<MovieDTO> getAllMovies() {
        return movieRepository.findAll().stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    public List<MovieDTO> getMoviesByStatus(String status) {
        Movie.MovieStatus movieStatus = Movie.MovieStatus.valueOf(status.toUpperCase());
        return movieRepository.findByStatus(movieStatus).stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    public MovieDTO getMovieById(Long id) {
        Movie movie = movieRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy phim"));
        return convertToDTO(movie);
    }

    public MovieDTO getMovieByImdbId(String imdbId) {
        Movie movie = movieRepository.findByImdbId(imdbId)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy phim"));
        return convertToDTO(movie);
    }

    public List<MovieDTO> searchMovies(String keyword) {
        return movieRepository.searchMovies(keyword).stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    private MovieDTO convertToDTO(Movie movie) {
        MovieDTO dto = new MovieDTO();
        dto.setId(movie.getId());
        dto.setImdbId(movie.getImdbId());
        dto.setTitle(movie.getTitle());
        dto.setTitleVietnamese(movie.getTitleVietnamese());
        dto.setDescription(movie.getDescription());
        dto.setGenre(movie.getGenre());
        dto.setDirector(movie.getDirector());
        dto.setActors(movie.getActors());
        dto.setReleaseDate(movie.getReleaseDate());
        dto.setDuration(movie.getDuration());
        dto.setRating(movie.getRating());
        dto.setLanguage(movie.getLanguage());
        dto.setCountry(movie.getCountry());
        dto.setPosterUrl(movie.getPosterUrl());
        dto.setTrailerUrl(movie.getTrailerUrl());
        dto.setStatus(movie.getStatus() != null ? movie.getStatus().name() : null);
        dto.setPrice(movie.getPrice());
        dto.setVipPrice(movie.getVipPrice());
        return dto;
    }
}


