<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Course List - Teacher" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>
<main class="container-fluid main-content">
    <div class="d-flex align-items-center gap-3 mb-3">
        <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-back"><i class="bi bi-arrow-left me-1"></i>Dashboard</a>
        <h2 class="page-title mb-0">Course List</h2>
    </div>

    <div class="search-section">
        <form id="course-search-form" action="${pageContext.request.contextPath}/teacher/courses" method="get"
              onsubmit="return validateSearchForm('course-keyword','course-search-error')">
            <div class="search-bar">
                <label for="course-searchtype" class="search-label">Search by:</label>
                <select name="searchType" id="course-searchtype" class="form-select search-type-select">
                    <option value="code"    ${searchType=='code'    ? 'selected':''}>Subject Code</option>
                    <option value="name"    ${searchType=='name'    ? 'selected':''}>Syllabus Name</option>
                    <option value="subject" ${searchType=='subject' ? 'selected':''}>Code / Name</option>
                </select>
                <input type="text" name="keyword" id="course-keyword" class="form-control search-input"
                       value="${fn:escapeXml(keyword)}" placeholder="Enter search term..." maxlength="200"/>
                <button type="submit" class="btn btn-search" id="course-search-btn">Search</button>
                <a href="${pageContext.request.contextPath}/teacher/courses" class="btn btn-outline-secondary" id="course-reset-btn">Reset</a>
            </div>
            <div id="course-search-error" class="search-error-msg"></div>
        </form>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-warning mt-2">${errorMessage}</div>
    </c:if>

    <c:if test="${totalRecords > 0}">
        <div class="result-count">${totalRecords} course(s) found</div>
    </c:if>

    <c:if test="${not empty courses}">
        <div class="table-responsive">
            <table class="fpt-table" id="courses-table">
                <thead>
                    <tr>
                        <th>Subject Code</th>
                        <th>Subject Name</th>
                        <th>Syllabus Title</th>
                        <th>Version</th>
                        <th>Credits</th>
                        <th>Current?</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${courses}" varStatus="s">
                        <tr class="${s.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                            <td><strong>${c.subjectCode}</strong></td>
                            <td>${c.subjectName}</td>
                            <td>${c.syllabusTitle}</td>
                            <td><span class="badge bg-light text-dark border">${c.versionNo}</span></td>
                            <td>${c.credits}</td>
                            <td class="text-center">
                                <input type="checkbox" ${c.currentVersion ? 'checked' : ''} disabled/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.status == 'Active'}"><span class="badge bg-success">${c.status}</span></c:when>
                                    <c:when test="${c.status == 'Draft'}"><span class="badge bg-warning text-dark">${c.status}</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">${c.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/syllabus/detail?syllabusId=${c.syllabusId}"
                                   class="btn-action" id="view-syllabus-${c.syllabusId}">View</a>
                                <a href="${pageContext.request.contextPath}/teacher/upload-material?syllabusId=${c.syllabusId}"
                                   class="btn-action ms-1" style="background:var(--fpt-teal);" id="upload-for-${c.syllabusId}">Upload</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${pagination.totalPages > 1}">
            <nav class="mt-3"><ul class="pagination fpt-pagination">
                <c:if test="${pagination.hasPrevious()}">
                    <li class="page-item"><a class="page-link" href="?searchType=${searchType}&keyword=${keyword}&page=${pagination.previousPage}">Previous</a></li>
                </c:if>
                <c:forEach begin="1" end="${pagination.totalPages}" var="p">
                    <li class="page-item ${p == pagination.currentPage ? 'active' : ''}">
                        <a class="page-link" href="?searchType=${searchType}&keyword=${keyword}&page=${p}">${p}</a>
                    </li>
                </c:forEach>
                <c:if test="${pagination.hasNext()}">
                    <li class="page-item"><a class="page-link" href="?searchType=${searchType}&keyword=${keyword}&page=${pagination.nextPage}">Next</a></li>
                </c:if>
            </ul></nav>
        </c:if>
    </c:if>

    <c:if test="${searched and empty courses}">
        <div class="empty-state">
            <i class="bi bi-search fs-1 text-muted"></i>
            <p class="mt-2 text-muted">No courses found for "<strong>${keyword}</strong>".</p>
        </div>
    </c:if>
</main>
<jsp:include page="/views/layout/footer.jsp"/>
