package com.example.productservice.service;

import com.example.productservice.entity.Product;
import com.example.productservice.repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    private final ProductRepository repository;

    public ProductService(ProductRepository repository) {
        this.repository = repository;
    }

    public List<Product> getAll() {
        return repository.findAll();
    }

    public Product getById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm có ID: " + id));
    }

    public Product create(Product product) {
        if (product.getName() == null || product.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên đồ uống không được để trống");
        }
        if (product.getPrice() == null) {
            throw new IllegalArgumentException("Giá bán không được để trống");
        }
        return repository.save(product);
    }

    public Product update(Long id, Product details) {
        Product product = getById(id);
        if (details.getName() != null && !details.getName().trim().isEmpty()) {
            product.setName(details.getName().trim());
        }
        if (details.getPrice() != null) {
            product.setPrice(details.getPrice());
        }
        if (details.getQuantity() != null) {
            product.setQuantity(details.getQuantity());
        }
        if (details.getDescription() != null) {
            product.setDescription(details.getDescription());
        }
        if (details.getSize() != null) {
            product.setSize(details.getSize());
        }
        if (details.getRating() != null) {
            product.setRating(details.getRating());
        }
        if (details.getIsAvailable() != null) {
            product.setIsAvailable(details.getIsAvailable());
        }
        if (details.getCategory() != null) {
            product.setCategory(details.getCategory());
        }
        if (details.getBrand() != null) {
            product.setBrand(details.getBrand());
        }
        return repository.save(product);
    }

    public void delete(Long id) {
        Product product = getById(id);
        repository.delete(product);
    }

    public List<Product> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return repository.findAll();
        }
        return repository.findByNameContainingIgnoreCase(keyword.trim());
    }

    public List<Product> getByCategoryId(Long categoryId) {
        return repository.findByCategoryId(categoryId);
    }
}
