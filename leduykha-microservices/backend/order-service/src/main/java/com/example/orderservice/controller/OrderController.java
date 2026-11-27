package com.example.orderservice.controller;

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
    public List<Order> getAll() {
        return service.getAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Order> getById(@PathVariable Long id) {
        return ResponseEntity.ok(service.getById(id));
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
