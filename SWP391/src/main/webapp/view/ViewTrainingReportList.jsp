<%@page import="model.User"%>
<%@page import="model.ViewTrainingReport"%>
<%@page import="java.util.List"%>
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

    @SuppressWarnings("unchecked")
    List<ViewTrainingReport> reports = (List<ViewTrainingReport>) request.getAttribute("reports");
    String keyword = (String) request.getAttribute("keyword");
    String status = (String) request.getAttribute("status");
    String fromDate = (String) request.getAttribute("fromDate");
    String toDate = (String) request.getAttribute("toDate");
    String sortBy = (String) request.getAttribute("sortBy");
    Boolean printMode = (Boolean) request.getAttribute("printMode");
    boolean isPrint = printMode != null && printMode;
    if (keyword == null) keyword = "";
    if (status == null) status = "";
    if (fromDate == null) fromDate = "";
    if (toDate == null) toDate = "";
    if (sortBy == null || sortBy.isBlank()) sortBy = "lastModifiedDate";

    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    String ctx = request.getContextPath();
    String qs = "keyword=" + java.net.URLEncoder.encode(keyword, java.nio.charset.StandardCharsets.UTF_8)
            + "&status=" + java.net.URLEncoder.encode(status, java.nio.charset.StandardCharsets.UTF_8)
            + "&fromDate=" + java.net.URLEncoder.encode(fromDate, java.nio.charset.StandardCharsets.UTF_8)
            + "&toDate=" + java.net.URLEncoder.encode(toDate, java.nio.charset.StandardCharsets.UTF_8)
            + "&sortBy=" + java.net.URLEncoder.encode(sortBy, java.nio.charset.StandardCharsets.UTF_8);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>View Training Report</title>
    <link rel="stylesheet" href="<%=ctx%>/css/TraningDepartment.css"/>
    <style>
        .filter-form {
            background: rgba(255, 255, 255, 0.6);
            padding: 15px;
            border-radius: 8px;
            display: flex;
            gap: 15px;
            align-items: flex-end;
            flex-wrap: wrap;
            margin-bottom: 20px;
            border: 1px solid var(--line);
        }
        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .filter-group label {
            font-size: 12px;
            font-weight: bold;
            color: var(--ink);
        }
        .filter-group input,
        .filter-group select {
            padding: 10px;
            border: 1px solid var(--line);
            border-radius: 6px;
            font-size: 14px;
            min-width: 170px;
            background: #fff;
        }
        .btn-submit {
            padding: 10px 20px;
            background-color: var(--orange);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
        }
        .btn-submit:hover { background-color: var(--orange-dark); }
        .btn-reset {
            padding: 10px 20px;
            background-color: #f1d2ad;
            color: var(--ink);
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
        }
        .table-container {
            background: #fff;
            border-radius: 12px;
            overflow: auto;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            border: 1px solid var(--line);
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 960px;
        }
        .data-table th,
        .data-table td {
            padding: 12px 14px;
            text-align: left;
            border-bottom: 1px solid var(--line);
            font-size: 14px;
        }
        .data-table th {
            background-color: var(--orange-soft);
            color: var(--orange-dark);
            font-weight: bold;
            white-space: nowrap;
        }
        .data-table tr:hover { background-color: #fafafa; }
        .link-detail {
            color: var(--orange-dark);
            font-weight: 700;
            text-decoration: none;
        }
        .link-detail:hover { text-decoration: underline; }
        .badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            background-color: #eee;
            display: inline-block;
        }
        .badge.approved { background-color: #d4edda; color: #155724; }
        .badge.pending { background-color: #fff3cd; color: #856404; }
        .badge.rejected { background-color: #f8d7da; color: #721c24; }
        .badge.draft { background-color: #e2e8f0; color: #334155; }
        .empty-row { text-align: center; color: var(--muted); padding: 28px !important; }
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
        .export-bar {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 14px;
        }
        .btn-export {
            padding: 9px 14px;
            background: var(--white);
            border: 1px solid var(--line);
            color: var(--orange-dark);
            text-decoration: none;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 700;
        }
        .btn-export:hover { border-color: var(--orange); }
        @media print {
            .topbar, .filter-form, .export-bar, .footer, .toolbar-note, .link-detail, .page-nav { display: none !important; }
            .data-table a { color: #000; text-decoration: none; }
        }
    </style>
    <% if (isPrint) { %>
    <script>window.addEventListener('load', function () { window.print(); });</script>
    <% } %>
</head>
<body>
<%@ include file="header.jsp" %>
<main class="page">


    <section class="content" style="padding: 30px clamp(18px, 5vw, 64px);">
        <nav class="page-nav" aria-label="Điều hướng">
            <div class="breadcrumb">
                <a href="<%=ctx%>/home">Home</a>
                <span class="sep">›</span>
                <span class="current">View Training Report</span>
            </div>
            <a class="btn-back-nav" href="<%=ctx%>/home" id="btnBackPrevious">← Quay lại trang trước</a>
        </nav>

        <div class="welcome" style="margin-bottom: 24px;">
            <h1>View Training Report</h1>
            <p>View, search, and filter reports of courses that were created or modified. Read-only.</p>
        </div>

        <p class="toolbar-note">
            Search by Course ID/Name · Filter by status &amp; date · Sort by Created / Last Modified · Export Excel / PDF.
        </p>

        <div class="export-bar">
            <a class="btn-export" href="<%=ctx%>/view-training-report?<%=qs%>&amp;export=excel">Export Excel</a>
            <a class="btn-export" href="<%=ctx%>/view-training-report?<%=qs%>&amp;export=csv">Export CSV</a>
            <a class="btn-export" target="_blank" href="<%=ctx%>/view-training-report?<%=qs%>&amp;export=print">Export PDF (Print)</a>
        </div>

        <form class="filter-form" method="get" action="<%=ctx%>/view-training-report">
            <div class="filter-group">
                <label for="keyword">Course ID / Name</label>
                <input id="keyword" type="text" name="keyword" value="<%= keyword %>"
                       placeholder="Code or name..."/>
            </div>
            <div class="filter-group">
                <label for="status">Status</label>
                <select id="status" name="status">
                    <option value="" <%= status.isEmpty() ? "selected" : "" %>>All</option>
                    <option value="Draft" <%= "Draft".equalsIgnoreCase(status) ? "selected" : "" %>>Draft</option>
                    <option value="Pending" <%= "Pending".equalsIgnoreCase(status) ? "selected" : "" %>>Pending</option>
                    <option value="Approved" <%= "Approved".equalsIgnoreCase(status) ? "selected" : "" %>>Approved</option>
                    <option value="Rejected" <%= "Rejected".equalsIgnoreCase(status) ? "selected" : "" %>>Rejected</option>
                </select>
            </div>
            <div class="filter-group">
                <label for="fromDate">From date</label>
                <input id="fromDate" type="date" name="fromDate" value="<%= fromDate %>"/>
            </div>
            <div class="filter-group">
                <label for="toDate">To date</label>
                <input id="toDate" type="date" name="toDate" value="<%= toDate %>"/>
            </div>
            <div class="filter-group">
                <label for="sortBy">Sort by</label>
                <select id="sortBy" name="sortBy">
                    <option value="lastModifiedDate" <%= "lastModifiedDate".equalsIgnoreCase(sortBy) ? "selected" : "" %>>
                        Last Modified Date
                    </option>
                    <option value="createdDate" <%= "createdDate".equalsIgnoreCase(sortBy) ? "selected" : "" %>>
                        Created Date
                    </option>
                </select>
            </div>
            <button type="submit" class="btn-submit">Search / Filter</button>
            <a class="btn-reset" href="<%=ctx%>/view-training-report">Reset</a>
            <a class="btn-reset" href="<%=ctx%>/home">Back to Home</a>
        </form>

        <div class="table-container">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Report ID</th>
                    <th>Course ID</th>
                    <th>Course Name</th>
                    <th>Created By</th>
                    <th>Last Modified By</th>
                    <th>Created Date</th>
                    <th>Last Modified Date</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <% if (reports == null || reports.isEmpty()) { %>
                <tr>
                    <td class="empty-row" colspan="8">No training reports found.</td>
                </tr>
                <% } else {
                    for (ViewTrainingReport r : reports) {
                        String st = r.getStatus() == null ? "" : r.getStatus();
                        String badgeCls = "draft";
                        if ("Approved".equalsIgnoreCase(st)) badgeCls = "approved";
                        else if ("Pending".equalsIgnoreCase(st)) badgeCls = "pending";
                        else if ("Rejected".equalsIgnoreCase(st)) badgeCls = "rejected";
                %>
                <tr>
                    <td>
                        <a class="link-detail"
                           href="<%=ctx%>/view-training-report?action=detail&amp;reportId=<%= r.getReportId() %>">
                            #<%= r.getReportId() %>
                        </a>
                    </td>
                    <td><strong><%= r.getCourseCode() != null ? r.getCourseCode() : r.getCourseId() %></strong></td>
                    <td><%= r.getCourseName() != null ? r.getCourseName() : "" %></td>
                    <td><%= r.getCreatedBy() != null ? r.getCreatedBy() : "-" %></td>
                    <td><%= r.getModifiedBy() != null ? r.getModifiedBy() : "-" %></td>
                    <td><%= r.getCreatedDate() != null ? df.format(r.getCreatedDate()) : "-" %></td>
                    <td><%= r.getLastModifiedDate() != null ? df.format(r.getLastModifiedDate()) : "-" %></td>
                    <td><span class="badge <%= badgeCls %>"><%= st.isEmpty() ? "-" : st %></span></td>
                </tr>
                <%  }
                   } %>
                </tbody>
            </table>
        </div>
    </section>


</main>
<%@ include file="footer.jsp" %>
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
