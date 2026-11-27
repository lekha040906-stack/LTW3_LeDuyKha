-- =====================================================
-- HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA - MILK TEA STORE MANAGEMENT SYSTEM
-- File: 02_stored_procedures.sql
-- Tác giả: Lê Duy Kha - MSSV: 2124110074
-- Mô tả: Các Stored Procedures cho nghiệp vụ Quán Trà Sữa
-- =====================================================

USE milk_tea_management;

-- =====================================================
-- A. MODULE USERS & NHÂN SỰ
-- =====================================================

-- 1. Lấy danh sách nhân viên
DROP PROCEDURE IF EXISTS sp_get_users;
DELIMITER //
CREATE PROCEDURE sp_get_users(
    IN p_page INT,
    IN p_limit INT,
    IN p_search VARCHAR(100)
)
BEGIN
    DECLARE v_offset INT;
    SET v_offset = (p_page - 1) * p_limit;
    
    SELECT 
        u.id, u.name, u.email, u.phone, u.avatar, u.status,
        r.name AS role_name, r.description AS role_description,
        u.created_at
    FROM users u
    INNER JOIN roles r ON u.role_id = r.id
    WHERE (p_search IS NULL 
           OR u.name LIKE CONCAT('%', p_search, '%') 
           OR u.email LIKE CONCAT('%', p_search, '%'))
    ORDER BY u.created_at DESC
    LIMIT v_offset, p_limit;
    
    SELECT COUNT(*) AS total_records
    FROM users u
    WHERE (p_search IS NULL 
           OR u.name LIKE CONCAT('%', p_search, '%') 
           OR u.email LIKE CONCAT('%', p_search, '%'));
END //
DELIMITER ;

-- 2. Lấy thông tin 1 nhân viên theo ID
DROP PROCEDURE IF EXISTS sp_get_user_by_id;
DELIMITER //
CREATE PROCEDURE sp_get_user_by_id(IN p_user_id INT)
BEGIN
    SELECT 
        u.id, u.name, u.email, u.phone, u.avatar, u.status, u.role_id,
        r.name AS role_name, u.created_at, u.updated_at
    FROM users u
    INNER JOIN roles r ON u.role_id = r.id
    WHERE u.id = p_user_id;
END //
DELIMITER ;

-- =====================================================
-- B. MODULE MENU & ĐỒ UỐNG TRÀ SỮA
-- =====================================================

-- 3. Lấy thực đơn trà sữa (theo danh mục hoặc từ khóa tìm kiếm)
DROP PROCEDURE IF EXISTS sp_get_menu;
DELIMITER //
CREATE PROCEDURE sp_get_menu(
    IN p_category_id INT,
    IN p_search VARCHAR(100)
)
BEGIN
    SELECT 
        p.id, p.name, p.base_price, p.image, p.unit, p.description, p.is_available,
        c.id AS category_id, c.name AS category_name, c.icon AS category_icon
    FROM products p
    INNER JOIN categories c ON p.category_id = c.id
    WHERE (p_category_id IS NULL OR p.category_id = p_category_id)
      AND (p_search IS NULL OR p.name LIKE CONCAT('%', p_search, '%'))
      AND c.status = 'active'
    ORDER BY c.display_order ASC, p.id ASC;
END //
DELIMITER ;

-- 4. Lấy danh sách Topping còn phục vụ
DROP PROCEDURE IF EXISTS sp_get_toppings;
DELIMITER //
CREATE PROCEDURE sp_get_toppings()
BEGIN
    SELECT id, name, price, is_available
    FROM toppings
    WHERE is_available = 1
    ORDER BY price ASC;
END //
DELIMITER ;

-- =====================================================
-- C. MODULE ORDERS & QUẦY BAR (KITCHEN DISPLAY)
-- =====================================================

-- 5. Tạo đơn hàng trà sữa mới
DROP PROCEDURE IF EXISTS sp_create_order;
DELIMITER //
CREATE PROCEDURE sp_create_order(
    IN p_order_type ENUM('dine_in', 'take_away', 'delivery'),
    IN p_table_id INT,
    IN p_user_id INT,
    IN p_customer_phone VARCHAR(20),
    IN p_customer_name VARCHAR(100),
    IN p_delivery_address TEXT,
    IN p_note TEXT,
    OUT p_order_id INT,
    OUT p_order_code VARCHAR(50)
)
BEGIN
    DECLARE v_customer_id INT DEFAULT NULL;
    DECLARE v_discount DECIMAL(5, 2) DEFAULT 0.00;
    DECLARE v_seq INT;
    
    -- Kiểm tra khách hàng theo SĐT để áp dụng giảm giá hội viên
    IF p_customer_phone IS NOT NULL AND p_customer_phone != '' THEN
        SELECT id, 
               CASE 
                   WHEN member_tier = 'gold' THEN 10.00
                   WHEN member_tier = 'silver' THEN 5.00
                   ELSE 0.00
               END
        INTO v_customer_id, v_discount
        FROM customers
        WHERE phone = p_customer_phone
        LIMIT 1;
    END IF;
    
    -- Sinh mã đơn tự động TS-YYYYMMDD-XXXX
    SELECT COUNT(*) + 1 INTO v_seq 
    FROM orders 
    WHERE DATE(created_at) = CURDATE();
    
    SET p_order_code = CONCAT('TS-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(v_seq, 4, '0'));
    
    INSERT INTO orders (
        order_code, order_type, table_id, user_id, customer_id,
        customer_name, customer_phone, delivery_address,
        discount_percent, note, status, payment_status
    ) VALUES (
        p_order_code, p_order_type, p_table_id, p_user_id, v_customer_id,
        p_customer_name, p_customer_phone, p_delivery_address,
        v_discount, p_note, 'pending', 'unpaid'
    );
    
    SET p_order_id = LAST_INSERT_ID();
    
    -- Nếu ngồi tại bàn, cập nhật trạng thái bàn
    IF p_table_id IS NOT NULL THEN
        UPDATE tables SET status = 'serving' WHERE id = p_table_id;
    END IF;
END //
DELIMITER ;

-- 6. Thêm ly trà sữa vào đơn hàng (chọn Size, Đường, Đá, Ghi chú)
DROP PROCEDURE IF EXISTS sp_add_drink_to_order;
DELIMITER //
CREATE PROCEDURE sp_add_drink_to_order(
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_size ENUM('M', 'L'),
    IN p_sugar VARCHAR(10),
    IN p_ice VARCHAR(10),
    IN p_quantity INT,
    IN p_note VARCHAR(255),
    OUT p_detail_id INT
)
BEGIN
    DECLARE v_base_price DECIMAL(12, 0);
    DECLARE v_unit_price DECIMAL(12, 0);
    DECLARE v_subtotal DECIMAL(12, 0);
    
    SELECT base_price INTO v_base_price FROM products WHERE id = p_product_id;
    
    -- Size L cộng thêm 6.000đ
    IF p_size = 'L' THEN
        SET v_unit_price = v_base_price + 6000;
    ELSE
        SET v_unit_price = v_base_price;
    END IF;
    
    SET v_subtotal = v_unit_price * p_quantity;
    
    INSERT INTO order_details (
        order_id, product_id, size, sugar_level, ice_level,
        quantity, unit_price, topping_total, subtotal, note, status
    ) VALUES (
        p_order_id, p_product_id, p_size, p_sugar, p_ice,
        p_quantity, v_unit_price, 0, v_subtotal, p_note, 'pending'
    );
    
    SET p_detail_id = LAST_INSERT_ID();
END //
DELIMITER ;

-- 7. Thêm Topping vào ly trà sữa
DROP PROCEDURE IF EXISTS sp_add_topping_to_drink;
DELIMITER //
CREATE PROCEDURE sp_add_topping_to_drink(
    IN p_detail_id INT,
    IN p_topping_id INT
)
BEGIN
    DECLARE v_topping_price DECIMAL(12, 0);
    DECLARE v_quantity INT;
    DECLARE v_unit_price DECIMAL(12, 0);
    
    SELECT price INTO v_topping_price FROM toppings WHERE id = p_topping_id;
    
    INSERT INTO order_detail_toppings (order_detail_id, topping_id, price)
    VALUES (p_detail_id, p_topping_id, v_topping_price);
    
    -- Cập nhật lại topping_total và subtotal của ly trà sữa
    SELECT quantity, unit_price INTO v_quantity, v_unit_price
    FROM order_details WHERE id = p_detail_id;
    
    UPDATE order_details 
    SET topping_total = (
            SELECT COALESCE(SUM(price), 0)
            FROM order_detail_toppings
            WHERE order_detail_id = p_detail_id
        ),
        subtotal = (v_unit_price + (
            SELECT COALESCE(SUM(price), 0)
            FROM order_detail_toppings
            WHERE order_detail_id = p_detail_id
        )) * v_quantity
    WHERE id = p_detail_id;
END //
DELIMITER ;

-- 8. Barista cập nhật tiến trình pha chế (Pending -> Brewing -> Ready)
DROP PROCEDURE IF EXISTS sp_update_brew_status;
DELIMITER //
CREATE PROCEDURE sp_update_brew_status(
    IN p_detail_id INT,
    IN p_new_status ENUM('pending', 'brewing', 'ready', 'cancelled')
)
BEGIN
    DECLARE v_order_id INT;
    DECLARE v_pending_count INT;
    
    UPDATE order_details 
    SET status = p_new_status
    WHERE id = p_detail_id;
    
    SELECT order_id INTO v_order_id FROM order_details WHERE id = p_detail_id;
    
    -- Nếu toàn bộ các ly trong đơn đã 'ready', cập nhật trạng thái đơn sang 'ready'
    SELECT COUNT(*) INTO v_pending_count
    FROM order_details
    WHERE order_id = v_order_id AND status IN ('pending', 'brewing');
    
    IF v_pending_count = 0 THEN
        UPDATE orders SET status = 'ready' WHERE id = v_order_id;
    ELSE
        UPDATE orders SET status = 'preparing' WHERE id = v_order_id;
    END IF;
END //
DELIMITER ;

-- 9. Thu ngân xác nhận thanh toán đơn hàng trà sữa
DROP PROCEDURE IF EXISTS sp_complete_payment;
DELIMITER //
CREATE PROCEDURE sp_complete_payment(
    IN p_order_id INT,
    IN p_payment_method ENUM('cash', 'vietqr', 'momo', 'vnpay')
)
BEGIN
    UPDATE orders 
    SET payment_method = p_payment_method,
        payment_status = 'paid',
        status = 'completed',
        completed_at = NOW()
    WHERE id = p_order_id;
END //
DELIMITER ;

-- =====================================================
-- D. MODULE BÁO CÁO DOANH THU & KHO
-- =====================================================

-- 10. Báo cáo doanh thu bán trà sữa theo ngày
DROP PROCEDURE IF EXISTS sp_report_daily_revenue;
DELIMITER //
CREATE PROCEDURE sp_report_daily_revenue(IN p_report_date DATE)
BEGIN
    SELECT 
        COUNT(id) AS total_orders,
        COALESCE(SUM(total_price), 0) AS gross_sales,
        COALESCE(SUM(final_price), 0) AS net_revenue,
        SUM(CASE WHEN payment_method = 'cash' THEN final_price ELSE 0 END) AS cash_revenue,
        SUM(CASE WHEN payment_method = 'vietqr' THEN final_price ELSE 0 END) AS vietqr_revenue,
        SUM(CASE WHEN payment_method = 'momo' THEN final_price ELSE 0 END) AS momo_revenue,
        SUM(CASE WHEN payment_method = 'vnpay' THEN final_price ELSE 0 END) AS vnpay_revenue
    FROM orders
    WHERE DATE(completed_at) = p_report_date AND status = 'completed';
END //
DELIMITER ;
