<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Subject List - FPT University" scope="request"/>
<c:set var="pageDescription" value="Browse and search all subjects with credits and semester information." scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <h2 class="page-title">Subject List</h2>

    <div class="search-section" id="subject-search-section">
        <form id="subject-search-form" action="${pageContext.request.contextPath}/subjects" method="get"
              onsubmit="return validateSimpleSearch('subject-keyword-input', 'subject-search-error')">
            <div class="search-bar">
                <label for="subject-keyword-input" class="search-label">Search Subject:</label>
                <input type="text" name="keyword" id="subject-keyword-input"
                       class="form-control search-input"
                       value="${fn:escapeXml(keyword)}"
                       placeholder="Code or name..."
                       maxlength="200"
                       autocomplete="off"/>
                <button type="submit" class="btn btn-search" id="subject-search-btn">Search</button>
            </div>
            <div id="subject-search-error" class="search-error-msg" role="alert"></div>
        </form>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-warning mt-3" id="subject-server-error" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
        </div>
    </c:if>

    <c:if test="${not empty subjects}">
        <div class="result-count" id="subject-result-count">
            ${totalRecords} subject(s) found
        </div>
        <div class="table-responsive mt-2" id="subject-table-wrapper">
            <table class="fpt-table" id="subject-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Subject Code</th>
                        <th>Subject Name</th>
                        <th>Credits</th>
                        <th>Semester</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="sub" items="${subjects}" varStatus="status">
                        <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}" id="subject-row-${sub.subjectId}">
                            <td>${status.index + 1}</td>
                            <td>${sub.subjectCode}</td>
                            <td>${sub.subjectName}</td>
                            <td>${sub.credits}</td>
                            <td>${sub.semester}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/learning-path?subjectCode=${sub.subjectCode}"
                                   class="btn-action" id="view-lp-btn-${sub.subjectId}">
                                    View Learning Path
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${pagination.totalPages > 1}">
            <nav aria-label="Subject pagination" class="mt-3">
                <ul class="pagination fpt-pagination" id="subject-pagination">
                    <c:if test="${pagination.hasPrevious()}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/subjects?keyword=${keyword}&page=${pagination.previousPage}"
                               id="subject-page-prev">Previous</a>
                        </li>
                    </c:if>
                    <c:forEach begin="1" end="${pagination.totalPages}" var="p">
                        <li class="page-item ${p == pagination.currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/subjects?keyword=${keyword}&page=${p}"
                               id="subject-page-${p}">${p}</a>
                        </li>
                    </c:forEach>
                    <c:if test="${pagination.hasNext()}">
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/subjects?keyword=${keyword}&page=${pagination.nextPage}"
                               id="subject-page-next">Next</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </c:if>

    <c:if test="${empty subjects}">
        <div class="empty-state mt-4" id="subject-empty-state">
            <i class="bi bi-journal-x fs-1 text-muted"></i>
            <p class="mt-2 text-muted">No subjects found.</p>
        </div>
    </c:if>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
