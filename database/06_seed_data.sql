-- =====================================================
-- HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA - MILK TEA STORE MANAGEMENT SYSTEM
-- File: 06_seed_data.sql
-- Tác giả: Lê Duy Kha - MSSV: 2124110074
-- Mô tả: Dữ liệu mẫu khởi tạo hoàn chỉnh cho Quán Trà Sữa
-- =====================================================

USE milk_tea_management;

-- =====================================================
-- 1. DỮ LIỆU ROLES (4 vai trò)
-- =====================================================
INSERT INTO roles (name, description) VALUES
('admin',   'Chủ quán / Quản trị viên - Toàn quyền quản trị hệ thống, menu và kho bãi'),
('cashier', 'Thu ngân - Nhận order tại quầy, xuất hóa đơn và xử lý thanh toán'),
('barista', 'Pha chế / Barista - Tiếp nhận danh sách ly cần pha trên KDS và hoàn thành đơn'),
('waiter',  'Phục vụ - Phục vụ đồ uống tại bàn và hỗ trợ giao đơn cho shipper');

-- =====================================================
-- 2. DỮ LIỆU USERS (8 nhân sự quán trà sữa)
-- Mật khẩu mẫu: "password123" (đã mã hóa bcrypt)
-- =====================================================
INSERT INTO users (name, email, password, phone, role_id, status) VALUES
-- Admin (Quản lý)
('Lê Duy Kha',      'admin@trasua.vn',      '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0901234567', 1, 'active'),
('Trần Thị Bích',   'bich.quanly@trasua.vn', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0901000002', 1, 'active'),

-- Thu ngân (Cashier)
('Lê Hoàng Cường',  'cuong.thungan@trasua.vn','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0902000001', 2, 'active'),
('Phạm Thị Dung',   'dung.thungan@trasua.vn', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0902000002', 2, 'active'),

-- Pha chế (Barista)
('Bùi Thanh Nam',   'nam.barista@trasua.vn', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0903000001', 3, 'active'),
('Lý Thị Oanh',    'oanh.barista@trasua.vn','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0903000002', 3, 'active'),

-- Phục vụ (Waiter)
('Hoàng Minh Đức',  'duc.phucvu@trasua.vn',  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0904000001', 4, 'active'),
('Võ Thị Hoa',      'hoa.phucvu@trasua.vn',  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0904000002', 4, 'active');

-- =====================================================
-- 3. DỮ LIỆU TABLES (10 bàn & khu vực phục vụ)
-- =====================================================
INSERT INTO tables (name, area, capacity, status) VALUES
('Bàn 01',        'Tầng trệt', 2, 'serving'),
('Bàn 02',        'Tầng trệt', 4, 'empty'),
('Bàn 03',        'Tầng trệt', 4, 'empty'),
('Bàn Sofa 04',   'Tầng trệt', 6, 'serving'),
('Bàn 05',        'Lầu 1',     4, 'empty'),
('Bàn 06',        'Lầu 1',     4, 'empty'),
('Bàn Ban công 07','Lầu 1',    2, 'reserved'),
('Bàn Nhóm 08',   'Lầu 1',     8, 'empty'),
('Quầy Bar 09',   'Quầy Bar',  2, 'empty'),
('Khu Mang đi',   'Mang đi',   10, 'empty');

-- =====================================================
-- 4. DỮ LIỆU CATEGORIES (5 danh mục đồ uống)
-- =====================================================
INSERT INTO categories (name, icon, display_order, status) VALUES
('Trà Sữa Đậm Vị',          '🧋', 1, 'active'),
('Trà Trái Cây Nhiệt Đới',   '🍑', 2, 'active'),
('Macchiato & Cheese Foam', '🍃', 3, 'active'),
('Sữa Tươi & Đá Xay',       '🥛', 4, 'active'),
('Cà Phê & Đồ Uống Khác',   '☕', 5, 'active');

-- =====================================================
-- 5. DỮ LIỆU PRODUCTS (20 món trà sữa & đồ uống signature)
-- =====================================================
INSERT INTO products (category_id, name, base_price, image, unit, description, is_available) VALUES
-- === Trà Sữa Đậm Vị (category_id = 1) ===
(1, 'Trà sữa Trân châu đường đen', 35000, 'ts_duongden.jpg',  'ly', 'Trà sữa truyền thống đậm vị trà, hòa quyện trân châu sốt đường đen béo ngọt.', 1),
(1, 'Trà sữa Oolong nướng',        38000, 'ts_oolong.jpg',    'ly', 'Lá trà Oolong được sấy nướng tạo mùi khói đặc trưng hòa quyện sữa béo bùi.', 1),
(1, 'Trà sữa Lài thanh mát',       32000, 'ts_lai.jpg',       'ly', 'Hương hoa nhài thơm ngát kết hợp sữa thanh nhẹ dịu mát.', 1),
(1, 'Trà sữa Thái xanh',           30000, 'ts_thaixanh.jpg',  'ly', 'Vị trà xanh Thái Lan thơm nồng đặc trưng kèm sữa béo.', 1),
(1, 'Trà sữa Hạt phỉ béo ngậy',    39000, 'ts_hatphi.jpg',    'ly', 'Hương thơm hạt phỉ rang kết hợp trà đen Assam đậm đà.', 1),

-- === Trà Trái Cây Nhiệt Đới (category_id = 2) ===
(2, 'Trà đào cam sả',              35000, 'tra_dao.jpg',      'ly', 'Trà thanh ngọt kết hợp lát cam vàng mọng nước, miếng đào giòn và sả thơm.', 1),
(2, 'Trà lài đác thơm',            35000, 'tra_dacthom.jpg',  'ly', 'Hạt đác rim dẻo thơm hòa quyện mứt thơm ngọt thanh trên nền trà lài.', 1),
(2, 'Trà ổi hồng Ruby',            38000, 'tra_oihong.jpg',   'ly', 'Nước ép ổi hồng thanh khiết, màu sắc bắt mắt và vị chua ngọt dễ chịu.', 1),
(2, 'Trà dưa lưới nha đam',        35000, 'tra_dualuoi.jpg',  'ly', 'Dưa lưới thơm ngát kết hợp thạch nha đam tươi giòn sảng khoái.', 1),
(2, 'Trà vải kim tuyên',           36000, 'tra_vai.jpg',      'ly', 'Trà Ô long Kim Tuyên kết hợp quả vải thiều mọng nước.', 1),

-- === Macchiato & Cheese Foam (category_id = 3) ===
(3, 'Matcha Macchiato',            42000, 'matcha_mac.jpg',   'ly', 'Matcha Uji Nhật Bản nguyên chất phủ lớp kem cheese béo mặn sánh mịn.', 1),
(3, 'Trà sen vàng Macchiato',      45000, 'sen_vang.jpg',     'ly', 'Hạt sen tươi bùi béo kết hợp củ năng giòn và lớp milk foam béo ngậy.', 1),
(3, 'Trà Oolong Kem Cheese',       42000, 'oolong_cheese.jpg','ly', 'Vị trà Oolong thanh đậm cùng lớp phô mai Anchor mằn mặn khó cưỡng.', 1),
(3, 'Trà xoài Kem Cheese',         45000, 'xoai_cheese.jpg',  'ly', 'Xoài cát tươi xay nhuyễn ngọt thơm phủ lớp foam phô mai dày dặn.', 1),

-- === Sữa Tươi & Đá Xay (category_id = 4) ===
(4, 'Sữa tươi Trân châu đường đen',40000, 'suatuoi_dd.jpg',   'ly', 'Sữa tươi Dalat Milk thanh trùng béo ngậy và trân châu đường đen dẻo dai.', 1),
(4, 'Khoai môn Đá xay trân châu',  45000, 'khoaimon_ice.jpg', 'ly', 'Khoai môn xay mịn thơm nức cùng lớp whipping cream béo ngậy.', 1),
(4, 'Cookie Đá xay socola',        46000, 'cookie_ice.jpg',   'ly', 'Bánh Oreo nghiền cùng sốt socola Bỉ đậm vị mát lạnh.', 1),

-- === Cà Phê & Đồ Uống Khác (category_id = 5) ===
(5, 'Cà phê Muối béo',             29000, 'cf_muoi.jpg',      'ly', 'Cà phê phin truyền thống hòa quyện lớp kem muối mặn mà ngây ngất.', 1),
(5, 'Bạc xỉu 3 tầng',              29000, 'bac_xiu.jpg',      'ly', 'Sữa đặc, sữa tươi và cà phê thơm lừng tạo nên ly bạc xỉu chuẩn vị.', 1),
(5, 'Cacao Kem Trứng nướng',       39000, 'cacao_trung.jpg',  'ly', 'Cacao nguyên chất phủ lớp kem trứng béo ngậy được khò nhiệt thơm lừng.', 1);

-- =====================================================
-- 6. DỮ LIỆU TOPPINGS (8 loại Topping trà sữa)
-- =====================================================
INSERT INTO toppings (name, price, is_available) VALUES
('Trân châu đen đường đen',   6000, 1),
('Trân châu trắng 3Q giòn',   6000, 1),
('Thạch phô mai tươi viên',   9000, 1),
('Thạch củ năng giòn',        8000, 1),
('Pudding trứng caramen',     7000, 1),
('Kem phô mai muối biển',    10000, 1),
('Thạch sương sáo Đài Loan',  6000, 1),
('Hạt sen tươi rim đường',    8000, 1);

-- =====================================================
-- 7. DỮ LIỆU CUSTOMERS (5 khách hàng tích điểm)
-- =====================================================
INSERT INTO customers (name, phone, email, loyalty_points, member_tier) VALUES
('Lê Duy Kha',      '0901234567', 'leduykha@gmail.com',      350, 'gold'),
('Nguyễn Văn An',   '0912345678', 'nguyenvanan@gmail.com',   120, 'silver'),
('Trần Thị Mai',    '0987654321', 'maitran@gmail.com',        45, 'bronze'),
('Hoàng Thị Lan',   '0933221100', 'lanhoang@gmail.com',      150, 'silver'),
('Đỗ Quốc Tuấn',    '0977889900', 'tuando@gmail.com',         20, 'bronze');

-- =====================================================
-- 8. DỮ LIỆU INGREDIENTS (Kho nguyên liệu pha chế)
-- =====================================================
INSERT INTO ingredients (name, unit, quantity_in_stock, min_threshold, cost_price) VALUES
('Cốt trà Oolong Đài Loan',     'gam',  5000.00,  1000.00, 150),
('Cốt trà đen Assam',           'gam',  6500.00,  1000.00, 120),
('Trà lài hoa tươi',            'gam',  4000.00,   800.00, 140),
('Bột sữa béo New Zealand',     'gam', 12000.00,  2500.00, 110),
('Đường đen cô đặc Đài Loan',   'ml',   8000.00,  1500.00,  95),
('Sữa tươi Dalat Milk 1L',      'hộp',    45.00,    10.00, 32000),
('Trân châu đen sống Gia Thịnh','gam', 10000.00,  2000.00,  60),
('Siro đào Monin',              'ml',   3000.00,   500.00, 280),
('Kem phô mai Anchor',          'gam',  2500.00,   500.00, 220),
('Ly nhựa ép màng 500ml (Size M)','cái', 1500.00,  300.00, 500),
('Ly nhựa ép màng 700ml (Size L)','cái', 1200.00,  300.00, 650),
('Ống hút trân châu bọc màng',  'cái',  2500.00,   500.00, 150);

-- =====================================================
-- 9. DỮ LIỆU ORDERS (4 đơn hàng mẫu)
-- =====================================================

-- Đơn 1: Khách ngồi Bàn 01 - Lê Duy Kha (Hội viên Vàng - giảm 10%)
INSERT INTO orders (order_code, order_type, table_id, user_id, customer_id, customer_name, customer_phone, total_price, discount_percent, final_price, payment_method, payment_status, status, note) VALUES
('TS-20261127-0001', 'dine_in', 1, 3, 1, 'Lê Duy Kha', '0901234567', 100000, 10.00, 90000, 'vietqr', 'paid', 'preparing', 'Uống tại bàn, ly đậm trà');

-- Đơn 2: Mang đi (Take-away) - Nguyễn Văn An (Hội viên Bạc - giảm 5%)
INSERT INTO orders (order_code, order_type, table_id, user_id, customer_id, customer_name, customer_phone, total_price, discount_percent, final_price, payment_method, payment_status, status, note) VALUES
('TS-20261127-0002', 'take_away', NULL, 3, 2, 'Nguyễn Văn An', '0912345678', 35000, 5.00, 33250, 'cash', 'paid', 'ready', 'Mang đi ngay, tách đá riêng');

-- Đơn 3: Giao tận nơi (Delivery) - Trần Thị Mai
INSERT INTO orders (order_code, order_type, table_id, user_id, customer_id, customer_name, customer_phone, delivery_address, total_price, discount_percent, final_price, payment_method, payment_status, status, note) VALUES
('TS-20261127-0003', 'delivery', NULL, 4, 3, 'Trần Thị Mai', '0987654321', '123 Đường Nguyễn Trãi, Phường 2, Quận 5, TP.HCM', 84000, 0.00, 84000, 'momo', 'paid', 'pending', 'Giao trước 14h, bấm chuông giúp mình');

-- Đơn 4: Khách ngồi Bàn Sofa 04
INSERT INTO orders (order_code, order_type, table_id, user_id, customer_id, customer_name, customer_phone, total_price, discount_percent, final_price, payment_method, payment_status, status, note) VALUES
('TS-20261127-0004', 'dine_in', 4, 3, NULL, 'Khách vãng lai', '0938000111', 77000, 0.00, 77000, 'cash', 'unpaid', 'preparing', 'Bàn 4 người');

-- =====================================================
-- 10. DỮ LIỆU ORDER_DETAILS & TOPPINGS
-- =====================================================

-- Chi tiết Đơn 1:
-- 2 ly Trà sữa Trân châu đường đen (Size L, 50% đường, 70% đá)
INSERT INTO order_details (order_id, product_id, size, sugar_level, ice_level, quantity, unit_price, topping_total, subtotal, note, status) VALUES
(1, 1, 'L', '50%', '70%', 2, 41000, 9000, 100000, 'Đậm vị trà', 'brewing');

-- Topping cho ly đơn 1: Thạch phô mai tươi
INSERT INTO order_detail_toppings (order_detail_id, topping_id, price) VALUES
(1, 3, 9000);

-- Chi tiết Đơn 2:
-- 1 ly Trà đào cam sả (Size M, 70% đường, 100% đá)
INSERT INTO order_details (order_id, product_id, size, sugar_level, ice_level, quantity, unit_price, topping_total, subtotal, note, status) VALUES
(2, 6, 'M', '70%', '100%', 1, 35000, 0, 35000, 'Cho nhiều sả thơm', 'ready');

-- Chi tiết Đơn 3:
-- 2 ly Matcha Macchiato (Size M, 50% đường, 50% đá)
INSERT INTO order_details (order_id, product_id, size, sugar_level, ice_level, quantity, unit_price, topping_total, subtotal, note, status) VALUES
(3, 11, 'M', '50%', '50%', 2, 42000, 0, 84000, 'Lớp kem cheese để riêng', 'pending');

-- Chi tiết Đơn 4:
-- 1 ly Trà sữa Oolong nướng (Size M) + 1 ly Trà sen vàng (Size M)
INSERT INTO order_details (order_id, product_id, size, sugar_level, ice_level, quantity, unit_price, topping_total, subtotal, note, status) VALUES
(4, 2, 'M', '70%', '100%', 1, 38000, 0, 38000, NULL, 'brewing'),
(4, 12, 'M', '50%', '70%', 1, 45000, 0, 45000, NULL, 'pending');
