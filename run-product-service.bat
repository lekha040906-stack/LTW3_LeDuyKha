@echo off
title Product Service (Port 8081)
cd /d "%~dp0product-service"
echo Starting Product Service on http://localhost:8081 ...
call .\mvnw.cmd spring-boot:run
pause
