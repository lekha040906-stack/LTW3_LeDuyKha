package com.example.productservice.service;

import com.example.productservice.entity.Category;
import com.example.productservice.repository.CategoryRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {

    private final CategoryRepository repository;

    public CategoryService(CategoryRepository repository) {
        this.repository = repository;
    }

    public List<Category> getAll() {
        return repository.findAll();
    }

    public Category getById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy loại sản phẩm có ID: " + id));
    }

    public Category create(Category category) {
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên loại sản phẩm không được để trống");
        }
        return repository.save(category);
    }

    public Category update(Long id, Category categoryDetails) {
        Category category = getById(id);
        if (categoryDetails.getName() != null && !categoryDetails.getName().trim().isEmpty()) {
            category.setName(categoryDetails.getName().trim());
        }
        category.setDescription(categoryDetails.getDescription());
        category.setIcon(categoryDetails.getIcon());
        if (categoryDetails.getActive() != null) {
            category.setActive(categoryDetails.getActive());
        }
        return repository.save(category);
    }

    public void delete(Long id) {
        Category category = getById(id);
        repository.delete(category);
    }
}
