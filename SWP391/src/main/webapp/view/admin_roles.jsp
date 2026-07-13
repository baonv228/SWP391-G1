<%@page import="model.Role"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<Role> roles = (List<Role>) request.getAttribute("roles");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý vai trò — TPMS</title>
    <style>
        :root {
            --primary: #4f46e5;
            --primary-dark: #3730a3;
            --primary-soft: #e0e7ff;
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
            padding: 18px 20px;
            font-weight: 700;
            color: var(--muted);
            border-bottom: 1px solid var(--line);
        }

        td {
            padding: 18px 20px;
            border-bottom: 1px solid var(--line);
            vertical-align: middle;
        }

        tr:last-child td {
            border-bottom: none;
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
        <div class="header-actions">
            <div class="title-section">
                <h1>Quản lý vai trò (Roles)</h1>
                <p>Danh sách các vai trò chính thức trong hệ thống dùng để phân quyền chức năng.</p>
            </div>
            <a class="btn-secondary" href="<%=request.getContextPath()%>/admin/roles?action=export">Export Excel</a>
        </div>

        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th style="width: 100px;">ID</th>
                        <th style="width: 250px;">Tên Vai trò</th>
                        <th>Mô tả chức năng</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (roles != null && !roles.isEmpty()) {
                        for (Role r : roles) { 
                    %>
                        <tr>
                            <td style="font-weight: bold; color: var(--muted);"><%= r.getRoleId() %></td>
                            <td><span style="background: var(--primary-soft); color: var(--primary); padding: 6px 12px; border-radius: 6px; font-weight: 700;"><%= r.getRoleName() %></span></td>
                            <td style="color: var(--muted); line-height: 1.5;"><%= r.getDescription() != null ? r.getDescription() : "Chưa có mô tả." %></td>
                        </tr>
                    <%  }
                       } else { %>
                        <tr>
                            <td colspan="3" style="text-align: center; color: var(--muted); padding: 32px;">Không tìm thấy vai trò nào.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
