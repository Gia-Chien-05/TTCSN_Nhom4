package com.cinemax.repository;

import com.cinemax.entity.CinemaRoom;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CinemaRoomRepository extends JpaRepository<CinemaRoom, Long> {
    List<CinemaRoom> findByCinemaId(Long cinemaId);
}



