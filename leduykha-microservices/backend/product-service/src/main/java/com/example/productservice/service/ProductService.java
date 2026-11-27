package com.example.productservice.service;

import com.example.productservice.dto.ProductRequest;
import com.example.productservice.dto.ProductResponse;
import com.example.productservice.entity.Brand;
import com.example.productservice.entity.Category;
import com.example.productservice.entity.Product;
import com.example.productservice.exception.ResourceNotFoundException;
import com.example.productservice.repository.BrandRepository;
import com.example.productservice.repository.CategoryRepository;
import com.example.productservice.repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProductService {

    private final ProductRepository repository;
    private final CategoryRepository categoryRepository;
    private final BrandRepository brandRepository;

    public ProductService(ProductRepository repository, CategoryRepository categoryRepository, BrandRepository brandRepository) {
        this.repository = repository;
        this.categoryRepository = categoryRepository;
        this.brandRepository = brandRepository;
    }

    public List<Product> getAll() {
        return repository.findAll();
    }

    public Product getById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy sản phẩm có ID: " + id));
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

    public Product createFromDto(ProductRequest request) {
        Long catId = request.categoryId() != null ? request.categoryId() : 1L;
        Category category = categoryRepository.findById(catId)
            .orElseGet(() -> categoryRepository.findAll().stream().findFirst().orElse(null));

        Brand brand = null;
        if (request.brandId() != null) {
            brand = brandRepository.findById(request.brandId()).orElse(null);
        } else {
            brand = brandRepository.findAll().stream().findFirst().orElse(null);
        }

        Product product = new Product(
            request.name().trim(),
            request.price(),
            request.quantity() != null ? request.quantity() : 100,
            request.description() != null ? request.description() : "",
            category,
            brand
        );
        if (request.size() != null) {
            product.setSize(request.size());
        }
        return repository.save(product);
    }

    public Product reduceStock(Long id, Integer quantity) {
        Product product = getById(id);
        if (product.getQuantity() < quantity) {
            throw new IllegalArgumentException("Món '" + product.getName() + "' không đủ số lượng tồn kho (còn: " + product.getQuantity() + ", yêu cầu: " + quantity + ")");
        }
        product.setQuantity(product.getQuantity() - quantity);
        if (product.getQuantity() == 0) {
            product.setIsAvailable(false);
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

    public ProductResponse toResponseDto(Product product) {
        return new ProductResponse(
            product.getId(),
            product.getName(),
            product.getPrice(),
            product.getQuantity(),
            product.getDescription(),
            product.getSize(),
            product.getRating(),
            product.getIsAvailable(),
            product.getCategory() != null ? product.getCategory().getId() : null,
            product.getCategory() != null ? product.getCategory().getName() : null,
            product.getCategory() != null ? product.getCategory().getIcon() : "🧋"
        );
    }

    public List<ProductResponse> getAllResponses() {
        return repository.findAll().stream()
            .map(this::toResponseDto)
            .collect(Collectors.toList());
    }
}
