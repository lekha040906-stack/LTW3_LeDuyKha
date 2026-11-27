-- =====================================================
-- HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA - MILK TEA STORE MANAGEMENT SYSTEM
-- File: 01_create_database.sql
-- Tác giả: Lê Duy Kha - MSSV: 2124110074
-- Mô tả: Tạo Database và toàn bộ cấu trúc bảng cho hệ thống Quán Trà Sữa
-- =====================================================

DROP DATABASE IF EXISTS milk_tea_management;
CREATE DATABASE milk_tea_management 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;

USE milk_tea_management;

-- =====================================================
-- 1. BẢNG ROLES - Phân quyền vai trò nhân viên
-- =====================================================
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT 'Tên vai trò: admin, cashier, barista, waiter',
    description VARCHAR(255) NULL COMMENT 'Mô tả chi tiết quyền hạn',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB COMMENT='Bảng phân quyền vai trò nhân viên quán trà sữa';

-- =====================================================
-- 2. BẢNG USERS - Tài khoản nhân sự
-- =====================================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT 'Họ và tên nhân viên',
    email VARCHAR(150) NOT NULL UNIQUE COMMENT 'Email đăng nhập hệ thống',
    password VARCHAR(255) NOT NULL COMMENT 'Mật khẩu đã mã hóa bcrypt',
    phone VARCHAR(20) NULL COMMENT 'Số điện thoại liên hệ',
    avatar VARCHAR(255) NULL COMMENT 'Đường dẫn ảnh đại diện',
    role_id INT NOT NULL COMMENT 'FK tới bảng roles',
    status ENUM('active', 'inactive') DEFAULT 'active' COMMENT 'Trạng thái hoạt động',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_users_email (email),
    INDEX idx_users_role (role_id),
    INDEX idx_users_status (status),
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id) 
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='Bảng thông tin tài khoản nhân viên';

-- =====================================================
-- 3. BẢNG TABLES - Quản lý Bàn / Khu vực tại quán
-- =====================================================
CREATE TABLE tables (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL COMMENT 'Tên bàn: Bàn 01, Bàn Sofa 02, Mang đi...',
    area VARCHAR(50) DEFAULT 'Tầng trệt' COMMENT 'Khu vực: Tầng trệt, Lầu 1, Ban công, Take-away',
    capacity INT DEFAULT 4 COMMENT 'Số lượng chỗ ngồi',
    status ENUM('empty', 'serving', 'reserved') DEFAULT 'empty' COMMENT 'Trạng thái bàn',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_tables_status (status),
    INDEX idx_tables_area (area)
) ENGINE=InnoDB COMMENT='Bảng quản lý sơ đồ bàn và khu vực phục vụ';

-- =====================================================
-- 4. BẢNG CATEGORIES - Danh mục đồ uống trà sữa
-- =====================================================
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT 'Tên nhóm: Trà sữa, Trà trái cây, Macchiato, Đá xay...',
    icon VARCHAR(100) NULL COMMENT 'Icon hiển thị danh mục',
    display_order INT DEFAULT 0 COMMENT 'Thứ tự hiển thị',
    status ENUM('active', 'inactive') DEFAULT 'active' COMMENT 'Trạng thái danh mục',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB COMMENT='Bảng danh mục đồ uống';

-- =====================================================
-- 5. BẢNG PRODUCTS - Danh sách đồ uống trà sữa
-- =====================================================
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL COMMENT 'FK tới bảng categories',
    name VARCHAR(150) NOT NULL COMMENT 'Tên đồ uống',
    base_price DECIMAL(12, 0) NOT NULL DEFAULT 0 COMMENT 'Giá chuẩn (Size M) (VNĐ)',
    image VARCHAR(255) NULL COMMENT 'Hình ảnh đại diện món nước',
    unit VARCHAR(30) DEFAULT 'ly' COMMENT 'Đơn vị tính: ly, chai',
    description TEXT NULL COMMENT 'Mô tả hương vị đồ uống',
    is_available TINYINT(1) DEFAULT 1 COMMENT '1 = Còn bán, 0 = Tạm hết',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_products_category (category_id),
    INDEX idx_products_available (is_available),
    INDEX idx_products_name (name),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id) 
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='Bảng danh sách đồ uống trà sữa';

-- =====================================================
-- 6. BẢNG TOPPINGS - Danh mục các loại Topping thêm
-- =====================================================
CREATE TABLE toppings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT 'Tên topping: Trân châu đen, Thạch phô mai, Pudding...',
    price DECIMAL(12, 0) NOT NULL DEFAULT 0 COMMENT 'Giá bán thêm (VNĐ)',
    is_available TINYINT(1) DEFAULT 1 COMMENT '1 = Còn hàng, 0 = Hết hàng',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_toppings_available (is_available)
) ENGINE=InnoDB COMMENT='Bảng các loại topping cho trà sữa';

-- =====================================================
-- 7. BẢNG CUSTOMERS - Khách hàng thành viên & tích điểm
-- =====================================================
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT 'Họ tên khách hàng',
    phone VARCHAR(20) NOT NULL UNIQUE COMMENT 'Số điện thoại tích điểm',
    email VARCHAR(150) NULL COMMENT 'Email nhận khuyến mãi',
    loyalty_points INT DEFAULT 0 COMMENT 'Điểm thưởng tích lũy (10.000đ = 1 điểm)',
    member_tier ENUM('bronze', 'silver', 'gold') DEFAULT 'bronze' COMMENT 'Hạng hội viên: Đồng, Bạc, Vàng',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_customers_phone (phone),
    INDEX idx_customers_tier (member_tier)
) ENGINE=InnoDB COMMENT='Bảng quản lý khách hàng thân thiết & tích điểm';

-- =====================================================
-- 8. BẢNG ORDERS - Hóa đơn / Đơn gọi món trà sữa
-- =====================================================
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_code VARCHAR(50) NOT NULL UNIQUE COMMENT 'Mã đơn hàng: TS-20261127-001',
    order_type ENUM('dine_in', 'take_away', 'delivery') DEFAULT 'take_away' COMMENT 'Hình thức đơn: Tại bàn, Mang đi, Giao hàng',
    table_id INT NULL COMMENT 'FK tới bảng tables (nếu dùng tại bàn)',
    user_id INT NOT NULL COMMENT 'FK tới bảng users - Nhân viên tạo đơn',
    customer_id INT NULL COMMENT 'FK tới bảng customers (nếu khách tích điểm)',
    customer_name VARCHAR(100) NULL COMMENT 'Tên người nhận (đặc biệt khi giao tận nơi)',
    customer_phone VARCHAR(20) NULL COMMENT 'Số điện thoại người nhận',
    delivery_address TEXT NULL COMMENT 'Địa chỉ giao hàng',
    total_price DECIMAL(12, 0) DEFAULT 0 COMMENT 'Tổng tiền hàng gốc (VNĐ)',
    discount_percent DECIMAL(5, 2) DEFAULT 0.00 COMMENT 'Giảm giá theo %',
    final_price DECIMAL(12, 0) DEFAULT 0 COMMENT 'Số tiền thực thu sau giảm giá (VNĐ)',
    payment_method ENUM('cash', 'vietqr', 'momo', 'vnpay') DEFAULT 'cash' COMMENT 'Hình thức thanh toán',
    payment_status ENUM('unpaid', 'paid', 'refunded') DEFAULT 'unpaid' COMMENT 'Trạng thái thanh toán',
    status ENUM('pending', 'preparing', 'ready', 'completed', 'cancelled') DEFAULT 'pending' 
        COMMENT 'Tiến trình đơn: Chờ xử lý, Đang pha, Đã pha xong, Hoàn thành, Hủy',
    note TEXT NULL COMMENT 'Ghi chú chung cho đơn',
    completed_at TIMESTAMP NULL COMMENT 'Thời điểm hoàn tất giao hàng/thanh toán',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_orders_code (order_code),
    INDEX idx_orders_status (status),
    INDEX idx_orders_user (user_id),
    INDEX idx_orders_created (created_at),
    CONSTRAINT fk_orders_table FOREIGN KEY (table_id) REFERENCES tables(id) 
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(id) 
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Bảng hóa đơn bán hàng trà sữa';

-- =====================================================
-- 9. BẢNG ORDER_DETAILS - Chi tiết từng ly trà sữa trong đơn
-- =====================================================
CREATE TABLE order_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL COMMENT 'FK tới bảng orders',
    product_id INT NOT NULL COMMENT 'FK tới bảng products',
    size ENUM('M', 'L') DEFAULT 'M' COMMENT 'Kích cỡ ly',
    sugar_level VARCHAR(10) DEFAULT '100%' COMMENT 'Mức đường: 0%, 30%, 50%, 70%, 100%',
    ice_level VARCHAR(10) DEFAULT '100%' COMMENT 'Mức đá: Không đá, 50% đá, 100% đá',
    quantity INT NOT NULL DEFAULT 1 COMMENT 'Số lượng ly',
    unit_price DECIMAL(12, 0) NOT NULL COMMENT 'Đơn giá đồ uống theo size (VNĐ)',
    topping_total DECIMAL(12, 0) DEFAULT 0 COMMENT 'Tổng tiền các topping của ly này (VNĐ)',
    subtotal DECIMAL(12, 0) NOT NULL COMMENT 'Thành tiền = (unit_price + topping_total) * quantity',
    note VARCHAR(255) NULL COMMENT 'Ghi chú riêng cho ly (vd: trà đậm, ít béo)',
    status ENUM('pending', 'brewing', 'ready', 'cancelled') DEFAULT 'pending' COMMENT 'Trạng thái pha chế quầy bar',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_od_order (order_id),
    INDEX idx_od_product (product_id),
    INDEX idx_od_status (status),
    CONSTRAINT fk_od_order FOREIGN KEY (order_id) REFERENCES orders(id) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_od_product FOREIGN KEY (product_id) REFERENCES products(id) 
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='Bảng chi tiết từng ly trà sữa kèm tùy chọn đường đá';

-- =====================================================
-- 10. BẢNG ORDER_DETAIL_TOPPINGS - Liên kết Topping cho từng ly
-- =====================================================
CREATE TABLE order_detail_toppings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_detail_id INT NOT NULL COMMENT 'FK tới bảng order_details',
    topping_id INT NOT NULL COMMENT 'FK tới bảng toppings',
    price DECIMAL(12, 0) NOT NULL COMMENT 'Đơn giá topping thời điểm mua',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_odt_detail (order_detail_id),
    INDEX idx_odt_topping (topping_id),
    CONSTRAINT fk_odt_detail FOREIGN KEY (order_detail_id) REFERENCES order_details(id) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_odt_topping FOREIGN KEY (topping_id) REFERENCES toppings(id) 
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='Bảng lưu các loại topping được thêm vào từng ly trà sữa';

-- =====================================================
-- 11. BẢNG INGREDIENTS - Kho nguyên vật liệu pha chế
-- =====================================================
CREATE TABLE ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT 'Tên nguyên vật liệu: Trà đen, Sữa béo, Đường đen...',
    unit VARCHAR(30) NOT NULL COMMENT 'Đơn vị tính: gam, ml, ly, cái, hộp',
    quantity_in_stock DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT 'Số lượng tồn kho',
    min_threshold DECIMAL(10, 2) NOT NULL DEFAULT 10.00 COMMENT 'Ngưỡng cảnh báo sắp hết hàng',
    cost_price DECIMAL(12, 0) DEFAULT 0 COMMENT 'Giá vốn nhập hàng',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_ingredients_stock (quantity_in_stock)
) ENGINE=InnoDB COMMENT='Bảng quản lý kho nguyên vật liệu pha chế quán trà sữa';
