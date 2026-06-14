# Hướng dẫn cài đặt - Module User Authentication (Linhnn)

Module thực hiện theo cấu trúc SDS: **View (.jsp) → controller (servlet) → service → model → dao**.

## 1. Cơ sở dữ liệu (SQL Server)
1. Mở SSMS / Azure Data Studio hoặc tab Database trong IntelliJ.
2. Chạy script `schema_sqlserver.sql` để tạo database `TPMS_DB`, các bảng `Role`, `User`, `PasswordResetToken` và dữ liệu mẫu.
3. Tài khoản admin mẫu:
   - Email: `admin@gmail.com`
   - Mật khẩu: `123456`

## 2. Cấu hình kết nối
Mở `src/main/java/dao/DBContext.java` và sửa `USER` / `PASSWORD` cho khớp SQL Server trên máy bạn (mặc định `sa` / `123`).

## 3. Chạy ứng dụng (IntelliJ)
1. Cấu hình một server Tomcat 10/11 (Jakarta Servlet 6).
2. Deploy artifact `SWP391:war exploded`.
3. Truy cập `http://localhost:8080/SWP391_war_exploded/` (đường dẫn context có thể khác).

## 4. Các chức năng (phần tracking: Linhnn)
| Chức năng | URL | Ghi chú |
|---|---|---|
| Home Page | `/index.jsp` | Hiển thị theo trạng thái đăng nhập |
| User Login | `/login` | |
| User Register | `/register` | Vai trò mặc định: Student |
| Logout | `/logout` | |
| User Profile | `/profile` | Cần đăng nhập |
| Change Password | `/change-password` | Cần đăng nhập |
| Password Reset | `/forgot-password` → `/reset-password` | Token dùng một lần, hiệu lực 30 phút |

> Lưu ý: chức năng Password Reset hiện hiển thị liên kết đặt lại trực tiếp trên trang (chế độ dev) do hệ thống chưa tích hợp Email Service.
