package com.example.productservice.service;

import com.example.productservice.entity.Brand;
import com.example.productservice.repository.BrandRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BrandService {

    private final BrandRepository repository;

    public BrandService(BrandRepository repository) {
        this.repository = repository;
    }

    public List<Brand> getAll() {
        return repository.findAll();
    }

    public Brand getById(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy thương hiệu có ID: " + id));
    }

    public Brand create(Brand brand) {
        if (brand.getName() == null || brand.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên thương hiệu không được để trống");
        }
        return repository.save(brand);
    }

    public Brand update(Long id, Brand brandDetails) {
        Brand brand = getById(id);
        if (brandDetails.getName() != null && !brandDetails.getName().trim().isEmpty()) {
            brand.setName(brandDetails.getName().trim());
        }
        brand.setOrigin(brandDetails.getOrigin());
        brand.setDescription(brandDetails.getDescription());
        return repository.save(brand);
    }

    public void delete(Long id) {
        Brand brand = getById(id);
        repository.delete(brand);
    }
}
