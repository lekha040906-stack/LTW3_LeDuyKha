-- =====================================================
-- HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA - MILK TEA STORE MANAGEMENT SYSTEM
-- File: 03_functions.sql
-- Tác giả: Lê Duy Kha - MSSV: 2124110074
-- Mô tả: Các MySQL Functions hỗ trợ tính toán & nghiệp vụ quán trà sữa
-- =====================================================

USE milk_tea_management;

-- =====================================================
-- 1. Tính tổng tiền đơn hàng (trước giảm giá)
-- =====================================================
DROP FUNCTION IF EXISTS fn_calc_order_subtotal;
DELIMITER //
CREATE FUNCTION fn_calc_order_subtotal(p_order_id INT)
RETURNS DECIMAL(12, 0)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_subtotal DECIMAL(12, 0);
    
    SELECT COALESCE(SUM(subtotal), 0)
    INTO v_subtotal
    FROM order_details
    WHERE order_id = p_order_id AND status != 'cancelled';
    
    RETURN v_subtotal;
END //
DELIMITER ;

-- =====================================================
-- 2. Tính tiền thực thu của đơn hàng (sau khi trừ % giảm giá)
-- =====================================================
DROP FUNCTION IF EXISTS fn_calc_order_final;
DELIMITER //
CREATE FUNCTION fn_calc_order_final(p_order_id INT)
RETURNS DECIMAL(12, 0)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_subtotal DECIMAL(12, 0);
    DECLARE v_discount DECIMAL(5, 2);
    
    SELECT COALESCE(SUM(subtotal), 0)
    INTO v_subtotal
    FROM order_details
    WHERE order_id = p_order_id AND status != 'cancelled';
    
    SELECT COALESCE(discount_percent, 0) INTO v_discount
    FROM orders WHERE id = p_order_id;
    
    RETURN v_subtotal - (v_subtotal * v_discount / 100);
END //
DELIMITER ;

-- =====================================================
-- 3. Tính tỷ lệ chiết khấu theo hạng hội viên khách hàng
-- =====================================================
DROP FUNCTION IF EXISTS fn_get_customer_discount;
DELIMITER //
CREATE FUNCTION fn_get_customer_discount(p_customer_id INT)
RETURNS DECIMAL(5, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_tier VARCHAR(20);
    
    IF p_customer_id IS NULL THEN
        RETURN 0.00;
    END IF;
    
    SELECT member_tier INTO v_tier FROM customers WHERE id = p_customer_id;
    
    IF v_tier = 'gold' THEN
        RETURN 10.00; -- Hạng Vàng: giảm 10%
    ELSEIF v_tier = 'silver' THEN
        RETURN 5.00;  -- Hạng Bạc: giảm 5%
    ELSE
        RETURN 0.00;  -- Hạng Đồng: 0%
    END IF;
END //
DELIMITER ;

-- =====================================================
-- 4. Đếm số ly trà sữa đang chờ quầy Bar pha chế của 1 đơn hàng
-- =====================================================
DROP FUNCTION IF EXISTS fn_count_pending_drinks;
DELIMITER //
CREATE FUNCTION fn_count_pending_drinks(p_order_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*)
    INTO v_count
    FROM order_details
    WHERE order_id = p_order_id AND status IN ('pending', 'brewing');
    
    RETURN v_count;
END //
DELIMITER ;

-- =====================================================
-- 5. Kiểm tra cảnh báo nguyên vật liệu pha chế sắp hết
-- =====================================================
DROP FUNCTION IF EXISTS fn_check_low_stock;
DELIMITER //
CREATE FUNCTION fn_check_low_stock(p_ingredient_id INT)
RETURNS TINYINT(1)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_stock DECIMAL(10, 2);
    DECLARE v_min DECIMAL(10, 2);
    
    SELECT quantity_in_stock, min_threshold
    INTO v_stock, v_min
    FROM ingredients
    WHERE id = p_ingredient_id;
    
    IF v_stock <= v_min THEN
        RETURN 1; -- Cảnh báo sắp hết
    ELSE
        RETURN 0; -- Đủ hàng
    END IF;
END //
DELIMITER ;
