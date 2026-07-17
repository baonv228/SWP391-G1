<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Combo List - ${curriculum.curriculumName}" scope="request"/>
<c:set var="pageDescription" value="Combo list of curriculum ${curriculum.curriculumName}" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/comboList.css"/>

<main class="container-fluid main-content">
    <div class="combo-page-heading">
        <div class="combo-top-actions">
            <a class="btn btn-back combo-back-button" href="${pageContext.request.contextPath}/curriculum/detail?curriculumId=${curriculum.curriculumId}">
                <i class="bi bi-arrow-left me-1"></i>Back to Curriculum Detail
            </a>
            <c:if test="${canCreateCombo}">
                <a class="btn create-combo-button" href="${pageContext.request.contextPath}/combo?action=create&curriculumId=${curriculum.curriculumId}">
                    Create Combo
                </a>
            </c:if>
        </div>
        <div>
            <h2 class="page-title mb-1">Combo List</h2>
            <p class="text-muted mb-0">
                Curriculum:
                <strong>${curriculum.programCode}</strong>
                -
                <strong>${curriculum.curriculumName}</strong>
            </p>
        </div>
    </div>

    <section class="combo-list-section mt-4">
        <div class="table-responsive">
            <table class="fpt-table">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Combo Name</th>
                        <th>Description</th>
                        <th>Subjects</th>
                        <th>Total Credits</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty combos}">
                            <tr>
                                <td colspan="6" class="empty-state">No combo found for this curriculum.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="combo" items="${combos}" varStatus="loop">
                                <tr class="${loop.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                                    <td>${loop.index + 1}</td>
                                    <td class="fw-bold">
                                        <a class="combo-name-link"
                                           href="${pageContext.request.contextPath}/combo?action=detail&comboId=${combo.comboId}">
                                            <c:out value="${combo.comboName}"/>
                                        </a>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty combo.description}">
                                                <c:out value="${combo.description}"/>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">N/A</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${combo.subjectCount}</td>
                                    <td>${combo.totalCredits}</td>
                                    <td>
                                        <span class="badge ${combo.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                                            <c:out value="${combo.status}"/>
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
