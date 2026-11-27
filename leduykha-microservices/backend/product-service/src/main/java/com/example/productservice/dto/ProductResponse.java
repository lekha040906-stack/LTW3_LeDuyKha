package com.example.productservice.dto;

import java.math.BigDecimal;

public record ProductResponse(
    Long id,
    String name,
    BigDecimal price,
    String category,
    String image,
    Integer quantity,
    String description,
    String size,
    Double rating,
    Boolean isAvailable
) {
    // Constructor 3 tham số chuẩn theo tài liệu Lab 03 (Mục 5 & Mục 7)
    public ProductResponse(Long id, String name, BigDecimal price) {
        this(id, name, price, "Trà sữa", "🧋", 100, "", "M", 5.0, true);
    }
}
