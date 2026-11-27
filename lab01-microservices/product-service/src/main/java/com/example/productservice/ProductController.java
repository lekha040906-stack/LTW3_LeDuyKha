package com.example.productservice;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*")
public class ProductController {

    private final List<Map<String, Object>> products = List.of(
        Map.of(
            "id", 1,
            "name", "Trà sữa Trân châu đường đen",
            "category", "Trà sữa",
            "price", 35000,
            "size", "M",
            "rating", 4.9,
            "image", "🧋",
            "description", "Trà sữa truyền thống thơm đậm vị trà, béo ngậy vị sữa kết hợp cùng trân châu dẻo dai sốt đường đen hảo hạng."
        ),
        Map.of(
            "id", 2,
            "name", "Trà đào cam sả",
            "category", "Trà trái cây",
            "price", 32000,
            "size", "M",
            "rating", 4.8,
            "image", "🍑",
            "description", "Trà đen thanh mát kết hợp cùng những lát cam vàng mọng nước, miếng đào giòn ngọt và hương sả thơm lừng."
        ),
        Map.of(
            "id", 3,
            "name", "Trà sữa Oolong nướng",
            "category", "Trà sữa",
            "price", 38000,
            "size", "M",
            "rating", 4.9,
            "image", "🍵",
            "description", "Lá trà Oolong được sấy nướng ở nhiệt độ chuẩn tạo hương thơm khói đặc trưng hòa quyện sữa béo thơm nức."
        ),
        Map.of(
            "id", 4,
            "name", "Matcha Macchiato",
            "category", "Macchiato",
            "price", 42000,
            "size", "M",
            "rating", 4.7,
            "image", "🍃",
            "description", "Bột trà xanh Uji Nhật Bản nguyên chất phối hợp cùng lớp kem phô mai Macchiato béo mặn sánh mịn bên trên."
        ),
        Map.of(
            "id", 5,
            "name", "Trà lài đác thơm",
            "category", "Trà trái cây",
            "price", 35000,
            "size", "M",
            "rating", 4.6,
            "image", "🍍",
            "description", "Trà hoa lài thanh dịu kết hợp hạt đác rim dẻo thơm và mứt quả thơm ngọt ngào giúp giải nhiệt tuyệt đối."
        ),
        Map.of(
            "id", 6,
            "name", "Sữa tươi Trân châu đường đen",
            "category", "Sữa tươi",
            "price", 40000,
            "size", "M",
            "rating", 4.9,
            "image", "🥛",
            "description", "Sữa tươi thanh trùng Dalat Milk nguyên chất, hòa quyện sốt đường đen Đài Loan và trân châu hoàng kim dẻo mềm."
        ),
        Map.of(
            "id", 7,
            "name", "Cà phê Muối béo",
            "category", "Cà phê",
            "price", 29000,
            "size", "M",
            "rating", 4.8,
            "image", "☕",
            "description", "Cà phê Robusta Đắk Lắk đậm đà hòa quyện cùng lớp kem muối béo mặn ngậy đầy lôi cuốn."
        ),
        Map.of(
            "id", 8,
            "name", "Trà xoài kem cheese",
            "category", "Macchiato",
            "price", 45000,
            "size", "M",
            "rating", 4.8,
            "image", "🥭",
            "description", "Nước ép xoài cát Hòa Lộc tươi mát phủ bên trên lớp kem phô mai béo ngậy tuyệt hảo."
        )
    );

    @GetMapping
    public List<Map<String, Object>> getProducts() {
        return products;
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getProduct(@PathVariable int id) {
        return products.stream()
            .filter(p -> p.get("id").equals(id))
            .findFirst()
            .map(ResponseEntity::ok)
            .orElseGet(() -> ResponseEntity.notFound().build());
    }
}
