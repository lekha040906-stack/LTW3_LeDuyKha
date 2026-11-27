package com.example.orderservice.service;

import com.example.orderservice.entity.Order;
import com.example.orderservice.entity.OrderItem;
import com.example.orderservice.repository.OrderRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderService {

    private final OrderRepository repository;

    public OrderService(OrderRepository repository) {
        this.repository = repository;
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

    public Order update(Long id, Order details) {
        Order order = getById(id);
        if (details.getCustomerName() != null) {
            order.setCustomerName(details.getCustomerName());
        }
        if (details.getPhone() != null) {
            order.setPhone(details.getPhone());
        }
        if (details.getOrderType() != null) {
            order.setOrderType(details.getOrderType());
        }
        if (details.getTotalAmount() != null) {
            order.setTotalAmount(details.getTotalAmount());
        }
        if (details.getPaymentMethod() != null) {
            order.setPaymentMethod(details.getPaymentMethod());
        }
        if (details.getStatus() != null) {
            order.setStatus(details.getStatus());
        }
        if (details.getNote() != null) {
            order.setNote(details.getNote());
        }
        return repository.save(order);
    }

    public void delete(Long id) {
        Order order = getById(id);
        repository.delete(order);
    }
}
