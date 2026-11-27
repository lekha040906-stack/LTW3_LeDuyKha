@echo off
chcp 65001 >nul
title Product Service - Menu Trà Sữa (Port 8081)
cd /d "%~dp0lab01-microservices\product-service"
echo ===================================================
echo  Khởi động Product Service (Quản lý Menu Trà Sữa)
echo  Địa chỉ: http://localhost:8081/api/products
echo ===================================================
call .\mvnw.cmd spring-boot:run
pause
