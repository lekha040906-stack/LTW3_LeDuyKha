package com.example.productservice.dto;

import java.math.BigDecimal;

public record ProductResponse(
    Long id,
    String name,
    BigDecimal price,
    Integer quantity,
    String description,
    String size,
    Double rating,
    Boolean isAvailable,
    Long categoryId,
    String categoryName,
    String icon
) {
    public ProductResponse(Long id, String name, BigDecimal price) {
        this(id, name, price, 100, "", "M", 5.0, true, null, null, null);
    }
}
