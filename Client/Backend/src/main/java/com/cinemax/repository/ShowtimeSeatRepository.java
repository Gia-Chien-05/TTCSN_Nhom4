package com.cinemax.repository;

import com.cinemax.entity.ShowtimeSeat;
import com.cinemax.entity.ShowtimeSeat.SeatStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ShowtimeSeatRepository extends JpaRepository<ShowtimeSeat, Long> {
    List<ShowtimeSeat> findByShowtimeId(Long showtimeId);
    List<ShowtimeSeat> findByShowtimeIdAndStatus(Long showtimeId, SeatStatus status);
    
    Optional<ShowtimeSeat> findByShowtimeIdAndSeatId(Long showtimeId, Long seatId);
}


