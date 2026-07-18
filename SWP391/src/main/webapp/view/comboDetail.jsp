<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Combo Detail - ${combo.comboName}" scope="request"/>
<c:set var="pageDescription" value="Combo detail ${combo.comboName}" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/comboList.css"/>

<main class="container-fluid main-content">
    <div class="combo-page-heading">
        <a class="btn btn-back combo-back-button" href="${pageContext.request.contextPath}/combo?action=list&curriculumId=${curriculum.curriculumId}">
            <i class="bi bi-arrow-left me-1"></i>Back to Combo List
        </a>
        <div>
            <h2 class="page-title mb-1">Combo Detail</h2>
            <p class="text-muted mb-0">
                Curriculum:
                <strong>${curriculum.programCode}</strong>
                -
                <strong>${curriculum.curriculumName}</strong>
            </p>
        </div>
    </div>

    <section class="combo-list-section mt-4">
        <div class="combo-detail-card">
            <div class="detail-row">
                <div class="detail-label">Combo Name:</div>
                <div class="detail-value fw-bold"><c:out value="${combo.comboName}"/></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Description:</div>
                <div class="detail-value">
                    <c:choose>
                        <c:when test="${not empty combo.description}">
                            <c:out value="${combo.description}"/>
                        </c:when>
                        <c:otherwise><span class="text-muted">N/A</span></c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Status:</div>
                <div class="detail-value">
                    <span class="badge ${combo.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                        <c:out value="${combo.status}"/>
                    </span>
                </div>
            </div>
        </div>
    </section>

    <section class="combo-list-section mt-4">
        <h3 class="section-subtitle">Subjects In Combo</h3>
        <div class="table-responsive">
            <table class="fpt-table">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Subject Code</th>
                        <th>Subject Name</th>
                        <th>Credits</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty subjects}">
                            <tr>
                                <td colspan="5" class="empty-state">No subject found in this combo.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="subject" items="${subjects}" varStatus="loop">
                                <tr class="${loop.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                                    <td>${loop.index + 1}</td>
                                    <td><span class="combo-subject-codes"><c:out value="${subject.subjectCode}"/></span></td>
                                    <td><c:out value="${subject.subjectName}"/></td>
                                    <td>${subject.credits}</td>
                                    <td><c:out value="${subject.status}"/></td>
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
