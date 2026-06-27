<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="System Reports - Teacher" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>
<main class="container-fluid main-content">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-back"><i class="bi bi-arrow-left me-1"></i>Dashboard</a>
            <h2 class="page-title mb-0">System Reports</h2>
        </div>
        <a href="${pageContext.request.contextPath}/teacher/report?export=csv"
           class="btn btn-download" id="btn-export-csv" title="Download CSV">
            <i class="bi bi-download me-1"></i>Export CSV
        </a>
    </div>

    <%-- Summary Row --%>
    <div class="stats-grid" id="report-summary-grid">
        <c:forEach var="entry" items="${summary}">
            <div class="stat-card" id="stat-${entry.key.replace(' ','-')}">
                <div class="stat-body">
                    <div class="stat-number">${entry.value}</div>
                    <div class="stat-label">${entry.key}</div>
                </div>
            </div>
        </c:forEach>
    </div>

    <%-- Detail Charts (bar-style using CSS) --%>
    <div class="row g-4 mt-2">
        <div class="col-md-6">
            <div class="teacher-card">
                <div class="teacher-card-header"><i class="bi bi-bar-chart-fill me-2"></i>Syllabi by Status</div>
                <div class="teacher-card-body">
                    <c:forEach var="e" items="${syllabiStatus}">
                        <div class="report-bar-row">
                            <span class="report-bar-label">${e.key}</span>
                            <div class="report-bar-track">
                                <div class="report-bar-fill" style="width:${e.value * 10}px; max-width:100%; background:var(--fpt-orange);"></div>
                            </div>
                            <span class="report-bar-count">${e.value}</span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty syllabiStatus}"><p class="text-muted">No data.</p></c:if>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="teacher-card">
                <div class="teacher-card-header"><i class="bi bi-bar-chart-fill me-2"></i>Subjects by Status</div>
                <div class="teacher-card-body">
                    <c:forEach var="e" items="${subjectStatus}">
                        <div class="report-bar-row">
                            <span class="report-bar-label">${e.key}</span>
                            <div class="report-bar-track">
                                <div class="report-bar-fill" style="width:${e.value * 10}px; max-width:100%; background:var(--fpt-green);"></div>
                            </div>
                            <span class="report-bar-count">${e.value}</span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty subjectStatus}"><p class="text-muted">No data.</p></c:if>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="teacher-card">
                <div class="teacher-card-header"><i class="bi bi-folder2 me-2"></i>Materials by Type</div>
                <div class="teacher-card-body">
                    <c:forEach var="e" items="${materialTypes}">
                        <div class="report-bar-row">
                            <span class="report-bar-label">${e.key}</span>
                            <div class="report-bar-track">
                                <div class="report-bar-fill" style="width:${e.value * 20}px; max-width:100%; background:var(--fpt-blue);"></div>
                            </div>
                            <span class="report-bar-count">${e.value}</span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty materialTypes}"><p class="text-muted">No materials uploaded yet.</p></c:if>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="teacher-card">
                <div class="teacher-card-header"><i class="bi bi-clipboard2-check me-2"></i>Approval Requests by Status</div>
                <div class="teacher-card-body">
                    <c:forEach var="e" items="${requestStatus}">
                        <div class="report-bar-row">
                            <span class="report-bar-label">${e.key}</span>
                            <div class="report-bar-track">
                                <div class="report-bar-fill" style="width:${e.value * 20}px; max-width:100%;
                                    background:${e.key == 'Approved' ? '#28a745' : e.key == 'Rejected' ? '#dc3545' : '#ffc107'};"></div>
                            </div>
                            <span class="report-bar-count">${e.value}</span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty requestStatus}"><p class="text-muted">No requests submitted.</p></c:if>
                </div>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/views/layout/footer.jsp"/>
