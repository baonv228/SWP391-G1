<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="View PO - ${curriculum.curriculumName}" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<style>
    .mapping-tick {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 18px;
        height: 18px;
        border-radius: 4px;
        background: #198754;
        color: #fff;
        font-size: 0.75rem;
        font-weight: 700;
        line-height: 1;
    }
</style>

<main class="container-fluid main-content">
    <c:set var="mappingEditable" value="${canManageMapping and (not mappingExists or editMapping)}"/>

    <h2 class="page-title">View PO</h2>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert" id="po-success-alert">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("successMessage"); %>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert" id="po-error-alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("errorMessage"); %>
    </c:if>

    <div class="detail-section mb-4" id="curriculum-po-info">
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Curriculum ID:</div>
            <div class="col-md-10">
                <input type="text" class="form-control bg-light" id="input-curriculum-id"
                       value="${fn:escapeXml(curriculum.curriculumCode)}" readonly/>
            </div>
        </div>
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Curriculum Name:</div>
            <div class="col-md-10">
                <input type="text" class="form-control bg-light" id="input-curriculum-name"
                       value="${fn:escapeXml(curriculum.curriculumName)}" readonly/>
            </div>
        </div>
        <div class="row">
            <div class="col-md-10 offset-md-2">
                <a href="${pageContext.request.contextPath}/curriculum/detail?curriculumId=${curriculum.curriculumId}"
                   class="link-detail" id="btn-back-to-curriculum-detail">
                    <i class="bi bi-arrow-left"></i> Back to curriculum details
                </a>
            </div>
        </div>
    </div>

    <div class="result-count mb-2" id="po-list-result-count">
        <span>${fn:length(poList)} PO(s) found</span>
    </div>

    <div class="table-responsive">
        <table class="fpt-table" id="po-table">
            <thead>
                <tr>
                    <th style="width: 15%">PO ID</th>
                    <th style="width: 20%">PO Code</th>
                    <th style="width: 65%">PO Description</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty poList}">
                        <tr>
                            <td colspan="3" class="text-center py-4 text-muted" id="td-empty-po">
                                No Program Outcomes defined for this Curriculum.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="po" items="${poList}" varStatus="status">
                            <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}" id="po-row-${po.poId}">
                                <td>${po.poId}</td>
                                <td class="fw-bold">${fn:escapeXml(po.poName)}</td>
                                <td style="white-space: pre-wrap;">${fn:escapeXml(po.poDescription)}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <h3 class="section-subtitle mt-5 mb-2" id="plo-section-title">${fn:length(ploList)} PLO(s) found</h3>
    <div class="table-responsive">
        <table class="fpt-table" id="plo-table">
            <thead>
                <tr>
                    <th style="width: 15%">PLO ID</th>
                    <th style="width: 20%">PLO Code</th>
                    <th style="width: 65%">PLO Description</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty ploList}">
                        <tr>
                            <td colspan="3" class="text-center py-4 text-muted" id="td-empty-plo">
                                No Program Learning Outcomes defined for this Curriculum.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="plo" items="${ploList}" varStatus="status">
                            <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}" id="plo-row-${plo.ploId}">
                                <td>${plo.ploId}</td>
                                <td class="fw-bold">${fn:escapeXml(plo.ploName)}</td>
                                <td style="white-space: pre-wrap;">${fn:escapeXml(plo.ploDescription)}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <div class="d-flex justify-content-between align-items-center mt-5 mb-2">
        <h3 class="section-subtitle m-0" id="mapping-section-title">Mapping PO to PLO</h3>
        <c:if test="${canManageMapping and mappingExists and not editMapping}">
            <a class="btn text-white fw-bold"
               style="background-color: var(--fpt-orange); border: none;"
               href="${pageContext.request.contextPath}/curriculum/po?action=list&amp;curriculumId=${curriculumId}&amp;editMapping=true"
               id="btn-edit-po-plo-mapping">
                <i class="bi bi-pencil-square me-1"></i>Edit Mapping
            </a>
        </c:if>
    </div>

    <form action="${pageContext.request.contextPath}/curriculum/po" method="post"
          id="po-plo-mapping-form"
          onsubmit="return confirm('Are you sure you want to save this PO-PLO mapping?');">
        <input type="hidden" name="action" value="saveMapping"/>
        <input type="hidden" name="curriculumId" value="${curriculumId}"/>

        <div class="table-responsive mb-5">
            <table class="fpt-table text-center" id="mapping-matrix-table">
                <thead>
                    <tr style="background-color: var(--fpt-orange); color: #fff;">
                        <th style="width: 15%; text-align: center; vertical-align: middle; font-weight: bold;">PLO(s)</th>
                        <c:forEach var="po" items="${poList}">
                            <th style="text-align: center; vertical-align: middle; font-weight: bold;">
                                ${fn:escapeXml(po.poName)}
                            </th>
                        </c:forEach>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty ploList or empty poList}">
                            <tr>
                                <td colspan="${fn:length(poList) + 1}" class="text-center py-4 text-muted">
                                    No outcomes to map.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="plo" items="${ploList}" varStatus="status">
                                <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                                    <td class="fw-bold text-start ps-3">${fn:escapeXml(plo.ploName)}</td>
                                    <c:forEach var="po" items="${poList}">
                                        <c:set var="poId" value="${po.poId}"/>
                                        <c:set var="ploId" value="${plo.ploId}"/>
                                        <c:set var="mappedList" value="${poPloMapping[poId]}"/>
                                        <td class="fw-bold text-success" style="font-size: 1rem;">
                                            <c:choose>
                                                <c:when test="${mappingEditable}">
                                                    <input type="checkbox" name="mapping" value="${poId}:${ploId}"
                                                           class="form-check-input"
                                                           ${not empty mappedList and mappedList.contains(ploId) ? 'checked' : ''}/>
                                                </c:when>
                                                <c:when test="${not empty mappedList and mappedList.contains(ploId)}">
                                                    <span class="mapping-tick" aria-label="Mapped">&#10003;</span>
                                                </c:when>
                                                <c:otherwise>&nbsp;</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <c:if test="${mappingEditable and not empty poList and not empty ploList}">
                <div class="text-end mt-3">
                    <c:if test="${mappingExists}">
                        <a class="btn btn-secondary fw-bold me-2"
                           href="${pageContext.request.contextPath}/curriculum/po?action=list&amp;curriculumId=${curriculumId}">
                            Cancel
                        </a>
                    </c:if>
                    <button type="submit" class="btn text-white fw-bold"
                            style="background-color: var(--fpt-orange); border: none;">
                        <i class="bi bi-save me-1"></i>Save Mapping
                    </button>
                </div>
            </c:if>
        </div>
    </form>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
