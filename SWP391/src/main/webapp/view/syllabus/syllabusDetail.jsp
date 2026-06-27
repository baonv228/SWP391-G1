<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Syllabus Details - ${syllabus.syllabusTitle}" scope="request"/>
<c:set var="pageDescription" value="Full syllabus detail for ${syllabus.subjectCode} - ${syllabus.syllabusTitle}" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<main class="container-fluid main-content">
    <h2 class="page-title">Syllabus Details</h2>

    <c:choose>
        <c:when test="${empty syllabus}">
            <div class="alert alert-warning" id="syllabus-detail-not-found">Syllabus not found.</div>
        </c:when>
        <c:otherwise>

            <%-- ═══════════════════════════════════════════════════════
                 SECTION 1 — Syllabus Info
            ═══════════════════════════════════════════════════════ --%>
            <div class="detail-section" id="syllabus-detail-info">
                <div class="detail-row">
                    <div class="detail-label">Syllabus ID:</div>
                    <div class="detail-value" id="detail-syllabus-id">${syllabus.syllabusId}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Syllabus Name:</div>
                    <div class="detail-value fw-bold" id="detail-syllabus-name">${syllabus.syllabusTitle}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Subject Code:</div>
                    <div class="detail-value fw-bold" id="detail-subject-code">${syllabus.subjectCode}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Subject Name:</div>
                    <div class="detail-value" id="detail-subject-name">${syllabus.subjectName}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Credits:</div>
                    <div class="detail-value" id="detail-credits">${syllabus.credits}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Version:</div>
                    <div class="detail-value" id="detail-version">${syllabus.versionNo}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Status:</div>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${syllabus.status == 'Active' or syllabus.status == 'Approved'}">
                                <span class="badge bg-success" id="detail-status">${syllabus.status}</span>
                            </c:when>
                            <c:when test="${syllabus.status == 'Draft'}">
                                <span class="badge bg-warning text-dark" id="detail-status">Draft</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary" id="detail-status">${syllabus.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Current Version:</div>
                    <div class="detail-value" id="detail-current-version">
                        <c:choose>
                            <c:when test="${syllabus.currentVersion}"><span class="badge bg-success">Yes</span></c:when>
                            <c:otherwise><span class="badge bg-secondary">No</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Approved:</div>
                    <div class="detail-value" id="detail-approved">
                        <c:choose>
                            <c:when test="${syllabus.approved}"><span class="badge bg-success">Yes</span></c:when>
                            <c:otherwise><span class="badge bg-warning text-dark">Pending</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <c:if test="${not empty syllabus.approvedAt}">
                    <div class="detail-row">
                        <div class="detail-label">Approved At:</div>
                        <div class="detail-value" id="detail-approved-at">${syllabus.approvedAt}</div>
                    </div>
                </c:if>
                <div class="detail-row">
                    <div class="detail-label">Description:</div>
                    <div class="detail-value" id="detail-description">
                        <c:choose>
                            <c:when test="${not empty syllabus.description}">${syllabus.description}</c:when>
                            <c:otherwise><span class="text-muted">N/A</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <c:if test="${not empty syllabus.learningOutcomes}">
                    <div class="detail-row">
                        <div class="detail-label">Learning Outcomes:</div>
                        <div class="detail-value" id="detail-learning-outcomes">
                            <ul class="lo-list">
                                <c:forEach var="lo" items="${syllabus.learningOutcomes}" varStatus="loStatus">
                                    <li id="lo-item-${loStatus.index + 1}">${lo}</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty syllabus.assessmentMethod}">
                    <div class="detail-row">
                        <div class="detail-label">Assessment:</div>
                        <div class="detail-value" id="detail-assessment">
                            <span style="white-space:pre-line;">${fn:escapeXml(syllabus.assessmentMethod)}</span>
                        </div>
                    </div>
                </c:if>

            </div>

            <%-- ═══════════════════════════════════════════════════════
                 SECTION 2 — Learning Materials (download requires login)
            ═══════════════════════════════════════════════════════ --%>
            <div class="materials-section mt-4" id="syllabus-materials-section">
                <h3 class="section-subtitle">
                    <i class="bi bi-folder2-open me-2"></i>Learning Materials
                </h3>

                <c:choose>
                    <c:when test="${empty syllabus.materials}">
                        <div class="empty-materials" id="materials-empty-msg">
                            <i class="bi bi-folder-x text-muted" style="font-size:2rem;"></i>
                            <p class="text-muted mt-2">No materials have been uploaded for this syllabus yet.</p>
                        </div>
                    </c:when>
                    <c:otherwise>

                        <%-- Login notice for guests --%>
                        <c:if test="${empty sessionScope.user}">
                            <div class="login-required-notice" id="login-required-notice">
                                <i class="bi bi-lock-fill me-2"></i>
                                <span>
                                    You must <a href="${pageContext.request.contextPath}/login?returnUrl=${pageContext.request.requestURL}%3FsyllabusId=${syllabus.syllabusId}"
                                                id="notice-login-link" class="fw-bold">log in</a>
                                    to download learning materials.
                                </span>
                            </div>
                        </c:if>

                        <%-- Materials count + Download All (logged-in only) --%>
                        <div class="d-flex align-items-center gap-3 mb-3">
                            <span class="materials-count" id="materials-count">
                                <i class="bi bi-files me-1"></i>
                                ${fn:length(syllabus.materials)} material(s) available
                            </span>

                            <c:if test="${not empty sessionScope.user}">
                                <button class="btn btn-download" id="btn-download-all"
                                        onclick="downloadAllMaterials()" type="button">
                                    <i class="bi bi-cloud-arrow-down-fill me-1"></i>Download All
                                </button>
                            </c:if>
                        </div>

                        <%-- Materials table --%>
                        <div class="table-responsive" id="materials-table-wrapper">
                            <table class="fpt-table" id="materials-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Material Name</th>
                                        <th>Type</th>
                                        <th>Visibility</th>
                                        <th>Uploaded At</th>
                                        <th class="text-center">Download</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="mat" items="${syllabus.materials}" varStatus="s">
                                        <tr class="${s.index % 2 == 0 ? 'row-even' : 'row-odd'}"
                                            id="material-row-${mat.materialId}">
                                            <td>${s.index + 1}</td>
                                            <td>
                                                <i class="bi ${mat.typeIconClass} me-1 material-type-icon"></i>
                                                ${mat.materialName}
                                            </td>
                                            <td>
                                                <span class="badge material-type-badge type-${fn:toLowerCase(mat.materialType)}">
                                                    ${mat.materialType}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${mat.visibility == 'Public'}">
                                                        <span class="badge bg-success-subtle text-success border border-success">Public</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning-subtle text-warning border border-warning">Private</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-muted" style="font-size:.82rem;">
                                                ${mat.uploadedAt}
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${not empty sessionScope.user}">
                                                        <%-- Logged in → show download link --%>
                                                        <a href="javascript:void(0)"
                                                           onclick="downloadSingleMaterial('${pageContext.request.contextPath}/download-material?materialId=${mat.materialId}')"
                                                           class="btn-download-file"
                                                           id="download-btn-${mat.materialId}"
                                                           title="Download ${mat.materialName}">
                                                            <i class="bi bi-cloud-arrow-down-fill"></i> Download
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <%-- Guest → lock with login redirect --%>
                                                        <a href="${pageContext.request.contextPath}/login?returnUrl=${pageContext.request.requestURL}%3FsyllabusId=${syllabus.syllabusId}"
                                                           class="btn-download-locked"
                                                           id="locked-btn-${mat.materialId}"
                                                           title="Login to download">
                                                            <i class="bi bi-lock-fill"></i> Login to Download
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <%-- Download all hidden form (for logged-in users) --%>
                        <c:if test="${not empty sessionScope.user}">
                            <div id="download-all-links" style="display:none;">
                                <c:forEach var="mat" items="${syllabus.materials}">
                                    <span data-url="${pageContext.request.contextPath}/download-material?materialId=${mat.materialId}"
                                          data-name="${fn:escapeXml(mat.materialName)}"></span>
                                </c:forEach>
                            </div>
                        </c:if>

                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Back --%>
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/syllabus" class="btn btn-back" id="btn-back-syllabus">
                    <i class="bi bi-arrow-left me-1"></i>Back to Syllabus List
                </a>
            </div>

        </c:otherwise>
    </c:choose>
</main>

<script>
/**
 * Triggers a file download using a temporary hidden iframe.
 * This keeps the user on the current page even if the request fails or redirects.
 */
function downloadSingleMaterial(url) {
    const iframe = document.createElement('iframe');
    iframe.style.display = 'none';
    iframe.src = url;
    document.body.appendChild(iframe);
    // Remove the iframe after a short delay
    setTimeout(function () { 
        document.body.removeChild(iframe); 
    }, 5000);
}

/**
 * Download all materials sequentially by opening each download link in a hidden iframe.
 * This avoids popup blockers while triggering one download per file.
 */
function downloadAllMaterials() {
    const container = document.getElementById('download-all-links');
    if (!container) return;
    const links = container.querySelectorAll('[data-url]');
    if (links.length === 0) {
        alert('No materials to download.');
        return;
    }
    links.forEach(function (el, idx) {
        setTimeout(function () {
            downloadSingleMaterial(el.getAttribute('data-url'));
        }, idx * 1000); // stagger 1s apart
    });
}
</script>

<jsp:include page="/views/layout/footer.jsp"/>
