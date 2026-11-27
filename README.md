# Hệ Thống Quản Lý Quán Trà Sữa (Milk Tea Store Management System)

**Môn học:** Lập trình Web 3 – Spring Boot & Microservices  
**Sinh viên thực hiện:** Lê Duy Kha  
**MSSV:** 2124110074  

---

## 📌 Giới Thiệu Đề Tài

Hệ thống Quản lý Quán Trà Sữa (Milk Tea Store Management System) được xây dựng theo kiến trúc **Spring Boot Microservices**, đáp ứng quy trình vận hành toàn diện cho một chuỗi/quán trà sữa hiện đại:
- **Product / Menu Service (Port 8081):** Quản lý thực đơn đồ uống trà sữa phong phú (Trà sữa trân châu đường đen, Trà đào cam sả, Trà sữa Oolong nướng, Matcha Macchiato...), phân loại kích cỡ (Size M, Size L), danh sách Topping và giá bán.
- **Order Service (Port 8082):** Tiếp nhận đơn hàng, quản lý chi tiết từng ly nước với mức tùy chỉnh chuyên sâu (% đường, % đá, các loại Topping thêm, ghi chú riêng), giao tiếp liên dịch vụ với Product Service qua `RestClient`.
- **Cơ sở dữ liệu MySQL (`milk_tea_management`):** CSDL hoàn chỉnh gồm Tables, Stored Procedures, Functions, Triggers, Views và Seed Data cho quầy Bar (KDS), Thu ngân và Khách hàng tích điểm.

---

## 🚀 Hướng Dẫn Khởi Động Nhanh

### Cách 1: Khởi động tự động bằng kịch bản Batch
Chạy file:
```bash
run-all.bat
```
Kịch bản sẽ tự động mở 2 cửa sổ terminal riêng biệt để biên dịch và chạy `Product Service` (Port 8081) và `Order Service` (Port 8082).

### Cách 2: Khởi động từng Service riêng lẻ
* **Product Service (Port 8081):**
  ```bash
  run-product-service.bat
  ```
  Hoặc bằng lệnh:
  ```bash
  cd lab01-microservices/product-service
  ./mvnw spring-boot:run
  ```
* **Order Service (Port 8082):**
  ```bash
  run-order-service.bat
  ```
  Hoặc bằng lệnh:
  ```bash
  cd lab01-microservices/order-service
  ./mvnw spring-boot:run
  ```

---

## 🌐 Trải Nghiệm Giao Diện Người Dùng

Mở file `index.html` (ở thư mục gốc hoặc trong `lab01-microservices/frontend/index.html`) trên trình duyệt:
1. **Nút "Tải Thực Đơn":** Gọi trực tiếp `GET http://localhost:8081/api/products` để tải danh mục đồ uống trà sữa với đầy đủ hình ảnh/icon, danh mục, giá bán và mô tả.
2. **Ô tìm kiếm "Tra Cứu Đồ Uống Qua Order Service":** Nhập ID đồ uống (1 - 8) để kiểm tra luồng giao tiếp giữa 2 microservices: `Order Service (8082)` ➜ `Product Service (8081)`.
3. **Nút "Tải Đơn Hàng":** Gọi `GET http://localhost:8082/api/orders` để xem các đơn hàng trà sữa thực tế với đầy đủ các mức độ ngọt, mức đá, danh sách topping và trạng thái pha chế tại quầy Bar.

---

## 🗄️ Cấu Trúc Cơ Sở Dữ Liệu MySQL (`database/`)

Toàn bộ các file SQL được đặt trong thư mục `database/`:
- `01_create_database.sql`: Khởi tạo CSDL `milk_tea_management` và 11 bảng chuẩn hóa quan hệ.
- `02_stored_procedures.sql`: Thủ tục xử lý nghiệp vụ bán hàng, quầy Bar KDS, báo cáo doanh thu.
- `03_functions.sql`: Các hàm tính tiền, chiết khấu hội viên, cảnh báo nguyên liệu.
- `04_triggers.sql`: Các Trigger tự động tính lại tổng tiền, tích điểm hội viên, cập nhật trạng thái bàn.
- `05_views.sql`: Màn hình Barista KDS, sơ đồ bàn, top đồ uống bán chạy nhất (Best-Seller).
- `06_seed_data.sql`: Dữ liệu mẫu khởi tạo 20 món trà sữa, 8 loại topping, tài khoản nhân sự và đơn hàng thực tế.

---

## 📄 Báo Cáo Chi Tiết
Xem tài liệu báo cáo đầy đủ tại:
- [BaoCao_QuanLyQuanTraSua.md](file:///D:/LTW3_LeDuyKha/BaoCao_QuanLyQuanTraSua.md)
- [LeDuyKha_2124110074_Lab02.docx](file:///D:/LTW3_LeDuyKha/LeDuyKha_2124110074_Lab02.docx)
