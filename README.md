# SWP391-G1
SWP391 Group1 

## LinhNN Demo

Phần demo của `LinhNN` trong tracking hiện tập trung vào 2 nhóm màn chính:

### 1. Training Program

- URL danh sách: `/training-program?action=list`
- URL tạo mới: `/training-program?action=create`
- URL chỉnh sửa: `/training-program?action=edit&id={programId}`
- Chức năng:
  - Xem danh sách training program
  - Tạo training program mới
  - Sửa training program hiện có

### 2. Curriculum

- URL danh sách: `/curriculum?action=list`
- URL tạo mới: `/curriculum?action=create`
- URL tạo theo program: `/curriculum?action=create&programId={programId}`
- Chức năng:
  - Xem danh sách curriculum
  - Tạo curriculum cho một training program
  - Chọn subject để mapping vào curriculum

### 3. Màn vào demo

- Dashboard Training Department: `/home`
- Từ dashboard này có thể vào:
  - `Curriculum`
  - `Training Program`

### 4. Quyền truy cập

- `Training Department`:
  - Có thể tạo và chỉnh sửa `Training Program`
  - Có thể tạo `Curriculum`
- User đã đăng nhập:
  - Có thể xem danh sách

### 5. Ghi chú demo

- Các card khác trong dashboard nếu chưa được gắn URL thì vẫn là phần chưa demo xong.
- Luồng hiện tại đang theo kiến trúc servlet + JSP + DAO của project.

## Phan cong cua Linhnn

Theo bang phan cong, cac phan do `Linhnn` phu trach bao gom:

### 1. Account and entry screens

- Home page: xem thong tin he thong va dieu huong chuc nang
- Login: dang nhap theo role
- Register: dang ky tai khoan moi
- Reset password: khoi phuc mat khau khi quen
- Profile: xem va cap nhat thong tin ca nhan
- Change password: doi mat khau de tang bao mat

### URL demo hien co

- Home: `/home`
- Login: `/login`
- Register: `/register`
- Forgot password: `/forgot-password`
- Reset password: `/reset-password?token={token}`
- Profile: `/profile`
- Change password: `/change-password`
- Logout: `/logout`

### URL demo cho phan training department do Linhnn phu trach trong tracking

- Training Program list: `/training-program?action=list`
- Training Program create: `/training-program?action=create`
- Training Program edit: `/training-program?action=edit&id={programId}`
- Curriculum list: `/curriculum?action=list`
- Curriculum create: `/curriculum?action=create`
- Curriculum create theo program: `/curriculum?action=create&programId={programId}`

### 2. Administration screens

- Manage user accounts: tao, cap nhat, vo hieu hoa, xoa tai khoan, reset mat khau, theo doi trang thai
- Role management: tao, sua, gan role va quyen
- System administration: cau hinh he thong, chinh sach bao mat, van hanh platform
- System reports: tao, xem va export bao cao ve nguoi dung, curriculum, course, va system performance

### URL nay chua co route rieng trong source

- Manage user accounts
- Role management
- System administration
- System reports

### 3. User information

- Allow users to view and update personal information:
  - profile details
  - contact information
  - account settings
  - other related data

### Nguon route trong code

- `HomeServlet`: `/home`
- `LoginServlet`: `/login`
- `RegisterServlet`: `/register`
- `ForgotPasswordServlet`: `/forgot-password`
- `ResetPasswordServlet`: `/reset-password`
- `ProfileServlet`: `/profile`
- `ChangePasswordServlet`: `/change-password`
- `LogoutServlet`: `/logout`
- `TrainingProgramServlet`: `/training-program`
- `CurriculumServlet`: `/curriculum`

### 4. Ghi chu

- Phan `Linhnn` trong bang phan cong la nhom chuc nang nen duoc note rieng trong README de de demo va doi chieu scope.
- Neu can, co the tach tiep thanh muc `Implemented`, `In progress`, va `Not yet implemented` theo trang thai code hien tai.
