package com.example.orderservice.controller;

import com.example.orderservice.entity.Order;
import com.example.orderservice.entity.OrderItem;
import com.example.orderservice.repository.OrderRepository;
import com.example.orderservice.service.OrderService;
import jakarta.annotation.PostConstruct;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;

import java.math.BigDecimal;
import java.util.*;

@RestController
@RequestMapping("/api/orders")
@CrossOrigin(origins = "*")
public class OrderController {

    private final RestClient restClient;
    private final OrderService orderService;
    private final OrderRepository orderRepository;

    public OrderController(RestClient.Builder builder, OrderService orderService, OrderRepository orderRepository) {
        this.restClient = builder
            .baseUrl("http://localhost:8081")
            .build();
        this.orderService = orderService;
        this.orderRepository = orderRepository;
    }

    @PostConstruct
    public void initDefaultOrders() {
        if (orderRepository.count() == 0) {
            Order o1 = new Order("ORDER-TRA-SUA-001", "Lê Duy Kha", "0901234567", "Mang đi (Takeaway)", BigDecimal.valueOf(90000), "Đang pha chế (Preparing)", "Giao trước 14h, tách đá riêng");
            OrderItem item1 = new OrderItem(1L, "Trà sữa Trân châu đường đen", 2, BigDecimal.valueOf(45000), BigDecimal.valueOf(90000), "L", "50%", "70%", "Trân châu đen đường đen, Thạch phô mai", "Giao trước 14h, tách đá riêng");
            item1.setOrder(o1);
            o1.getItems().add(item1);
            orderRepository.save(o1);

            Order o2 = new Order("ORDER-TRA-SUA-002", "Nguyễn Văn An", "0912345678", "Tại bàn 03 (Dine-in)", BigDecimal.valueOf(32000), "Đã hoàn thành (Completed)", "Cho nhiều sả thơm");
            OrderItem item2 = new OrderItem(2L, "Trà đào cam sả", 1, BigDecimal.valueOf(32000), BigDecimal.valueOf(32000), "M", "70%", "100%", "Đào miếng giòn", "Cho nhiều sả thơm");
            item2.setOrder(o2);
            o2.getItems().add(item2);
            orderRepository.save(o2);

            Order o3 = new Order("ORDER-TRA-SUA-003", "Trần Thị Mai", "0988776655", "Giao hàng (Delivery)", BigDecimal.valueOf(118000), "Đang giao (Delivering)", "Giao hẻm 120 Kha Vạn Cân");
            OrderItem item3 = new OrderItem(3L, "Trà sữa Oolong nướng", 2, BigDecimal.valueOf(38000), BigDecimal.valueOf(76000), "M", "30%", "50%", "Trân châu hoàng kim", "Giao hẻm 120 Kha Vạn Cân");
            item3.setOrder(o3);
            o3.getItems().add(item3);
            OrderItem item4 = new OrderItem(4L, "Matcha Macchiato", 1, BigDecimal.valueOf(42000), BigDecimal.valueOf(42000), "M", "50%", "50%", "Kem cheese thêm", "Ít ngọt");
            item4.setOrder(o3);
            o3.getItems().add(item4);
            orderRepository.save(o3);
        }
    }

    @GetMapping
    public List<Order> getOrders() {
        return orderService.getAllOrders();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Order> getOrderById(@PathVariable Long id) {
        return orderService.getOrderById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Order> createOrder(@RequestBody Order order) {
        if (order.getItems() != null) {
            for (OrderItem item : order.getItems()) {
                item.setOrder(order);
            }
        }
        Order saved = orderService.saveOrder(order);
        return ResponseEntity.ok(saved);
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
