<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Syllabus Management - FPT University" scope="request"/>
<c:set var="pageDescription" value="Search and browse syllabi by code, name, or subject code." scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<main class="container-fluid main-content">
    <h2 class="page-title">Syllabus Management</h2>

    <%-- Search Form --%>
    <div class="search-section" id="syllabus-search-section">
        <form id="syllabus-search-form" action="${pageContext.request.contextPath}/syllabus" method="get"
              onsubmit="return validateSearchForm('syllabus-keyword-input', 'syllabus-search-error')">
            <div class="search-bar">
                <label for="syllabus-searchtype-select" class="search-label">Search by:</label>
                <select name="searchType" id="syllabus-searchtype-select" class="form-select search-type-select">
                    <option value="code"    ${searchType == 'code'    ? 'selected' : ''}>Subject Code</option>
                    <option value="name"    ${searchType == 'name'    ? 'selected' : ''}>Syllabus Name</option>
                    <option value="subject" ${searchType == 'subject' ? 'selected' : ''}>Subject Code/Name</option>
                </select>
                <input type="text" name="keyword" id="syllabus-keyword-input"
                       class="form-control search-input"
                       value="${fn:escapeXml(keyword)}"
                       placeholder="Enter search term..."
                       maxlength="200"
                       autocomplete="off"/>
                <button type="submit" class="btn btn-search" id="syllabus-search-btn">Search</button>
            </div>
            <div id="syllabus-search-error" class="search-error-msg" role="alert"></div>
        </form>
    </div>

    <%-- Server Validation Error --%>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-warning mt-3" id="server-error-alert" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
        </div>
    </c:if>

    <%-- Results --%>
    <c:if test="${not empty syllabi}">
        <div class="result-count" id="syllabus-result-count">
            ${totalRecords} syllabus(es) found
        </div>

        <div class="table-responsive" id="syllabus-table-wrapper">
            <table class="fpt-table" id="syllabus-table">
                <thead>
                    <tr>
                        <th>Syllabus ID</th>
                        <th>Subject Code</th>
                        <th>Subject Name</th>
                        <th>Syllabus Name</th>
                        <th>Is Current Version</th>
                        <th>Approved</th>
                        <th>Version No</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${syllabi}" varStatus="status">
                        <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                            <td>${s.syllabusId}</td>
                            <td>${s.subjectCode}</td>
                            <td>${s.subjectName}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/syllabus/detail?syllabusId=${s.syllabusId}"
                                   class="link-detail" id="syllabus-link-${s.syllabusId}">
                                    ${s.syllabusTitle}
                                </a>
                            </td>
                            <td class="text-center">
                                <input type="checkbox" ${s.currentVersion ? 'checked' : ''} disabled
                                       aria-label="${s.currentVersion ? 'Current version' : 'Not current version'}"/>
                            </td>
                            <td class="text-center">
                                <input type="checkbox" ${s.approved ? 'checked' : ''} disabled
                                       aria-label="${s.approved ? 'Approved' : 'Not approved'}"/>
                            </td>
                            <td id="version-${s.syllabusId}">
                                <a href="${pageContext.request.contextPath}/syllabus/detail?syllabusId=${s.syllabusId}"
                                   class="link-decision" id="decision-link-${s.syllabusId}">
                                    ${s.versionNo}
                                </a>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${s.status == 'Active' or s.status == 'Approved'}">
                                        <span class="badge bg-success">${s.status}</span>
                                    </c:when>
                                    <c:when test="${s.status == 'Draft'}">
                                        <span class="badge bg-warning text-dark">${s.status}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${s.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <%-- Pagination --%>
        <c:if test="${pagination.totalPages > 1}">
            <nav aria-label="Syllabus pagination" class="mt-3">
                <ul class="pagination fpt-pagination" id="syllabus-pagination">
                    <c:if test="${pagination.hasPrevious()}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/syllabus?searchType=${searchType}&keyword=${keyword}&page=${pagination.previousPage}"
                               id="syllabus-page-prev">Previous</a>
                        </li>
                    </c:if>
                    <c:forEach begin="1" end="${pagination.totalPages}" var="p">
                        <li class="page-item ${p == pagination.currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/syllabus?searchType=${searchType}&keyword=${keyword}&page=${p}"
                               id="syllabus-page-${p}">${p}</a>
                        </li>
                    </c:forEach>
                    <c:if test="${pagination.hasNext()}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/syllabus?searchType=${searchType}&keyword=${keyword}&page=${pagination.nextPage}"
                               id="syllabus-page-next">Next</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </c:if>

    <%-- Empty State --%>
    <c:if test="${searched and empty syllabi}">
        <div class="empty-state" id="syllabus-empty-state">
            <i class="bi bi-search fs-1 text-muted"></i>
            <p class="mt-2 text-muted">No syllabus found for "<strong>${keyword}</strong>".</p>
        </div>
    </c:if>
</main>

<jsp:include page="/views/layout/footer.jsp"/>
