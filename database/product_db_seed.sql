-- ====================================================================
-- HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA (MILK TEA STORE)
-- Database Seed: Product Service (MySQL - product_db)
-- Sinh viên: Lê Duy Kha - MSSV: 2124110074
-- ====================================================================

CREATE DATABASE IF NOT EXISTS product_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE product_db;

-- 1. BẢNG CATEGORIES (5 danh mục)
INSERT INTO categories (id, name, description, icon, active) VALUES
(1, 'Trà sữa', 'Các dòng trà sữa truyền thống thơm béo đậm vị', '🧋', 1),
(2, 'Trà trái cây', 'Trà hoa quả tươi nhiệt đới thanh mát giải nhiệt', '🍑', 1),
(3, 'Macchiato', 'Trà kem phô mai béo ngậy mặn ngọt sánh mịn', '🍃', 1),
(4, 'Sữa tươi', 'Sữa tươi thanh trùng nguyên chất Dalat Milk', '🥛', 1),
(5, 'Cà phê', 'Cà phê Robusta Đắk Lắk nguyên chất thơm lừng', '☕', 1)
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- 2. BẢNG BRANDS (3 thương hiệu)
INSERT INTO brands (id, name, origin, description) VALUES
(1, 'Kha Milk Tea Store', 'Việt Nam', 'Thương hiệu trà sữa nhà làm chuẩn vị tự nhiên'),
(2, 'Đài Loan Oolong Master', 'Đài Loan', 'Nguyên liệu trà lá Oolong cao nguyên trứ danh'),
(3, 'Uji Kyoto Matcha', 'Nhật Bản', 'Bột trà xanh Matcha nguyên chất nhập khẩu Nhật Bản')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- 3. BẢNG PRODUCTS (12 món đồ uống trà sữa)
INSERT INTO products (id, name, price, quantity, description, size, rating, is_available, category_id, brand_id) VALUES
(1, 'Trà sữa Trân châu đường đen', 35000.00, 100, 'Trà sữa truyền thống thơm đậm vị trà, béo ngậy vị sữa kết hợp cùng trân châu dẻo dai sốt đường đen hảo hạng.', 'M', 4.9, 1, 1, 1),
(2, 'Trà đào cam sả', 32000.00, 80, 'Trà đen thanh mát kết hợp cùng những lát cam vàng mọng nước, miếng đào giòn ngọt và hương sả thơm lừng.', 'M', 4.8, 1, 2, 1),
(3, 'Trà sữa Oolong nướng', 38000.00, 90, 'Lá trà Oolong được sấy nướng ở nhiệt độ chuẩn tạo hương thơm khói đặc trưng hòa quyện sữa béo thơm nức.', 'M', 4.9, 1, 1, 2),
(4, 'Matcha Macchiato', 42000.00, 60, 'Bột trà xanh Uji Nhật Bản nguyên chất phối hợp cùng lớp kem phô mai Macchiato béo mặn sánh mịn bên trên.', 'M', 4.7, 1, 3, 3),
(5, 'Trà lài đác thơm', 35000.00, 75, 'Trà hoa lài thanh dịu kết hợp hạt đác rim dẻo thơm và mứt quả thơm ngọt ngào giúp giải nhiệt tuyệt đối.', 'M', 4.6, 1, 2, 1),
(6, 'Sữa tươi Trân châu đường đen', 40000.00, 85, 'Sữa tươi thanh trùng Dalat Milk nguyên chất, hòa quyện sốt đường đen Đài Loan và trân châu hoàng kim dẻo mềm.', 'M', 4.9, 1, 4, 1),
(7, 'Cà phê Muối béo', 29000.00, 120, 'Cà phê Robusta Đắk Lắk đậm đà hòa quyện cùng lớp kem muối béo mặn ngậy đầy lôi cuốn.', 'M', 4.8, 1, 5, 1),
(8, 'Trà xoài kem cheese', 45000.00, 50, 'Nước ép xoài cát Hòa Lộc tươi mát phủ bên trên lớp kem phô mai béo ngậy tuyệt hảo.', 'M', 4.8, 1, 3, 1),
(9, 'Trà sữa Khoai môn dẻo', 36000.00, 70, 'Trà sữa thơm lừng hương vị khoai môn ngọt bùi kết hợp cùng bột khoai môn tươi tự nhiên.', 'M', 4.7, 1, 1, 1),
(10, 'Trà dâu tây ổi hồng', 38000.00, 65, 'Sự hòa quyện tuyệt hảo giữa dâu tây Đà Lạt mọng nước và ổi hồng ruột đỏ thơm nức.', 'M', 4.8, 1, 2, 1),
(11, 'Trà sữa Thái xanh thạch phô mai', 32000.00, 85, 'Trà Thái xanh thơm dịu mát lạnh kèm viên thạch phô mai béo ngậy giòn tan.', 'M', 4.6, 1, 1, 1),
(12, 'Bạc xỉu ba tầng cốt dừa', 30000.00, 95, 'Cà phê sữa ba tầng phân tầng đẹp mắt, béo thơm cốt dừa Bến Tre hòa quyện sữa đặc ngọt ngào.', 'M', 4.9, 1, 5, 1)
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- 4. BẢNG PRODUCT_IMAGES (Hình ảnh sản phẩm)
INSERT INTO product_images (id, image_url, is_primary, product_id) VALUES
(1, 'https://images.unsplash.com/photo-1558857563-b37fe432d005?auto=format&fit=crop&w=600&q=80', 1, 1),
(2, 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?auto=format&fit=crop&w=600&q=80', 1, 2),
(3, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?auto=format&fit=crop&w=600&q=80', 1, 3),
(4, 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?auto=format&fit=crop&w=600&q=80', 1, 4),
(5, 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80', 1, 5),
(6, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=600&q=80', 1, 6),
(7, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80', 1, 7),
(8, 'https://images.unsplash.com/photo-1546173159-315724a31696?auto=format&fit=crop&w=600&q=80', 1, 8)
ON DUPLICATE KEY UPDATE image_url=VALUES(image_url);
