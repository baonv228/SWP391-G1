<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Syllabus"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<Syllabus> requests = (List<Syllabus>) request.getAttribute("requests");
    if (requests == null) {
        requests = java.util.Collections.emptyList();
    }
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Request List</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/RequestList.css" />
    </head>
    <body>
        <main class="request-page">
            <header class="request-header">
                <a class="back-link" href="<%=request.getContextPath()%>/home">Home</a>
                <div>
                    <h1>Request List</h1>
                </div>
            </header>

            <section class="toolbar" aria-label="Syllabus request summary">
                <div>
                    <h2>Syllabus Requests</h2>
                    <p>List syllabus da duoc Syllabus Designer submit va dang cho Training Department xu ly.</p>
                </div>

                <div class="request-card">
                    <span>Total Pending Requests</span>
                    <strong><%= requests.size() %></strong>
                    <small>Pending Approval</small>
                </div>
            </section>

            <section class="table-section">
                <table>
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Subject Code</th>
                            <th>Subject Name</th>
                            <th>Syllabus Title</th>
                            <th>Version</th>
                            <th>Submitted By</th>
                            <th>Submitted At</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (requests.isEmpty()) { %>
                        <tr>
                            <td colspan="8" class="empty">Khong co request nao dang cho xu ly.</td>
                        </tr>
                        <% } else {
                            int index = 1;
                            for (Syllabus syllabus : requests) {
                        %>
                        <tr>
                            <td><%= index++ %></td>
                            <td><span class="code-pill"><%= syllabus.getSubjectCode() != null ? syllabus.getSubjectCode() : "" %></span></td>
                            <td><%= syllabus.getSubjectName() != null ? syllabus.getSubjectName() : "" %></td>
                            <td><%= syllabus.getSyllabusTitle() != null ? syllabus.getSyllabusTitle() : "" %></td>
                            <td><%= syllabus.getVersionNo() != null ? syllabus.getVersionNo() : "" %></td>
                            <td><%= syllabus.getCreatedByName() != null ? syllabus.getCreatedByName() : "" %></td>
                            <td><%= syllabus.getCreatedAt() != null ? dateFormat.format(syllabus.getCreatedAt()) : "" %></td>
                            <td><span class="status"><%= syllabus.getStatus() != null ? syllabus.getStatus() : "" %></span></td>
                        </tr>
                        <%  }
                        } %>
                    </tbody>
                </table>
            </section>

            <div class="summary">Total: <%= requests.size() %> request(s)</div>
        </main>
    </body>
</html>
