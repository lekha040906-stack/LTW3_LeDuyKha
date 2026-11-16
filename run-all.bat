@echo off
echo ========================================================
echo  Khoi dong Microservices: Product Service & Order Service
echo ========================================================
start "Product Service (8081)" cmd /k "cd /d %~dp0lab01-microservices\product-service && .\mvnw.cmd spring-boot:run"
timeout /t 5 /nobreak >nul
start "Order Service (8082)" cmd /k "cd /d %~dp0lab01-microservices\order-service && .\mvnw.cmd spring-boot:run"
echo Ca 2 services dang duoc khoi dong trong cac cua so rieng!
echo Sau khi ca 2 service khoi dong xong, hay mo file index.html de trai nghiem.
pause
