package com.example.orderservice.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class OrderItemRequest {

    @NotNull(message = "ID đồ uống không được để trống")
    private Long productId;

    @NotNull(message = "Số lượng không được để trống")
    @Min(value = 1, message = "Số lượng phải từ 1 trở lên")
    private Integer quantity;

    @NotBlank(message = "Size đồ uống không được để trống (M hoặc L)")
    private String size = "M";

    private String sugar = "50%";
    private String ice = "50%";
    private String toppings;
    private String note;

    public OrderItemRequest() {}

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }

    public String getSugar() { return sugar; }
    public void setSugar(String sugar) { this.sugar = sugar; }

    public String getIce() { return ice; }
    public void setIce(String ice) { this.ice = ice; }

    public String getToppings() { return toppings; }
    public void setToppings(String toppings) { this.toppings = toppings; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}
