<%@page import="java.util.List"%>
<%@page import="model.TrainingProgram"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<TrainingProgram> programs = (List<TrainingProgram>) request.getAttribute("programs");
    List<TrainingProgram> programOptions = (List<TrainingProgram>) request.getAttribute("programOptions");
    String selectedProgramCode = (String) request.getAttribute("selectedProgramCode");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalItems = (Integer) request.getAttribute("totalItems");
    TrainingProgram selectedProgram = (TrainingProgram) request.getAttribute("program");

    if (selectedProgramCode == null) {
        selectedProgramCode = "";
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
        <title>Department Management System</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/ListTrainingProgram.css" />
    </head>
    <body>
        <main class="tp-page">
            <header class="tp-header">
                <a class="back-link" href="<%=request.getContextPath()%>/home">Home</a>
                <h1>Department Management System</h1>
            </header>

            <section class="toolbar" aria-label="Department filters">
                <div>
                    <h2>Department</h2>
                </div>

                <form class="search-form" method="get" action="<%=request.getContextPath()%>/training-program">
                    <input type="hidden" name="action" value="list" />
                    <label for="programCode">Major Code</label>
                    <div class="search-row">
                        <select id="programCode" name="programCode">
                            <option value="">All Program Codes</option>
                            <% if (programOptions != null) {
                                for (TrainingProgram option : programOptions) {
                                    String code = option.getProgramCode() != null ? option.getProgramCode() : "";
                                    boolean selected = selectedProgramCode.equalsIgnoreCase(code);
                                    String optionName = option.getMajorName() != null && !option.getMajorName().isBlank()
                                            ? option.getMajorName()
                                            : option.getProgramName();
                                    String optionLabel = code + " - " + (optionName != null ? optionName : "");
                            %>
                            <option value="<%= code %>" <%= selected ? "selected" : "" %>><%= optionLabel %></option>
                            <%  }
                            } %>
                        </select>
                        <button type="submit">Apply</button>
                    </div>
                </form>

                <a class="create-button" href="<%=request.getContextPath()%>/training-program?action=create">Create Department</a>
            </section>

            <% if (selectedProgram != null) { %>
            <section class="detail-panel">
                <div>
                    <span class="detail-label">Detail</span>
                    <h3><%= selectedProgram.getMajorName() != null && !selectedProgram.getMajorName().isBlank() ? selectedProgram.getMajorName() : selectedProgram.getProgramName() %></h3>
                </div>
                <dl>
                    <dt>Program ID</dt>
                    <dd><%= selectedProgram.getProgramId() %></dd>
                    <dt>Major Code</dt>
                    <dd><%= selectedProgram.getProgramCode() != null ? selectedProgram.getProgramCode() : "" %></dd>
                    <dt>Program Name</dt>
                    <dd><%= selectedProgram.getProgramName() != null ? selectedProgram.getProgramName() : "" %></dd>
                    <dt>Status</dt>
                    <dd><%= selectedProgram.getStatus() != null ? selectedProgram.getStatus() : "" %></dd>
                </dl>
            </section>
            <% } %>

            <section class="table-section">
                <table>
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Major</th>
                            <th>Major Code</th>
                            <th>Detail</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (programs == null || programs.isEmpty()) { %>
                        <tr>
                            <td colspan="4" class="empty">No matching department.</td>
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
                                <a class="detail-link" href="<%=request.getContextPath()%>/training-program?action=detail&id=<%= program.getProgramId() %>">Detail</a>
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
                   href="<%=request.getContextPath()%>/training-program?action=list&programCode=<%= java.net.URLEncoder.encode(selectedProgramCode, "UTF-8") %>&page=<%= i %>"><%= i %></a>
                <% } %>
                <span>/ <%= totalPages %></span>
            </nav>

            <div class="summary">Total: <%= totalItems %> department(s)</div>
        </main>
    </body>
</html>
