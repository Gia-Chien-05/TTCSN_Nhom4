package com.cinemax.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "movies")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Movie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "imdb_id", unique = true, length = 20)
    private String imdbId;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(name = "title_vietnamese", length = 200)
    private String titleVietnamese;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 200)
    private String genre;

    @Column(length = 100)
    private String director;

    @Column(columnDefinition = "TEXT")
    private String actors;

    @Column(name = "release_date")
    private LocalDate releaseDate;

    private Integer duration;

    @Column(precision = 3, scale = 1)
    private BigDecimal rating;

    @Column(length = 50)
    private String language;

    @Column(length = 50)
    private String country;

    @Column(name = "poster_url", length = 500)
    private String posterUrl;

    @Column(name = "trailer_url", length = 500)
    private String trailerUrl;

    @Enumerated(EnumType.STRING)
    private MovieStatus status = MovieStatus.NOW_SHOWING;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(name = "vip_price", precision = 10, scale = 2)
    private BigDecimal vipPrice;

    @OneToMany(mappedBy = "movie", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private java.util.List<Showtime> showtimes;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public enum MovieStatus {
        COMING_SOON, NOW_SHOWING, ENDED
    }
}


