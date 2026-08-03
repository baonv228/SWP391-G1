<%@page import="java.util.List"%>
<%@page import="model.CurriculumElective"%>
<%@page import="model.Subject"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    dto.CurriculumDTO curriculum = (dto.CurriculumDTO) request.getAttribute("curriculum");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    CurriculumElective elective = (CurriculumElective) request.getAttribute("elective");
    String error = (String) request.getAttribute("error");
    if (elective == null) {
        elective = new CurriculumElective();
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Add Elective Course</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/createElective.css" />
    </head>
    <body>
    <%@ include file="header.jsp" %>
        <main class="elective-create-page">
            <header class="elective-create-header">
                <a class="back-link" href="<%=request.getContextPath()%>/curriculum/elective?action=list&curriculumId=<%= curriculum.getCurriculumId() %>">Back to Elective List</a>
                <h1>Add Elective Course</h1>
                <p><%= curriculum.getProgramCode() %> - <%= curriculum.getCurriculumName() %></p>
            </header>

            <% if (error != null && !error.isBlank()) { %>
            <div class="alert-error"><%= error %></div>
            <% } %>

            <form id="createElectiveForm" class="elective-create-shell" method="post" action="<%=request.getContextPath()%>/curriculum/elective">
                <input type="hidden" name="action" value="create" />
                <input type="hidden" name="curriculumId" value="<%= curriculum.getCurriculumId() %>" />

                <section class="elective-card">
                    <div class="card-title">Elective Course Information</div>

                    <div class="subject-search-box">
                        <label class="span-2">
                            <span>Tìm môn học theo tên hoặc mã môn</span>
                            <input id="subjectSearch" list="subjectOptions" placeholder="VD: Software Project hoặc SWP391" autocomplete="off" />
                        </label>

                        <label class="span-2">
                            <span>Chọn môn học từ list</span>
                            <select id="subjectSelect" name="subjectId" required>
                                <option value="">Select subject</option>
                                <% if (subjects != null) {
                                    for (Subject subject : subjects) {
                                        String code = subject.getSubjectCode() != null ? subject.getSubjectCode() : "";
                                        String name = subject.getSubjectName() != null ? subject.getSubjectName() : "";
                                        String selected = subject.getSubjectId() == elective.getSubjectId() ? "selected" : "";
                                %>
                                <option value="<%= subject.getSubjectId() %>"
                                        data-code="<%= code %>"
                                        data-name="<%= name %>"
                                        data-credits="<%= subject.getCredits() %>"
                                        <%= selected %>>
                                    <%= code %> - <%= name %> (<%= subject.getCredits() %> credits)
                                </option>
                                <%  }
                                } %>
                            </select>
                        </label>

                        <datalist id="subjectOptions">
                            <% if (subjects != null) {
                                for (Subject subject : subjects) {
                                    String code = subject.getSubjectCode() != null ? subject.getSubjectCode() : "";
                                    String name = subject.getSubjectName() != null ? subject.getSubjectName() : "";
                            %>
                            <option value="<%= code %> - <%= name %>" data-id="<%= subject.getSubjectId() %>"></option>
                            <%  }
                            } %>
                        </datalist>

                        <div class="subject-preview" id="subjectPreview">Chọn môn học để xem thông tin.</div>
                    </div>

                    <div class="form-grid single-column">
                        <label>
                            <span>Group Name</span>
                            <input name="electiveGroupName" value="<%= elective.getElectiveGroupName() != null ? elective.getElectiveGroupName() : "" %>" placeholder="VD: Elective Group 1" />
                        </label>
                    </div>
                </section>

                <div class="form-actions">
                    <button type="submit" class="primary-button">Add to Elective List</button>
                    <a class="outline-button" href="<%=request.getContextPath()%>/curriculum/elective?action=list&curriculumId=<%= curriculum.getCurriculumId() %>">Cancel</a>
                </div>
            </form>
        </main>
    <%@ include file="footer.jsp" %>

        <script>
            const subjectSearch = document.getElementById("subjectSearch");
            const subjectSelect = document.getElementById("subjectSelect");
            const subjectPreview = document.getElementById("subjectPreview");

            subjectSearch.addEventListener("input", function () {
                const keyword = subjectSearch.value.trim().toLowerCase();
                if (!keyword) {
                    return;
                }

                const matched = Array.from(subjectSelect.options).find(function (option) {
                    return option.value && option.textContent.trim().toLowerCase() === keyword;
                }) || Array.from(subjectSelect.options).find(function (option) {
                    return option.value && option.textContent.toLowerCase().includes(keyword);
                });

                if (matched) {
                    subjectSelect.value = matched.value;
                    updateSubjectPreview();
                }
            });

            subjectSelect.addEventListener("change", updateSubjectPreview);
            updateSubjectPreview();

            function updateSubjectPreview() {
                const option = subjectSelect.selectedOptions[0];
                if (!option || !option.value) {
                    subjectPreview.textContent = "Chọn môn học để xem thông tin.";
                    return;
                }
                subjectPreview.textContent = option.dataset.code + " - " + option.dataset.name
                    + " | Credits: " + option.dataset.credits;
            }
        </script>
    </body>
</html>
