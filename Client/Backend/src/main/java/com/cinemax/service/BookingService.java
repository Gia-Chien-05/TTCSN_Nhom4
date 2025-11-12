package com.cinemax.service;

import com.cinemax.dto.BookingDTO;
import com.cinemax.dto.BookingRequest;
import com.cinemax.dto.ShowtimeDTO;
import com.cinemax.entity.*;
import com.cinemax.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BookingService {

    private final BookingRepository bookingRepository;
    private final ShowtimeRepository showtimeRepository;
    private final SeatRepository seatRepository;
    private final ShowtimeSeatRepository showtimeSeatRepository;
    private final PromotionRepository promotionRepository;
    private final BookingSeatRepository bookingSeatRepository;
    private final ShowtimeService showtimeService;

    @Transactional
    public BookingDTO createBooking(BookingRequest request, Long userId) {
        Showtime showtime = showtimeRepository.findById(request.getShowtimeId())
            .orElseThrow(() -> new RuntimeException("Không tìm thấy suất chiếu"));

        if (showtime.getStatus() != Showtime.ShowtimeStatus.AVAILABLE) {
            throw new RuntimeException("Suất chiếu không còn khả dụng");
        }

        List<Seat> seats = seatRepository.findAllById(request.getSeatIds());
        if (seats.size() != request.getSeatIds().size()) {
            throw new RuntimeException("Một số ghế không hợp lệ");
        }

        // Kiểm tra ghế đã được đặt chưa
        for (Seat seat : seats) {
            ShowtimeSeat showtimeSeat = showtimeSeatRepository
                .findByShowtimeIdAndSeatId(showtime.getId(), seat.getId())
                .orElse(null);

            if (showtimeSeat != null && showtimeSeat.getStatus() == ShowtimeSeat.SeatStatus.BOOKED) {
                throw new RuntimeException("Ghế " + seat.getRowNumber() + seat.getSeatNumber() + " đã được đặt");
            }
        }

        // Tính tổng tiền
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Seat seat : seats) {
            if (seat.getSeatType() == Seat.SeatType.VIP && showtime.getMovie().getVipPrice() != null) {
                totalAmount = totalAmount.add(showtime.getMovie().getVipPrice());
            } else {
                totalAmount = totalAmount.add(showtime.getPrice());
            }
        }

        // Áp dụng khuyến mãi nếu có
        BigDecimal discountAmount = BigDecimal.ZERO;
        if (request.getPromotionCode() != null && !request.getPromotionCode().isEmpty()) {
            Promotion promotion = promotionRepository.findByCode(request.getPromotionCode())
                .orElse(null);
            
            if (promotion != null && promotion.getIsActive()) {
                if (promotion.getDiscountType() == Promotion.DiscountType.PERCENTAGE) {
                    discountAmount = totalAmount.multiply(promotion.getDiscountValue())
                        .divide(new BigDecimal("100"));
                    
                    if (promotion.getMaxDiscount() != null && discountAmount.compareTo(promotion.getMaxDiscount()) > 0) {
                        discountAmount = promotion.getMaxDiscount();
                    }
                } else {
                    discountAmount = promotion.getDiscountValue();
                }
            }
        }

        BigDecimal finalAmount = totalAmount.subtract(discountAmount);

        // Tạo booking
        Booking booking = new Booking();
        booking.setBookingCode("CM" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        booking.setShowtime(showtime);
        booking.setTotalAmount(totalAmount);
        booking.setDiscountAmount(discountAmount);
        booking.setFinalAmount(finalAmount);
        // Convert payment method to uppercase để handle cả lowercase và uppercase
        String paymentMethod = request.getPaymentMethod().toUpperCase();
        try {
            booking.setPaymentMethod(Booking.PaymentMethod.valueOf(paymentMethod));
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Phương thức thanh toán không hợp lệ: " + request.getPaymentMethod());
        }
        booking.setPaymentStatus(Booking.PaymentStatus.PENDING);
        booking.setBookingStatus(Booking.BookingStatus.PENDING);
        booking.setNotes(request.getNotes());

        if (userId != null) {
            User user = new User();
            user.setId(userId);
            booking.setUser(user);
        }

        booking = bookingRepository.save(booking);

        // Tạo booking seats và update showtime seats
        for (Seat seat : seats) {
            BookingSeat bookingSeat = new BookingSeat();
            bookingSeat.setBooking(booking);
            bookingSeat.setSeat(seat);
            
            if (seat.getSeatType() == Seat.SeatType.VIP && showtime.getMovie().getVipPrice() != null) {
                bookingSeat.setPrice(showtime.getMovie().getVipPrice());
            } else {
                bookingSeat.setPrice(showtime.getPrice());
            }
            
            bookingSeatRepository.save(bookingSeat);

            // Update showtime seat status
            ShowtimeSeat showtimeSeat = showtimeSeatRepository
                .findByShowtimeIdAndSeatId(showtime.getId(), seat.getId())
                .orElse(new ShowtimeSeat());

            if (showtimeSeat.getId() == null) {
                showtimeSeat.setShowtime(showtime);
                showtimeSeat.setSeat(seat);
            }
            
            showtimeSeat.setStatus(ShowtimeSeat.SeatStatus.BOOKED);
            showtimeSeat.setBooking(booking);
            showtimeSeatRepository.save(showtimeSeat);
        }

        // Update available seats
        showtime.setAvailableSeats(showtime.getAvailableSeats() - seats.size());
        if (showtime.getAvailableSeats() <= 0) {
            showtime.setStatus(Showtime.ShowtimeStatus.FULL);
        }
        showtimeRepository.save(showtime);

        return convertToDTO(booking);
    }

    public BookingDTO getBookingByCode(String bookingCode) {
        Booking booking = bookingRepository.findByBookingCode(bookingCode)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy đặt vé"));
        return convertToDTO(booking);
    }

    public List<BookingDTO> getUserBookings(Long userId) {
        return bookingRepository.findByUserId(userId).stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Transactional
    public BookingDTO confirmPayment(String bookingCode) {
        Booking booking = bookingRepository.findByBookingCode(bookingCode)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy đặt vé"));

        booking.setPaymentStatus(Booking.PaymentStatus.PAID);
        booking.setBookingStatus(Booking.BookingStatus.CONFIRMED);
        booking.setPaymentDate(LocalDateTime.now());
        booking = bookingRepository.save(booking);

        return convertToDTO(booking);
    }

    private BookingDTO convertToDTO(Booking booking) {
        BookingDTO dto = new BookingDTO();
        dto.setId(booking.getId());
        dto.setBookingCode(booking.getBookingCode());
        
        if (booking.getUser() != null) {
            dto.setUserId(booking.getUser().getId());
            dto.setUserName(booking.getUser().getFullName());
        }
        
        dto.setShowtimeId(booking.getShowtime().getId());
        
        // Convert showtime to ShowtimeDTO
        if (booking.getShowtime() != null) {
            ShowtimeDTO showtimeDTO = showtimeService.getShowtimeById(booking.getShowtime().getId());
            dto.setShowtime(showtimeDTO);
        }
        
        dto.setTotalAmount(booking.getTotalAmount());
        dto.setDiscountAmount(booking.getDiscountAmount());
        dto.setFinalAmount(booking.getFinalAmount());
        dto.setPaymentMethod(booking.getPaymentMethod().name());
        dto.setPaymentStatus(booking.getPaymentStatus().name());
        dto.setBookingStatus(booking.getBookingStatus().name());
        dto.setBookingDate(booking.getBookingDate());
        dto.setPaymentDate(booking.getPaymentDate());
        dto.setNotes(booking.getNotes());

        if (booking.getBookingSeats() != null) {
            dto.setSeatIds(booking.getBookingSeats().stream()
                .map(bs -> bs.getSeat().getId())
                .collect(Collectors.toList()));
            
            dto.setSeatNames(booking.getBookingSeats().stream()
                .map(bs -> bs.getSeat().getRowNumber() + String.valueOf(bs.getSeat().getSeatNumber()))
                .collect(Collectors.toList()));
        }

        return dto;
    }
}
