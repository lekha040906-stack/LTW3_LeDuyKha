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
        Category category = categoryRepository.findById(request.getCategoryId())
            .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy danh mục với ID: " + request.getCategoryId()));
        Brand brand = null;
        if (request.getBrandId() != null) {
            brand = brandRepository.findById(request.getBrandId()).orElse(null);
        }

        Product product = new Product(
            request.getName().trim(),
            request.getPrice(),
            request.getQuantity(),
            request.getDescription(),
            category,
            brand
        );
        if (request.getSize() != null) {
            product.setSize(request.getSize());
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
        ProductResponse dto = new ProductResponse();
        dto.setId(product.getId());
        dto.setName(product.getName());
        dto.setPrice(product.getPrice());
        dto.setQuantity(product.getQuantity());
        dto.setDescription(product.getDescription());
        dto.setSize(product.getSize());
        dto.setRating(product.getRating());
        dto.setIsAvailable(product.getIsAvailable());
        if (product.getCategory() != null) {
            dto.setCategoryId(product.getCategory().getId());
            dto.setCategoryName(product.getCategory().getName());
            dto.setIcon(product.getCategory().getIcon());
        }
        if (product.getBrand() != null) {
            dto.setBrandId(product.getBrand().getId());
            dto.setBrandName(product.getBrand().getName());
        }
        return dto;
    }

    public List<ProductResponse> getAllResponses() {
        return repository.findAll().stream()
            .map(this::toResponseDto)
            .collect(Collectors.toList());
    }
}
