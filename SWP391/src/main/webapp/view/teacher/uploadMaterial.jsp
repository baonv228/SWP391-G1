<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Upload Learning Materials - Teacher" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <div class="d-flex align-items-center gap-3 mb-3">
        <a href="${pageContext.request.contextPath}/teacher/dashboard"
           class="btn btn-back" id="btn-back-dashboard">
            <i class="bi bi-arrow-left me-1"></i>Dashboard
        </a>
        <h2 class="page-title mb-0">Upload Learning Materials</h2>
    </div>

    <%-- Success / Error alerts --%>
    <c:if test="${not empty param.success}">
        <div class="alert alert-success d-flex align-items-center gap-2" id="upload-success-alert">
            <i class="bi bi-check-circle-fill"></i>${param.success}
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger d-flex align-items-center gap-2" id="upload-error-alert">
            <i class="bi bi-exclamation-triangle-fill"></i>${error}
        </div>
    </c:if>

    <div class="row g-4 upload-material-row align-items-stretch">

        <%-- Upload Form (left) --%>
        <div class="col-md-5">
            <div class="teacher-card h-100" id="upload-form-card">
                <div class="teacher-card-header">
                    <i class="bi bi-cloud-upload me-2"></i>Upload New Material
                </div>
                <div class="teacher-card-body">
                    <form id="upload-material-form"
                          action="${pageContext.request.contextPath}/teacher/upload-material"
                          method="post" enctype="multipart/form-data"
                          onsubmit="return validateUploadForm()">

                        <div class="mb-3">
                            <label for="syllabusId" class="form-label fw-semibold">
                                Syllabus <span class="text-danger">*</span>
                            </label>
                            <select name="syllabusId" id="syllabusId" class="form-select" required onchange="if(this.value) { window.location.href='${pageContext.request.contextPath}/teacher/upload-material?syllabusId=' + this.value; }">
                                <option value="">— Select Syllabus —</option>
                                <c:forEach var="s" items="${syllabi}">
                                    <option value="${s.syllabusId}"
                                            ${selectedSyllabusId == s.syllabusId ? 'selected' : ''}>
                                        [${s.subjectCode}] ${s.syllabusTitle} (v${s.versionNo})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <input type="hidden" name="materialName" id="materialName" value="" />
                        <input type="hidden" name="visibility" value="Public" />

                        <div class="mb-3">
                            <label for="materialFile" class="form-label fw-semibold">
                                File <span class="text-danger">*</span>
                            </label>
                            <div class="upload-drop-area" id="upload-drop-area"
                                 onclick="document.getElementById('materialFile').click()">
                                <i class="bi bi-cloud-arrow-up-fill upload-drop-icon"></i>
                                <p class="upload-drop-text">Click or drag file here</p>
                                <p class="upload-drop-hint">ZIP, PDF, PPTX, DOCX, MP4 — max 100 MB</p>
                                <div id="file-preview" class="file-preview d-none"></div>
                            </div>
                            <input type="file" name="materialFile" id="materialFile"
                                   class="d-none" required
                                   accept=".zip,.pdf,.pptx,.ppt,.docx,.doc,.mp4,.avi"
                                   onchange="previewFile(this)"/>
                        </div>

                        <div id="upload-form-error" class="text-danger small mb-2"></div>

                        <button type="submit" class="btn btn-upload-submit w-100" id="btn-upload-submit">
                            <i class="bi bi-cloud-upload-fill me-2"></i>Upload Material
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <%-- Existing Materials (right) --%>
        <div class="col-md-7">
            <div class="teacher-card h-100" id="existing-materials-card">
                <div class="teacher-card-header">
                    <i class="bi bi-folder2-open me-2"></i>
                    Existing Materials
                    <c:if test="${not empty selectedSyllabusId}">
                        <span class="ms-2 badge bg-light text-secondary border">
                            Syllabus #${selectedSyllabusId}
                        </span>
                        <c:if test="${totalMaterials > 0}">
                            <span class="ms-1 badge bg-secondary">${totalMaterials}</span>
                        </c:if>
                    </c:if>
                </div>
                <div class="teacher-card-body">
                    <c:choose>
                        <c:when test="${empty existingMaterials}">
                            <p class="text-muted text-center py-3">
                                Select a syllabus to view its materials, or none have been uploaded yet.
                            </p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="fpt-table" id="existing-materials-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Name</th>
                                            <th>Type</th>
                                            <th>Visibility</th>
                                            <th>Uploaded</th>
                                            <th class="text-center">Downloads</th>
                                            <th class="text-center">Download</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="mat" items="${existingMaterials}" varStatus="s">
                                            <tr class="${s.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                                                <td>${materialPagination.offset + s.index + 1}</td>
                                                <td>
                                                    <i class="bi ${mat.typeIconClass} material-type-icon me-1"></i>
                                                    <a href="${pageContext.request.contextPath}/download-material?materialId=${mat.materialId}"
                                                       class="text-decoration-none fw-semibold" style="color: var(--fpt-orange);"
                                                       title="Download ${fn:escapeXml(mat.materialName)}">
                                                        ${mat.materialName}
                                                    </a>
                                                </td>
                                                <td>
                                                    <span class="badge material-type-badge type-${fn:toLowerCase(mat.materialType)}">
                                                        ${mat.materialType}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${mat.visibility == 'Public'}">
                                                            <span class="badge bg-success-subtle text-success border border-success" style="font-size:.7rem;">Public</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning-subtle text-warning border border-warning" style="font-size:.7rem;">Private</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="font-size:.78rem;" class="text-muted">${mat.uploadedAt}</td>
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
                            <c:if test="${not empty materialPagination and materialPagination.totalPages > 1}">
                                <nav class="mt-2">
                                    <ul class="pagination fpt-pagination mb-0">
                                        <c:if test="${materialPagination.hasPrevious()}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/teacher/upload-material?syllabusId=${selectedSyllabusId}&page=${materialPagination.previousPage}">Previous</a>
                                            </li>
                                        </c:if>
                                        <c:forEach begin="1" end="${materialPagination.totalPages}" var="p">
                                            <li class="page-item ${p == materialPagination.currentPage ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/teacher/upload-material?syllabusId=${selectedSyllabusId}&page=${p}">${p}</a>
                                            </li>
                                        </c:forEach>
                                        <c:if test="${materialPagination.hasNext()}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/teacher/upload-material?syllabusId=${selectedSyllabusId}&page=${materialPagination.nextPage}">Next</a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function previewFile(input) {
    const preview = document.getElementById('file-preview');
    const dropText = document.querySelector('.upload-drop-text');
    const dropHint = document.querySelector('.upload-drop-hint');
    if (input.files && input.files[0]) {
        const file = input.files[0];
        document.getElementById('materialName').value = file.name;
        const sizeStr = file.size > 1048576
            ? (file.size / 1048576).toFixed(1) + ' MB'
            : (file.size / 1024).toFixed(0) + ' KB';
        preview.textContent = '📎 ' + file.name + ' (' + sizeStr + ')';
        preview.classList.remove('d-none');
        dropText.textContent = 'File selected';
        dropHint.style.display = 'none';
    }
}

// Drag-and-drop
(function() {
    const area = document.getElementById('upload-drop-area');
    const input = document.getElementById('materialFile');
    area.addEventListener('dragover', e => { e.preventDefault(); area.classList.add('drag-over'); });
    area.addEventListener('dragleave', () => area.classList.remove('drag-over'));
    area.addEventListener('drop', e => {
        e.preventDefault();
        area.classList.remove('drag-over');
        if (e.dataTransfer.files.length > 0) {
            input.files = e.dataTransfer.files;
            previewFile(input);
        }
    });
})();

function validateUploadForm() {
    const syllabusId = document.getElementById('syllabusId').value;
    const name = document.getElementById('materialName').value.trim();
    const file = document.getElementById('materialFile').files[0];
    const err = document.getElementById('upload-form-error');

    if (!syllabusId) { err.textContent = 'Please select a syllabus.'; return false; }
    if (!name) { err.textContent = 'Material Name is required.'; return false; }
    if (!file) { err.textContent = 'Please select a file.'; return false; }
    if (file.size > 100 * 1024 * 1024) { err.textContent = 'File exceeds 100 MB limit.'; return false; }

    err.textContent = '';

    // Show progress indication
    const btn = document.getElementById('btn-upload-submit');
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Uploading...';
    btn.disabled = true;
    return true;
}
</script>

<jsp:include page="/view/layout/footer.jsp"/>
