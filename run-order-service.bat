@echo off
chcp 65001 >nul
title Order Service - Đơn Hàng Trà Sữa (Port 8082)
cd /d "%~dp0lab01-microservices\order-service"
echo ===================================================
echo  Khởi động Order Service (Quản lý Đơn Hàng Trà Sữa)
echo  Địa chỉ: http://localhost:8082/api/orders
echo ===================================================
call .\mvnw.cmd spring-boot:run
pause
