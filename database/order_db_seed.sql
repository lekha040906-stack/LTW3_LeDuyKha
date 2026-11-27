-- ====================================================================
-- HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA (MILK TEA STORE)
-- Database Seed: Order Service (Microsoft SQL Server - order_db)
-- Sinh viên: Lê Duy Kha - MSSV: 2124110074
-- ====================================================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'order_db')
BEGIN
    CREATE DATABASE order_db;
END
GO

USE order_db;
GO

-- 1. BẢNG ORDERS (5 đơn hàng mẫu)
SET IDENTITY_INSERT orders ON;
INSERT INTO orders (id, order_code, customer_name, phone, order_type, total_amount, payment_method, status, note, created_at) VALUES
(1, 'ORDER-TRA-SUA-001', N'Lê Duy Kha', '0901234567', N'Mang đi (Takeaway)', 90000.00, N'Tiền mặt', N'Đang pha chế (Preparing)', N'Giao trước 14h, tách đá riêng', GETDATE()),
(2, 'ORDER-TRA-SUA-002', N'Nguyễn Văn An', '0912345678', N'Tại bàn 03 (Dine-in)', 32000.00, N'Chuyển khoản VietQR', N'Đã hoàn thành (Completed)', N'Cho nhiều sả thơm', GETDATE()),
(3, 'ORDER-TRA-SUA-003', N'Trần Thị Mai', '0988776655', N'Giao hàng (Delivery)', 118000.00, N'Tiền mặt', N'Đang giao (Delivering)', N'Giao hẻm 120 Kha Vạn Cân', GETDATE()),
(4, 'ORDER-TRA-SUA-004', N'Phạm Hoàng Nam', '0933221100', N'Mang đi (Takeaway)', 42000.00, N'MoMo', N'Đang pha chế (Preparing)', N'Ít đá 30%, ngọt 50%', GETDATE()),
(5, 'ORDER-TRA-SUA-005', N'Võ Mỹ Linh', '0977889900', N'Tại bàn 05 (Dine-in)', 65000.00, N'Tiền mặt', N'Mới tiếp nhận (Pending)', N'Uống tại chỗ', GETDATE());
SET IDENTITY_INSERT orders OFF;
GO

-- 2. BẢNG ORDER_ITEMS (Chi tiết các món trong đơn hàng)
SET IDENTITY_INSERT order_items ON;
INSERT INTO order_items (id, product_id, product_name, quantity, price, subtotal, size, sugar, ice, toppings, note, order_id) VALUES
(1, 1, N'Trà sữa Trân châu đường đen', 2, 45000.00, 90000.00, 'L', '50%', '70%', N'Trân châu đen đường đen, Thạch phô mai', N'Tách đá riêng', 1),
(2, 2, N'Trà đào cam sả', 1, 32000.00, 32000.00, 'M', '70%', '100%', N'Đào miếng giòn', N'Cho nhiều sả thơm', 2),
(3, 3, N'Trà sữa Oolong nướng', 2, 38000.00, 76000.00, 'M', '30%', '50%', N'Trân châu hoàng kim', N'Giao nhanh', 3),
(4, 4, N'Matcha Macchiato', 1, 42000.00, 42000.00, 'M', '50%', '50%', N'Kem cheese thêm', N'Ít ngọt', 3),
(5, 4, N'Matcha Macchiato', 1, 42000.00, 42000.00, 'M', '30%', '30%', N'Kem phô mai', N'Ít đá', 4),
(6, 5, N'Trà lài đác thơm', 1, 35000.00, 35000.00, 'M', '50%', '50%', N'Hạt đác rim', N'Nhiều đác', 5),
(7, 12, N'Bạc xỉu ba tầng cốt dừa', 1, 30000.00, 30000.00, 'M', '100%', '70%', N'Không topping', N'Thơm béo', 5);
SET IDENTITY_INSERT order_items OFF;
GO

-- 3. BẢNG CARTS (2 giỏ hàng mẫu)
SET IDENTITY_INSERT carts ON;
INSERT INTO carts (id, customer_id, total_amount, updated_at) VALUES
(1, 'CUST-001', 77000.00, GETDATE()),
(2, 'CUST-002', 35000.00, GETDATE());
SET IDENTITY_INSERT carts OFF;
GO

-- 4. BẢNG CART_ITEMS (Chi tiết giỏ hàng)
SET IDENTITY_INSERT cart_items ON;
INSERT INTO cart_items (id, product_id, product_name, quantity, price, size, sugar, ice, toppings, cart_id) VALUES
(1, 1, N'Trà sữa Trân châu đường đen', 1, 35000.00, 'M', '50%', '50%', N'Trân châu đen', 1),
(2, 4, N'Matcha Macchiato', 1, 42000.00, 'M', '50%', '70%', N'Kem cheese', 1),
(3, 5, N'Trà lài đác thơm', 1, 35000.00, 'M', '70%', '100%', N'Hạt đác rim', 2);
SET IDENTITY_INSERT cart_items OFF;
GO
