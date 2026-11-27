package com.example.productservice.dto;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

public record ProductRequest(
    @NotBlank(message = "Tên sản phẩm không được để trống")
    @Size(max = 200, message = "Tên sản phẩm tối đa 200 ký tự")
    String name,

    @NotNull(message = "Giá không được để trống")
    @Positive(message = "Giá phải lớn hơn 0")
    BigDecimal price,

    @Min(value = 0, message = "Số lượng không được âm")
    Integer quantity,

    String description,
    String size,
    Long categoryId,
    Long brandId
) {
    public ProductRequest(String name, BigDecimal price) {
        this(name, price, 100, "", "M", 1L, 1L);
    }
}
