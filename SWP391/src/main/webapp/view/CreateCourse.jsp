<%@page import="model.Subject"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String creatorName = (String) request.getAttribute("creatorName");
    Subject course = (Subject) request.getAttribute("course");

    if (creatorName == null) {
        creatorName = "";
    }
    if (course == null) {
        course = new Subject();
        course.setStatus("pending design");
    }
    String creditsValue = course.getCredits() > 0 ? String.valueOf(course.getCredits()) : "";
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Create Course</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/CreateCourse.css" />
    </head>
    <body>
        <main class="create-course-page">
            <header class="page-header">
                <a class="back-link" href="<%=request.getContextPath()%>/course?action=list">Back to list</a>
                <h1>Training Program Management System</h1>
            </header>

            <section class="create-shell">
                <div class="section-title">
                    <span>Course</span>
                    <strong>Create Course</strong>
                </div>

                <% if (error != null) { %>
                <div class="error"><%= error %></div>
                <% } %>

                <form id="createCourseForm" method="post" action="<%=request.getContextPath()%>/course" onsubmit="return confirmCreateCourse();">
                    <input type="hidden" name="action" value="create" />

                    <fieldset class="course-info">
                        <legend>Course Information</legend>

                        <div class="form-grid">
                            <label>
                                <span>Course Code</span>
                                <input name="subjectCode" value="<%= course.getSubjectCode() != null ? course.getSubjectCode() : "" %>" placeholder="VD: SWP391" maxlength="50" required />
                            </label>

                            <label>
                                <span>Course Name</span>
                                <input name="subjectName" value="<%= course.getSubjectName() != null ? course.getSubjectName() : "" %>" placeholder="Software Project" required />
                            </label>

                            <label>
                                <span>Credits</span>
                                <input type="number" name="credits" value="<%= creditsValue %>" min="1" max="20" placeholder="3" required />
                            </label>

                            <label>
                                <span>Created By</span>
                                <input value="<%= creatorName %>" readonly />
                            </label>

                            <label class="span-2">
                                <span>Description</span>
                                <textarea name="description" rows="5" placeholder="Nhập mô tả môn học" required><%= course.getDescription() != null ? course.getDescription() : "" %></textarea>
                            </label>

                            <label>
                                <span>Status</span>
                                <input value="pending design" readonly />
                            </label>
                        </div>
                    </fieldset>

                    <div class="form-actions">
                        <button class="submit-button" type="submit">Create Course</button>
                        <a class="cancel-button" href="<%=request.getContextPath()%>/course?action=list">Cancel</a>
                    </div>
                </form>
            </section>
        </main>

        <script>
            function confirmCreateCourse() {
                const form = document.getElementById("createCourseForm");
                if (!form.checkValidity()) {
                    form.reportValidity();
                    return false;
                }
                return confirm("Bạn có chắc chắn muốn tạo course này không?");
            }
        </script>
    </body>
</html>
