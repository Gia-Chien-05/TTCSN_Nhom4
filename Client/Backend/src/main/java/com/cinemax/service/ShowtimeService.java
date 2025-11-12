package com.cinemax.service;

import com.cinemax.dto.CreateShowtimeRequest;
import com.cinemax.dto.SeatDTO;
import com.cinemax.dto.ShowtimeDTO;
import com.cinemax.entity.Cinema;
import com.cinemax.entity.CinemaRoom;
import com.cinemax.entity.Movie;
import com.cinemax.entity.Seat;
import com.cinemax.entity.Showtime;
import com.cinemax.entity.ShowtimeSeat;
import com.cinemax.repository.CinemaRepository;
import com.cinemax.repository.CinemaRoomRepository;
import com.cinemax.repository.MovieRepository;
import com.cinemax.repository.SeatRepository;
import com.cinemax.repository.ShowtimeRepository;
import com.cinemax.repository.ShowtimeSeatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ShowtimeService {

    private final ShowtimeRepository showtimeRepository;
    private final ShowtimeSeatRepository showtimeSeatRepository;
    private final SeatRepository seatRepository;
    private final MovieRepository movieRepository;
    private final CinemaRepository cinemaRepository;
    private final CinemaRoomRepository cinemaRoomRepository;

    public List<ShowtimeDTO> getShowtimesByDate(LocalDate date) {
        return showtimeRepository.findByShowDate(date).stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    public List<ShowtimeDTO> getShowtimesByDateAndCinema(LocalDate date, Long cinemaId) {
        return showtimeRepository.findByDateAndCinema(date, cinemaId).stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    public List<ShowtimeDTO> getShowtimesByDateAndMovie(LocalDate date, Long movieId) {
        return showtimeRepository.findByDateAndMovie(date, movieId).stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    public ShowtimeDTO getShowtimeById(Long id) {
        Showtime showtime = showtimeRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy suất chiếu"));
        return convertToDTO(showtime);
    }

    @Transactional
    public ShowtimeDTO createShowtime(CreateShowtimeRequest request) {
        // Validate và lấy entities
        Movie movie = movieRepository.findById(request.getMovieId())
            .orElseThrow(() -> new RuntimeException("Không tìm thấy phim với ID: " + request.getMovieId()));
        
        Cinema cinema = cinemaRepository.findById(request.getCinemaId())
            .orElseThrow(() -> new RuntimeException("Không tìm thấy rạp với ID: " + request.getCinemaId()));
        
        CinemaRoom room = cinemaRoomRepository.findById(request.getRoomId())
            .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng chiếu với ID: " + request.getRoomId()));
        
        // Kiểm tra room thuộc cinema
        if (!room.getCinema().getId().equals(cinema.getId())) {
            throw new RuntimeException("Phòng chiếu không thuộc rạp đã chọn");
        }
        
        // Tạo showtime
        Showtime showtime = new Showtime();
        showtime.setMovie(movie);
        showtime.setCinema(cinema);
        showtime.setRoom(room);
        showtime.setShowDate(request.getShowDate());
        showtime.setShowTime(request.getShowTime());
        showtime.setPrice(request.getPrice());
        
        // Tính total seats từ room hoặc dùng giá trị truyền vào
        int totalSeats = request.getTotalSeats() != null 
            ? request.getTotalSeats() 
            : room.getCapacity();
        showtime.setTotalSeats(totalSeats);
        showtime.setAvailableSeats(totalSeats);
        showtime.setStatus(Showtime.ShowtimeStatus.AVAILABLE);
        
        showtime = showtimeRepository.save(showtime);
        
        return convertToDTO(showtime);
    }

    public List<SeatDTO> getShowtimeSeats(Long showtimeId) {
        Showtime showtime = showtimeRepository.findById(showtimeId)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy suất chiếu"));

        // Lấy tất cả ghế trong phòng chiếu
        List<Seat> allSeats = seatRepository.findByRoomId(showtime.getRoom().getId());

        // Lấy trạng thái ghế cho suất chiếu này
        List<ShowtimeSeat> showtimeSeats = showtimeSeatRepository.findByShowtimeId(showtimeId);
        Map<Long, ShowtimeSeat.SeatStatus> seatStatusMap = new HashMap<>();
        for (ShowtimeSeat showtimeSeat : showtimeSeats) {
            seatStatusMap.put(showtimeSeat.getSeat().getId(), showtimeSeat.getStatus());
        }

        // Convert to DTO
        final Map<Long, ShowtimeSeat.SeatStatus> statusMap = seatStatusMap;
        return allSeats.stream()
            .map(seat -> {
                SeatDTO dto = new SeatDTO();
                dto.setId(seat.getId());
                dto.setRowNumber(seat.getRowNumber());
                dto.setSeatNumber(seat.getSeatNumber());
                dto.setSeatType(seat.getSeatType() != null ? seat.getSeatType().name() : "NORMAL");
                dto.setStatus(statusMap.getOrDefault(seat.getId(), ShowtimeSeat.SeatStatus.AVAILABLE).name());
                dto.setSeatName(seat.getRowNumber() + String.valueOf(seat.getSeatNumber()));
                return dto;
            })
            .collect(Collectors.toList());
    }

    private ShowtimeDTO convertToDTO(Showtime showtime) {
        ShowtimeDTO dto = new ShowtimeDTO();
        dto.setId(showtime.getId());
        
        if (showtime.getMovie() != null) {
            dto.setMovieId(showtime.getMovie().getId());
            dto.setMovieTitle(showtime.getMovie().getTitle());
            dto.setMovieTitleVietnamese(showtime.getMovie().getTitleVietnamese());
            dto.setMoviePoster(showtime.getMovie().getPosterUrl());
        }
        
        if (showtime.getCinema() != null) {
            dto.setCinemaId(showtime.getCinema().getId());
            dto.setCinemaName(showtime.getCinema().getName());
        }
        
        if (showtime.getRoom() != null) {
            dto.setRoomId(showtime.getRoom().getId());
            dto.setRoomName(showtime.getRoom().getRoomName());
        }
        
        dto.setShowDate(showtime.getShowDate());
        dto.setShowTime(showtime.getShowTime());
        dto.setPrice(showtime.getPrice());
        dto.setAvailableSeats(showtime.getAvailableSeats());
        dto.setTotalSeats(showtime.getTotalSeats());
        dto.setStatus(showtime.getStatus() != null ? showtime.getStatus().name() : null);
        
        return dto;
    }
}


