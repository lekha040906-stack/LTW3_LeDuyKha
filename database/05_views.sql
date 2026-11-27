-- =====================================================
-- HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA - MILK TEA STORE MANAGEMENT SYSTEM
-- File: 05_views.sql
-- Tác giả: Lê Duy Kha - MSSV: 2124110074
-- Mô tả: Các Views phục vụ màn hình Quầy Bar, Thu ngân & Báo cáo quản lý
-- =====================================================

USE milk_tea_management;

-- =====================================================
-- 1. VIEW: Danh sách nhân sự quán trà sữa kèm vai trò
-- =====================================================
DROP VIEW IF EXISTS v_users_with_roles;
CREATE VIEW v_users_with_roles AS
SELECT 
    u.id,
    u.name,
    u.email,
    u.phone,
    u.avatar,
    u.status,
    u.role_id,
    r.name AS role_name,
    r.description AS role_description,
    u.created_at
FROM users u
INNER JOIN roles r ON u.role_id = r.id;

-- =====================================================
-- 2. VIEW: Thực đơn trà sữa hoàn chỉnh (đồ uống + danh mục)
-- =====================================================
DROP VIEW IF EXISTS v_menu_full;
CREATE VIEW v_menu_full AS
SELECT 
    p.id AS product_id,
    p.name AS product_name,
    p.base_price,
    p.image,
    p.unit,
    p.description,
    p.is_available,
    p.category_id,
    c.name AS category_name,
    c.icon AS category_icon
FROM products p
INNER JOIN categories c ON p.category_id = c.id
WHERE c.status = 'active';

-- =====================================================
-- 3. VIEW: Màn hình quầy Bar (Kitchen Display System - KDS)
-- Hiển thị danh sách các ly trà sữa cần pha chế theo thứ tự đơn hàng
-- =====================================================
DROP VIEW IF EXISTS v_barista_kds;
CREATE VIEW v_barista_kds AS
SELECT 
    od.id AS item_id,
    o.order_code,
    o.order_type,
    t.name AS table_name,
    p.name AS drink_name,
    od.size,
    od.sugar_level,
    od.ice_level,
    od.quantity,
    od.note AS item_note,
    od.status AS brew_status,
    od.created_at AS order_time,
    GROUP_CONCAT(tp.name SEPARATOR ', ') AS toppings_list
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN products p ON od.product_id = p.id
LEFT JOIN tables t ON o.table_id = t.id
LEFT JOIN order_detail_toppings odt ON od.id = odt.order_detail_id
LEFT JOIN toppings tp ON odt.topping_id = tp.id
WHERE od.status IN ('pending', 'brewing')
GROUP BY od.id, o.order_code, o.order_type, t.name, p.name, od.size, od.sugar_level, od.ice_level, od.quantity, od.note, od.status, od.created_at
ORDER BY od.created_at ASC;

-- =====================================================
-- 4. VIEW: Sơ đồ bàn trà sữa và hóa đơn đang phục vụ
-- =====================================================
DROP VIEW IF EXISTS v_table_overview;
CREATE VIEW v_table_overview AS
SELECT 
    t.id AS table_id,
    t.name AS table_name,
    t.area,
    t.capacity,
    t.status AS table_status,
    o.id AS current_order_id,
    o.order_code,
    o.final_price,
    o.created_at AS seated_at
FROM tables t
LEFT JOIN orders o ON t.id = o.table_id AND o.status IN ('pending', 'preparing', 'ready');

-- =====================================================
-- 5. VIEW: Top đồ uống trà sữa bán chạy nhất (Best-Seller)
-- =====================================================
DROP VIEW IF EXISTS v_best_seller_drinks;
CREATE VIEW v_best_seller_drinks AS
SELECT 
    p.id AS product_id,
    p.name AS drink_name,
    c.name AS category_name,
    p.base_price,
    SUM(od.quantity) AS total_sold,
    SUM(od.subtotal) AS total_revenue
FROM order_details od
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories c ON p.category_id = c.id
INNER JOIN orders o ON od.order_id = o.id
WHERE o.status = 'completed' AND od.status != 'cancelled'
GROUP BY p.id, p.name, c.name, p.base_price
ORDER BY total_sold DESC;

-- =====================================================
-- 6. VIEW: Cảnh báo tồn kho nguyên vật liệu pha chế
-- =====================================================
DROP VIEW IF EXISTS v_inventory_alerts;
CREATE VIEW v_inventory_alerts AS
SELECT 
    id,
    name AS ingredient_name,
    unit,
    quantity_in_stock,
    min_threshold,
    CASE 
        WHEN quantity_in_stock <= 0 THEN 'HẾT HÀNG'
        WHEN quantity_in_stock <= min_threshold THEN 'SẮP HẾT'
        ELSE 'ĐỦ HÀNG'
    END AS stock_status
FROM ingredients
WHERE quantity_in_stock <= min_threshold;

-- =====================================================
-- 7. VIEW: Thống kê khách hàng thân thiết & xếp hạng hội viên
-- =====================================================
DROP VIEW IF EXISTS v_customer_loyalty_summary;
CREATE VIEW v_customer_loyalty_summary AS
SELECT 
    c.id,
    c.name,
    c.phone,
    c.member_tier,
    c.loyalty_points,
    COUNT(o.id) AS total_orders,
    COALESCE(SUM(o.final_price), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id AND o.status = 'completed'
GROUP BY c.id, c.name, c.phone, c.member_tier, c.loyalty_points
ORDER BY total_spent DESC;
