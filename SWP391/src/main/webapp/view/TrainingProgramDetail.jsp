<%@page import="java.util.List"%>
<%@page import="model.Curriculum"%>
<%@page import="model.TrainingProgram"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    TrainingProgram program = (TrainingProgram) request.getAttribute("program");
    List<Curriculum> curriculums = (List<Curriculum>) request.getAttribute("curriculums");

    String majorName = "";
    String programCode = "";
    String programName = "";
    String description = "";
    String status = "";

    if (program != null) {
        majorName = program.getMajorName() != null ? program.getMajorName() : "";
        programCode = program.getProgramCode() != null ? program.getProgramCode() : "";
        programName = program.getProgramName() != null ? program.getProgramName() : "";
        description = program.getDescription() != null ? program.getDescription() : "";
        status = program.getStatus() != null ? program.getStatus() : "";
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Department Detail</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/TrainingProgramDetail.css" />
    </head>
    <body>
        <main class="detail-page">
            <header class="page-header">
                <a class="back-link" href="<%=request.getContextPath()%>/training-program?action=list">Back</a>
                <h1>Department Management System</h1>
            </header>

            <section class="detail-toolbar">
                <div>
                    <h2>Department Detail</h2>
                    <p><%= programName.isBlank() ? "Department overview" : programName %></p>
                </div>
                <div class="toolbar-actions">
                    <span class="count-pill">(<%= curriculums != null ? curriculums.size() : 0 %>)</span>
                    <a class="create-button" href="<%=request.getContextPath()%>/curriculum-manage?action=create&programId=<%= program != null ? program.getProgramId() : 0 %>">Create curriculum</a>
                </div>
            </section>

            <section class="program-card" aria-label="Department information">
                <dl>
                    <div>
                        <dt>Major Name</dt>
                        <dd><%= majorName %></dd>
                    </div>
                    <div>
                        <dt>Major Code</dt>
                        <dd><%= programCode %></dd>
                    </div>
                    <div>
                        <dt>Program Name</dt>
                        <dd><%= programName %></dd>
                    </div>
                    <div>
                        <dt>Status</dt>
                        <dd><span class="status-pill"><%= status %></span></dd>
                    </div>
                    <div class="wide">
                        <dt>Purpose</dt>
                        <dd><%= description %></dd>
                    </div>
                </dl>
            </section>

            <section class="curriculum-section" aria-label="Curriculum list">
                <table>
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Total credit</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (curriculums == null || curriculums.isEmpty()) { %>
                        <tr>
                            <td class="empty" colspan="5">Chưa có curriculum cho department này.</td>
                        </tr>
                        <% } else {
                            int index = 1;
                            for (Curriculum curriculum : curriculums) {
                                String curriculumName = curriculum.getCurriculumName() != null ? curriculum.getCurriculumName() : "";
                                String curriculumDescription = curriculum.getDescription() != null ? curriculum.getDescription() : "";
                                String code = curriculum.getProgramCode() != null ? curriculum.getProgramCode() : programCode;
                        %>
                        <tr>
                            <td><%= index++ %></td>
                            <td><%= code %></td>
                            <td>
                                <a class="curriculum-link" href="<%=request.getContextPath()%>/curriculum/detail?curriculumId=<%= curriculum.getCurriculumId() %>"><%= curriculumName %></a>
                            </td>
                            <td><%= curriculumDescription %></td>
                            <td><%= curriculum.getTotalCredits() %></td>
                        </tr>
                        <%  }
                        } %>
                    </tbody>
                </table>
            </section>
        </main>
    </body>
</html>
