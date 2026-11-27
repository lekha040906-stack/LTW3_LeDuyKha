# BÁO CÁO ĐỀ TÀI: HỆ THỐNG QUẢN LÝ QUÁN TRÀ SỮA (MILK TEA STORE MANAGEMENT SYSTEM)

**Môn học:** Lập trình Web 3 – Spring Boot & Microservices  
**Sinh viên thực hiện:** Lê Duy Kha  
**Mã số sinh viên (MSSV):** 2124110074  

---

## CHƯƠNG 1. TỔNG QUAN VỀ ĐỀ TÀI

### 1.1. Tên đề tài
* **Tên tiếng Việt:** Hệ thống Quản lý Quán Trà Sữa
* **Tên tiếng Anh:** Milk Tea Store Management System
* **Mô hình kiến trúc:** Spring Boot Microservices, RESTful API, Cơ sở dữ liệu MySQL, Frontend HTML5/CSS3/JavaScript hiện đại.

### 1.2. Lý do chọn đề tài
Thị trường F&B trà sữa và đồ uống đóng vai trò rất lớn trong đời sống giới trẻ hiện nay với lượng đơn đặt hàng lớn mỗi ngày:
* **Đặc thù của ngành trà sữa:**
  * Mỗi ly nước có nhiều cấp độ tùy chỉnh phức tạp: kích thước ly (Size M, Size L), mức độ ngọt (0%, 30%, 50%, 70%, 100% đường), mức đá (không đá, 50% đá, 100% đá), cùng nhiều loại Topping phong phú (trân châu đen, thạch phô mai, pudding trứng, trân châu trắng...).
  * Yêu cầu quy trình pha chế tại quầy Bar (Kitchen Display System - KDS) phải cực kỳ chuẩn xác và nhanh chóng.
  * Việc tích hợp đa kênh: đặt trực tiếp tại bàn (Dine-in), mang đi (Takeaway), và giao hàng trực tuyến (Delivery).
* **Ứng dụng kiến trúc Microservices:**
  * Phân rã hệ thống thành các dịch vụ độc lập: Menu Service, Order Service, Inventory Service, Preparation Service, Payment Service, Customer Service.
  * Dễ dàng mở rộng quy mô (scalability), triển khai độc lập (independent deployment), và giảm thiểu rủi ro lỗi dây chuyền (fault isolation).

---

## CHƯƠNG 2. PHÂN TÍCH CHỨC NĂNG HỆ THỐNG (ADMIN & CLIENT)

### 2.1. Nhóm chức năng Admin (Dành cho Quản lý, Thu ngân, Barista pha chế)
1. **Quản lý thực đơn (Menu Management):**
   * Quản lý danh mục đồ uống (Trà sữa đậm vị, Trà trái cây nhiệt đới, Macchiato Kem Cheese, Sữa tươi & Đá xay, Cà phê).
   * Quản lý danh sách món, đơn giá theo size, hình ảnh, mô tả, trạng thái còn món / tạm hết.
   * Quản lý danh mục Topping và giá bán kèm.
2. **Quản lý đơn hàng (Order Management):**
   * Tiếp nhận đơn hàng từ tại quầy và online; hiển thị chi tiết từng ly (Size, % đường, % đá, Topping, Ghi chú).
   * Cập nhật tiến trình: *Chờ xử lý ➜ Đang pha chế ➜ Đã pha xong ➜ Hoàn thành ➜ Đã hủy*.
3. **Màn hình điều phối quầy Bar (KDS - Kitchen Display System):**
   * Màn hình riêng cho Barista nhận lệnh pha chế theo thứ tự thời gian.
   * Hiển thị chi tiết công thức định lượng và tùy chọn cho từng ly.
   * Đánh dấu hoàn tất pha chế để phục vụ tại bàn hoặc bàn giao cho shipper.
4. **Quản lý kho nguyên liệu (Inventory Management):**
   * Quản lý nguyên vật liệu (cốt trà Oolong, cốt trà lài, sữa béo, trân châu sống, đường đen, ly nhựa, ống hút...).
   * Cảnh báo tồn kho khi số lượng giảm xuống dưới ngưỡng tối thiểu.
5. **Quản lý thanh toán & Hóa đơn (Payment Management):**
   * Tính tiền hóa đơn, áp dụng chiết khấu hội viên.
   * Hỗ trợ thanh toán: Tiền mặt, quét mã VietQR tự động, ví điện tử MoMo, VNPAY.
6. **Quản lý khách hàng thân thiết & Tích điểm (Customer Loyalty):**
   * Tích lũy điểm hội viên (10.000đ = 1 điểm).
   * Tự động xếp hạng thành viên: Đồng (Bronze), Bạc (Silver), Vàng (Gold) với mức ưu đãi tương ứng.
7. **Báo cáo & Thống kê doanh thu:**
   * Doanh thu theo ca làm việc, ngày, tháng.
   * Top đồ uống bán chạy nhất (Best-Seller).
8. **Quản lý nhân viên (Employee Management):**
   * Phân quyền tài khoản theo vai trò: Admin, Thu ngân, Pha chế (Barista), Phục vụ.

### 2.2. Nhóm chức năng Client (Dành cho Khách hàng đặt món)
1. **Khám phá thực đơn:** Xem danh sách đồ uống trà sữa theo từng danh mục, xem top best-seller.
2. **Tùy biến ly trà sữa (Customization):**
   * Chọn Size ly (Size M, Size L).
   * Chọn mức đường: 0%, 30%, 50%, 70%, 100%.
   * Chọn mức đá: Không đá, 50% đá, 100% đá.
   * Chọn thêm Topping kèm theo giá phụ thu.
3. **Giỏ hàng & Đặt hàng:**
   * Xem trước tổng tiền, chọn hình thức nhận (Dùng tại bàn, Mang đi, Giao hàng tận nơi).
   * Áp dụng mã ưu đãi / điểm tích lũy thành viên.
4. **Theo dõi đơn hàng thời gian thực:**
   * Theo dõi trạng thái: Đã gửi đơn ➜ Quầy Bar đang pha ➜ Sẵn sàng phục vụ / Đang giao hàng.

---

## CHƯƠNG 3. THIẾT KẾ KIẾN TRÚC MICROSERVICES

### 3.1. Danh sách các Microservices
| STT | Tên Service | Port | Chức năng phụ trách | Giao tiếp với |
|---|---|---|---|---|
| 1 | **Product / Menu Service** | `8081` | Quản lý danh mục, đồ uống trà sữa, đơn giá, kích cỡ, danh sách topping, trạng thái còn/hết hàng. | Order Service, Inventory Service |
| 2 | **Order Service** | `8082` | Tiếp nhận đơn đặt hàng, quản lý chi tiết từng ly trà sữa (đường, đá, topping), điều phối trạng thái đơn. | Product Service, Payment, Customer, Preparation |
| 3 | **Inventory Service** | `8083` | Quản lý kho nguyên vật liệu, định lượng trừ kho tự động khi tạo đơn. | Order Service, Menu Service |
| 4 | **Preparation Service (KDS)** | `8084` | Màn hình hiển thị đơn pha chế tại quầy Bar, cập nhật tiến độ làm đồ uống. | Order Service |
| 5 | **Payment Service** | `8085` | Xử lý thanh toán đa kênh (Tiền mặt, VietQR, MoMo, VNPAY). | Order Service |
| 6 | **Customer Service** | `8086` | Quản lý tài khoản khách hàng, tích lũy điểm thưởng và thăng hạng thành viên. | Order Service |

### 3.2. Chi tiết luồng giao tiếp liên dịch vụ (Service-to-Service Communication)
* **Luồng gọi món & xác thực thông tin:**
  1. Client gửi yêu cầu tạo đơn hàng tới **Order Service (Port 8082)**.
  2. Order Service sử dụng `RestClient` gọi sang **Product Service (Port 8081)** tại `GET /api/products/{id}` để kiểm tra tính hợp lệ của món trà sữa và đơn giá thực tế.
  3. Sau khi xác thực thành công, Order Service lưu đơn hàng và chuyển trạng thái sang `preparing` để đẩy dữ liệu tới quầy Bar pha chế.
* **Luồng thanh toán & tích điểm:**
  1. Khách hàng thanh toán qua VietQR/MoMo hoặc Thu ngân xác nhận thu tiền mặt.
  2. Order Service cập nhật trạng thái đơn sang `completed` và kích hoạt cộng điểm thưởng vào tài khoản hội viên qua **Customer Service** (10.000đ = 1 điểm).

---

## CHƯƠNG 4. THIẾT KẾ CƠ SỞ DỮ LIỆU (MYSQL)

Database: `milk_tea_management` (Bộ mã: `utf8mb4_unicode_ci`)
Bao gồm các kịch bản SQL chi tiết:
1. `01_create_database.sql`: Cấu trúc 11 bảng chuẩn hóa quan hệ (`roles`, `users`, `tables`, `categories`, `products`, `toppings`, `customers`, `orders`, `order_details`, `order_detail_toppings`, `ingredients`).
2. `02_stored_procedures.sql`: Các thủ tục lưu trữ cho nhân viên, thực đơn, tạo đơn hàng trà sữa, thêm topping, cập nhật tiến trình pha chế Barista, hoàn tất thanh toán và báo cáo doanh thu.
3. `03_functions.sql`: Hàm tính tiền đơn hàng, chiết khấu hội viên, đếm số ly đang chờ pha chế, cảnh báo tồn kho.
4. `04_triggers.sql`: Trigger tự động tính lại tổng tiền đơn khi thêm/sửa/xóa món, tự động tích điểm nâng hạng hội viên khi hoàn thành đơn, tự động cập nhật trạng thái bàn ăn.
5. `05_views.sql`: Màn hình điều phối quầy Bar KDS, sơ đồ bàn trực quan, top đồ uống bán chạy nhất (Best-Seller), cảnh báo kho hàng.
6. `06_seed_data.sql`: Dữ liệu mẫu phong phú với 20 món trà sữa signature, 8 loại topping, 10 bàn/khu vực, và các đơn hàng thực tế.

---

## CHƯƠNG 5. HƯỚNG DẪN KHỞI CHẠY HỆ THỐNG

1. **Khởi động đồng thời cả 2 services:**
   * Nhấp đúp chạy file `run-all.bat`.
   * Hoặc khởi động độc lập:
     * Product Service (Port 8081): Chạy `run-product-service.bat`.
     * Order Service (Port 8082): Chạy `run-order-service.bat`.
2. **Trải nghiệm giao diện Web:**
   * Mở file `index.html` trực tiếp trên trình duyệt.
   * Xem thực đơn trà sữa từ Product Service, tra cứu đồ uống qua Order Service, và xem danh sách đơn hàng thực tế.
