<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Elective List - ${curriculum.curriculumName}" scope="request"/>
<c:set var="pageDescription" value="Elective list of curriculum ${curriculum.curriculumName}" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/electiveList.css"/>

<main class="container-fluid main-content">
    <div class="elective-page-heading">
        <div class="elective-top-actions">
            <a class="btn btn-back elective-back-button" href="${pageContext.request.contextPath}/curriculum/detail?curriculumId=${curriculum.curriculumId}">
                <i class="bi bi-arrow-left me-1"></i>Back to Curriculum Detail
            </a>
            <c:if test="${canCreateElective}">
                <a class="btn add-elective-button" href="${pageContext.request.contextPath}/elective?action=create&curriculumId=${curriculum.curriculumId}">
                    Add new elective Course
                </a>
            </c:if>
        </div>
        <div>
            <h2 class="page-title mb-1">Elective List</h2>
            <p class="text-muted mb-0">
                Curriculum:
                <strong>${curriculum.programCode}</strong>
                -
                <strong>${curriculum.curriculumName}</strong>
            </p>
        </div>
    </div>

    <section class="elective-list-section mt-4">
        <div class="table-responsive">
            <table class="fpt-table">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Group Name</th>
                        <th>Subject Code</th>
                        <th>Subject Name</th>
                        <th>Credits</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty electives}">
                            <tr>
                                <td colspan="6" class="empty-state">No elective found for this curriculum.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="elective" items="${electives}" varStatus="loop">
                                <tr class="${loop.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                                    <td>${loop.index + 1}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty elective.electiveGroupName}">
                                                <c:out value="${elective.electiveGroupName}"/>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">N/A</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><span class="elective-subject-code"><c:out value="${elective.subjectCode}"/></span></td>
                                    <td><c:out value="${elective.subjectName}"/></td>
                                    <td>${elective.credits}</td>
                                    <td>
                                        <span class="badge ${elective.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                                            <c:out value="${elective.status}"/>
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </section>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
