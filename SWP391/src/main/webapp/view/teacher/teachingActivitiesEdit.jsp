<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Manage Session Materials - Teacher" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <div class="d-flex align-items-center gap-3 mb-3">
        <a href="${pageContext.request.contextPath}/teacher/teaching-activities?syllabusId=${selectedSyllabusId}"
           class="btn btn-back" id="btn-back-view">
            <i class="bi bi-arrow-left me-1"></i>Back
        </a>
        <h2 class="page-title mb-0">Manage Session Materials</h2>
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

    <c:choose>
        <c:when test="${empty sessions}">
            <div class="teacher-card">
                <div class="teacher-card-body">
                    <p class="text-muted text-center py-3 mb-0">
                        This syllabus has no teaching sessions yet.
                    </p>
                </div>
            </div>
        </c:when>
        <c:when test="${empty myMaterials}">
            <div class="teacher-card">
                <div class="teacher-card-body">
                    <p class="text-muted text-center py-3 mb-0">
                        You have no private-cloud materials for this syllabus yet.
                        <a href="${pageContext.request.contextPath}/teacher/upload-material?syllabusId=${selectedSyllabusId}">Upload one first.</a>
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
                    </div>
                    <div class="teacher-card-body">
                        <%-- Attached materials with unlink --%>
                        <c:set var="mats" value="${linksBySession[ses.sessionNumber]}"/>
                        <c:choose>
                            <c:when test="${empty mats}">
                                <p class="text-muted mb-2" style="font-size:.85rem;">
                                    No materials attached yet.
                                </p>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive mb-2">
                                    <table class="fpt-table mb-0">
                                        <thead>
                                            <tr>
                                                <th>Material</th>
                                                <th>Type</th>
                                                <th class="text-center">Downloads</th>
                                                <th class="text-center">Remove</th>
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
                                                    <td class="text-center">
                                                        <span class="badge bg-info-subtle text-info border border-info">${mat.downloadCount}</span>
                                                    </td>
                                                    <td class="text-center">
                                                        <form action="${pageContext.request.contextPath}/teacher/teaching-activities/edit"
                                                              method="post" class="d-inline mb-0"
                                                              onsubmit="return confirm('Remove this material from the session?');">
                                                            <input type="hidden" name="action" value="unlink"/>
                                                            <input type="hidden" name="syllabusId" value="${selectedSyllabusId}"/>
                                                            <input type="hidden" name="sessionNumber" value="${ses.sessionNumber}"/>
                                                            <input type="hidden" name="materialId" value="${mat.materialId}"/>
                                                            <button type="submit" class="btn btn-sm btn-outline-danger py-0 px-2"
                                                                    title="Remove ${fn:escapeXml(mat.materialName)}">
                                                                <i class="bi bi-x-lg"></i>
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <%-- Attach a material from the private cloud --%>
                        <form action="${pageContext.request.contextPath}/teacher/teaching-activities/edit"
                              method="post" class="row g-2 align-items-end">
                            <input type="hidden" name="action" value="link"/>
                            <input type="hidden" name="syllabusId" value="${selectedSyllabusId}"/>
                            <input type="hidden" name="sessionNumber" value="${ses.sessionNumber}"/>
                            <div class="col-sm-8">
                                <select name="materialId" class="form-select form-select-sm" required>
                                    <option value="">— Select material to attach —</option>
                                    <c:forEach var="m" items="${myMaterials}">
                                        <option value="${m.materialId}">
                                            ${fn:escapeXml(m.materialName)} (${m.materialType})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-sm-4">
                                <button type="submit" class="btn btn-sm btn-upload-submit w-100">
                                    <i class="bi bi-plus-lg me-1"></i>Attach
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
