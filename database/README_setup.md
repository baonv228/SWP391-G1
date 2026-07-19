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
| Login with Google | `/login/google` | OAuth2 - cần cấu hình ở mục 5 |
| User Register | `/register` | Vai trò mặc định: Student |
| Logout | `/logout` | |
| User Profile | `/profile` | Cần đăng nhập |
| Change Password | `/change-password` | Cần đăng nhập |
| Password Reset | `/forgot-password` → `/reset-password` | Token dùng một lần, hiệu lực 30 phút |

> Lưu ý: chức năng Password Reset hiện hiển thị liên kết đặt lại trực tiếp trên trang (chế độ dev) do hệ thống chưa tích hợp Email Service.

## 5. Cấu hình Login with Google (OAuth2)
1. Vào https://console.cloud.google.com/ → tạo Project.
2. **APIs & Services → OAuth consent screen**: chọn External, thêm email test.
3. **APIs & Services → Credentials → Create Credentials → OAuth client ID** → loại **Web application**.
4. Thêm **Authorized redirect URI** trùng khớp với `REDIRECT_URI` trong code, ví dụ:
   `http://localhost:8080/SWP391_war_exploded/login/google/callback`
5. Mở `src/main/java/service/GoogleOAuthConfig.java`, điền `CLIENT_ID`, `CLIENT_SECRET`, và sửa `REDIRECT_URI` cho khớp context path khi deploy.

> ⚠️ Không commit Client Secret thật lên GitHub công khai.
