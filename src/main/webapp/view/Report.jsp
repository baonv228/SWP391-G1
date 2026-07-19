<%@page import="model.User"%>
<%@page import="model.TrainingReportStats"%>
<%@page import="model.CourseReportItem"%>
<%@page import="model.TrainingProgram"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User currentUser = (User) session.getAttribute("user");
    String roleName = (String) session.getAttribute("roleName");
    if (roleName == null && currentUser != null && currentUser.getRole() != null) {
        roleName = currentUser.getRole().getRoleName();
        session.setAttribute("roleName", roleName);
    }

    if (currentUser == null || roleName == null || !"Training Department".equalsIgnoreCase(roleName.trim())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String displayName = currentUser.getFullName();
    if (displayName == null || displayName.isBlank()) {
        displayName = currentUser.getEmail();
    }

    TrainingReportStats stats = (TrainingReportStats) request.getAttribute("stats");
    List<CourseReportItem> reportItems = (List<CourseReportItem>) request.getAttribute("reportItems");
    List<TrainingProgram> programs = (List<TrainingProgram>) request.getAttribute("programs");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    String programFilter = (String) request.getAttribute("programFilter");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Training Report Dashboard</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/TraningDepartment.css" />
        <style>
            .dashboard-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }
            .card {
                background: #fff;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                border-left: 5px solid var(--orange);
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                transition: transform 0.2s ease;
            }
            .card:hover {
                transform: translateY(-5px);
            }
            .card-title {
                font-size: 14px;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 10px;
            }
            .card-value {
                font-size: 32px;
                font-weight: bold;
                color: var(--orange-dark);
            }
            .filter-form {
                background: rgba(255, 255, 255, 0.6);
                padding: 15px;
                border-radius: 8px;
                display: flex;
                gap: 15px;
                align-items: flex-end;
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
            .filter-group input, .filter-group select {
                padding: 10px;
                border: 1px solid var(--line);
                border-radius: 6px;
                font-size: 14px;
                min-width: 200px;
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
                transition: background 0.2s;
            }
            .btn-submit:hover {
                background-color: var(--orange-dark);
            }
            .btn-reset {
                padding: 10px 20px;
                background-color: #f1d2ad;
                color: var(--ink);
                text-decoration: none;
                border-radius: 6px;
                font-size: 14px;
                font-weight: bold;
                text-align: center;
                transition: background 0.2s;
            }
            .btn-reset:hover {
                background-color: #d1b18c;
            }
            .table-container {
                background: #fff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                border: 1px solid var(--line);
            }
            .data-table {
                width: 100%;
                border-collapse: collapse;
            }
            .data-table th, .data-table td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid var(--line);
            }
            .data-table th {
                background-color: var(--orange-soft);
                color: var(--orange-dark);
                font-weight: bold;
            }
            .data-table tr:hover {
                background-color: #fafafa;
            }
            .badge {
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
                background-color: #eee;
            }
            .badge.approved { background-color: #d4edda; color: #155724; }
            .badge.pending { background-color: #fff3cd; color: #856404; }
            .badge.nosyllabus { background-color: #f8d7da; color: #721c24; }
        </style>
    </head>
    <body>
        <main class="page">
            <header class="topbar">
                <div class="brand">Training Program Management System</div>
                <div class="top-actions" aria-label="Tài khoản">
                    <button class="icon-button" type="button" aria-label="Thông báo">
                        <svg viewBox="0 0 24 24" aria-hidden="true" width="20" height="20">
                            <path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9"></path>
                            <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                        </svg>
                    </button>
                    <div class="profile" title="<%= displayName %>">
                        <span class="avatar">TD</span>
                        <span>Training Department</span>
                    </div>
                </div>
            </header>

            <section class="content" style="padding: 30px clamp(18px, 5vw, 64px);">
                <div class="welcome" style="margin-bottom: 30px;">
                    <h1>Training Report Dashboard</h1>
                    <p>Overview of system statistics and detailed course list.</p>
                </div>
                
                <% if (stats != null) { %>
                <div class="dashboard-cards">
                    <div class="card">
                        <div class="card-title">Training Programs</div>
                        <div class="card-value"><%= stats.getTotalPrograms() %></div>
                    </div>
                    <div class="card">
                        <div class="card-title">Curriculums</div>
                        <div class="card-value"><%= stats.getTotalCurriculums() %></div>
                    </div>
                    <div class="card">
                        <div class="card-title">Subjects</div>
                        <div class="card-value"><%= stats.getTotalSubjects() %></div>
                    </div>
                    <div class="card">
                        <div class="card-title">Syllabuses</div>
                        <div class="card-value"><%= stats.getTotalSyllabuses() %></div>
                    </div>
                </div>
                <% } %>
                
                <form action="<%=request.getContextPath()%>/report" method="GET" class="filter-form">
                    <div class="filter-group">
                        <label for="searchKeyword">Search Subject</label>
                        <input type="text" id="searchKeyword" name="searchKeyword" 
                               value="<%= searchKeyword != null ? searchKeyword : "" %>" 
                               placeholder="Code or Name...">
                    </div>
                    <div class="filter-group">
                        <label for="programFilter">Filter by Program</label>
                        <select id="programFilter" name="programFilter">
                            <option value="">-- All Programs --</option>
                            <% if (programs != null) { 
                                for (TrainingProgram p : programs) { %>
                                <option value="<%= p.getProgramId() %>" 
                                        <%= (programFilter != null && programFilter.equals(String.valueOf(p.getProgramId()))) ? "selected" : "" %>>
                                    <%= p.getProgramCode() %> - <%= p.getProgramName() %>
                                </option>
                            <%  } 
                               } %>
                        </select>
                    </div>
                    <button type="submit" class="btn-submit">Filter</button>
                    <a href="<%=request.getContextPath()%>/report" class="btn-reset">Reset</a>
                </form>

                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Subject Code</th>
                                <th>Subject Name</th>
                                <th>Credits</th>
                                <th>Associated Programs</th>
                                <th>Syllabus Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (reportItems != null && !reportItems.isEmpty()) { 
                                for (CourseReportItem item : reportItems) { 
                                    String statusCls = "nosyllabus";
                                    String status = item.getSyllabusStatus();
                                    if ("Approved".equalsIgnoreCase(status) || "Active".equalsIgnoreCase(status)) statusCls = "approved";
                                    else if (!"No Syllabus".equalsIgnoreCase(status)) statusCls = "pending";
                            %>
                            <tr>
                                <td><strong><%= item.getSubjectCode() %></strong></td>
                                <td><%= item.getSubjectName() %></td>
                                <td><%= item.getCredits() %></td>
                                <td style="max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" 
                                    title="<%= item.getAssociatedPrograms() != null ? item.getAssociatedPrograms() : "None" %>">
                                    <%= item.getAssociatedPrograms() != null ? item.getAssociatedPrograms() : "<em style='color:#ccc'>None</em>" %>
                                </td>
                                <td><span class="badge <%= statusCls %>"><%= status %></span></td>
                            </tr>
                            <%  } 
                               } else { %>
                            <tr>
                                <td colspan="5" style="text-align: center; color: var(--muted); padding: 30px;">
                                    No courses found matching your criteria.
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </body>
</html>
