package com.example.orderservice.config;

import com.example.orderservice.entity.Order;
import com.example.orderservice.entity.OrderItem;
import com.example.orderservice.repository.OrderRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.math.BigDecimal;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initOrders(OrderRepository orderRepository) {
        return args -> {
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
        };
    }
}
