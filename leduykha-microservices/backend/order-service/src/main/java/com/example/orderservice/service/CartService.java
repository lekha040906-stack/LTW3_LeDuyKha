package com.example.orderservice.service;

import com.example.orderservice.entity.Cart;
import com.example.orderservice.entity.CartItem;
import com.example.orderservice.repository.CartRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CartService {

    private final CartRepository repository;

    public CartService(CartRepository repository) {
        this.repository = repository;
    }

    public List<Cart> getAll() {
        return repository.findAll();
    }

    public Cart getById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy giỏ hàng có ID: " + id));
    }

    public Cart getByCustomerId(String customerId) {
        return repository.findByCustomerId(customerId)
            .orElseGet(() -> repository.save(new Cart(customerId)));
    }

    public Cart create(Cart cart) {
        if (cart.getItems() != null) {
            for (CartItem item : cart.getItems()) {
                item.setCart(cart);
            }
        }
        return repository.save(cart);
    }

    public Cart update(Long id, Cart details) {
        Cart cart = getById(id);
        if (details.getTotalAmount() != null) {
            cart.setTotalAmount(details.getTotalAmount());
        }
        return repository.save(cart);
    }

    public void delete(Long id) {
        Cart cart = getById(id);
        repository.delete(cart);
    }
}
