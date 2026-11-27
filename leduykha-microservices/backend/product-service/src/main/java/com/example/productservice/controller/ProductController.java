package com.example.productservice.controller;

import com.example.productservice.dto.request.ProductCreateRequest;
import com.example.productservice.dto.response.ApiResponse;
import com.example.productservice.dto.response.ProductResponse;
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

    @GetMapping
    public List<ProductResponse> getAll() {
        return service.getAllResponses();
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductResponse> getById(@PathVariable Long id) {
        Product product = service.getById(id);
        return ResponseEntity.ok(service.toResponseDto(product));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<ProductResponse>> create(@Valid @RequestBody ProductCreateRequest request) {
        Product created = service.createFromDto(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(
            ApiResponse.ok("Tạo đồ uống thành công", service.toResponseDto(created))
        );
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<ProductResponse>> update(@PathVariable Long id, @Valid @RequestBody Product product) {
        Product updated = service.update(id, product);
        return ResponseEntity.ok(
            ApiResponse.ok("Cập nhật đồ uống thành công", service.toResponseDto(updated))
        );
    }

    @PutMapping("/{id}/reduce-stock")
    public ResponseEntity<ApiResponse<ProductResponse>> reduceStock(@PathVariable Long id, @RequestParam Integer quantity) {
        Product updated = service.reduceStock(id, quantity);
        return ResponseEntity.ok(
            ApiResponse.ok("Giảm tồn kho thành công", service.toResponseDto(updated))
        );
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
