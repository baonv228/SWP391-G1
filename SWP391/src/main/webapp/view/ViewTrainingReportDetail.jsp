<%@page import="model.User"%>
<%@page import="model.ViewTrainingReport"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User currentUser = (User) session.getAttribute("user");
    String roleName = (String) session.getAttribute("roleName");
    if (roleName == null && currentUser != null && currentUser.getRole() != null) {
        roleName = currentUser.getRole().getRoleName();
        session.setAttribute("roleName", roleName);
    }

    if (currentUser == null || roleName == null
            || (!"Training Department".equalsIgnoreCase(roleName.trim())
            && !"Admin".equalsIgnoreCase(roleName.trim()))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String displayName = currentUser.getFullName();
    if (displayName == null || displayName.isBlank()) {
        displayName = currentUser.getEmail();
    }

    ViewTrainingReport report = (ViewTrainingReport) request.getAttribute("report");
    if (report == null) {
        response.sendRedirect(request.getContextPath() + "/view-training-report");
        return;
    }

    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    String ctx = request.getContextPath();
    String st = report.getStatus() == null ? "" : report.getStatus();
    String badgeCls = "draft";
    if ("Approved".equalsIgnoreCase(st)) badgeCls = "approved";
    else if ("Pending".equalsIgnoreCase(st)) badgeCls = "pending";
    else if ("Rejected".equalsIgnoreCase(st)) badgeCls = "rejected";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Training Report Detail #<%= report.getReportId() %></title>
    <link rel="stylesheet" href="<%=ctx%>/css/TraningDepartment.css"/>
    <style>
        .detail-card {
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            padding: 24px;
            max-width: 920px;
        }
        .detail-card h1 {
            margin: 0 0 8px;
            font-size: 24px;
            color: var(--orange-dark);
        }
        .detail-sub {
            color: var(--muted);
            font-size: 13px;
            margin-bottom: 20px;
        }
        .detail-grid {
            display: grid;
            grid-template-columns: 220px 1fr;
            gap: 10px 16px;
        }
        .detail-grid .label {
            font-size: 13px;
            font-weight: 700;
            color: var(--muted);
        }
        .detail-grid .value {
            font-size: 14px;
            color: var(--ink);
            word-break: break-word;
        }
        .badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
            background: #eee;
        }
        .badge.approved { background-color: #d4edda; color: #155724; }
        .badge.pending { background-color: #fff3cd; color: #856404; }
        .badge.rejected { background-color: #f8d7da; color: #721c24; }
        .badge.draft { background-color: #e2e8f0; color: #334155; }
        .actions {
            margin-top: 22px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn-back {
            padding: 10px 18px;
            background: #f1d2ad;
            color: var(--ink);
            text-decoration: none;
            border-radius: 6px;
            font-weight: 700;
            font-size: 14px;
        }
        .btn-print {
            padding: 10px 18px;
            background: var(--orange);
            color: #fff;
            border: none;
            border-radius: 6px;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
        }
        .readonly-note {
            margin-top: 14px;
            font-size: 12px;
            color: var(--muted);
        }
        .page-nav {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 18px;
            padding: 10px 14px;
            background: rgba(255, 255, 255, 0.75);
            border: 1px solid var(--line);
            border-radius: 8px;
        }
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
            font-size: 13px;
            color: var(--muted);
        }
        .breadcrumb a {
            color: var(--orange-dark);
            text-decoration: none;
            font-weight: 700;
        }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb .sep { color: #c4a484; }
        .breadcrumb .current { color: var(--ink); font-weight: 700; }
        .btn-back-nav {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            border-radius: 6px;
            border: 1px solid var(--line);
            background: var(--white);
            color: var(--orange-dark);
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-back-nav:hover {
            border-color: var(--orange);
            background: var(--orange-soft);
        }
        @media print {
            .topbar, .actions, .footer, .readonly-note, .page-nav { display: none !important; }
            body { background: #fff; }
            .detail-card { box-shadow: none; border: none; }
        }
    </style>
</head>
<body>
<main class="page">
    <header class="topbar">
        <div class="brand">Training Program Management System</div>
        <div class="top-actions">
            <a class="profile" href="<%=ctx%>/home" title="<%= displayName %>">
                <span class="avatar">TD</span>
                <span><%= displayName %></span>
            </a>
            <a class="logout-button" href="<%=ctx%>/logout">Đăng xuất</a>
        </div>
    </header>

    <section class="content" style="padding: 30px clamp(18px, 5vw, 64px);">
        <nav class="page-nav" aria-label="Điều hướng">
            <div class="breadcrumb">
                <a href="<%=ctx%>/home">Home</a>
                <span class="sep">›</span>
                <a href="<%=ctx%>/view-training-report">View Training Report</a>
                <span class="sep">›</span>
                <span class="current">Report #<%= report.getReportId() %></span>
            </div>
            <a class="btn-back-nav" href="<%=ctx%>/view-training-report" id="btnBackPrevious">← Quay lại trang trước</a>
        </nav>

        <div class="detail-card">
            <h1>Training Report #<%= report.getReportId() %></h1>
            <p class="detail-sub">Read-only detail. No editing is allowed.</p>

            <div class="detail-grid">
                <div class="label">Report ID</div>
                <div class="value"><%= report.getReportId() %></div>

                <div class="label">Course ID</div>
                <div class="value"><%= report.getCourseId() %> (<%= report.getCourseCode() != null ? report.getCourseCode() : "-" %>)</div>

                <div class="label">Course Name</div>
                <div class="value"><%= report.getCourseName() != null ? report.getCourseName() : "-" %></div>

                <div class="label">Curriculum Name</div>
                <div class="value"><%= report.getCurriculumName() != null ? report.getCurriculumName() : "-" %></div>

                <div class="label">Course Description</div>
                <div class="value"><%= report.getCourseDescription() != null ? report.getCourseDescription() : "-" %></div>

                <div class="label">Created By</div>
                <div class="value"><%= report.getCreatedBy() != null ? report.getCreatedBy() : "-" %></div>

                <div class="label">Modified By</div>
                <div class="value"><%= report.getModifiedBy() != null ? report.getModifiedBy() : "-" %></div>

                <div class="label">Created Date</div>
                <div class="value"><%= report.getCreatedDate() != null ? df.format(report.getCreatedDate()) : "-" %></div>

                <div class="label">Last Modified Date</div>
                <div class="value"><%= report.getLastModifiedDate() != null ? df.format(report.getLastModifiedDate()) : "-" %></div>

                <div class="label">Status</div>
                <div class="value"><span class="badge <%= badgeCls %>"><%= st.isEmpty() ? "-" : st %></span></div>

                <div class="label">Report Type</div>
                <div class="value"><%= report.getReportType() != null ? report.getReportType() : "-" %></div>

                <div class="label">Number of Changes</div>
                <div class="value"><%= report.getNumberOfChanges() %></div>

                <div class="label">Change Details</div>
                <div class="value"><%= report.getChangeDetails() != null ? report.getChangeDetails() : "-" %></div>

                <div class="label">Reviewer</div>
                <div class="value"><%= report.getReviewer() != null ? report.getReviewer() : "-" %></div>

                <div class="label">Review Date</div>
                <div class="value"><%= report.getReviewDate() != null ? df.format(report.getReviewDate()) : "-" %></div>
            </div>

            <div class="actions">
                <a class="btn-back" href="<%=ctx%>/view-training-report">← Back to list</a>
                <button type="button" class="btn-print" onclick="window.print()">Print / Save PDF</button>
            </div>
            <p class="readonly-note">This page is view-only. Use browser Print to export PDF.</p>
        </div>
    </section>

    <footer class="footer">
        © 2026 Training Program Management System. All rights reserved.
    </footer>
</main>
<script>
    (function () {
        var btn = document.getElementById("btnBackPrevious");
        if (!btn) return;
        btn.addEventListener("click", function (e) {
            if (window.history.length > 1) {
                e.preventDefault();
                window.history.back();
            }
        });
    })();
</script>
</body>
</html>
