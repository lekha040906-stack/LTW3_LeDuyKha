package com.example.productservice;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*")
public class ProductController {

    private final List<Product> products = new CopyOnWriteArrayList<>(List.of(
            new Product(1L, "Laptop Dell XPS 15", 35000000.0),
            new Product(2L, "Bàn phím cơ không dây", 1500000.0),
            new Product(3L, "Chuột Logitech MX Master 3S", 2200000.0),
            new Product(4L, "Màn hình Dell UltraSharp 27 inch", 8900000.0)
    ));

    @GetMapping
    public List<Product> getAllProducts() {
        return products;
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        return products.stream()
                .filter(p -> p.id().equals(id))
                .findFirst()
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
