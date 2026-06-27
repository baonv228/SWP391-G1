<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Show Learning Path - FPT University" scope="request"/>
<c:set var="pageDescription" value="View the full learning path and prerequisite chain for a subject." scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <h2 class="page-title">Show Learning Path of a Subject</h2>

    <%-- Search Form --%>
    <div class="search-section" id="learning-path-search-section">
        <form id="learning-path-form" action="${pageContext.request.contextPath}/learning-path" method="get"
              onsubmit="return validateSimpleSearch('lp-subject-input', 'lp-search-error')">
            <div class="search-bar">
                <label for="lp-subject-input" class="search-label">Subject Code:</label>
                <input type="text" name="subjectCode" id="lp-subject-input"
                       class="form-control search-input-simple"
                       value="${fn:escapeXml(subjectCode)}"
                       placeholder="e.g. LAB211"
                       maxlength="50"
                       autocomplete="off"/>
                <button type="submit" class="btn btn-search" id="lp-search-btn">Search</button>
            </div>
            <div id="lp-search-error" class="search-error-msg" role="alert"></div>
        </form>
    </div>

    <%-- Server Error --%>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-warning mt-3" id="lp-server-error" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
        </div>
    </c:if>

    <%-- Results --%>
    <c:if test="${searched}">
        <c:choose>
            <c:when test="${not empty learningPaths}">
                <div class="result-count" id="lp-result-count">
                    All ${totalResults} syllabus(es)
                </div>

                <div class="table-responsive mt-2" id="learning-path-table-wrapper">
                    <table class="fpt-table" id="learning-path-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Syllabus ID</th>
                                <th>Subject Name</th>
                                <th>Syllabus Name</th>
                                <th>DecisionNo MM/dd/yyyy</th>
                                <th>All subjects need to learn before</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="lp" items="${learningPaths}" varStatus="status">
                                <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}" id="lp-row-${status.index + 1}">
                                    <td>${status.index + 1}</td>
                                    <td>${lp.syllabusId}</td>
                                    <td>${lp.subjectCode}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/syllabus/detail?syllabusId=${lp.syllabusId}"
                                           class="link-detail" id="lp-syllabus-link-${lp.syllabusId}">
                                            ${lp.syllabusName}
                                        </a>
                                    </td>
                                    <td>${lp.decisionNo}</td>
                                    <td>
                                        <c:if test="${not empty lp.prerequisiteMap}">
                                            <c:forEach var="entry" items="${lp.prerequisiteMap}">
                                                <div class="prereq-entry" id="prereq-entry-${entry.key}">
                                                    <strong>${entry.key}:</strong>
                                                    <c:forEach var="prereq" items="${entry.value}" varStatus="ps">
                                                        ${prereq}<c:if test="${!ps.last}">, </c:if>
                                                    </c:forEach>
                                                    <c:if test="${not empty lp.prerequisiteMap}">
                                                        <ul class="prereq-sub-list">
                                                            <c:forEach var="subEntry" items="${lp.prerequisiteMap}">
                                                                <c:if test="${subEntry.key != entry.key}">
                                                                    <li id="prereq-sub-${subEntry.key}">
                                                                        ${subEntry.key}:
                                                                        <c:forEach var="p" items="${subEntry.value}" varStatus="ps2">
                                                                            ${p}<c:if test="${!ps2.last}">, </c:if>
                                                                        </c:forEach>
                                                                    </li>
                                                                </c:if>
                                                            </c:forEach>
                                                        </ul>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state" id="lp-empty-state">
                    <i class="bi bi-search fs-1 text-muted"></i>
                    <p class="mt-2 text-muted">No learning path found for subject code "<strong>${subjectCode}</strong>".</p>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
