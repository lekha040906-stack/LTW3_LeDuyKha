@echo off
chcp 65001 >nul
echo ======================================================================
echo   HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA (MILK TEA STORE MICROSERVICES)
echo   Sinh viên: Lê Duy Kha - MSSV: 2124110074
echo ======================================================================

echo Khởi động Product Service (MySQL - Port 8081)...
start "Product Service (MySQL - 8081)" cmd /k "cd /d %~dp0backend\product-service && .\mvnw.cmd spring-boot:run"
timeout /t 5 /nobreak >nul

echo Khởi động Order Service (SQL Server - Port 8082)...
start "Order Service (SQL Server - 8082)" cmd /k "cd /d %~dp0backend\order-service && .\mvnw.cmd spring-boot:run"

echo.
echo ======================================================================
echo   CẢ 2 SERVICES ĐANG ĐƯỢC KHỞI ĐỘNG TRONG CÁC CỬA SỔ RIÊNG BIỆT!
echo   - Product Service (MySQL):      http://localhost:8081/api/products
echo   - Order Service   (SQL Server): http://localhost:8082/api/orders
echo.
echo   Mở file frontend/admin/index.html (Quản trị)
echo   hoặc frontend/client/index.html (Khách hàng đặt món) để trải nghiệm.
echo ======================================================================
pause
