package com.cinemax.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtConfig jwtConfig;

    public JwtAuthenticationFilter(JwtConfig jwtConfig) {
        this.jwtConfig = jwtConfig;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        
        // Chỉ xử lý JWT cho các endpoint cần authentication
        // Path có thể là /api/bookings hoặc /bookings tùy context-path
        if (path.contains("/bookings") || path.contains("/users")) {
            try {
                String token = extractToken(request);
                System.out.println("JWT Filter - Path: " + path + ", Token: " + (token != null ? "Present" : "Missing"));
                
                if (token != null) {
                    boolean isValid = jwtConfig.validateToken(token);
                    System.out.println("JWT Filter - Token valid: " + isValid);
                    
                    if (isValid) {
                        String email = jwtConfig.getEmailFromToken(token);
                        System.out.println("JWT Filter - Email: " + email);
                        
                        if (email != null) {
                            // Tạo authentication object
                            List<SimpleGrantedAuthority> authorities = Collections.singletonList(
                                new SimpleGrantedAuthority("ROLE_USER")
                            );
                            Authentication authentication = new UsernamePasswordAuthenticationToken(
                                email, null, authorities
                            );
                            SecurityContextHolder.getContext().setAuthentication(authentication);
                            System.out.println("JWT Filter - Authentication set for: " + email);
                        }
                    } else {
                        System.out.println("JWT Filter - Token validation failed");
                    }
                } else {
                    System.out.println("JWT Filter - No token found in request");
                }
            } catch (Exception e) {
                System.err.println("JWT Filter Error: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        filterChain.doFilter(request, response);
    }

    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}

