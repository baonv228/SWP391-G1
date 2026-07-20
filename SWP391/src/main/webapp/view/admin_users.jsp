<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Role"%>
<%@page import="model.User"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<User> users = (List<User>) request.getAttribute("users");
    List<Role> roles = (List<Role>) request.getAttribute("roles");
    String successMsg = (String) request.getAttribute("successMsg");
    String errorMsg = (String) request.getAttribute("errorMsg");
    User currentUser = (User) session.getAttribute("user");
    int currentUserId = currentUser != null ? currentUser.getUserId() : 0;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý người dùng — TPMS</title>
    <style>
        :root {
            --primary: #d95f12;
            --primary-dark: #b94f0c;
            --primary-soft: #fff1e7;
            --success: #10b981;
            --success-soft: #d1fae5;
            --danger: #ef4444;
            --danger-soft: #fee2e2;
            --ink: #0f172a;
            --muted: #475569;
            --line: #e2e8f0;
            --white: #ffffff;
            --bg: #f8fafc;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: var(--ink);
            background-color: var(--bg);
        }

        .topbar {
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 40px;
            border-bottom: 1px solid var(--line);
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(12px);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .brand-link {
            font-size: 20px;
            font-weight: 800;
            color: var(--primary);
            text-decoration: none;
            letter-spacing: 0.05em;
        }

        .btn-back {
            padding: 8px 16px;
            border-radius: 8px;
            border: 1px solid var(--line);
            background: var(--white);
            color: var(--muted);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .btn-back:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        .container {
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
            padding: 32px 24px;
        }

        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 16px;
        }

        .title-section h1 {
            font-size: 26px;
            font-weight: 800;
            color: var(--ink);
        }

        .title-section p {
            font-size: 14px;
            color: var(--muted);
            margin-top: 4px;
        }

        .btn-primary {
            padding: 10px 20px;
            border-radius: 8px;
            background: var(--primary);
            color: var(--white);
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 6px -1px rgba(217, 95, 18, 0.2);
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .btn-secondary {
            padding: 10px 20px;
            border-radius: 8px;
            background: var(--white);
            color: var(--muted);
            border: 1px solid var(--line);
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s ease;
        }

        .btn-secondary:hover {
            border-color: var(--muted);
            color: var(--ink);
        }

        .alert {
            padding: 14px 20px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 14px;
            font-weight: 500;
            animation: fadeIn 0.3s ease;
        }

        .alert-success {
            background: var(--success-soft);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .alert-danger {
            background: var(--danger-soft);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .search-bar {
            background: var(--white);
            border: 1px solid var(--line);
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 24px;
            display: flex;
            gap: 16px;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .search-input {
            flex: 1;
            padding: 10px 14px;
            border: 1px solid var(--line);
            border-radius: 8px;
            outline: none;
            font-size: 14px;
            transition: border-color 0.2s ease;
        }

        .search-input:focus {
            border-color: var(--primary);
        }

        .filter-select {
            padding: 10px 14px;
            border: 1px solid var(--line);
            border-radius: 8px;
            outline: none;
            font-size: 14px;
            background: var(--white);
            cursor: pointer;
        }

        .table-card {
            background: var(--white);
            border: 1px solid var(--line);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 14px;
        }

        th {
            background: #f8fafc;
            padding: 16px 20px;
            font-weight: 700;
            color: var(--muted);
            border-bottom: 1px solid var(--line);
        }

        td {
            padding: 16px 20px;
            border-bottom: 1px solid var(--line);
            vertical-align: middle;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-active {
            background: var(--success-soft);
            color: var(--success);
        }

        .badge-deactive {
            background: var(--danger-soft);
            color: var(--danger);
        }

        .actions-cell {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid var(--line);
            background: var(--white);
            color: var(--muted);
            transition: all 0.2s ease;
        }

        .btn-action:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        /* Modals */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
            z-index: 1000;
            animation: fadeIn 0.2s ease;
        }

        .modal-content {
            background: var(--white);
            border-radius: 16px;
            width: 100%;
            max-width: 480px;
            padding: 32px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            position: relative;
            transform: scale(0.95);
            transition: transform 0.2s ease;
        }

        .modal.open {
            display: flex;
        }

        .modal.open .modal-content {
            transform: scale(1);
        }

        .modal-header {
            margin-bottom: 20px;
        }

        .modal-header h2 {
            font-size: 20px;
            font-weight: 800;
        }

        .modal-body {
            margin-bottom: 24px;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--muted);
            margin-bottom: 6px;
        }

        .form-control {
            width: 100%;
            padding: 10px 12px;
            border-radius: 8px;
            border: 1px solid var(--line);
            outline: none;
            font-size: 14px;
            transition: border-color 0.2s ease;
        }

        .form-control:focus {
            border-color: var(--primary);
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    </style>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/theme-orange.css" />
</head>
<body>
    <header class="topbar">
        <a href="<%=request.getContextPath()%>/home" class="brand-link">TPMS ADMIN</a>
        <a href="<%=request.getContextPath()%>/home" class="btn-back">Quay lại Dashboard</a>
    </header>

    <main class="container">
        <% if (successMsg != null) { %>
            <div class="alert alert-success"><%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
            <div class="alert alert-danger"><%= errorMsg %></div>
        <% } %>

        <div class="header-actions">
            <div class="title-section">
                <h1>Quản lý người dùng</h1>
                <p>Danh sách tất cả các tài khoản sinh viên, giảng viên và quản trị viên trong hệ thống.</p>
            </div>
            <button class="btn-primary" onclick="openAddModal()">+ Thêm người dùng</button>
            <a class="btn-secondary" href="<%=request.getContextPath()%>/admin/users?action=export">Export Excel</a>
        </div>

        <div class="search-bar">
            <input type="text" id="searchInput" class="search-input" placeholder="Tìm kiếm theo Tên hoặc Email..." onkeyup="filterUsers()" />
            
            <select id="roleFilter" class="filter-select" onchange="filterUsers()">
                <option value="">Tất cả Vai trò</option>
                <% if (roles != null) { 
                    for (Role r : roles) { %>
                        <option value="<%= r.getRoleName() %>"><%= r.getRoleName() %></option>
                <%   }
                   } %>
            </select>

            <select id="statusFilter" class="filter-select" onchange="filterUsers()">
                <option value="">Tất cả Trạng thái</option>
                <option value="Active">Active</option>
                <option value="Deactive">Deactive</option>
            </select>
        </div>

        <div class="table-card">
            <table id="usersTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ và Tên</th>
                        <th>Email</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (users != null && !users.isEmpty()) {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        for (User u : users) { 
                            String statusBadge = u.getStatus() != null && u.getStatus().equalsIgnoreCase("Active") ? "badge-active" : "badge-deactive";
                            String formattedDate = u.getCreatedAt() != null ? sdf.format(u.getCreatedAt()) : "N/A";
                            String roleNameVal = u.getRole() != null ? u.getRole().getRoleName() : "N/A";
                    %>
                        <tr class="user-row" data-name="<%= u.getFullName().toLowerCase() %>" data-email="<%= u.getEmail().toLowerCase() %>" data-role="<%= roleNameVal %>" data-status="<%= u.getStatus() %>">
                            <td><%= u.getUserId() %></td>
                            <td class="user-fullname" style="font-weight: 600;"><%= u.getFullName() %></td>
                            <td><%= u.getEmail() %></td>
                            <td><span class="badge" style="background: var(--primary-soft); color: var(--primary); font-weight: 700;"><%= roleNameVal %></span></td>
                            <td><span class="badge <%= statusBadge %>"><%= u.getStatus() %></span></td>
                            <td style="color: var(--muted);"><%= formattedDate %></td>
                            <td class="actions-cell">
                                <button class="btn-action" onclick="openEditModal(<%= u.getUserId() %>, '<%= u.getFullName() %>', <%= u.getRole() != null ? u.getRole().getRoleId() : 0 %>, '<%= u.getStatus() %>')">Chỉnh sửa</button>
                                <button class="btn-action" onclick="openResetModal(<%= u.getUserId() %>, '<%= u.getEmail() %>')">Mật khẩu</button>
                            </td>
                        </tr>
                    <%  }
                       } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--muted); padding: 32px;">Không tìm thấy người dùng nào.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <!-- Modal Thêm mới -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Thêm người dùng mới</h2>
            </div>
            <form method="post" action="<%=request.getContextPath()%>/admin/users?action=add" onsubmit="return validateAddForm();">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="addFullName">Họ và Tên</label>
                        <input type="text" id="addFullName" name="fullName" class="form-control" required />
                    </div>
                    <div class="form-group">
                        <label for="addEmail">Email</label>
                        <input type="email" id="addEmail" name="email" class="form-control" required />
                    </div>
                    <div class="form-group">
                        <label for="addPassword">Mật khẩu ban đầu</label>
                        <input type="password" id="addPassword" name="password" class="form-control" required placeholder="Tối thiểu 6 ký tự" />
                    </div>
                    <div class="form-group">
                        <label for="addRole">Vai trò</label>
                        <select id="addRole" name="roleId" class="form-control" required>
                            <% if (roles != null) {
                                for (Role r : roles) { %>
                                    <option value="<%= r.getRoleId() %>"><%= r.getRoleName() %></option>
                            <%  }
                               } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="addStatus">Trạng thái</label>
                        <select id="addStatus" name="status" class="form-control" required>
                            <option value="Active">Active</option>
                            <option value="Deactive">Deactive</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('addModal')">Hủy</button>
                    <button type="submit" class="btn-primary">Tạo tài khoản</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Chỉnh sửa -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Chỉnh sửa người dùng</h2>
            </div>
            <form method="post" action="<%=request.getContextPath()%>/admin/users?action=edit">
                <input type="hidden" id="editUserId" name="userId" />
                <div class="modal-body">
                    <div class="form-group">
                        <label for="editFullName">Họ và Tên</label>
                        <input type="text" id="editFullName" name="fullName" class="form-control" required />
                    </div>
                    <div class="form-group">
                        <label for="editRole">Vai trò</label>
                        <select id="editRole" name="roleId" class="form-control" required>
                            <% if (roles != null) {
                                for (Role r : roles) { %>
                                    <option value="<%= r.getRoleId() %>"><%= r.getRoleName() %></option>
                            <%  }
                               } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editStatus">Trạng thái</label>
                        <select id="editStatus" name="status" class="form-control" required>
                            <option value="Active">Active</option>
                            <option value="Deactive">Deactive</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('editModal')">Hủy</button>
                    <button type="submit" class="btn-primary">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Đặt lại Mật khẩu -->
    <div id="resetModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Đặt lại mật khẩu</h2>
                <p style="font-size: 13px; color: var(--muted); margin-top: 4px;" id="resetEmailText"></p>
            </div>
            <form method="post" action="<%=request.getContextPath()%>/admin/users?action=reset-password" onsubmit="return validateResetForm();">
                <input type="hidden" id="resetUserId" name="userId" />
                <div class="modal-body">
                    <div class="form-group">
                        <label for="resetNewPassword">Mật khẩu mới</label>
                        <input type="password" id="resetNewPassword" name="newPassword" class="form-control" required placeholder="Tối thiểu 6 ký tự" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('resetModal')">Hủy</button>
                    <button type="submit" class="btn-primary">Cập nhật mật khẩu</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openAddModal() {
            document.getElementById("addModal").classList.add("open");
        }

        const currentUserId = <%= currentUserId %>;

        function openEditModal(userId, fullName, roleId, status) {
            document.getElementById("editUserId").value = userId;
            document.getElementById("editFullName").value = fullName;
            document.getElementById("editRole").value = roleId;
            document.getElementById("editStatus").value = status;

            const statusSelect = document.getElementById("editStatus");
            const roleSelect = document.getElementById("editRole");

            if (userId === currentUserId) {
                statusSelect.disabled = true;
                roleSelect.disabled = true;
                createOrUpdateHiddenField("editStatusHidden", "status", status);
                createOrUpdateHiddenField("editRoleHidden", "roleId", roleId);
            } else {
                statusSelect.disabled = false;
                roleSelect.disabled = false;
                removeHiddenField("editStatusHidden");
                removeHiddenField("editRoleHidden");
            }

            document.getElementById("editModal").classList.add("open");
        }

        function createOrUpdateHiddenField(id, name, value) {
            let el = document.getElementById(id);
            if (!el) {
                el = document.createElement("input");
                el.type = "hidden";
                el.id = id;
                el.name = name;
                document.querySelector("#editModal form").appendChild(el);
            }
            el.value = value;
        }

        function removeHiddenField(id) {
            const el = document.getElementById(id);
            if (el) {
                el.remove();
            }
        }

        function openResetModal(userId, email) {
            document.getElementById("resetUserId").value = userId;
            document.getElementById("resetEmailText").textContent = "Đang đổi mật khẩu cho tài khoản: " + email;
            document.getElementById("resetNewPassword").value = "";
            document.getElementById("resetModal").classList.add("open");
        }

        function closeModal(modalId) {
            document.getElementById(modalId).classList.remove("open");
        }

        function filterUsers() {
            const query = document.getElementById("searchInput").value.toLowerCase();
            const roleFilter = document.getElementById("roleFilter").value;
            const statusFilter = document.getElementById("statusFilter").value;
            
            const rows = document.querySelectorAll(".user-row");
            rows.forEach(row => {
                const name = row.getAttribute("data-name");
                const email = row.getAttribute("data-email");
                const role = row.getAttribute("data-role");
                const status = row.getAttribute("data-status");

                const queryMatch = name.includes(query) || email.includes(query);
                const roleMatch = !roleFilter || role === roleFilter;
                const statusMatch = !statusFilter || status === statusFilter;

                if (queryMatch && roleMatch && statusMatch) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }

        function validateAddForm() {
            const pwd = document.getElementById("addPassword").value;
            if (pwd.length < 6) {
                alert("Mật khẩu ban đầu phải từ 6 ký tự trở lên.");
                return false;
            }
            return true;
        }

        function validateResetForm() {
            const pwd = document.getElementById("resetNewPassword").value;
            if (pwd.length < 6) {
                alert("Mật khẩu mới phải từ 6 ký tự trở lên.");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
