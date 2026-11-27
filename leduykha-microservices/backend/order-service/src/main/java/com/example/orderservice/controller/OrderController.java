package com.example.orderservice.controller;

import com.example.orderservice.dto.OrderRequest;
import com.example.orderservice.dto.OrderResponse;
import com.example.orderservice.entity.Order;
import com.example.orderservice.service.OrderService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
@CrossOrigin(origins = "*")
public class OrderController {

    private final OrderService service;
    private final RestClient restClient;

    public OrderController(OrderService service, RestClient.Builder builder) {
        this.service = service;
        this.restClient = builder
            .baseUrl("http://localhost:8081")
            .build();
    }

    @GetMapping
    public List<OrderResponse> getAll() {
        return service.getAllResponses();
    }

    @GetMapping("/{id}")
    public ResponseEntity<OrderResponse> getById(@PathVariable Long id) {
        return ResponseEntity.ok(service.toResponseDto(service.getById(id)));
    }

    @GetMapping("/code/{orderCode}")
    public ResponseEntity<OrderResponse> getByOrderCode(@PathVariable String orderCode) {
        return ResponseEntity.ok(service.toResponseDto(service.getByOrderCode(orderCode)));
    }

    @PostMapping("/place-order")
    public ResponseEntity<OrderResponse> placeOrder(@Valid @RequestBody OrderRequest request) {
        OrderResponse response = service.placeOrder(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping
    public ResponseEntity<Order> create(@Valid @RequestBody Order order) {
        Order created = service.create(order);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Order> update(@PathVariable Long id, @Valid @RequestBody Order order) {
        return ResponseEntity.ok(service.update(id, order));
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<Order> updateStatus(@PathVariable Long id, @RequestParam String status) {
        Order order = service.getById(id);
        order.setStatus(status);
        return ResponseEntity.ok(service.update(id, order));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/verify-product/{productId}")
    public ResponseEntity<?> verifyProductFromProductService(@PathVariable Long productId) {
        try {
            Map product = restClient.get()
                .uri("/api/products/{id}", productId)
                .retrieve()
                .body(Map.class);
            return ResponseEntity.ok(Map.of(
                "status", "CONNECTED_SUCCESS",
                "message", "Order Service đã gọi thành công Product Service (port 8081)",
                "product", product
            ));
        } catch (HttpClientErrorException.NotFound e) {
            return ResponseEntity.status(404).body(Map.of(
                "status", "PRODUCT_NOT_FOUND",
                "message", "Không tìm thấy đồ uống có ID: " + productId + " từ Product Service"
            ));
        } catch (Exception e) {
            return ResponseEntity.status(503).body(Map.of(
                "status", "PRODUCT_SERVICE_OFFLINE",
                "message", "Không thể kết nối đến Product Service tại http://localhost:8081. Hãy chắc chắn Product Service đang chạy!",
                "error", e.getMessage()
            ));
        }
    }
}
