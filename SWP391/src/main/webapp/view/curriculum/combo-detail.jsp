<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Combo Detail - ${combo.comboName}" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <h2 class="page-title">Combo Detail</h2>

    <div class="detail-section mb-4" id="combo-info-card">
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Combo Name:</div>
            <div class="col-md-10">
                <input type="text" class="form-control bg-light" value="${fn:escapeXml(combo.comboName)}" readonly />
            </div>
        </div>
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Description:</div>
            <div class="col-md-10">
                <textarea class="form-control bg-light" rows="3" readonly>${fn:escapeXml(combo.description)}</textarea>
            </div>
        </div>
        <div class="row">
            <div class="col-md-10 offset-md-2">
                <a href="${pageContext.request.contextPath}/curriculum/combo?action=list&curriculumId=${curriculum.curriculumId}" class="link-detail" id="btn-back-to-combos">
                    <i class="bi bi-arrow-left"></i> Back to Combo list
                </a>
            </div>
        </div>
    </div>

    <h3 class="section-subtitle mt-4 mb-2">Subject List</h3>
    <div class="table-responsive">
        <table class="fpt-table" id="combo-subjects-table">
            <thead>
                <tr>
                    <th style="width: 10%">No.</th>
                    <th style="width: 20%">Subject Code</th>
                    <th style="width: 40%">Subject Name</th>
                    <th style="width: 30%">Semester</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty subjectList}">
                        <tr>
                            <td colspan="4" class="text-center py-4 text-muted">No Subjects mapped to this Combo.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="cs" items="${subjectList}" varStatus="status">
                            <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}" id="combo-subj-row-${cs.subjectId}">
                                <td>${status.index + 1}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/learning-path?subjectCode=${cs.subjectCode}" class="link-detail">
                                        ${fn:escapeXml(cs.subjectCode)}
                                    </a>
                                </td>
                                <td class="fw-semibold">${fn:escapeXml(cs.subjectName)}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty cs.semesterNo}">Semester ${cs.semesterNo}</c:when>
                                        <c:otherwise><span class="text-muted">N/A</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
