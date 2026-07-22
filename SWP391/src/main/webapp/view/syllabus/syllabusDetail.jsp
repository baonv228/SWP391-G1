<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Syllabus Details - ${syllabus.syllabusTitle}" scope="request"/>
<c:set var="pageDescription" value="Full syllabus detail for ${syllabus.subjectCode} - ${syllabus.syllabusTitle}" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<style>
.syllabus-property-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 2rem;
    font-size: 0.9rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}
.syllabus-property-table td {
    padding: 8px 16px;
    border: 1px solid #e9ecef;
    vertical-align: top;
    line-height: 1.5;
}
.syllabus-property-table td.property-label {
    width: 20%;
    font-weight: 600;
    color: #495057;
    background-color: #f8f9fa;
    text-align: right;
    border-right: 2px solid #dee2e6;
}
.syllabus-property-table td.property-value {
    color: #212529;
}
.section-header-orange {
    background-color: #f3722c;
    color: white;
    padding: 8px 16px;
    font-weight: bold;
    font-size: 0.95rem;
    border-radius: 4px 4px 0 0;
    margin-bottom: 0;
}
.materials-section-title {
    color: #f3722c;
    font-size: 0.9rem;
    font-weight: bold;
    margin-bottom: 0.5rem;
}
.table-syllabus-detail {
    font-size: 0.85rem;
    margin-bottom: 2rem;
    border-collapse: collapse;
    width: 100%;
}
.table-syllabus-detail th {
    background-color: #f3722c;
    color: white;
    font-weight: 600;
    padding: 8px 12px;
    border: 1px solid #e9ecef;
    text-align: left;
}
.table-syllabus-detail td {
    padding: 8px 12px;
    border: 1px solid #e9ecef;
    vertical-align: middle;
}
.syllabus-table-scroll {
    overflow-x: auto;
    margin-bottom: 2rem;
}
.syllabus-table-scroll .table-syllabus-detail {
    margin-bottom: 0;
    min-width: 1450px;
}
.badge-main {
    background-color: #e6f4ea;
    color: #137333;
    border: 1px solid #ceead6;
}
</style>

<main class="container-fluid main-content px-4 py-3">
    <div class="d-flex align-items-center gap-3 mb-3">
        <a href="${pageContext.request.contextPath}/syllabus" class="btn btn-back" id="btn-back-syllabus-list">
            <i class="bi bi-arrow-left me-1"></i>Back to List
        </a>
        <h2 class="page-title mb-0">Syllabus Details</h2>
    </div>

    <c:choose>
        <c:when test="${empty syllabus}">
            <div class="alert alert-warning" id="syllabus-detail-not-found">Syllabus not found.</div>
        </c:when>
        <c:otherwise>

            <%-- ═══════════════════════════════════════════════════════
                 SECTION 1 — Syllabus Property Sheet Table
            ═══════════════════════════════════════════════════════ --%>
            <table class="syllabus-property-table">
                <tbody>
                    <tr>
                        <td class="property-label">Syllabus ID:</td>
                        <td class="property-value" id="prop-id">${syllabus.syllabusId}</td>
                    </tr>
                    <tr>
                        <td class="property-label">Syllabus Name:</td>
                        <td class="property-value fw-bold" id="prop-name">${syllabus.syllabusName}</td>
                    </tr>
                    <tr>
                        <td class="property-label">Syllabus English:</td>
                        <td class="property-value" id="prop-english">${syllabus.syllabusEnglishName}</td>
                    </tr>
                    <tr>
                        <td class="property-label">Subject Code:</td>
                        <td class="property-value fw-bold" id="prop-code">${syllabus.subjectCode}</td>
                    </tr>
                    <tr>
                        <td class="property-label">NoCredit:</td>
                        <td class="property-value" id="prop-credits">${syllabus.credits}</td>
                    </tr>
                    <tr>
                        <td class="property-label">Degree Level:</td>
                        <td class="property-value" id="prop-degree">${syllabus.degreeLevel}</td>
                    </tr>
                    <tr>
                        <td class="property-label">Time Allocation:</td>
                        <td class="property-value" id="prop-time">${syllabus.timeAllocation}</td>
                    </tr>
                    <tr>
                        <td class="property-label">Pre-Requisite:</td>
                        <td class="property-value" id="prop-prereq">${syllabus.preRequisiteText}</td>
                    </tr>
                    <tr>
                        <td class="property-label">Description:</td>
                        <td class="property-value" id="prop-desc">${syllabus.description}</td>
                    </tr>
                    <tr>
                        <td class="property-label">StudentTasks:</td>
                        <td class="property-value" style="white-space: pre-line;" id="prop-tasks">${syllabus.studentTasks}</td>
                    </tr>
                    <tr>
                        <td class="property-label">Tools:</td>
                        <td class="property-value" style="white-space: pre-line;" id="prop-tools">${syllabus.tools}</td>
                    </tr>
                    <tr>
                        <td class="property-label">DecisionNo MM/dd/yyyy:</td>
                        <td class="property-value" id="prop-decision">${syllabus.decisionNo}</td>
                    </tr>
                    <tr>
                        <td class="property-label">IsApproved:</td>
                        <td class="property-value" id="prop-approved">
                            <span class="badge ${syllabus.approved ? 'bg-success' : 'bg-warning text-dark'}">
                                ${syllabus.approved ? 'True' : 'False'}
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="property-label">Note:</td>
                        <td class="property-value" id="prop-note">${syllabus.note}</td>
                    </tr>
                    <tr>
                        <td class="property-label">IsActive:</td>
                        <td class="property-value" id="prop-active">
                            <span class="badge ${syllabus.isActive() ? 'bg-success' : 'bg-secondary'}">
                                ${syllabus.isActive() ? 'True' : 'False'}
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="property-label">ApprovedDate:</td>
                        <td class="property-value" id="prop-approved-date">${syllabus.approvedAt}</td>
                    </tr>
                </tbody>
            </table>

            <%-- ═══════════════════════════════════════════════════════
                 SECTION 2 — Textbooks / Reference Materials
            ═══════════════════════════════════════════════════════ --%>
            <div class="materials-section-title">
                ${fn:length(syllabus.textbooks)} material(s)
            </div>
            <table class="table-syllabus-detail" id="textbooks-table">
                <thead>
                    <tr>
                        <th>MaterialDescription</th>
                        <th>Author</th>
                        <th>Publisher</th>
                        <th>PublishedDate</th>
                        <th>Edition</th>
                        <th>ISBN</th>
                        <th class="text-center">IsMainMaterial</th>
                        <th class="text-center">IsHardCopy</th>
                        <th class="text-center">IsOnline</th>
                        <th>Note</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty syllabus.textbooks}">
                            <tr>
                                <td colspan="10" class="text-muted text-center py-3">No reference materials added yet.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="book" items="${syllabus.textbooks}">
                                <tr>
                                    <td class="fw-bold">${book.materialDescription}</td>
                                    <td>${book.author}</td>
                                    <td>${book.publisher}</td>
                                    <td>${book.publishedDate}</td>
                                    <td>${book.edition}</td>
                                    <td>${book.isbn}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${book.isMainMaterial}">
                                                <i class="bi bi-check-square-fill text-success" style="font-size:1.1rem;"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-square text-muted" style="font-size:1.1rem;"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${book.isHardCopy}">
                                                <i class="bi bi-check-square-fill text-success" style="font-size:1.1rem;"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-square text-muted" style="font-size:1.1rem;"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${book.isOnline}">
                                                <i class="bi bi-check-square-fill text-success" style="font-size:1.1rem;"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-square text-muted" style="font-size:1.1rem;"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-muted" style="font-size: 0.8rem;">${book.note}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <%-- ═══════════════════════════════════════════════════════
                 SECTION 2b — Downloadable Learning Materials
            ═══════════════════════════════════════════════════════ --%>
            <c:set var="learningMaterialsSection">
            <div class="d-flex align-items-center justify-content-between mb-2">
                <div class="materials-section-title mb-0">
                    ${fn:length(syllabus.materials)} learning material(s)
                </div>
                <c:if test="${not empty syllabus.materials}">
                    <button class="btn btn-sm btn-upload-submit py-1 px-3 d-inline-flex align-items-center gap-1"
                            style="background-color: #f3722c; color: white;"
                            id="btn-download-all" onclick="downloadAllMaterials()" type="button">
                        <i class="bi bi-cloud-arrow-down-fill"></i> Download All
                    </button>
                </c:if>
            </div>
            <table class="table-syllabus-detail" id="learning-materials-table">
                <thead>
                    <tr>
                        <th style="width: 50px;">#</th>
                        <th>Name</th>
                        <th style="width: 90px;">Type</th>
                        <th style="width: 100px;">Visibility</th>
                        <th style="width: 150px;">Uploaded</th>
                        <th style="width: 100px;" class="text-center">Downloads</th>
                        <th style="width: 90px;" class="text-center">Download</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty syllabus.materials}">
                            <tr>
                                <td colspan="7" class="text-muted text-center py-3">No learning materials uploaded yet.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="mat" items="${syllabus.materials}" varStatus="s">
                                <tr>
                                    <td class="text-center">${s.index + 1}</td>
                                    <td>
                                        <i class="bi ${mat.typeIconClass} me-1" style="color: #f3722c;"></i>
                                        <c:choose>
                                            <c:when test="${mat.materialId > 0}">
                                                <a href="${pageContext.request.contextPath}/download-material?materialId=${mat.materialId}"
                                                   class="text-decoration-none fw-semibold" style="color: #f3722c;"
                                                   title="Download ${fn:escapeXml(mat.materialName)}">
                                                    <c:out value="${mat.materialName}"/>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="javascript:void(0)"
                                                   data-file-path="${fn:escapeXml(mat.filePath)}"
                                                   onclick="downloadSessionMaterial(this.dataset.filePath)"
                                                   class="text-decoration-none fw-semibold" style="color: #f3722c;"
                                                   title="Download ${fn:escapeXml(mat.materialName)}">
                                                    <c:out value="${mat.materialName}"/>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border">${mat.materialType}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${mat.visibility == 'Public'}">
                                                <span class="badge bg-success-subtle text-success border border-success" style="font-size:.75rem;">Public</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning-subtle text-warning border border-warning" style="font-size:.75rem;">Private</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-muted" style="font-size:.8rem;">
                                        <c:choose>
                                            <c:when test="${mat.materialId > 0}">${mat.uploadedAt}</c:when>
                                            <c:otherwise>From S-Download</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${mat.materialId > 0}">
                                                <span class="badge bg-info-subtle text-info border border-info">${mat.downloadCount}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${mat.materialId > 0}">
                                                <a href="${pageContext.request.contextPath}/download-material?materialId=${mat.materialId}"
                                                   class="btn btn-sm py-0 px-2 d-inline-flex align-items-center"
                                                   style="background-color: #f3722c; color: white;"
                                                   title="Download ${fn:escapeXml(mat.materialName)}">
                                                    <i class="bi bi-cloud-arrow-down-fill"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="javascript:void(0)"
                                                   data-file-path="${fn:escapeXml(mat.filePath)}"
                                                   onclick="downloadSessionMaterial(this.dataset.filePath)"
                                                   class="btn btn-sm py-0 px-2 d-inline-flex align-items-center"
                                                   style="background-color: #f3722c; color: white;"
                                                   title="Download ${fn:escapeXml(mat.materialName)}">
                                                    <i class="bi bi-cloud-arrow-down-fill"></i>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <%-- Hidden downloads area for Download All --%>
            <div id="download-all-links" style="display:none;">
                <c:forEach var="mat" items="${syllabus.materials}">
                    <c:choose>
                        <c:when test="${mat.materialId > 0}">
                            <span data-download-url="${pageContext.request.contextPath}/download-material?materialId=${mat.materialId}"></span>
                        </c:when>
                        <c:otherwise>
                            <span data-file-path="${fn:escapeXml(mat.filePath)}"></span>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
            </c:set>

            <%-- ═══════════════════════════════════════════════════════
                 SECTION 3 — CLOs Mapping
            ═══════════════════════════════════════════════════════ --%>
            <div class="materials-section-title">
                ${fn:length(syllabus.clos)} LO(s)
            </div>
            <table class="table-syllabus-detail" id="clos-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">CLO Name</th>
                        <th style="width: 150px;">CLO Details</th>
                        <th>LO Details</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty syllabus.clos}">
                            <tr>
                                <td colspan="3" class="text-muted text-center py-3">No course learning outcomes mapped yet.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="clo" items="${syllabus.clos}">
                                <tr>
                                    <td>${clo.cloName}</td>
                                    <td class="fw-bold">${clo.cloDetails}</td>
                                    <td>${clo.loDetails}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <a class="btn btn-link text-decoration-none p-0 mb-4 fw-semibold text-orange d-inline-flex align-items-center gap-1"
               style="color: #f3722c;"
               data-bs-toggle="collapse" href="#cloPloMappingCollapse" role="button" aria-expanded="false">
                <i class="bi bi-grid-3x3-gap-fill"></i> View mapping of CLOs to PLOs
            </a>
            <div class="collapse" id="cloPloMappingCollapse">
                <div class="card card-body mb-4 bg-light border-0 shadow-sm p-3">
                    <h6 class="fw-bold mb-3" style="color: #f3722c;"><i class="bi bi-link-45deg me-1"></i>Course Outcomes Mapped to Program Outcomes (PLOs)</h6>
                    <table class="table table-bordered table-sm text-center align-middle bg-white mb-0" style="font-size:0.85rem;">
                        <thead class="table-dark">
                            <tr>
                                <th style="width: 120px;">CLO Name</th>
                                <th>Mapped Program Learning Outcomes (PLOs)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="clo" items="${syllabus.clos}">
                                <tr>
                                    <td class="fw-bold bg-light">${clo.cloDetails}</td>
                                    <td class="text-start px-3">
                                        <c:choose>
                                            <c:when test="${empty clo.plos}">
                                                <span class="text-muted" style="font-size: 0.8rem;">No direct PLO mapping found.</span>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="p" items="${clo.plos}">
                                                    <span class="badge bg-secondary text-white me-2 p-1 px-2"
                                                          title="${fn:escapeXml(p.ploDescription)}"><c:out value="${p.ploCode}"/></span>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- ═══════════════════════════════════════════════════════
                 SECTION 4 — Weekly Syllabus Sessions
            ═══════════════════════════════════════════════════════ --%>
            <c:out value="${learningMaterialsSection}" escapeXml="false"/>
            <div class="d-flex align-items-center justify-content-between mb-2">
                <div class="materials-section-title mb-0">
                    ${fn:length(syllabus.sessions)} sessions (45'/session)
                </div>
            </div>
            <table class="table-syllabus-detail" id="sessions-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">Session</th>
                        <th>Topic</th>
                        <th style="width: 180px;">Learning-Teaching Type</th>
                        <th style="width: 80px;">LO</th>
                        <th style="width: 80px;">ITU</th>
                        <th style="width: 150px;">Student Materials</th>
                        <th style="width: 150px;">S-Download</th>
                        <th>Student's Tasks</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty syllabus.sessions}">
                            <tr>
                                <td colspan="8" class="text-muted text-center py-3">No sessions scheduled for this syllabus.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="s" items="${syllabus.sessions}">
                                <tr>
                                    <td class="text-center fw-semibold">${s.sessionNo}</td>
                                    <td class="fw-bold">${s.topic}</td>
                                    <td>${s.learningTeachingType}</td>
                                    <td class="text-center">${s.lo}</td>
                                    <td class="text-center">${s.itu}</td>
                                    <td>${s.studentMaterials}</td>
                                    <td style="visibility: hidden;" aria-hidden="true">
                                        <c:choose>
                                            <c:when test="${not empty s.studentDownload}">
                                                <a href="javascript:void(0)"
                                                   onclick="downloadSessionMaterial('${s.studentDownload}')"
                                                   class="text-decoration-none fw-bold" style="color: #f3722c;">
                                                    <i class="bi bi-file-earmark-arrow-down-fill me-1"></i>${s.studentDownload}
                                                </a>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-size: 0.8rem;" class="text-muted">${s.studentTasks}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="materials-section-title">
                ${fn:length(syllabus.constructiveQuestions)} constructive question(s)
            </div>
            <c:if test="${syllabus.constructiveQuestions != null and fn:length(syllabus.constructiveQuestions) gt 0}">
                <table class="table-syllabus-detail" id="constructive-questions-table">
                    <thead>
                        <tr>
                            <th style="width:55px;"></th>
                            <th style="width:120px;">Session No</th>
                            <th style="width:280px;">Name</th>
                            <th>Details</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="question" items="${syllabus.constructiveQuestions}" varStatus="questionStatus">
                            <tr>
                                <td class="text-center">${questionStatus.index + 1}</td>
                                <td class="text-center"><c:out value="${question.sessionNo}"/></td>
                                <td><c:out value="${question.name}"/></td>
                                <td><c:out value="${question.details}"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <div class="materials-section-title">
                ${fn:length(syllabus.assessments)} assessment(s)
            </div>
            <div class="syllabus-table-scroll">
                <table class="table-syllabus-detail" id="assessments-table">
                    <thead>
                        <tr>
                            <th>Category</th>
                            <th>Type</th>
                            <th style="width:65px;">Part</th>
                            <th style="width:80px;">Weight</th>
                            <th>Completion Criteria</th>
                            <th>Duration</th>
                            <th>CLO</th>
                            <th>Question Type</th>
                            <th>No. Question</th>
                            <th>Knowledge and Skill</th>
                            <th>Grading Guide</th>
                            <th>Note</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty syllabus.assessments}">
                                <tr>
                                    <td colspan="12" class="text-muted text-center py-3">No assessments added yet.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="assessment" items="${syllabus.assessments}">
                                    <tr>
                                        <td><c:out value="${assessment.category}"/></td>
                                        <td><c:out value="${assessment.type}"/></td>
                                        <td class="text-center"><c:out value="${assessment.part}"/></td>
                                        <td class="text-center">${assessment.weight}%</td>
                                        <td><c:out value="${assessment.completionCriteria}"/></td>
                                        <td><c:out value="${assessment.duration}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty assessment.cloNames}">—</c:when>
                                                <c:otherwise>
                                                    <c:forEach var="cloName" items="${assessment.cloNames}" varStatus="cloStatus">
                                                        <c:if test="${not cloStatus.first}">, </c:if><c:out value="${cloName}"/>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><c:out value="${assessment.questionType}"/></td>
                                        <td class="text-center"><c:out value="${assessment.noQuestion}"/></td>
                                        <td><c:out value="${assessment.knowledgeAndSkill}"/></td>
                                        <td><c:out value="${assessment.gradingGuide}"/></td>
                                        <td><c:out value="${assessment.note}"/></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

        </c:otherwise>
    </c:choose>
</main>

<script>
function downloadSessionMaterial(filePath) {
    window.location.href = buildSessionMaterialUrl(filePath);
}

function buildSessionMaterialUrl(filePath) {
    const ctx = '${pageContext.request.contextPath}';
    if (/^https?:\/\//i.test(filePath)) {
        return filePath;
    }
    return filePath.startsWith('/materials/')
        ? ctx + filePath
        : ctx + '/materials/' + filePath.replace(/^\/+/, '');
}

function getMaterialDownloadUrl(element) {
    if (element.dataset.downloadUrl) {
        return element.dataset.downloadUrl;
    }
    if (element.dataset.filePath) {
        return buildSessionMaterialUrl(element.dataset.filePath);
    }
    return null;
}

function downloadSingleMaterial(url) {
    const iframe = document.createElement('iframe');
    iframe.style.display = 'none';
    iframe.src = url;
    document.body.appendChild(iframe);
    setTimeout(function () { 
        document.body.removeChild(iframe); 
    }, 5000);
}

function downloadAllMaterials() {
    const container = document.getElementById('download-all-links');
    if (!container) return;
    const links = container.querySelectorAll('[data-file-path], [data-download-url]');
    if (links.length === 0) {
        alert('No materials to download.');
        return;
    }
    links.forEach(function (el, idx) {
        setTimeout(function () {
            const url = getMaterialDownloadUrl(el);
            if (url) {
                downloadSingleMaterial(url);
            }
        }, idx * 1000);
    });
}
</script>

<jsp:include page="/view/layout/footer.jsp"/>
