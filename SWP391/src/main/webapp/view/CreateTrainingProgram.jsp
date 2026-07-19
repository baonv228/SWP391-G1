<%@page import="model.TrainingProgram"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    TrainingProgram program = (TrainingProgram) request.getAttribute("program");

    if (program == null) {
        program = new TrainingProgram();
        program.setStatus("Active");
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Create Department</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/CreateTrainingProgram.css" />
    </head>
    <body>
        <main class="create-page">
            <header class="page-header">
                <a class="back-link" href="<%=request.getContextPath()%>/training-program?action=list">Back to list</a>
                <h1>Department Management System</h1>
            </header>

            <section class="create-shell">
                <div class="section-title">
                    <span>Department</span>
                    <strong>Create Department</strong>
                </div>

                <% if (error != null) { %>
                <div class="error"><%= error %></div>
                <% } %>

                <form id="createTrainingProgramForm" method="post" action="<%=request.getContextPath()%>/training-program" onsubmit="return validateCreateForm();">
                    <input type="hidden" name="action" value="create" />

                    <section class="tab-panel active">
                        <div class="form-grid">
                            <label>
                                <span>Major Name</span>
                                <input name="majorName" value="<%= program.getMajorName() != null ? program.getMajorName() : "" %>" placeholder="Software Engineering" required />
                            </label>
                            <label>
                                <span>Major Code</span>
                                <input name="programCode" value="<%= program.getProgramCode() != null ? program.getProgramCode() : "" %>" placeholder="SE" maxlength="50" required />
                            </label>
                            <label class="span-2">
                                <span>Program Name</span>
                                <input name="programName" value="<%= program.getProgramName() != null ? program.getProgramName() : "" %>" placeholder="Software Engineering" required />
                            </label>
                            <label class="span-2">
                                <span>Purpose</span>
                                <textarea name="description" rows="5" placeholder="Describe the department purpose" required><%= program.getDescription() != null ? program.getDescription() : "" %></textarea>
                            </label>
                        </div>
                    </section>

                    <div class="form-actions">
                        <a class="ghost-button" href="<%=request.getContextPath()%>/training-program?action=list">Cancel</a>
                        <button class="submit-button" type="submit">Create Department</button>
                    </div>
                </form>
            </section>
        </main>

        <script>
            function validateCreateForm() {
                const form = document.getElementById("createTrainingProgramForm");
                if (!form.checkValidity()) {
                    form.reportValidity();
                    return false;
                }
                return confirm("Are you sure you want to create this Department?");
            }
        </script>
    </body>
</html>
