package com.cinemax.repository;

import com.cinemax.entity.Showtime;
import com.cinemax.entity.Showtime.ShowtimeStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
public interface ShowtimeRepository extends JpaRepository<Showtime, Long> {
    List<Showtime> findByShowDate(LocalDate showDate);
    List<Showtime> findByMovieId(Long movieId);
    List<Showtime> findByCinemaId(Long cinemaId);
    
    @Query("SELECT s FROM Showtime s WHERE " +
           "s.showDate = :date AND " +
           "s.cinema.id = :cinemaId AND " +
           "s.status = 'AVAILABLE' " +
           "ORDER BY s.showTime")
    List<Showtime> findByDateAndCinema(@Param("date") LocalDate date, @Param("cinemaId") Long cinemaId);
    
    @Query("SELECT s FROM Showtime s WHERE " +
           "s.showDate = :date AND " +
           "s.movie.id = :movieId AND " +
           "s.status = 'AVAILABLE' " +
           "ORDER BY s.cinema.name, s.showTime")
    List<Showtime> findByDateAndMovie(@Param("date") LocalDate date, @Param("movieId") Long movieId);
    
    @Query("SELECT s FROM Showtime s WHERE " +
           "s.showDate = :date AND " +
           "s.showTime >= :time AND " +
           "s.status = 'AVAILABLE' " +
           "ORDER BY s.showTime")
    List<Showtime> findByDateFromTime(@Param("date") LocalDate date, @Param("time") LocalTime time);
}


