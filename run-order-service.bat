@echo off
title Order Service (Port 8082)
cd /d "%~dp0order-service"
echo Starting Order Service on http://localhost:8082 ...
call .\mvnw.cmd spring-boot:run
pause
