<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="model.Subject"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<Subject> courses = (List<Subject>) request.getAttribute("courses");
    Subject selectedCourse = (Subject) request.getAttribute("course");
    String subjectCode = (String) request.getAttribute("subjectCode");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    List<String> statusOptions = (List<String>) request.getAttribute("statusOptions");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalItems = (Integer) request.getAttribute("totalItems");
    Boolean canCreateCourse = (Boolean) request.getAttribute("canCreateCourse");
    Map<Integer, List<String>> prerequisiteMap = (Map<Integer, List<String>>) request.getAttribute("prerequisiteMap");

    if (subjectCode == null) {
        subjectCode = "";
    }
    if (selectedStatus == null) {
        selectedStatus = "";
    }
    if (statusOptions == null) {
        statusOptions = java.util.Collections.emptyList();
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
    if (canCreateCourse == null) {
        canCreateCourse = false;
    }
    if (prerequisiteMap == null) {
        prerequisiteMap = java.util.Collections.emptyMap();
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Course List</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/CourseList.css" />
    </head>
    <body>
        <main class="course-page">
            <header class="course-header">
                <a class="back-link" href="<%=request.getContextPath()%>/home">Home</a>
                <div>
                    <h1>Course List</h1>
                </div>
            </header>

            <section class="toolbar <%= canCreateCourse ? "has-action" : "" %>" aria-label="Course filters">
                <div>
                    <h2>Subject Management</h2>
                    <p>Search môn học theo Subject Code và lọc theo trạng thái.</p>
                </div>

                <form class="search-form" method="get" action="<%=request.getContextPath()%>/course">
                    <input type="hidden" name="action" value="list" />
                    <label for="subjectCode">Filter</label>
                    <div class="search-row">
                        <input id="subjectCode" name="subjectCode" value="<%= subjectCode %>" placeholder="VD: SWP hoặc SWP391" />
                        <select id="status" name="status" aria-label="Status">
                            <option value="">All Status</option>
                            <% for (String statusOption : statusOptions) {
                                boolean selected = selectedStatus.equalsIgnoreCase(statusOption);
                            %>
                            <option value="<%= statusOption %>" <%= selected ? "selected" : "" %>><%= statusOption %></option>
                            <% } %>
                        </select>
                        <button type="submit">Search</button>
                        <% if (!subjectCode.isBlank() || !selectedStatus.isBlank()) { %>
                        <a class="clear-button" href="<%=request.getContextPath()%>/course?action=list">Clear</a>
                        <% } %>
                    </div>
                </form>

                <% if (canCreateCourse) { %>
                <a class="create-button" href="<%=request.getContextPath()%>/course?action=create">Create Course</a>
                <% } %>
            </section>

            <% if (selectedCourse != null) { %>
            <section class="detail-panel">
                <div>
                    <span class="detail-label">Course Detail</span>
                    <h3><%= selectedCourse.getSubjectCode() != null ? selectedCourse.getSubjectCode() : "" %></h3>
                </div>
                <dl>
                    <dt>Subject ID</dt>
                    <dd><%= selectedCourse.getSubjectId() %></dd>
                    <dt>Subject Name</dt>
                    <dd><%= selectedCourse.getSubjectName() != null ? selectedCourse.getSubjectName() : "" %></dd>
                    <dt>Credits</dt>
                    <dd><%= selectedCourse.getCredits() %></dd>
                    <dt>Status</dt>
                    <dd><%= selectedCourse.getStatus() != null ? selectedCourse.getStatus() : "" %></dd>
                    <dt>Description</dt>
                    <dd><%= selectedCourse.getDescription() != null ? selectedCourse.getDescription() : "" %></dd>
                </dl>
            </section>
            <% } %>

            <section class="table-section">
                <table>
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Subject Code</th>
                            <th>Subject Name</th>
                            <th>Credits</th>
                            <th>Môn điều kiện</th>
                            <th>Status</th>
                            <th>Detail</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (courses == null || courses.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="empty">Không có môn học phù hợp.</td>
                        </tr>
                        <% } else {
                            int index = (currentPage - 1) * 10 + 1;
                            for (Subject course : courses) {
                        %>
                        <tr>
                            <td><%= index++ %></td>
                            <td><span class="code-pill"><%= course.getSubjectCode() != null ? course.getSubjectCode() : "" %></span></td>
                            <td><%= course.getSubjectName() != null ? course.getSubjectName() : "" %></td>
                            <td><%= course.getCredits() %></td>
                            <td>
                                <%
                                    List<String> prerequisites = prerequisiteMap.get(course.getSubjectId());
                                    if (prerequisites == null || prerequisites.isEmpty()) {
                                %>
                                <span class="no-prerequisite">None</span>
                                <% } else {
                                    for (String prerequisiteCode : prerequisites) {
                                %>
                                <span class="prerequisite-pill"><%= prerequisiteCode %></span>
                                <%  }
                                } %>
                            </td>
                            <td><span class="status"><%= course.getStatus() != null ? course.getStatus() : "" %></span></td>
                            <td>
                                <a class="detail-link" href="<%=request.getContextPath()%>/course?action=detail&id=<%= course.getSubjectId() %>&subjectCode=<%= java.net.URLEncoder.encode(subjectCode, "UTF-8") %>&status=<%= java.net.URLEncoder.encode(selectedStatus, "UTF-8") %>&page=<%= currentPage %>">chi tiết</a>
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
                   href="<%=request.getContextPath()%>/course?action=list&subjectCode=<%= java.net.URLEncoder.encode(subjectCode, "UTF-8") %>&status=<%= java.net.URLEncoder.encode(selectedStatus, "UTF-8") %>&page=<%= i %>"><%= i %></a>
                <% } %>
                <span>/ <%= totalPages %></span>
            </nav>

            <div class="summary">Total: <%= totalItems %> course(s)</div>
        </main>
    </body>
</html>
