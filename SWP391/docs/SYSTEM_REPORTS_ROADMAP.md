# System Reports — Roadmap (Admin / Manager)

Phù hợp SRS: generate / view / filter / export báo cáo vận hành TPMS.

## Phase 1 — MVP (đã triển khai)
- [x] Card **System Reports** trên Admin Home
- [x] Trang `/admin/reports` (chỉ Admin, qua `AdminFilter`)
- [x] Dashboard tóm tắt (users, programs, curricula, syllabi, subjects, materials, requests)
- [x] Lọc theo **category** (all / users / curriculum / syllabus / materials)
- [x] Export **CSV** và **Excel** (Apache POI)
- [x] Tái sử dụng / mở rộng `ReportDAO`

## Phase 2 — Vận hành (đã triển khai phần cốt lõi)
- [x] Lọc **date range** theo ngày tạo tài khoản (`User.CreatedAt`)
- [x] Biểu đồ dạng bar (CSS) + thống kê user theo role/status
- [x] Curriculum / Syllabus / Subject / Material / Approval panels
- [x] **In / PDF** qua trang print (`export=print` → trình duyệt Save as PDF)
- [ ] Login history thật (cần bảng audit — xem Phase 3)
- [ ] So sánh hai kỳ (period A vs B) trên cùng dashboard
- [ ] Export PDF binary server-side (iText/OpenPDF) nếu bắt buộc không dùng print

## Phase 3 — Nâng cao (kế hoạch)
1. **User activity log**
   - Tạo bảng `UserActivityLog` (UserID, Action, IP, CreatedAt)
   - Ghi log ở Login / Logout / Admin update/deactivate user
   - Báo cáo: login theo ngày, top active users
2. **Kỳ học / semester**
   - Filter theo semester nếu có cột AcademicYear / Semester trên Curriculum
3. **System performance**
   - Metrics ngoài DB (response time, storage) cần APM hoặc bảng `SystemMetric` ghi định kỳ
4. **Manager / Training Department**
   - Cho phép role Training Department xem `/admin/reports` (read-only) hoặc `/report` nâng cấp
5. **Charts nâng cao**
   - Chart.js / dashboard tương tác
6. **Booking statistics**
   - Chỉ khi module booking tồn tại trong schema

## Cách dùng nhanh
1. Đăng nhập Admin → mở **System Reports**
2. Chọn category + from/to date → **Apply filters**
3. **Export CSV** / **Export Excel** / **In / PDF**

## URL
- `GET /admin/reports`
- `GET /admin/reports?export=csv|excel|print&category=...&fromDate=yyyy-MM-dd&toDate=yyyy-MM-dd`
