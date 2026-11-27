package com.example.productservice.controller;

import com.example.productservice.dto.ProductRequest;
import com.example.productservice.dto.ProductResponse;
import com.example.productservice.entity.Product;
import com.example.productservice.service.ProductService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*")
public class ProductController {

    private final ProductService service;

    public ProductController(ProductService service) {
        this.service = service;
    }

    // Lấy danh sách sản phẩm (Lab 03 - Mục 7)
    @GetMapping
    public List<ProductResponse> getAll() {
        return service.getAll();
    }

    // Lấy chi tiết sản phẩm theo ID (Lab 03 - Mục 7)
    @GetMapping("/{id}")
    public ProductResponse getById(@PathVariable Long id) {
        return service.getById(id);
    }

    @PostMapping
    public ResponseEntity<ProductResponse> create(@Valid @RequestBody ProductRequest request) {
        Product created = service.createFromDto(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(service.getById(created.getId()));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductResponse> update(@PathVariable Long id, @Valid @RequestBody Product product) {
        Product updated = service.update(id, product);
        return ResponseEntity.ok(service.getById(updated.getId()));
    }

    @PutMapping("/{id}/reduce-stock")
    public ResponseEntity<ProductResponse> reduceStock(@PathVariable Long id, @RequestParam Integer quantity) {
        Product updated = service.reduceStock(id, quantity);
        return ResponseEntity.ok(service.getById(updated.getId()));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/search")
    public List<Product> search(@RequestParam(required = false, defaultValue = "") String keyword) {
        return service.search(keyword);
    }

    @GetMapping("/category/{categoryId}")
    public List<Product> getByCategory(@PathVariable Long categoryId) {
        return service.getByCategoryId(categoryId);
    }
}
