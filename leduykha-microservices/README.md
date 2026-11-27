# HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA (MILK TEA STORE MICROSERVICES)

**Sinh viên thực hiện:** Lê Duy Kha  
**MSSV:** 2124110074  
**Môn học:** Lập trình Web 3 – Spring Boot & Microservices (Lab 02)  

---

## 1. Cấu Trúc Đồ Án (Project Structure)

```
leduykha-microservices/
├── backend/
│   ├── product-service/       # Port 8081 (MySQL): Quản lý thực đơn đồ uống trà sữa
│   └── order-service/         # Port 8082 (SQL Server): Tiếp nhận đơn hàng, chi tiết ly
├── frontend/
│   ├── admin/                 # Giao diện Quản trị viên, Quản lý quán, Barista pha chế
│   │   └── index.html
│   └── client/                # Giao diện Khách hàng đặt món trà sữa online / tại bàn
│       └── index.html
├── .gitignore                 # Bỏ qua target/, .idea/, .vscode/, .env, *.log
├── README.md                  # Hướng dẫn chi tiết kiến trúc đồ án
└── run-all.bat                # Kịch bản khởi chạy đồng thời cả 2 microservices
```

---

## 2. Thông Số Kỹ Thuật 2 Services Ban Đầu

| STT | Tên Service | Hệ Quản Trị CSDL | Port | Dependencies Chính |
|:---:|---|:---:|:---:|---|
| 1 | **product-service** | **MySQL** | `8081` | `Spring Web`, `Spring Data JPA`, `Validation`, `MySQL Driver` |
| 2 | **order-service** | **SQL Server** | `8082` | `Spring Web`, `Spring Data JPA`, `Validation`, `MS SQL Server Driver` |

---

## 3. Cấu Hình application.properties

* **Product Service (backend/product-service/src/main/resources/application.properties):**
  ```properties
  spring.application.name=product-service
  server.port=8081
  ```
* **Order Service (backend/order-service/src/main/resources/application.properties):**
  ```properties
  spring.application.name=order-service
  server.port=8082
  ```

---

## 4. Hướng Dẫn Khởi Chạy

1. Chạy file `run-all.bat` để bật đồng thời cả 2 services.
2. Hoặc mở terminal trong từng service và chạy:
   ```bash
   cd backend/product-service && ./mvnw.cmd spring-boot:run
   cd backend/order-service   && ./mvnw.cmd spring-boot:run
   ```
3. Mở `frontend/admin/index.html` hoặc `frontend/client/index.html` để trải nghiệm hệ thống.
