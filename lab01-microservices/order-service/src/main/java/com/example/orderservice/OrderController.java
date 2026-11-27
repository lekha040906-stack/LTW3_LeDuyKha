package com.example.orderservice;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;
import java.util.*;

@RestController
@RequestMapping("/api/orders")
@CrossOrigin(origins = "*")
public class OrderController {

    private final RestClient restClient;

    public OrderController(RestClient.Builder builder) {
        this.restClient = builder
            .baseUrl("http://localhost:8081")
            .build();
    }

    private Map<String, Object> createOrder(
        int id,
        String orderCode,
        String customerName,
        String phone,
        String orderType,
        int productId,
        String productName,
        int quantity,
        String size,
        String sugar,
        String ice,
        List<String> toppings,
        String note,
        int unitPrice,
        int totalPrice,
        String status
    ) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", id);
        map.put("orderCode", orderCode);
        map.put("customerName", customerName);
        map.put("phone", phone);
        map.put("orderType", orderType);
        map.put("productId", productId);
        map.put("productName", productName);
        map.put("quantity", quantity);
        map.put("size", size);
        map.put("sugar", sugar);
        map.put("ice", ice);
        map.put("toppings", toppings);
        map.put("note", note);
        map.put("unitPrice", unitPrice);
        map.put("totalPrice", totalPrice);
        map.put("status", status);
        return map;
    }

    @GetMapping
    public List<Map<String, Object>> getOrders() {
        return List.of(
            createOrder(
                101,
                "ORDER-TRA-SUA-001",
                "Lê Duy Kha",
                "0901234567",
                "Mang đi (Takeaway)",
                1,
                "Trà sữa Trân châu đường đen",
                2,
                "L",
                "50%",
                "70%",
                List.of("Trân châu đen đường đen", "Thạch phô mai"),
                "Giao trước 14h, tách đá riêng",
                45000,
                90000,
                "Đang pha chế (Preparing)"
            ),
            createOrder(
                102,
                "ORDER-TRA-SUA-002",
                "Nguyễn Văn An",
                "0912345678",
                "Tại bàn 03 (Dine-in)",
                2,
                "Trà đào cam sả",
                1,
                "M",
                "70%",
                "100%",
                List.of("Đào miếng giòn"),
                "Cho nhiều sả thơm",
                32000,
                32000,
                "Đã hoàn thành (Completed)"
            ),
            createOrder(
                103,
                "ORDER-TRA-SUA-003",
                "Trần Thị Mai",
                "0987654321",
                "Giao tận nơi (Delivery)",
                4,
                "Matcha Macchiato",
                2,
                "M",
                "50%",
                "50%",
                List.of("Trân châu trắng 3Q"),
                "Lớp kem phô mai để riêng",
                42000,
                84000,
                "Chờ xác nhận (Pending)"
            )
        );
    }

    @GetMapping("/product/{id}")
    public ResponseEntity<String> getProduct(@PathVariable int id) {
        try {
            String product = restClient.get()
                .uri("/api/products/{id}", id)
                .retrieve()
                .body(String.class);
            return ResponseEntity.ok(product);
        } catch (HttpClientErrorException.NotFound e) {
            return ResponseEntity.notFound().build();
        }
    }
}
