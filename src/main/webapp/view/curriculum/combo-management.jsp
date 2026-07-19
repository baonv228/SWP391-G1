<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Combo Management - ${curriculum.curriculumName}" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <h2 class="page-title">Combo Management</h2>

    <div class="detail-section mb-4" id="curriculum-combo-info">
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

    <div class="result-count mb-2" id="combo-list-result-count">
        ${fn:length(comboList)} Combo(s) found
    </div>

    <div class="table-responsive">
        <table class="fpt-table" id="combo-table">
            <thead>
                <tr>
                    <th style="width: 15%">Combo ID</th>
                    <th style="width: 20%">Combo Code</th>
                    <th style="width: 30%">Combo Name</th>
                    <th style="width: 35%">Description</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty comboList}">
                        <tr>
                            <td colspan="4" class="text-center py-4 text-muted">No Combos defined for this Curriculum.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="combo" items="${comboList}" varStatus="status">
                            <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}" id="combo-row-${combo.comboId}">
                                <td>${combo.comboId}</td>
                                <td class="fw-bold">${fn:escapeXml(combo.comboCode)}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/curriculum/combo/detail?action=detail&comboId=${combo.comboId}" class="link-detail" id="link-combo-${combo.comboId}">
                                        ${fn:escapeXml(combo.comboName)}
                                    </a>
                                </td>
                                <td>${fn:escapeXml(combo.description)}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
