<%@page import="java.util.List"%>
<%@page import="model.TrainingProgram"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<TrainingProgram> programs = (List<TrainingProgram>) request.getAttribute("programs");
    String programCode = (String) request.getAttribute("programCode");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalItems = (Integer) request.getAttribute("totalItems");
    TrainingProgram selectedProgram = (TrainingProgram) request.getAttribute("program");

    if (programCode == null) {
        programCode = "";
    }
    if (currentPage == null) {
        currentPage = 1;
    }
    if (totalPages == null) {
        totalPages = 1;
    }
    if (totalItems == null) {
        totalItems = 0;
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Training Program Management System</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/ListTrainingProgram.css" />
    </head>
    <body>
        <main class="tp-page">
            <header class="tp-header">
                <a class="back-link" href="<%=request.getContextPath()%>/home">← Home</a>
                <h1>Training Program Management System</h1>
            </header>

            <section class="toolbar" aria-label="Training program filters">
                <div>
                    <h2>Training Program</h2>
                    <p>Search by program code such as SE, GD, KT.</p>
                </div>

                <form class="search-form" method="get" action="<%=request.getContextPath()%>/training-program">
                    <input type="hidden" name="action" value="list" />
                    <label for="programCode">Mã ngành</label>
                    <div class="search-row">
                        <input id="programCode" name="programCode" value="<%= programCode %>" placeholder="SE, GD, KT..." />
                        <button type="submit">Apply</button>
                    </div>
                </form>

                <a class="create-button" href="<%=request.getContextPath()%>/training-program?action=create">Create Training Program</a>
            </section>

            <% if (selectedProgram != null) { %>
            <section class="detail-panel">
                <div>
                    <span class="detail-label">Chi tiết</span>
                    <h3><%= selectedProgram.getMajorName() != null && !selectedProgram.getMajorName().isBlank() ? selectedProgram.getMajorName() : selectedProgram.getProgramName() %></h3>
                </div>
                <dl>
                    <dt>Mã ngành</dt>
                    <dd><%= selectedProgram.getProgramCode() != null ? selectedProgram.getProgramCode() : "" %></dd>
                    <dt>Năm học</dt>
                    <dd><%= selectedProgram.getAcademicYear() != null ? selectedProgram.getAcademicYear() : "" %></dd>
                    <dt>Tên chương trình</dt>
                    <dd><%= selectedProgram.getProgramName() != null ? selectedProgram.getProgramName() : "" %></dd>
                    <dt>Trạng thái</dt>
                    <dd><%= selectedProgram.getStatus() != null ? selectedProgram.getStatus() : "" %></dd>
                </dl>
            </section>
            <% } %>

            <section class="table-section">
                <table>
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Chuyên ngành</th>
                            <th>Mã ngành</th>
                            <th>Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (programs == null || programs.isEmpty()) { %>
                        <tr>
                            <td colspan="4" class="empty">Không có training program phù hợp.</td>
                        </tr>
                        <% } else {
                            int index = (currentPage - 1) * 10 + 1;
                            for (TrainingProgram program : programs) {
                        %>
                        <tr>
                            <td><%= index++ %></td>
                            <td><%= program.getMajorName() != null && !program.getMajorName().isBlank() ? program.getMajorName() : program.getProgramName() %></td>
                            <td><%= program.getProgramCode() != null ? program.getProgramCode() : "" %></td>
                            <td>
                                <a class="detail-link" href="<%=request.getContextPath()%>/training-program?action=detail&id=<%= program.getProgramId() %>">chi tiết</a>
                            </td>
                        </tr>
                        <%  }
                        } %>
                    </tbody>
                </table>
            </section>

            <nav class="pagination" aria-label="Pagination">
                <% for (int i = 1; i <= totalPages; i++) { %>
                <a class="<%= i == currentPage ? "active" : "" %>"
                   href="<%=request.getContextPath()%>/training-program?action=list&programCode=<%= java.net.URLEncoder.encode(programCode, "UTF-8") %>&page=<%= i %>"><%= i %></a>
                <% } %>
                <span>/ <%= totalPages %></span>
            </nav>

            <div class="summary">Total: <%= totalItems %> training program(s)</div>
        </main>
    </body>
</html>
