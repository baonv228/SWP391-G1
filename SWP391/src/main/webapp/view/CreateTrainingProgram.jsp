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
        <title>Create Training Program</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/CreateTrainingProgram.css" />
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/theme-orange.css" />
</head>
    <body>
        <main class="create-page">
            <header class="page-header">
                <a class="back-link" href="<%=request.getContextPath()%>/training-program?action=list">Back to list</a>
                <h1>Training Program Management System</h1>
            </header>

            <section class="create-shell">
                <div class="section-title">
                    <span>Training Program</span>
                    <strong>Create Training Program</strong>
                </div>

                <% if (error != null) { %>
                <div class="error"><%= error %></div>
                <% } %>

                <form id="createTrainingProgramForm" method="post" action="<%=request.getContextPath()%>/training-program" onsubmit="return validateCreateForm();">
                    <input type="hidden" name="action" value="create" />

                    <section class="tab-panel active">
                        <div class="form-grid">
                            <label>
                                <span>Tên ngành</span>
                                <input name="majorName" value="<%= program.getMajorName() != null ? program.getMajorName() : "" %>" placeholder="Kỹ thuật phần mềm" required />
                            </label>
                            <label>
                                <span>Mã ngành</span>
                                <input name="programCode" value="<%= program.getProgramCode() != null ? program.getProgramCode() : "" %>" placeholder="SE" maxlength="50" required />
                            </label>
                            <label class="span-2">
                                <span>Tên chương trình</span>
                                <input name="programName" value="<%= program.getProgramName() != null ? program.getProgramName() : "" %>" placeholder="Software Engineering" required />
                            </label>
                            <label class="span-2">
                                <span>Mục đích</span>
                                <textarea name="description" rows="5" placeholder="Mô tả mục đích của chương trình đào tạo" required><%= program.getDescription() != null ? program.getDescription() : "" %></textarea>
                            </label>
                        </div>
                    </section>

                    <div class="form-actions">
                        <a class="ghost-button" href="<%=request.getContextPath()%>/training-program?action=list">Cancel</a>
                        <button class="submit-button" type="submit">Create Training Program</button>
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
                return confirm("Bạn có chắc chắn muốn tạo Training Program này không?");
            }
        </script>
    </body>
</html>