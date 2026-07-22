<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Teacher Dashboard" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <div class="teacher-welcome" id="teacher-welcome-banner">
        <div class="welcome-avatar" id="welcome-avatar">
            ${fn:substring(sessionScope.user.fullName, 0, 1)}
        </div>
        <div>
            <h2 class="mb-1">Welcome back, <span class="text-orange">${sessionScope.user.fullName}</span></h2>
            <p class="text-muted mb-0">Teacher Portal — FPT University Learning Materials</p>
        </div>
    </div>

    <%-- Quick Stats --%>
    <div class="stats-grid" id="teacher-stats-grid">
        <div class="stat-card" id="stat-materials">
            <div class="stat-icon stat-icon-blue"><i class="bi bi-folder2-open"></i></div>
            <div class="stat-body">
                <div class="stat-number">${myMaterialsCount}</div>
                <div class="stat-label">My Uploaded Materials</div>
            </div>
        </div>
        <div class="stat-card" id="stat-requests">
            <div class="stat-icon stat-icon-orange"><i class="bi bi-file-earmark-text"></i></div>
            <div class="stat-body">
                <div class="stat-number">${totalRequests}</div>
                <div class="stat-label">Design Requests Submitted</div>
            </div>
        </div>
        <div class="stat-card" id="stat-downloads">
            <div class="stat-icon stat-icon-green"><i class="bi bi-cloud-arrow-down-fill"></i></div>
            <div class="stat-body">
                <div class="stat-number">${myDownloadsCount}</div>
                <div class="stat-label">Material Downloads</div>
            </div>
        </div>
    </div>

    <%-- Quick Navigation --%>
    <h3 class="section-subtitle mt-4">Quick Actions</h3>
    <div class="quick-actions-grid" id="teacher-quick-actions">
        <a href="${pageContext.request.contextPath}/teacher/upload-material"
           class="quick-action-card" id="qa-upload">
            <i class="bi bi-cloud-upload-fill quick-action-icon icon-green"></i>
            <div class="quick-action-title">Upload Learning Materials</div>
            <div class="quick-action-desc">Upload ZIP files, PDFs, slides for your syllabi</div>
        </a>
        <a href="${pageContext.request.contextPath}/teacher/submit-request"
           class="quick-action-card" id="qa-request">
            <i class="bi bi-pencil-square quick-action-icon icon-orange"></i>
            <div class="quick-action-title">Submit Design Request</div>
            <div class="quick-action-desc">Request course creation or modification for review</div>
        </a>
        <a href="${pageContext.request.contextPath}/teacher/courses"
           class="quick-action-card" id="qa-courses">
            <i class="bi bi-journal-bookmark-fill quick-action-icon icon-blue"></i>
            <div class="quick-action-title">Course List</div>
            <div class="quick-action-desc">Browse and search all subjects and syllabi</div>
        </a>
        <a href="${pageContext.request.contextPath}/teacher/teaching-activities"
           class="quick-action-card" id="qa-teaching-activities">
            <i class="bi bi-easel quick-action-icon icon-teal"></i>
            <div class="quick-action-title">Teaching &amp; Learning Activities</div>
            <div class="quick-action-desc">Manage materials for each session of your syllabi</div>
        </a>
    </div>

    <%-- Recent Requests --%>
    <c:if test="${not empty recentRequests}">
        <h3 class="section-subtitle mt-4">Recent Requests</h3>
        <div class="table-responsive">
            <table class="fpt-table" id="recent-requests-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Subject</th>
                        <th>Syllabus</th>
                        <th>Request Type</th>
                        <th>Status</th>
                        <th>Submitted At</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${recentRequests}" varStatus="s">
                        <tr class="${s.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                            <td>${r.requestId}</td>
                            <td><strong>${r.subjectCode}</strong></td>
                            <td>${r.syllabusTitle}</td>
                            <td><span class="badge bg-secondary">${r.requestType}</span></td>
                            <td><span class="badge ${r.statusBadgeClass}">${r.status}</span></td>
                            <td style="font-size:.82rem;">${r.requestedAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <a href="${pageContext.request.contextPath}/teacher/submit-request"
           class="btn btn-sm btn-outline-secondary mt-2" id="view-all-requests">
            View All Requests →
        </a>
    </c:if>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
