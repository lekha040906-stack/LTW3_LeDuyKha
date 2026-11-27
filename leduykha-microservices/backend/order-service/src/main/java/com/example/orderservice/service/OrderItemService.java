package com.example.orderservice.service;

import com.example.orderservice.entity.OrderItem;
import com.example.orderservice.repository.OrderItemRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderItemService {

    private final OrderItemRepository repository;

    public OrderItemService(OrderItemRepository repository) {
        this.repository = repository;
    }

    public List<OrderItem> getAll() {
        return repository.findAll();
    }

    public OrderItem getById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy chi tiết đơn hàng có ID: " + id));
    }

    public List<OrderItem> getByOrderId(Long orderId) {
        return repository.findByOrderId(orderId);
    }

    public OrderItem create(OrderItem item) {
        return repository.save(item);
    }

    public void delete(Long id) {
        OrderItem item = getById(id);
        repository.delete(item);
    }
}
