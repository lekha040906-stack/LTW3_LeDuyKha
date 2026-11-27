package com.example.productservice.controller;

import com.example.productservice.entity.Brand;
import com.example.productservice.entity.Category;
import com.example.productservice.entity.Product;
import com.example.productservice.repository.BrandRepository;
import com.example.productservice.repository.CategoryRepository;
import com.example.productservice.repository.ProductRepository;
import com.example.productservice.service.CategoryService;
import com.example.productservice.service.ProductService;
import jakarta.annotation.PostConstruct;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*")
public class ProductController {

    private final ProductService productService;
    private final CategoryService categoryService;
    private final CategoryRepository categoryRepository;
    private final BrandRepository brandRepository;
    private final ProductRepository productRepository;

    public ProductController(
        ProductService productService,
        CategoryService categoryService,
        CategoryRepository categoryRepository,
        BrandRepository brandRepository,
        ProductRepository productRepository
    ) {
        this.productService = productService;
        this.categoryService = categoryService;
        this.categoryRepository = categoryRepository;
        this.brandRepository = brandRepository;
        this.productRepository = productRepository;
    }

    @PostConstruct
    public void initDefaultData() {
        if (categoryRepository.count() == 0) {
            Category c1 = categoryRepository.save(new Category("Trà sữa", "Các dòng trà sữa thơm ngon truyền thống", "🧋"));
            Category c2 = categoryRepository.save(new Category("Trà trái cây", "Trà hoa quả nhiệt đới tươi mát", "🍑"));
            Category c3 = categoryRepository.save(new Category("Macchiato", "Trà kem phô mai béo ngậy sánh mịn", "🍃"));
            Category c4 = categoryRepository.save(new Category("Sữa tươi", "Sữa tươi thanh trùng Dalat Milk", "🥛"));
            Category c5 = categoryRepository.save(new Category("Cà phê", "Cà phê Robusta Đắk Lắk đậm đà", "☕"));

            Brand b1 = brandRepository.save(new Brand("Kha Milk Tea Store", "Việt Nam", "Thương hiệu trà sữa phong cách hiện đại"));

            productRepository.save(new Product("Trà sữa Trân châu đường đen", BigDecimal.valueOf(35000), 100, "Trà sữa truyền thống thơm đậm vị trà, béo ngậy vị sữa kết hợp cùng trân châu dẻo dai sốt đường đen hảo hạng.", c1, b1));
            productRepository.save(new Product("Trà đào cam sả", BigDecimal.valueOf(32000), 80, "Trà đen thanh mát kết hợp cùng những lát cam vàng mọng nước, miếng đào giòn ngọt và hương sả thơm lừng.", c2, b1));
            productRepository.save(new Product("Trà sữa Oolong nướng", BigDecimal.valueOf(38000), 90, "Lá trà Oolong được sấy nướng ở nhiệt độ chuẩn tạo hương thơm khói đặc trưng hòa quyện sữa béo thơm nức.", c1, b1));
            productRepository.save(new Product("Matcha Macchiato", BigDecimal.valueOf(42000), 60, "Bột trà xanh Uji Nhật Bản nguyên chất phối hợp cùng lớp kem phô mai Macchiato béo mặn sánh mịn bên trên.", c3, b1));
            productRepository.save(new Product("Trà lài đác thơm", BigDecimal.valueOf(35000), 75, "Trà hoa lài thanh dịu kết hợp hạt đác rim dẻo thơm và mứt quả thơm ngọt ngào giúp giải nhiệt tuyệt đối.", c2, b1));
            productRepository.save(new Product("Sữa tươi Trân châu đường đen", BigDecimal.valueOf(40000), 85, "Sữa tươi thanh trùng Dalat Milk nguyên chất, hòa quyện sốt đường đen Đài Loan và trân châu hoàng kim dẻo mềm.", c4, b1));
            productRepository.save(new Product("Cà phê Muối béo", BigDecimal.valueOf(29000), 120, "Cà phê Robusta Đắk Lắk đậm đà hòa quyện cùng lớp kem muối béo mặn ngậy đầy lôi cuốn.", c5, b1));
            productRepository.save(new Product("Trà xoài kem cheese", BigDecimal.valueOf(45000), 50, "Nước ép xoài cát Hòa Lộc tươi mát phủ bên trên lớp kem phô mai béo ngậy tuyệt hảo.", c3, b1));
        }
    }

    @GetMapping
    public List<Map<String, Object>> getProducts() {
        List<Product> list = productService.getAllProducts();
        List<Map<String, Object>> result = new ArrayList<>();
        for (Product p : list) {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", p.getId());
            map.put("name", p.getName());
            map.put("category", p.getCategory() != null ? p.getCategory().getName() : "Trà sữa");
            map.put("price", p.getPrice());
            map.put("quantity", p.getQuantity());
            map.put("size", p.getSize() != null ? p.getSize() : "M");
            map.put("rating", p.getRating() != null ? p.getRating() : 5.0);
            map.put("isAvailable", p.getIsAvailable());
            map.put("image", p.getCategory() != null && p.getCategory().getIcon() != null ? p.getCategory().getIcon() : "🧋");
            map.put("description", p.getDescription());
            result.add(map);
        }
        return result;
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getProductById(@PathVariable Long id) {
        Optional<Product> opt = productService.getProductById(id);
        if (opt.isPresent()) {
            Product p = opt.get();
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", p.getId());
            map.put("name", p.getName());
            map.put("category", p.getCategory() != null ? p.getCategory().getName() : "Trà sữa");
            map.put("price", p.getPrice());
            map.put("quantity", p.getQuantity());
            map.put("size", p.getSize());
            map.put("rating", p.getRating());
            map.put("isAvailable", p.getIsAvailable());
            map.put("description", p.getDescription());
            return ResponseEntity.ok(map);
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/search")
    public List<Product> searchProducts(@RequestParam(required = false, defaultValue = "") String keyword) {
        return productService.searchProducts(keyword);
    }

    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        Product created = productService.saveProduct(product);
        return ResponseEntity.ok(created);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return ResponseEntity.noContent().build();
    }
}
