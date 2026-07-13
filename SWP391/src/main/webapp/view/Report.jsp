<%@page import="model.User"%>
<%@page import="model.TrainingReportStats"%>
<%@page import="model.CourseReportItem"%>
<%@page import="model.TrainingProgram"%>
<%@page import="controller.ReportServlet.ReportFilter"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
    private String e(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    private String date(java.sql.Timestamp value) {
        return value == null ? "-" : value.toLocalDateTime().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
%>
<%
    User currentUser = (User) session.getAttribute("user");
    String roleName = (String) session.getAttribute("roleName");
    if (roleName == null && currentUser != null && currentUser.getRole() != null) {
        roleName = currentUser.getRole().getRoleName();
        session.setAttribute("roleName", roleName);
    }
    boolean allowed = roleName != null && ("Training Department".equalsIgnoreCase(roleName.trim()) || "TrainingDepartment".equalsIgnoreCase(roleName.trim()));
    if (currentUser == null || !allowed) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    TrainingReportStats stats = (TrainingReportStats) request.getAttribute("stats");
    List<CourseReportItem> reportItems = (List<CourseReportItem>) request.getAttribute("reportItems");
    List<TrainingProgram> programs = (List<TrainingProgram>) request.getAttribute("programs");
    ReportFilter filter = (ReportFilter) request.getAttribute("filter");
    String keyword = filter == null || filter.getKeyword() == null ? "" : filter.getKeyword();
    String program = filter == null || filter.getProgramFilter() == null ? "" : filter.getProgramFilter();
    String status = filter == null || filter.getStatus() == null ? "" : filter.getStatus();
    String fromDate = filter == null || filter.getFromDate() == null ? "" : filter.getFromDate();
    String toDate = filter == null || filter.getToDate() == null ? "" : filter.getToDate();
    String sort = filter == null || filter.getSort() == null ? "modified_desc" : filter.getSort();
%>
<!DOCTYPE html>
<html lang="en"><head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Training Reports | TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/TraningDepartment.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/theme-orange.css">
    <style>
        .report-header,.report-actions,.filter-form{display:flex;gap:12px;align-items:end;flex-wrap:wrap}.report-header{justify-content:space-between;align-items:center;margin-bottom:20px}.report-actions{align-items:center}.dashboard-cards{display:grid;grid-template-columns:repeat(4,minmax(150px,1fr));gap:14px;margin-bottom:24px}.card,.table-container{background:#fff;border:1px solid var(--line);border-radius:8px;box-shadow:0 6px 20px rgba(199,107,18,.08)}.card{padding:16px}.card-title{font-size:12px;color:var(--muted);text-transform:uppercase}.card-value{font-size:26px;font-weight:800;color:var(--orange-dark);margin-top:6px}.filter-form{padding:16px;margin-bottom:18px;background:#fff;border:1px solid var(--line);border-radius:8px}.filter-group{display:flex;flex-direction:column;gap:5px}.filter-group label{font-size:12px;font-weight:700}.filter-group input,.filter-group select{height:38px;min-width:145px;padding:7px;border:1px solid var(--line);border-radius:5px;background:#fff}.button{display:inline-flex;align-items:center;justify-content:center;min-height:38px;padding:8px 12px;border:1px solid var(--orange);border-radius:5px;background:var(--orange);color:#fff;text-decoration:none;font-weight:700;cursor:pointer}.button.secondary{background:#fff;color:var(--orange-dark)}.button.pdf{background:#b84b2a;border-color:#b84b2a}.table-container{overflow:auto}.data-table{width:100%;border-collapse:collapse;min-width:1020px}.data-table th,.data-table td{padding:12px;border-bottom:1px solid var(--line);text-align:left;vertical-align:top;font-size:13px}.data-table th{background:var(--orange-soft);color:var(--orange-dark);white-space:nowrap}.badge{display:inline-block;padding:4px 8px;border-radius:12px;background:#fff1df;color:#9a510d;font-weight:700;font-size:12px}.badge.approved{background:#e1f4e4;color:#26633b}.empty{text-align:center;color:var(--muted);padding:28px!important}@media(max-width:800px){.dashboard-cards{grid-template-columns:repeat(2,1fr)}.report-header{align-items:flex-start}.content{width:min(100% - 24px,1120px)}}
    </style>
</head><body><main class="page">
    <header class="topbar"><div class="brand">Training Program Management System</div><div class="profile"><span class="avatar">TD</span><span>Training Department</span></div></header>
    <section class="content">
        <div class="report-header"><div class="welcome" style="margin:0"><h1>View Training Report</h1><p>Review created and updated course syllabus reports.</p></div><div class="report-actions"><a class="button secondary" href="<%=request.getContextPath()%>/report?<%= request.getQueryString() == null ? "" : e(request.getQueryString()).replace("action=export-excel", "") %>&action=export-excel">Export Excel</a><a class="button pdf" href="<%=request.getContextPath()%>/report?<%= request.getQueryString() == null ? "" : e(request.getQueryString()).replace("action=export-pdf", "") %>&action=export-pdf">Export PDF</a></div></div>
        <% if (stats != null) { %><div class="dashboard-cards"><div class="card"><div class="card-title">Programs</div><div class="card-value"><%=stats.getTotalPrograms()%></div></div><div class="card"><div class="card-title">Curriculums</div><div class="card-value"><%=stats.getTotalCurriculums()%></div></div><div class="card"><div class="card-title">Subjects</div><div class="card-value"><%=stats.getTotalSubjects()%></div></div><div class="card"><div class="card-title">Syllabus Versions</div><div class="card-value"><%=stats.getTotalSyllabuses()%></div></div></div><% } %>
        <form action="<%=request.getContextPath()%>/report" class="filter-form" method="get">
            <div class="filter-group"><label for="searchKeyword">Course</label><input id="searchKeyword" name="searchKeyword" value="<%=e(keyword)%>" placeholder="Code or name"></div>
            <div class="filter-group"><label for="programFilter">Program</label><select id="programFilter" name="programFilter"><option value="">All programs</option><% if(programs != null) for(TrainingProgram p:programs){ %><option value="<%=p.getProgramId()%>" <%=program.equals(String.valueOf(p.getProgramId()))?"selected":""%>><%=e(p.getProgramCode())%> - <%=e(p.getProgramName())%></option><% } %></select></div>
            <div class="filter-group"><label for="status">Status</label><select id="status" name="status"><option value="">All statuses</option><% for(String option:new String[]{"Draft","Pending","Approved","Rejected"}){ %><option value="<%=option%>" <%=status.equalsIgnoreCase(option)?"selected":""%>><%=option%></option><% } %></select></div>
            <div class="filter-group"><label for="fromDate">From date</label><input id="fromDate" type="date" name="fromDate" value="<%=e(fromDate)%>"></div><div class="filter-group"><label for="toDate">To date</label><input id="toDate" type="date" name="toDate" value="<%=e(toDate)%>"></div>
            <div class="filter-group"><label for="sort">Sort</label><select id="sort" name="sort"><option value="modified_desc" <%=sort.equals("modified_desc")?"selected":""%>>Last modified: newest</option><option value="modified_asc" <%=sort.equals("modified_asc")?"selected":""%>>Last modified: oldest</option><option value="created_desc" <%=sort.equals("created_desc")?"selected":""%>>Created: newest</option><option value="created_asc" <%=sort.equals("created_asc")?"selected":""%>>Created: oldest</option></select></div>
            <button class="button" type="submit">Apply</button><a class="button secondary" href="<%=request.getContextPath()%>/report">Reset</a>
        </form>
        <div class="table-container"><table class="data-table"><thead><tr><th>Report ID</th><th>Course</th><th>Curriculum</th><th>Created by</th><th>Last modified</th><th>Status</th><th>Type</th><th>Review</th><th></th></tr></thead><tbody>
        <% if(reportItems != null && !reportItems.isEmpty()) for(CourseReportItem item:reportItems){ String statusClass="Approved".equalsIgnoreCase(item.getSyllabusStatus())?"approved":""; %><tr><td>#<%=item.getReportId()%></td><td><strong><%=e(item.getSubjectCode())%></strong><br><%=e(item.getSubjectName())%></td><td><%=e(item.getAssociatedCurriculums())%></td><td><%=e(item.getCreatedBy())%><br><small><%=date(item.getCreatedDate())%></small></td><td><%=e(item.getModifiedBy())%><br><small><%=date(item.getLastModifiedDate())%></small></td><td><span class="badge <%=statusClass%>"><%=e(item.getSyllabusStatus())%></span></td><td><%=e(item.getReportType())%><br><small>v<%=e(item.getVersionNo())%></small></td><td><%=e(item.getReviewer())%><br><small><%=date(item.getReviewDate())%></small></td><td><a class="button secondary" href="<%=request.getContextPath()%>/report?action=detail&id=<%=item.getReportId()%>">Details</a></td></tr><% } else { %><tr><td class="empty" colspan="9">No reports match the selected criteria.</td></tr><% } %>
        </tbody></table></div>
    </section>
</main></body></html>
