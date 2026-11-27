@echo off
chcp 65001 >nul
echo ========================================================
echo  HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA (MILK TEA STORE)
echo  Khởi động Microservices: Product Service & Order Service
echo ========================================================
start "Product Service - Menu Trà Sữa (8081)" cmd /k "cd /d %~dp0lab01-microservices\product-service && .\mvnw.cmd spring-boot:run"
timeout /t 5 /nobreak >nul
start "Order Service - Đơn Hàng Trà Sữa (8082)" cmd /k "cd /d %~dp0lab01-microservices\order-service && .\mvnw.cmd spring-boot:run"
echo Cả 2 services đang được khởi động trong các cửa sổ riêng biệt!
echo - Product Service: http://localhost:8081/api/products
echo - Order Service:   http://localhost:8082/api/orders
echo Sau khi khởi động xong, mở file index.html để trải nghiệm.
pause
