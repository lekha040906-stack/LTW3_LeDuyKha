package com.example.orderservice.service;

import com.example.orderservice.entity.Cart;
import com.example.orderservice.repository.CartRepository;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class CartService {

    private final CartRepository cartRepository;

    public CartService(CartRepository cartRepository) {
        this.cartRepository = cartRepository;
    }

    public Optional<Cart> getCartByCustomerId(String customerId) {
        return cartRepository.findByCustomerId(customerId);
    }

    public Cart saveCart(Cart cart) {
        return cartRepository.save(cart);
    }
}
