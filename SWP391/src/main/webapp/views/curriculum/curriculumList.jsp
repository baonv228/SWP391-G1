<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Curriculum Listing - FPT University" scope="request"/>
<c:set var="pageDescription" value="Browse and search FPT University curricula by code or name." scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<main class="container-fluid main-content">
    <h2 class="page-title">Curriculum Listing</h2>

    <%-- Search Form --%>
    <div class="search-section" id="curriculum-search-section">
        <form id="curriculum-search-form" action="${pageContext.request.contextPath}/curriculum" method="get"
              onsubmit="return validateSearchForm('curriculum-keyword-input', 'curriculum-search-error')">
            <div class="search-bar">
                <label for="curriculum-searchtype-select" class="search-label">Enter curriculum:</label>
                <select name="searchType" id="curriculum-searchtype-select" class="form-select search-type-select">
                    <option value="code" ${searchType == 'code' ? 'selected' : ''}>Code</option>
                    <option value="name" ${searchType == 'name' ? 'selected' : ''}>Name</option>
                </select>
                <input type="text" name="keyword" id="curriculum-keyword-input"
                       class="form-control search-input"
                       value="${fn:escapeXml(keyword)}"
                       placeholder="Enter search term..."
                       maxlength="200"
                       autocomplete="off"/>
                <button type="submit" class="btn btn-search" id="curriculum-search-btn">Search</button>
            </div>
            <div id="curriculum-search-error" class="search-error-msg" role="alert"></div>
        </form>
    </div>

    <%-- Server Error --%>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-warning mt-3" id="curriculum-server-error" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
        </div>
    </c:if>

    <%-- Results Table --%>
    <c:if test="${not empty curricula}">
        <div class="result-count" id="curriculum-result-count">
            ${totalRecords} curriculum(s) found
        </div>

        <div class="table-responsive mt-2" id="curriculum-table-wrapper">
            <table class="fpt-table" id="curriculum-table">
                <thead>
                    <tr>
                        <th>Curriculum Code</th>
                        <th>Curriculum Name</th>
                        <th>Total Credits</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${curricula}" varStatus="status">
                        <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}" id="curriculum-row-${c.curriculumId}">
                            <td>${c.curriculumCode}</td>
                            <td>${c.curriculumName}</td>
                            <td>${c.totalCredits}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.status == 'Active'}">
                                        <span class="badge bg-success">${c.status}</span>
                                    </c:when>
                                    <c:when test="${c.status == 'Inactive'}">
                                        <span class="badge bg-secondary">${c.status}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-info">${c.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/curriculum/detail?curriculumId=${c.curriculumId}"
                                   class="btn-action" id="curriculum-detail-btn-${c.curriculumId}">
                                    View Detail
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <%-- Pagination --%>
        <c:if test="${pagination.totalPages > 1}">
            <nav aria-label="Curriculum pagination" class="mt-3">
                <ul class="pagination fpt-pagination" id="curriculum-pagination">
                    <c:if test="${pagination.hasPrevious()}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/curriculum?searchType=${searchType}&keyword=${keyword}&page=${pagination.previousPage}"
                               id="curriculum-page-prev">Previous</a>
                        </li>
                    </c:if>
                    <c:forEach begin="1" end="${pagination.totalPages}" var="p">
                        <li class="page-item ${p == pagination.currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/curriculum?searchType=${searchType}&keyword=${keyword}&page=${p}"
                               id="curriculum-page-${p}">${p}</a>
                        </li>
                    </c:forEach>
                    <c:if test="${pagination.hasNext()}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/curriculum?searchType=${searchType}&keyword=${keyword}&page=${pagination.nextPage}"
                               id="curriculum-page-next">Next</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </c:if>

    <%-- Empty State --%>
    <c:if test="${searched and empty curricula}">
        <div class="empty-state" id="curriculum-empty-state">
            <i class="bi bi-search fs-1 text-muted"></i>
            <p class="mt-2 text-muted">No curriculum found for "<strong>${keyword}</strong>".</p>
        </div>
    </c:if>
</main>

<jsp:include page="/views/layout/footer.jsp"/>
