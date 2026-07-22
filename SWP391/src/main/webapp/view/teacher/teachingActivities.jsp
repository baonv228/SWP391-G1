<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Teaching &amp; Learning Activities - Teacher" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <div class="d-flex align-items-center gap-3 mb-3">
        <a href="${pageContext.request.contextPath}/teacher/dashboard"
           class="btn btn-back" id="btn-back-dashboard">
            <i class="bi bi-arrow-left me-1"></i>Dashboard
        </a>
        <h2 class="page-title mb-0">Teaching &amp; Learning Activities</h2>
    </div>

    <%-- Flash alerts --%>
    <c:if test="${not empty param.success}">
        <div class="alert alert-success d-flex align-items-center gap-2" id="ta-success-alert">
            <i class="bi bi-check-circle-fill"></i>${fn:escapeXml(param.success)}
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger d-flex align-items-center gap-2" id="ta-error-alert">
            <i class="bi bi-exclamation-triangle-fill"></i>${fn:escapeXml(param.error)}
        </div>
    </c:if>

    <%-- Syllabus picker --%>
    <div class="teacher-card mb-3" id="ta-picker-card">
        <div class="teacher-card-body">
            <form action="${pageContext.request.contextPath}/teacher/teaching-activities"
                  method="get" class="row g-2 align-items-end" id="ta-syllabus-form">
                <div class="col-sm-8">
                    <label for="syllabusId" class="form-label fw-semibold">
                        Syllabus <span class="text-danger">*</span>
                    </label>
                    <select name="syllabusId" id="syllabusId" class="form-select"
                            onchange="if(this.value){ this.form.submit(); }">
                        <option value="">— Select Syllabus —</option>
                        <c:forEach var="s" items="${syllabi}">
                            <option value="${s.syllabusId}"
                                    ${selectedSyllabusId == s.syllabusId ? 'selected' : ''}>
                                [${s.subjectCode}] ${s.syllabusTitle} (v${s.versionNo})
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-sm-4">
                    <c:if test="${not empty selectedSyllabusId}">
                        <a href="${pageContext.request.contextPath}/teacher/teaching-activities/edit?syllabusId=${selectedSyllabusId}"
                           class="btn btn-upload-submit w-100" id="ta-edit-link">
                            <i class="bi bi-pencil-square me-1"></i>Manage Materials
                        </a>
                    </c:if>
                </div>
            </form>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty selectedSyllabusId}">
            <div class="teacher-card">
                <div class="teacher-card-body">
                    <p class="text-muted text-center py-3 mb-0">
                        Select a syllabus to view its teaching sessions and attached materials.
                    </p>
                </div>
            </div>
        </c:when>
        <c:when test="${empty sessions}">
            <div class="teacher-card">
                <div class="teacher-card-body">
                    <p class="text-muted text-center py-3 mb-0">
                        This syllabus has no teaching sessions yet.
                    </p>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="ses" items="${sessions}">
                <div class="teacher-card mb-3">
                    <div class="teacher-card-header d-flex align-items-center gap-2">
                        <span class="badge bg-secondary">Session ${ses.sessionNumber}</span>
                        <span>${fn:escapeXml(ses.topic)}</span>
                        <c:if test="${not empty ses.learningTeachingType}">
                            <span class="ms-auto badge bg-light text-dark border">
                                ${fn:escapeXml(ses.learningTeachingType)}
                            </span>
                        </c:if>
                    </div>
                    <div class="teacher-card-body">
                        <c:set var="mats" value="${linksBySession[ses.sessionNumber]}"/>
                        <c:choose>
                            <c:when test="${empty mats}">
                                <p class="text-muted mb-0" style="font-size:.85rem;">
                                    No materials attached to this session.
                                </p>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="fpt-table mb-0">
                                        <thead>
                                            <tr>
                                                <th>Material</th>
                                                <th>Type</th>
                                                <th>Size</th>
                                                <th class="text-center">Downloads</th>
                                                <th class="text-center">Download</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="mat" items="${mats}">
                                                <tr>
                                                    <td>
                                                        <i class="bi ${mat.typeIconClass} me-1"></i>
                                                        ${fn:escapeXml(mat.materialName)}
                                                    </td>
                                                    <td>
                                                        <span class="badge material-type-badge type-${fn:toLowerCase(mat.materialType)}">
                                                            ${mat.materialType}
                                                        </span>
                                                    </td>
                                                    <td style="font-size:.8rem;" class="text-muted">${mat.fileSizeDisplay}</td>
                                                    <td class="text-center">
                                                        <span class="badge bg-info-subtle text-info border border-info">${mat.downloadCount}</span>
                                                    </td>
                                                    <td class="text-center">
                                                        <a href="${pageContext.request.contextPath}/download-material?materialId=${mat.materialId}"
                                                           class="btn btn-sm btn-upload-submit py-0 px-2"
                                                           title="Download ${fn:escapeXml(mat.materialName)}">
                                                            <i class="bi bi-cloud-arrow-down-fill"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
