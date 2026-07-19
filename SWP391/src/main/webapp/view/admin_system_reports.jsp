<%@page import="java.util.Map"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Boolean printMode = (Boolean) request.getAttribute("printMode");
    boolean isPrint = printMode != null && printMode;
    String ctx = request.getContextPath();
    String category = (String) request.getAttribute("category");
    if (category == null) category = "all";
    String fromDate = (String) request.getAttribute("fromDate");
    String toDate = (String) request.getAttribute("toDate");
    if (fromDate == null) fromDate = "";
    if (toDate == null) toDate = "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>System Reports — Admin TPMS</title>
    <style>
        :root {
            --primary: #d95f12;
            --primary-dark: #b94f0c;
            --primary-soft: #fff1e7;
            --ink: #0f172a;
            --muted: #475569;
            --line: #e2e8f0;
            --white: #ffffff;
            --bg: #f8fafc;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: var(--ink);
            background: var(--bg);
        }
        .topbar {
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            border-bottom: 1px solid var(--line);
            background: rgba(255,255,255,.9);
        }
        .brand { font-size: 18px; font-weight: 800; color: var(--primary); letter-spacing: .04em; }
        .top-actions { display: flex; gap: 10px; flex-wrap: wrap; }
        .btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 8px 14px; border-radius: 8px; font-size: 13px; font-weight: 700;
            text-decoration: none; border: 1px solid var(--line); background: var(--white); color: var(--muted);
            cursor: pointer;
        }
        .btn:hover { border-color: var(--primary); color: var(--primary); }
        .btn-primary { background: var(--primary); border-color: var(--primary); color: #fff; }
        .btn-primary:hover { background: var(--primary-dark); color: #fff; }
        .content { max-width: 1180px; margin: 0 auto; padding: 28px 20px 48px; }
        h1 { font-size: 26px; font-weight: 800; margin-bottom: 6px; }
        .subtitle { color: var(--muted); font-size: 14px; margin-bottom: 22px; }
        .filters {
            background: var(--white); border: 1px solid var(--line); border-radius: 14px;
            padding: 16px; margin-bottom: 22px; display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 12px; align-items: end;
        }
        .filters label { display: block; font-size: 12px; font-weight: 700; color: var(--muted); margin-bottom: 6px; }
        .filters select, .filters input {
            width: 100%; padding: 9px 10px; border-radius: 8px; border: 1px solid var(--line); font-size: 14px;
        }
        .error {
            margin-bottom: 16px; padding: 12px 14px; border-radius: 10px;
            background: #fef2f2; border: 1px solid #fecaca; color: #b91c1c; font-size: 14px;
        }
        .stats-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 12px; margin-bottom: 22px;
        }
        .stat-card {
            background: var(--white); border: 1px solid var(--line); border-radius: 12px;
            padding: 16px; text-align: center;
        }
        .stat-number { font-size: 28px; font-weight: 800; color: var(--primary); }
        .stat-label { margin-top: 4px; font-size: 12px; color: var(--muted); font-weight: 600; }
        .panels {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 16px;
        }
        .panel {
            background: var(--white); border: 1px solid var(--line); border-radius: 14px; padding: 16px 18px;
        }
        .panel h2 { font-size: 15px; font-weight: 800; margin-bottom: 12px; color: var(--ink); }
        .bar-row {
            display: grid; grid-template-columns: 110px 1fr 42px; gap: 8px; align-items: center;
            margin-bottom: 8px; font-size: 13px;
        }
        .bar-label { color: var(--muted); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .bar-track { height: 10px; background: #f1f5f9; border-radius: 999px; overflow: hidden; }
        .bar-fill { height: 100%; border-radius: 999px; background: var(--primary); min-width: 2px; }
        .bar-count { text-align: right; font-weight: 700; }
        .empty { color: var(--muted); font-size: 13px; }
        .hint { margin-top: 18px; font-size: 12px; color: var(--muted); }
        @media print {
            .topbar, .filters, .no-print, .hint { display: none !important; }
            body { background: #fff; }
            .content { padding: 0; max-width: none; }
            .panel, .stat-card { box-shadow: none; break-inside: avoid; }
        }
    </style>
    <% if (isPrint) { %>
    <script>window.addEventListener('load', function () { window.print(); });</script>
    <% } %>
</head>
<body>
<header class="topbar no-print">
    <div class="brand">TPMS ADMIN</div>
    <div class="top-actions">
        <a class="btn" href="<%=ctx%>/home">← Dashboard</a>
        <a class="btn" href="<%=ctx%>/admin/reports?category=<%=category%>&fromDate=<%=fromDate%>&toDate=<%=toDate%>&export=csv">Export CSV</a>
        <a class="btn" href="<%=ctx%>/admin/reports?category=<%=category%>&fromDate=<%=fromDate%>&toDate=<%=toDate%>&export=excel">Export Excel</a>
        <a class="btn btn-primary" target="_blank"
           href="<%=ctx%>/admin/reports?category=<%=category%>&fromDate=<%=fromDate%>&toDate=<%=toDate%>&export=print">In / PDF</a>
    </div>
</header>

<main class="content">
    <h1>System Reports</h1>
    <p class="subtitle">
        Báo cáo vận hành: người dùng, curriculum, syllabus, course và phê duyệt.
        Hỗ trợ lọc theo khoảng thời gian tạo tài khoản và xuất CSV / Excel / in PDF.
    </p>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <form class="filters no-print" method="get" action="<%=ctx%>/admin/reports">
        <div>
            <label for="category">Category</label>
            <select id="category" name="category">
                <option value="all" <%= "all".equals(category) ? "selected" : "" %>>All</option>
                <option value="users" <%= "users".equals(category) ? "selected" : "" %>>Users</option>
                <option value="curriculum" <%= "curriculum".equals(category) ? "selected" : "" %>>Curriculum / Course</option>
                <option value="syllabus" <%= "syllabus".equals(category) ? "selected" : "" %>>Syllabus / Approval</option>
                <option value="materials" <%= "materials".equals(category) ? "selected" : "" %>>Materials</option>
            </select>
        </div>
        <div>
            <label for="fromDate">From date (user created)</label>
            <input id="fromDate" type="date" name="fromDate" value="<%=fromDate%>"/>
        </div>
        <div>
            <label for="toDate">To date (user created)</label>
            <input id="toDate" type="date" name="toDate" value="<%=toDate%>"/>
        </div>
        <div>
            <button class="btn btn-primary" type="submit" style="width:100%; justify-content:center;">Apply filters</button>
        </div>
    </form>

    <div class="stats-grid">
        <c:forEach var="entry" items="${summary}">
            <div class="stat-card">
                <div class="stat-number">${entry.value}</div>
                <div class="stat-label">${entry.key}</div>
            </div>
        </c:forEach>
        <div class="stat-card">
            <div class="stat-number">${usersCreatedInRange}</div>
            <div class="stat-label">Users created in range</div>
        </div>
    </div>

    <div class="panels">
        <c:if test="${not empty usersByRole}">
            <section class="panel">
                <h2>Users by Role</h2>
                <c:forEach var="e" items="${usersByRole}">
                    <div class="bar-row">
                        <span class="bar-label">${e.key}</span>
                        <div class="bar-track"><div class="bar-fill" style="width:${e.value * 8}%; max-width:100%;"></div></div>
                        <span class="bar-count">${e.value}</span>
                    </div>
                </c:forEach>
            </section>
        </c:if>

        <c:if test="${not empty usersByStatus}">
            <section class="panel">
                <h2>Users by Status</h2>
                <c:forEach var="e" items="${usersByStatus}">
                    <div class="bar-row">
                        <span class="bar-label">${e.key}</span>
                        <div class="bar-track"><div class="bar-fill" style="width:${e.value * 8}%; max-width:100%; background:#0ea5e9;"></div></div>
                        <span class="bar-count">${e.value}</span>
                    </div>
                </c:forEach>
            </section>
        </c:if>

        <c:if test="${not empty usersCreatedByDay}">
            <section class="panel">
                <h2>Account creation by day</h2>
                <c:forEach var="e" items="${usersCreatedByDay}">
                    <div class="bar-row">
                        <span class="bar-label">${e.key}</span>
                        <div class="bar-track"><div class="bar-fill" style="width:${e.value * 20}%; max-width:100%; background:#16a34a;"></div></div>
                        <span class="bar-count">${e.value}</span>
                    </div>
                </c:forEach>
            </section>
        </c:if>
        <c:if test="${empty usersCreatedByDay and (category eq 'all' or category eq 'users')}">
            <section class="panel">
                <h2>Account creation by day</h2>
                <p class="empty">Không có tài khoản được tạo trong khoảng đã chọn.</p>
            </section>
        </c:if>

        <c:if test="${not empty syllabiStatus}">
            <section class="panel">
                <h2>Syllabi by Status</h2>
                <c:forEach var="e" items="${syllabiStatus}">
                    <div class="bar-row">
                        <span class="bar-label">${e.key}</span>
                        <div class="bar-track"><div class="bar-fill" style="width:${e.value * 10}%; max-width:100%;"></div></div>
                        <span class="bar-count">${e.value}</span>
                    </div>
                </c:forEach>
            </section>
        </c:if>

        <c:if test="${not empty requestStatus}">
            <section class="panel">
                <h2>Syllabus approvals</h2>
                <c:forEach var="e" items="${requestStatus}">
                    <div class="bar-row">
                        <span class="bar-label">${e.key}</span>
                        <div class="bar-track"><div class="bar-fill" style="width:${e.value * 12}%; max-width:100%; background:#a855f7;"></div></div>
                        <span class="bar-count">${e.value}</span>
                    </div>
                </c:forEach>
            </section>
        </c:if>

        <c:if test="${not empty curriculumStatus}">
            <section class="panel">
                <h2>Curricula by Status</h2>
                <c:forEach var="e" items="${curriculumStatus}">
                    <div class="bar-row">
                        <span class="bar-label">${e.key}</span>
                        <div class="bar-track"><div class="bar-fill" style="width:${e.value * 10}%; max-width:100%; background:#f59e0b;"></div></div>
                        <span class="bar-count">${e.value}</span>
                    </div>
                </c:forEach>
            </section>
        </c:if>

        <c:if test="${not empty subjectStatus}">
            <section class="panel">
                <h2>Subjects / Courses by Status</h2>
                <c:forEach var="e" items="${subjectStatus}">
                    <div class="bar-row">
                        <span class="bar-label">${e.key}</span>
                        <div class="bar-track"><div class="bar-fill" style="width:${e.value * 10}%; max-width:100%; background:#64748b;"></div></div>
                        <span class="bar-count">${e.value}</span>
                    </div>
                </c:forEach>
            </section>
        </c:if>

        <c:if test="${not empty materialTypes}">
            <section class="panel">
                <h2>Materials by Type</h2>
                <c:forEach var="e" items="${materialTypes}">
                    <div class="bar-row">
                        <span class="bar-label">${e.key}</span>
                        <div class="bar-track"><div class="bar-fill" style="width:${e.value * 15}%; max-width:100%; background:#06b6d4;"></div></div>
                        <span class="bar-count">${e.value}</span>
                    </div>
                </c:forEach>
            </section>
        </c:if>
    </div>

    <p class="hint">
        Phase nâng cao (roadmap): login history thật, so sánh theo kỳ, response-time / storage metrics.
        Hiện tại activity người dùng dùng proxy từ ngày tạo tài khoản (CreatedAt).
    </p>
</main>
</body>
</html>
