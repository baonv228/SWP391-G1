<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dto.SyllabusDTO"%>
<%@page import="dto.MaterialDTO"%>
<%@page import="model.SyllabusMaterial"%>
<%@page import="model.CLO"%>
<%@page import="model.SyllabusAssessment"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
    private String h(Object value) {
        if (value == null) {
            return "";
        }
        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<%
    SyllabusDTO syllabus = (SyllabusDTO) request.getAttribute("syllabus");
    String error = (String) request.getAttribute("error");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Process Request</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/ProcessRequest.css" />
    </head>
    <body>
        <main class="process-page">
            <header class="process-header">
                <a class="back-link" href="<%=request.getContextPath()%>/request-list">Back</a>
                <div>
                    <h1>Process Request</h1>
                    <p><%= syllabus != null ? h(syllabus.getSubjectCode()) + " - " + h(syllabus.getSubjectName()) : "" %></p>
                </div>
            </header>

            <% if (error != null && !error.isBlank()) { %>
            <div class="alert-error"><%= h(error) %></div>
            <% } %>

            <% if (syllabus == null) { %>
            <section class="info-card empty-card">Syllabus not found.</section>
            <% } else { %>
            <section class="summary-card">
                <div>
                    <span>Subject</span>
                    <strong><%= h(syllabus.getSubjectCode()) %></strong>
                    <small><%= h(syllabus.getSubjectName()) %></small>
                </div>
                <div>
                    <span>Syllabus</span>
                    <strong><%= h(syllabus.getSyllabusTitle()) %></strong>
                    <small>Version <%= h(syllabus.getVersionNo()) %></small>
                </div>
                <div>
                    <span>Status</span>
                    <strong class="status-text"><%= h(syllabus.getStatus()) %></strong>
                    <small><%= syllabus.getCreatedAt() != null ? dateFormat.format(syllabus.getCreatedAt()) : "" %></small>
                </div>
            </section>

            <section class="info-card">
                <h2>1. Syllabus Details</h2>
                <dl class="detail-grid">
                    <div><dt>Syllabus Name</dt><dd><%= h(syllabus.getSyllabusName()) %></dd></div>
                    <div><dt>English Name</dt><dd><%= h(syllabus.getSyllabusEnglish()) %></dd></div>
                    <div><dt>Degree Level</dt><dd><%= h(syllabus.getDegreeLevel()) %></dd></div>
                    <div><dt>Credits</dt><dd><%= syllabus.getCredits() %></dd></div>
                    <div><dt>Time Allocation</dt><dd><%= h(syllabus.getTimeAllocation()) %></dd></div>
                    <div><dt>Scoring Scale</dt><dd><%= syllabus.getScoringScale() != null ? syllabus.getScoringScale() : "" %></dd></div>
                    <div><dt>Min Avg Mark To Pass</dt><dd><%= syllabus.getMinAvgMarkToPass() != null ? syllabus.getMinAvgMarkToPass() : "" %></dd></div>
                    <div><dt>Decision No</dt><dd><%= h(syllabus.getDecisionNo()) %></dd></div>
                    <div class="wide"><dt>Description</dt><dd><%= h(syllabus.getDescription()) %></dd></div>
                    <div class="wide"><dt>Prerequisite</dt><dd><%= h(syllabus.getPreRequisiteText()) %></dd></div>
                    <div class="wide"><dt>Student Tasks</dt><dd><%= h(syllabus.getStudentTasks()) %></dd></div>
                    <div class="wide"><dt>Tools</dt><dd><%= h(syllabus.getTools()) %></dd></div>
                    <div class="wide"><dt>Note</dt><dd><%= h(syllabus.getNote()) %></dd></div>
                </dl>
            </section>

            <section class="info-card">
                <h2>2. Materials</h2>
                <div class="table-wrap">
                    <table>
                        <thead><tr><th>No.</th><th>Description</th><th>Author</th><th>Publisher</th><th>Published Date</th><th>Edition</th><th>ISBN</th><th>Main</th><th>Hard Copy</th><th>Online</th><th>Note</th></tr></thead>
                        <tbody>
                            <% List<SyllabusMaterial> textbooks = syllabus.getTextbooks();
                               if (textbooks == null || textbooks.isEmpty()) { %>
                            <tr><td colspan="11" class="empty">No material.</td></tr>
                            <% } else { int i = 1; for (SyllabusMaterial material : textbooks) { %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><%= h(material.getMaterialDescription()) %></td>
                                <td><%= h(material.getAuthor()) %></td>
                                <td><%= h(material.getPublisher()) %></td>
                                <td><%= h(material.getPublishedDate()) %></td>
                                <td><%= h(material.getEdition()) %></td>
                                <td><%= h(material.getIsbn()) %></td>
                                <td><%= material.getIsMainMaterial() ? "Yes" : "No" %></td>
                                <td><%= material.getIsHardCopy() ? "Yes" : "No" %></td>
                                <td><%= material.getIsOnline() ? "Yes" : "No" %></td>
                                <td><%= h(material.getNote()) %></td>
                            </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="info-card">
                <h2>3. Course Learning Outcomes</h2>
                <div class="table-wrap">
                    <table>
                        <thead><tr><th>No.</th><th>CLO Name</th><th>CLO Details</th><th>LO Details</th></tr></thead>
                        <tbody>
                            <% List<CLO> clos = syllabus.getClos();
                               if (clos == null || clos.isEmpty()) { %>
                            <tr><td colspan="4" class="empty">No CLO.</td></tr>
                            <% } else { int i = 1; for (CLO clo : clos) { %>
                            <tr><td><%= i++ %></td><td><%= h(clo.getCloName()) %></td><td><%= h(clo.getCloDetails()) %></td><td><%= h(clo.getLoDetails()) %></td></tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="info-card">
                <h2>4. Sessions</h2>
                <div class="table-wrap">
                    <table>
                        <thead><tr><th>Session</th><th>Topic</th><th>Learning Type</th><th>ITU</th><th>Student Materials</th><th>Download</th><th>Student Tasks</th><th>URLs</th></tr></thead>
                        <tbody>
                            <% List<SyllabusDTO.SessionDTO> sessions = syllabus.getSessions();
                               if (sessions == null || sessions.isEmpty()) { %>
                            <tr><td colspan="8" class="empty">No session.</td></tr>
                            <% } else { for (SyllabusDTO.SessionDTO sessionItem : sessions) { %>
                            <tr>
                                <td><%= sessionItem.getSessionNo() %></td>
                                <td><%= h(sessionItem.getTopic()) %></td>
                                <td><%= h(sessionItem.getLearningTeachingType()) %></td>
                                <td><%= h(sessionItem.getItu()) %></td>
                                <td><%= h(sessionItem.getStudentMaterials()) %></td>
                                <td><%= h(sessionItem.getStudentDownload()) %></td>
                                <td><%= h(sessionItem.getStudentTasks()) %></td>
                                <td><%= h(sessionItem.getUrls()) %></td>
                            </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="info-card">
                <h2>5. Assessments</h2>
                <div class="table-wrap">
                    <table>
                        <thead><tr><th>No.</th><th>Category</th><th>Type</th><th>Part</th><th>Weight</th><th>Criteria</th><th>Duration</th><th>Question Type</th><th>No Question</th><th>Knowledge And Skill</th><th>Grading Guide</th><th>Note</th></tr></thead>
                        <tbody>
                            <% List<SyllabusAssessment> assessments = syllabus.getAssessments();
                               if (assessments == null || assessments.isEmpty()) { %>
                            <tr><td colspan="12" class="empty">No assessment.</td></tr>
                            <% } else { int i = 1; for (SyllabusAssessment assessment : assessments) { %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><%= h(assessment.getCategory()) %></td>
                                <td><%= h(assessment.getType()) %></td>
                                <td><%= assessment.getPart() != null ? assessment.getPart() : "" %></td>
                                <td><%= assessment.getWeight() %></td>
                                <td><%= h(assessment.getCompletionCriteria()) %></td>
                                <td><%= h(assessment.getDuration()) %></td>
                                <td><%= h(assessment.getQuestionType()) %></td>
                                <td><%= h(assessment.getNoQuestion()) %></td>
                                <td><%= h(assessment.getKnowledgeAndSkill()) %></td>
                                <td><%= h(assessment.getGradingGuide()) %></td>
                                <td><%= h(assessment.getNote()) %></td>
                            </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="info-card">
                <h2>6. Uploaded Learning Materials</h2>
                <div class="table-wrap">
                    <table>
                        <thead><tr><th>No.</th><th>Name</th><th>Type</th><th>Visibility</th><th>Status</th><th>Uploaded At</th></tr></thead>
                        <tbody>
                            <% List<MaterialDTO> uploadedMaterials = syllabus.getMaterials();
                               if (uploadedMaterials == null || uploadedMaterials.isEmpty()) { %>
                            <tr><td colspan="6" class="empty">No uploaded material.</td></tr>
                            <% } else { int i = 1; for (MaterialDTO material : uploadedMaterials) { %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><%= h(material.getMaterialName()) %></td>
                                <td><%= h(material.getMaterialType()) %></td>
                                <td><%= h(material.getVisibility()) %></td>
                                <td><%= h(material.getStatus()) %></td>
                                <td><%= material.getUploadedAt() != null ? dateFormat.format(material.getUploadedAt()) : "" %></td>
                            </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="process-actions">
                <form id="approveForm" method="post" action="<%=request.getContextPath()%>/process-request">
                    <input type="hidden" name="action" value="approve" />
                    <input type="hidden" name="syllabusId" value="<%= syllabus.getSyllabusId() %>" />
                    <button type="button" class="approve-button" id="approveButton">Approve</button>
                </form>
                <button type="button" class="reject-button" id="openRejectModal">Reject</button>
            </section>
            <% } %>
        </main>

        <% if (syllabus != null) { %>
        <div class="modal-backdrop" id="rejectModal" aria-hidden="true">
            <div class="modal">
                <header class="modal-header">
                    <h3>Reject Request</h3>
                    <button type="button" class="close-button" data-close="rejectModal">x</button>
                </header>
                <form method="post" action="<%=request.getContextPath()%>/process-request" onsubmit="return confirm('Are you sure you want to reject this request?');">
                    <input type="hidden" name="action" value="reject" />
                    <input type="hidden" name="syllabusId" value="<%= syllabus.getSyllabusId() %>" />
                    <div class="modal-body">
                        <label for="rejectReason">Reject reason</label>
                        <textarea id="rejectReason" name="rejectReason" rows="5" required placeholder="Enter reject reason"></textarea>
                    </div>
                    <footer class="modal-actions">
                        <button type="button" class="cancel-button" data-close="rejectModal">Cancel</button>
                        <button type="submit" class="reject-button">Confirm Reject</button>
                    </footer>
                </form>
            </div>
        </div>
        <% } %>

        <script>
            const approveButton = document.getElementById("approveButton");
            if (approveButton) {
                approveButton.addEventListener("click", function () {
                    if (confirm("Are you sure you want to approve this request?")) {
                        document.getElementById("approveForm").submit();
                    }
                });
            }

            const rejectModal = document.getElementById("rejectModal");
            const openRejectModal = document.getElementById("openRejectModal");
            if (openRejectModal) {
                openRejectModal.addEventListener("click", function () {
                    rejectModal.classList.add("show");
                    rejectModal.setAttribute("aria-hidden", "false");
                });
            }
            document.querySelectorAll("[data-close]").forEach(function (button) {
                button.addEventListener("click", function () {
                    const modal = document.getElementById(button.dataset.close);
                    modal.classList.remove("show");
                    modal.setAttribute("aria-hidden", "true");
                });
            });
        </script>
    </body>
</html>
