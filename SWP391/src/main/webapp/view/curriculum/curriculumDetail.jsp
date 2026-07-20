<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Curriculum Detail - ${curriculum.curriculumName}" scope="request"/>
<c:set var="pageDescription" value="Detailed view of curriculum ${curriculum.programCode} - ${curriculum.curriculumName}" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <h2 class="page-title">Curriculum Detail</h2>

    <c:choose>
        <c:when test="${empty curriculum}">
            <div class="alert alert-warning" id="curriculum-detail-not-found">Curriculum not found.</div>
        </c:when>
        <c:otherwise>
            <%-- Curriculum Info Card --%>
            <div class="detail-section" id="curriculum-info-section">
                <div class="detail-row">
                    <div class="detail-label">Program Code:</div>
                    <div class="detail-value fw-bold" id="detail-program-code">${curriculum.programCode}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Program Name:</div>
                    <div class="detail-value fw-bold" id="detail-program-name">${curriculum.programName}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Curriculum Name:</div>
                    <div class="detail-value" id="detail-curriculum-name">${curriculum.curriculumName}</div>
                </div>
                <c:if test="${not empty curriculum.majorName}">
                    <div class="detail-row">
                        <div class="detail-label">Major:</div>
                        <div class="detail-value" id="detail-major">${curriculum.majorName}</div>
                    </div>
                </c:if>
                <c:if test="${not empty curriculum.academicYear}">
                    <div class="detail-row">
                        <div class="detail-label">Academic Year:</div>
                        <div class="detail-value" id="detail-academic-year">${curriculum.academicYear}</div>
                    </div>
                </c:if>
                <div class="detail-row">
                    <div class="detail-label">Description:</div>
                    <div class="detail-value" id="detail-curriculum-desc">
                        <c:choose>
                            <c:when test="${not empty curriculum.description}">${curriculum.description}</c:when>
                            <c:otherwise><span class="text-muted">N/A</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Total Credits:</div>
                    <div class="detail-value fw-bold text-success" id="detail-total-credits">${curriculum.totalCredits}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Status:</div>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${curriculum.status == 'Active'}">
                                <span class="badge bg-success" id="detail-curriculum-status">Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary" id="detail-curriculum-status">${curriculum.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
               
            </div>

            <%-- Semester Breakdown --%>
            <c:if test="${not empty curriculum.semesterSubjects}">
                <div class="semester-section mt-4" id="curriculum-semester-section">
                    <h3 class="section-subtitle">Semester Breakdown</h3>
                    <c:forEach var="entry" items="${curriculum.semesterSubjects}">
                        <div class="semester-block" id="semester-block-${entry.key}">
                            <div class="semester-header">Semester ${entry.key}</div>
                            <div class="table-responsive">
                                <table class="fpt-table curriculum-semester-table"
                                       id="semester-${entry.key}-table"
                                       style="table-layout: fixed;">
                                    <colgroup>
                                        <col style="width: 16.5%;">
                                        <col style="width: 38%;">
                                        <col style="width: 11%;">
                                        <col style="width: 13%;">
                                        <col style="width: 21.5%;">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>Subject Code</th>
                                            <th>Subject Name</th>
                                            <th>Credits</th>
                                            <th>Required</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="sub" items="${entry.value}" varStatus="subStatus">
                                            <tr class="${subStatus.index % 2 == 0 ? 'row-even' : 'row-odd'}"
                                                id="semester-${entry.key}-subject-${sub.subjectId}">
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/learning-path?subjectCode=${sub.subjectCode}"
                                                       class="link-detail" id="link-lp-${sub.subjectCode}">
                                                        ${sub.subjectCode}
                                                    </a>
                                                </td>
                                                <td>${sub.subjectName}</td>
                                                <td>${sub.credits}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sub.required}">
                                                            <span class="badge bg-warning text-dark">Required</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-light text-secondary border">Elective</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${sub.status}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <%-- Graduation Requirements Summary --%>
            <div class="graduation-section mt-4" id="graduation-requirements">
                <h3 class="section-subtitle">Graduation Requirements</h3>
                <div class="req-box">
                    <p><strong>Total Credits Required:</strong> ${curriculum.totalCredits}</p>
                    <p class="text-muted mb-0">All required subjects in each semester must be completed successfully to meet graduation requirements.</p>
                </div>
            </div>

            <div class="mt-4 d-flex gap-2 flex-wrap">
                <a href="${pageContext.request.contextPath}/curriculum" class="btn btn-back" id="btn-back-curriculum">
                    <i class="bi bi-arrow-left me-1"></i>Back to Curriculum List
                </a>
                <a href="${pageContext.request.contextPath}/curriculum/po?action=list&amp;curriculumId=${curriculum.curriculumId}" class="btn text-white fw-bold d-inline-flex align-items-center gap-1 px-3" style="background-color: var(--fpt-orange); border: none;" id="btn-view-po">
                    <i class="bi bi-eye-fill"></i> View PO
                </a>
                <a href="${pageContext.request.contextPath}/combo?action=list&curriculumId=${curriculum.curriculumId}" class="btn text-white fw-bold d-inline-flex align-items-center gap-1 px-3" style="background-color: var(--fpt-orange); border: none;" id="btn-view-combo">
                    <i class="bi bi-stack"></i> View Combo
                </a>
                <a href="${pageContext.request.contextPath}/curriculum/elective?action=list&curriculumId=${curriculum.curriculumId}" class="btn text-white fw-bold d-inline-flex align-items-center gap-1 px-3" style="background-color: var(--fpt-orange); border: none;" id="btn-view-elective">
                    <i class="bi bi-list-check"></i> View Elective
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
