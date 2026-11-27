-- =====================================================
-- HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA - MILK TEA STORE MANAGEMENT SYSTEM
-- File: 04_triggers.sql
-- Tác giả: Lê Duy Kha - MSSV: 2124110074
-- Mô tả: Các Triggers tự động hóa nghiệp vụ bán trà sữa & quầy Bar
-- =====================================================

USE milk_tea_management;

-- =====================================================
-- 1. TRIGGER: Tự động cập nhật tổng tiền đơn hàng khi THÊM ly nước mới
-- =====================================================
DROP TRIGGER IF EXISTS trg_after_insert_order_detail;
DELIMITER //
CREATE TRIGGER trg_after_insert_order_detail
AFTER INSERT ON order_details
FOR EACH ROW
BEGIN
    UPDATE orders 
    SET total_price = (
            SELECT COALESCE(SUM(subtotal), 0) 
            FROM order_details 
            WHERE order_id = NEW.order_id AND status != 'cancelled'
        ),
        final_price = (
            SELECT COALESCE(SUM(subtotal), 0) * (1 - COALESCE(discount_percent, 0) / 100)
            FROM order_details 
            WHERE order_id = NEW.order_id AND status != 'cancelled'
        )
    WHERE id = NEW.order_id;
END //
DELIMITER ;

-- =====================================================
-- 2. TRIGGER: Tự động cập nhật tổng tiền đơn hàng khi CẬP NHẬT ly nước
-- =====================================================
DROP TRIGGER IF EXISTS trg_after_update_order_detail;
DELIMITER //
CREATE TRIGGER trg_after_update_order_detail
AFTER UPDATE ON order_details
FOR EACH ROW
BEGIN
    IF OLD.subtotal != NEW.subtotal OR OLD.status != NEW.status THEN
        UPDATE orders 
        SET total_price = (
                SELECT COALESCE(SUM(subtotal), 0) 
                FROM order_details 
                WHERE order_id = NEW.order_id AND status != 'cancelled'
            ),
            final_price = (
                SELECT COALESCE(SUM(subtotal), 0) * (1 - COALESCE(discount_percent, 0) / 100)
                FROM order_details 
                WHERE order_id = NEW.order_id AND status != 'cancelled'
            )
        WHERE id = NEW.order_id;
    END IF;
END //
DELIMITER ;

-- =====================================================
-- 3. TRIGGER: Tự động cập nhật tổng tiền khi XÓA ly nước khỏi đơn
-- =====================================================
DROP TRIGGER IF EXISTS trg_after_delete_order_detail;
DELIMITER //
CREATE TRIGGER trg_after_delete_order_detail
AFTER DELETE ON order_details
FOR EACH ROW
BEGIN
    UPDATE orders 
    SET total_price = (
            SELECT COALESCE(SUM(subtotal), 0) 
            FROM order_details 
            WHERE order_id = OLD.order_id AND status != 'cancelled'
        ),
        final_price = (
            SELECT COALESCE(SUM(subtotal), 0) * (1 - COALESCE(discount_percent, 0) / 100)
            FROM order_details 
            WHERE order_id = OLD.order_id AND status != 'cancelled'
        )
    WHERE id = OLD.order_id;
END //
DELIMITER ;

-- =====================================================
-- 4. TRIGGER: Tự động tích lũy điểm hội viên khi hoàn thành đơn hàng
-- Quy tắc: 10.000 VNĐ = 1 điểm. Tự động nâng hạng Silver (>100 điểm), Gold (>300 điểm)
-- =====================================================
DROP TRIGGER IF EXISTS trg_after_order_completed;
DELIMITER //
CREATE TRIGGER trg_after_order_completed
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    DECLARE v_earned_points INT;
    
    IF NEW.status = 'completed' AND OLD.status != 'completed' AND NEW.customer_id IS NOT NULL THEN
        SET v_earned_points = FLOOR(NEW.final_price / 10000);
        
        UPDATE customers 
        SET loyalty_points = loyalty_points + v_earned_points,
            member_tier = CASE 
                WHEN (loyalty_points + v_earned_points) >= 300 THEN 'gold'
                WHEN (loyalty_points + v_earned_points) >= 100 THEN 'silver'
                ELSE 'bronze'
            END
        WHERE id = NEW.customer_id;
    END IF;
END //
DELIMITER ;

-- =====================================================
-- 5. TRIGGER: Cập nhật trạng thái bàn khi tạo hoặc hoàn thành đơn
-- =====================================================
DROP TRIGGER IF EXISTS trg_update_table_status;
DELIMITER //
CREATE TRIGGER trg_update_table_status
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.table_id IS NOT NULL THEN
        IF NEW.status IN ('completed', 'cancelled') THEN
            UPDATE tables SET status = 'empty' WHERE id = NEW.table_id;
        ELSEIF NEW.status IN ('pending', 'preparing', 'ready') THEN
            UPDATE tables SET status = 'serving' WHERE id = NEW.table_id;
        END IF;
    END IF;
END //
DELIMITER ;
