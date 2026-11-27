package com.example.orderservice.service;

import com.example.orderservice.dto.request.CreateOrderRequest;
import com.example.orderservice.dto.request.OrderItemRequest;
import com.example.orderservice.dto.response.OrderItemResponse;
import com.example.orderservice.dto.response.OrderResponse;
import com.example.orderservice.dto.response.ProductDto;
import com.example.orderservice.entity.Order;
import com.example.orderservice.entity.OrderItem;
import com.example.orderservice.exception.ProductNotFoundException;
import com.example.orderservice.exception.ProductUnavailableException;
import com.example.orderservice.exception.ServiceUnavailableException;
import com.example.orderservice.repository.OrderRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderService {

    private final OrderRepository repository;
    private final RestClient restClient;

    public OrderService(OrderRepository repository, RestClient.Builder builder) {
        this.repository = repository;
        this.restClient = builder
            .baseUrl("http://localhost:8081")
            .build();
    }

    public List<Order> getAll() {
        return repository.findAll();
    }

    public Order getById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng có ID: " + id));
    }

    public Order getByOrderCode(String orderCode) {
        return repository.findByOrderCode(orderCode)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng có mã: " + orderCode));
    }

    public Order create(Order order) {
        if (order.getOrderCode() == null || order.getOrderCode().trim().isEmpty()) {
            order.setOrderCode("ORDER-" + System.currentTimeMillis());
        }
        if (order.getItems() != null) {
            for (OrderItem item : order.getItems()) {
                item.setOrder(order);
            }
        }
        return repository.save(order);
    }

    /**
     * Quy trình gọi món / đặt hàng liên Microservices (Lab 03):
     * 1. Gọi Product Service để kiểm tra sản phẩm và lấy đơn giá chính xác.
     * 2. Kiểm tra tình trạng còn món và tồn kho.
     * 3. Tính toán tiền món (kèm phụ thu size L) và tổng tiền đơn hàng.
     * 4. Gọi Product Service để trừ số lượng tồn kho.
     * 5. Lưu đơn hàng vào SQL Server và trả về OrderResponse DTO.
     */
    public OrderResponse placeOrder(CreateOrderRequest request) {
        Order order = new Order();
        order.setOrderCode("ORDER-" + System.currentTimeMillis());
        order.setCustomerName(request.getCustomerName().trim());
        order.setPhone(request.getPhone().trim());
        order.setOrderType(request.getOrderType().trim());
        order.setPaymentMethod(request.getPaymentMethod() != null ? request.getPaymentMethod() : "Tiền mặt");
        order.setNote(request.getNote());
        order.setStatus("Đang pha chế (Preparing)");
        order.setCreatedAt(LocalDateTime.now());

        BigDecimal totalAmount = BigDecimal.ZERO;
        List<OrderItem> orderItems = new ArrayList<>();

        for (OrderItemRequest itemReq : request.getItems()) {
            // 1. Gọi Product Service kiểm tra sản phẩm
            ProductDto product = fetchProductFromProductService(itemReq.getProductId());

            // 2. Kiểm tra tình trạng món
            if (product.getIsAvailable() != null && !product.getIsAvailable()) {
                throw new ProductUnavailableException("Món '" + product.getName() + "' hiện đang tạm ngưng phục vụ.");
            }
            if (product.getQuantity() != null && product.getQuantity() < itemReq.getQuantity()) {
                throw new ProductUnavailableException("Món '" + product.getName() + "' không đủ số lượng (còn: " + product.getQuantity() + ", yêu cầu: " + itemReq.getQuantity() + ")");
            }

            // 3. Tính đơn giá và thành tiền
            BigDecimal unitPrice = product.getPrice();
            BigDecimal sizeExtra = "L".equalsIgnoreCase(itemReq.getSize()) ? BigDecimal.valueOf(5000) : BigDecimal.ZERO;
            BigDecimal finalItemPrice = unitPrice.add(sizeExtra);
            BigDecimal subtotal = finalItemPrice.multiply(BigDecimal.valueOf(itemReq.getQuantity()));

            totalAmount = totalAmount.add(subtotal);

            // 4. Tạo OrderItem
            OrderItem orderItem = new OrderItem(
                product.getId(),
                product.getName(),
                itemReq.getQuantity(),
                finalItemPrice,
                subtotal,
                itemReq.getSize().toUpperCase(),
                itemReq.getSugar(),
                itemReq.getIce(),
                itemReq.getToppings(),
                itemReq.getNote()
            );
            orderItem.setOrder(order);
            orderItems.add(orderItem);

            // 5. Cập nhật tồn kho bên Product Service
            reduceStockOnProductService(product.getId(), itemReq.getQuantity());
        }

        order.setTotalAmount(totalAmount);
        order.setItems(orderItems);

        Order savedOrder = repository.save(order);
        return toResponseDto(savedOrder);
    }

    private ProductDto fetchProductFromProductService(Long productId) {
        try {
            return restClient.get()
                .uri("/api/products/{id}", productId)
                .retrieve()
                .body(ProductDto.class);
        } catch (HttpClientErrorException.NotFound e) {
            throw new ProductNotFoundException("Đồ uống với ID " + productId + " không tồn tại trong Product Service");
        } catch (Exception e) {
            throw new ServiceUnavailableException("Không thể kết nối đến Product Service (port 8081). Chi tiết: " + e.getMessage());
        }
    }

    private void reduceStockOnProductService(Long productId, Integer quantity) {
        try {
            restClient.put()
                .uri("/api/products/{id}/reduce-stock?quantity={qty}", productId, quantity)
                .retrieve()
                .toBodilessEntity();
        } catch (Exception e) {
            // Log và tiếp tục nếu Product Service ghi nhận sau
            System.err.println("Cảnh báo: Không thể giảm tồn kho sản phẩm " + productId + ": " + e.getMessage());
        }
    }

    public Order update(Long id, Order details) {
        Order order = getById(id);
        if (details.getCustomerName() != null) order.setCustomerName(details.getCustomerName());
        if (details.getPhone() != null) order.setPhone(details.getPhone());
        if (details.getOrderType() != null) order.setOrderType(details.getOrderType());
        if (details.getTotalAmount() != null) order.setTotalAmount(details.getTotalAmount());
        if (details.getPaymentMethod() != null) order.setPaymentMethod(details.getPaymentMethod());
        if (details.getStatus() != null) order.setStatus(details.getStatus());
        if (details.getNote() != null) order.setNote(details.getNote());
        return repository.save(order);
    }

    public void delete(Long id) {
        Order order = getById(id);
        repository.delete(order);
    }

    public OrderResponse toResponseDto(Order order) {
        OrderResponse resp = new OrderResponse();
        resp.setId(order.getId());
        resp.setOrderCode(order.getOrderCode());
        resp.setCustomerName(order.getCustomerName());
        resp.setPhone(order.getPhone());
        resp.setOrderType(order.getOrderType());
        resp.setTotalAmount(order.getTotalAmount());
        resp.setPaymentMethod(order.getPaymentMethod());
        resp.setStatus(order.getStatus());
        resp.setNote(order.getNote());
        resp.setCreatedAt(order.getCreatedAt());

        if (order.getItems() != null) {
            List<OrderItemResponse> itemResponses = order.getItems().stream().map(i -> {
                OrderItemResponse itemResp = new OrderItemResponse();
                itemResp.setId(i.getId());
                itemResp.setProductId(i.getProductId());
                itemResp.setProductName(i.getProductName());
                itemResp.setQuantity(i.getQuantity());
                itemResp.setPrice(i.getPrice());
                itemResp.setSubtotal(i.getSubtotal());
                itemResp.setSize(i.getSize());
                itemResp.setSugar(i.getSugar());
                itemResp.setIce(i.getIce());
                itemResp.setToppings(i.getToppings());
                itemResp.setNote(i.getNote());
                return itemResp;
            }).collect(Collectors.toList());
            resp.setItems(itemResponses);
        }
        return resp;
    }

    public List<OrderResponse> getAllResponses() {
        return repository.findAll().stream()
            .map(this::toResponseDto)
            .collect(Collectors.toList());
    }
}
