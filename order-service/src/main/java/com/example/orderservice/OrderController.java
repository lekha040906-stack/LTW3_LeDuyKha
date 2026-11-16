package com.example.orderservice;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.HttpClientErrorException;

import java.util.Map;

@RestController
@RequestMapping("/api/orders")
@CrossOrigin(origins = "*")
public class OrderController {

    private final RestClient restClient = RestClient.create("http://localhost:8081");

    @GetMapping("/product/{id}")
    public ResponseEntity<?> getProductViaOrder(@PathVariable Long id) {
        try {
            Object product = restClient.get()
                    .uri("/api/products/{id}", id)
                    .retrieve()
                    .body(Object.class);
            return ResponseEntity.ok(product);
        } catch (HttpClientErrorException.NotFound e) {
            return ResponseEntity.status(404).body(Map.of("message", "Sản phẩm không tìm thấy từ Product Service"));
        } catch (Exception e) {
            return ResponseEntity.status(503).body(Map.of(
                    "error", "Không thể kết nối đến Product Service (cổng 8081)",
                    "details", e.getMessage()
            ));
        }
    }
}
