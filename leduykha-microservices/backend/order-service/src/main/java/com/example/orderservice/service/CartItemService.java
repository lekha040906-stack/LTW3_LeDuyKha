package com.example.orderservice.service;

import com.example.orderservice.entity.CartItem;
import com.example.orderservice.repository.CartItemRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CartItemService {

    private final CartItemRepository repository;

    public CartItemService(CartItemRepository repository) {
        this.repository = repository;
    }

    public List<CartItem> getAll() {
        return repository.findAll();
    }

    public CartItem getById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy món trong giỏ hàng có ID: " + id));
    }

    public List<CartItem> getByCartId(Long cartId) {
        return repository.findByCartId(cartId);
    }

    public CartItem create(CartItem item) {
        return repository.save(item);
    }

    public CartItem update(Long id, CartItem details) {
        CartItem item = getById(id);
        if (details.getQuantity() != null) {
            item.setQuantity(details.getQuantity());
        }
        if (details.getPrice() != null) {
            item.setPrice(details.getPrice());
        }
        if (details.getSize() != null) {
            item.setSize(details.getSize());
        }
        if (details.getSugar() != null) {
            item.setSugar(details.getSugar());
        }
        if (details.getIce() != null) {
            item.setIce(details.getIce());
        }
        if (details.getToppings() != null) {
            item.setToppings(details.getToppings());
        }
        return repository.save(item);
    }

    public void delete(Long id) {
        CartItem item = getById(id);
        repository.delete(item);
    }
}
