<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Elective Group Detail - ${elective.electiveName}" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<main class="container-fluid main-content">
    <h2 class="page-title">Elective Detail</h2>

    <div class="detail-section mb-4" id="elective-info-card">
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Elective Code:</div>
            <div class="col-md-10">
                <input type="text" class="form-control bg-light" value="${fn:escapeXml(elective.electiveCode)}" readonly />
            </div>
        </div>
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Elective Name:</div>
            <div class="col-md-10">
                <input type="text" class="form-control bg-light" value="${fn:escapeXml(elective.electiveName)}" readonly />
            </div>
        </div>
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Note:</div>
            <div class="col-md-10">
                <textarea class="form-control bg-light" rows="3" readonly>${fn:escapeXml(elective.note)}</textarea>
            </div>
        </div>
        <div class="row">
            <div class="col-md-10 offset-md-2">
                <a href="${pageContext.request.contextPath}/curriculum/elective?action=list&curriculumId=${curriculum.curriculumId}" class="link-detail" id="btn-back-to-electives">
                    <i class="bi bi-arrow-left"></i> Back to Elective list
                </a>
            </div>
        </div>
    </div>

    <h3 class="section-subtitle mt-4 mb-2">Subject List</h3>
    <div class="table-responsive">
        <table class="fpt-table" id="elective-subjects-table">
            <thead>
                <tr>
                    <th style="width: 15%">No.</th>
                    <th style="width: 25%">Subject Code</th>
                    <th style="width: 60%">Subject Name</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty subjectList}">
                        <tr>
                            <td colspan="3" class="text-center py-4 text-muted">No Subjects mapped to this Elective.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="sub" items="${subjectList}" varStatus="status">
                            <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}" id="elective-subj-row-${sub.subjectId}">
                                <td>${status.index + 1}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/learning-path?subjectCode=${sub.subjectCode}" class="link-detail">
                                        ${fn:escapeXml(sub.subjectCode)}
                                    </a>
                                </td>
                                <td class="fw-semibold">${fn:escapeXml(sub.subjectName)}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="/views/layout/footer.jsp"/>
