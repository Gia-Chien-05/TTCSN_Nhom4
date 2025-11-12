package com.cinemax.repository;

import com.cinemax.entity.Cinema;
import com.cinemax.entity.Cinema.CinemaStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CinemaRepository extends JpaRepository<Cinema, Long> {
    List<Cinema> findByStatus(CinemaStatus status);
    List<Cinema> findByCity(String city);
    
    @Query("SELECT DISTINCT c.city FROM Cinema c ORDER BY c.city")
    List<String> findAllDistinctCities();
    
    @Query("SELECT c FROM Cinema c WHERE " +
           "(:city IS NULL OR c.city = :city) AND " +
           "(:district IS NULL OR c.district = :district) AND " +
           "c.status = 'OPEN'")
    List<Cinema> findFilteredCinemas(@Param("city") String city, @Param("district") String district);
}


