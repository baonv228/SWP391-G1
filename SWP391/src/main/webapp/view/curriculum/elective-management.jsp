<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Elective Management - ${curriculum.curriculumName}" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <div class="d-flex justify-content-between align-items-center gap-2 flex-wrap mb-3">
        <h2 class="page-title mb-0">Elective Management</h2>
        <c:if test="${canCreateElective}">
            <a href="${pageContext.request.contextPath}/curriculum/elective?action=create&curriculumId=${curriculum.curriculumId}"
               class="btn text-white fw-bold d-inline-flex align-items-center gap-1 px-3"
               style="background-color: var(--fpt-orange); border: none;"
               id="btn-add-elective">
                <i class="bi bi-plus-circle"></i> Add Elective
            </a>
        </c:if>
    </div>

    <div class="detail-section mb-4" id="curriculum-elective-info">
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Curriculum ID:</div>
            <div class="col-md-10">
                <input type="text" class="form-control bg-light" value="${curriculum.curriculumId}" readonly />
            </div>
        </div>
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Curriculum Code:</div>
            <div class="col-md-10">
                <input type="text" class="form-control bg-light" value="${fn:escapeXml(curriculum.curriculumCode)}" readonly />
            </div>
        </div>
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Curriculum Name:</div>
            <div class="col-md-10">
                <input type="text" class="form-control bg-light" value="${fn:escapeXml(curriculum.curriculumName)}" readonly />
            </div>
        </div>
        <div class="row">
            <div class="col-md-10 offset-md-2">
                <a href="${pageContext.request.contextPath}/curriculum/detail?curriculumId=${curriculum.curriculumId}" class="link-detail" id="btn-back-to-curriculum-detail">
                    <i class="bi bi-arrow-left"></i> Back to curriculum details
                </a>
            </div>
        </div>
    </div>

    <div class="result-count mb-2" id="elective-list-result-count">
        ${fn:length(electiveList)} Elective Group(s) found
    </div>

    <div class="table-responsive">
        <table class="fpt-table" id="elective-table">
            <thead>
                <tr>
                    <th style="width: 15%">Elective ID</th>
                    <th style="width: 20%">Elective Code</th>
                    <th style="width: 30%">Elective Name</th>
                    <th style="width: 35%">Note</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty electiveList}">
                        <tr>
                            <td colspan="4" class="text-center py-4 text-muted">No Electives defined for this Curriculum.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="el" items="${electiveList}" varStatus="status">
                            <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}" id="elective-row-${el.electiveId}">
                                <td>${el.electiveId}</td>
                                <td class="fw-bold">${fn:escapeXml(el.electiveCode)}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/curriculum/elective/detail?action=detail&electiveId=${el.electiveId}" class="link-detail" id="link-elective-${el.electiveId}">
                                        ${fn:escapeXml(el.electiveName)}
                                    </a>
                                </td>
                                <td>${fn:escapeXml(el.note)}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
