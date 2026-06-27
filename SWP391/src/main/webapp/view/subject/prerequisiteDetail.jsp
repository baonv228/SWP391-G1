<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Subject Prerequisite Detail - FPT University" scope="request"/>
<c:set var="pageDescription" value="View subjects that are prerequisites and subsequent subjects for a given subject." scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<main class="container-fluid main-content">
    <h2 class="page-title">A Subject is the Pre-Requisite Of</h2>

    <%-- Search Form --%>
    <div class="search-section" id="prereq-search-section">
        <form id="prereq-search-form" action="${pageContext.request.contextPath}/prerequisite" method="get"
              onsubmit="return validateSimpleSearch('prereq-subject-input', 'prereq-search-error')">
            <div class="search-bar">
                <label for="prereq-subject-input" class="search-label">Subject Code:</label>
                <input type="text" name="subjectCode" id="prereq-subject-input"
                       class="form-control search-input-simple"
                       value="${fn:escapeXml(subjectCode)}"
                       placeholder="e.g. PRF192"
                       maxlength="50"
                       autocomplete="off"/>
                <button type="submit" class="btn btn-search" id="prereq-search-btn">Search</button>
            </div>
            <div id="prereq-search-error" class="search-error-msg" role="alert"></div>
        </form>
    </div>

    <%-- Server Error --%>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-warning mt-3" id="prereq-server-error" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
        </div>
    </c:if>

    <%-- Not Found --%>
    <c:if test="${notFound}">
        <div class="empty-state mt-3" id="prereq-not-found">
            <i class="bi bi-search fs-1 text-muted"></i>
            <p class="mt-2 text-muted">Subject "<strong>${notFoundCode}</strong>" was not found.</p>
        </div>
    </c:if>

    <%-- Results --%>
    <c:if test="${not empty prerequisiteDetail}">
        <div class="prereq-detail-wrapper" id="prereq-detail-wrapper">

            <%-- Current Subject --%>
            <div class="subject-card current-subject" id="current-subject-card">
                <div class="subject-card-label">Current Subject</div>
                <div class="subject-card-code" id="current-subject-code">
                    ${prerequisiteDetail.currentSubject.subjectCode}
                </div>
                <div class="subject-card-name" id="current-subject-name">
                    ${prerequisiteDetail.currentSubject.subjectName}
                </div>
                <div class="subject-card-meta">
                    Credits: ${prerequisiteDetail.currentSubject.credits} |
                    Semester: ${prerequisiteDetail.currentSubject.semester}
                </div>
            </div>

            <%-- Flow Diagram --%>
            <div class="flow-diagram" id="flow-diagram">
                <%-- Prerequisites --%>
                <c:choose>
                    <c:when test="${not empty prerequisiteDetail.prerequisites}">
                        <div class="flow-section" id="prereq-subjects-section">
                            <div class="flow-label">Prerequisites</div>
                            <div class="flow-arrow">&#8595;</div>
                            <div class="flow-subjects" id="prereq-subjects-list">
                                <c:forEach var="pre" items="${prerequisiteDetail.prerequisites}" varStatus="preStatus">
                                    <div class="subject-box prereq-box" id="prereq-box-${pre.subjectId}">
                                        <span class="subject-code">${pre.subjectCode}</span>
                                        <span class="subject-name">${pre.subjectName}</span>
                                        <span class="subject-credits">${pre.credits} credits</span>
                                    </div>
                                </c:forEach>
                            </div>
                            <div class="flow-arrow">&#8595;</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flow-section" id="prereq-empty-section">
                            <div class="flow-label">Prerequisites</div>
                            <div class="flow-arrow">&#8595;</div>
                            <div class="subject-box none-box" id="prereq-none-box">None</div>
                            <div class="flow-arrow">&#8595;</div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <%-- Current Subject Node --%>
                <div class="flow-current-node" id="flow-current-node">
                    <span class="subject-code">${prerequisiteDetail.currentSubject.subjectCode}</span>
                </div>

                <div class="flow-arrow">&#8595;</div>

                <%-- Subsequent Subjects --%>
                <c:choose>
                    <c:when test="${not empty prerequisiteDetail.subsequents}">
                        <div class="flow-section" id="subsequent-subjects-section">
                            <div class="flow-label">Subsequent Subjects</div>
                            <div class="flow-subjects" id="subsequent-subjects-list">
                                <c:forEach var="sub" items="${prerequisiteDetail.subsequents}" varStatus="subStatus">
                                    <div class="subject-box subsequent-box" id="subsequent-box-${sub.subjectId}">
                                        <span class="subject-code">${sub.subjectCode}</span>
                                        <span class="subject-name">${sub.subjectName}</span>
                                        <span class="subject-credits">${sub.credits} credits</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="subject-box none-box" id="subsequent-none-box">No subsequent subjects</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Detail Tables --%>
            <div class="mt-4" id="prereq-detail-tables">
                <%-- Prerequisites Table --%>
                <c:if test="${not empty prerequisiteDetail.prerequisites}">
                    <h3 class="section-subtitle">Prerequisites</h3>
                    <div class="table-responsive">
                        <table class="fpt-table" id="prereq-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Subject Code</th>
                                    <th>Subject Name</th>
                                    <th>Credits</th>
                                    <th>Semester</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pre" items="${prerequisiteDetail.prerequisites}" varStatus="ps">
                                    <tr id="prereq-row-${ps.index + 1}">
                                        <td>${ps.index + 1}</td>
                                        <td>${pre.subjectCode}</td>
                                        <td>${pre.subjectName}</td>
                                        <td>${pre.credits}</td>
                                        <td>${pre.semester}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <%-- Subsequent Subjects Table --%>
                <c:if test="${not empty prerequisiteDetail.subsequents}">
                    <h3 class="section-subtitle mt-4">${prerequisiteDetail.currentSubject.subjectCode} is a pre-requisite of</h3>
                    <div class="table-responsive">
                        <table class="fpt-table" id="subsequent-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Subject Code</th>
                                    <th>Subject Name</th>
                                    <th>Credits</th>
                                    <th>Semester</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sub" items="${prerequisiteDetail.subsequents}" varStatus="ss">
                                    <tr id="subsequent-row-${ss.index + 1}">
                                        <td>${ss.index + 1}</td>
                                        <td>${sub.subjectCode}</td>
                                        <td>${sub.subjectName}</td>
                                        <td>${sub.credits}</td>
                                        <td>${sub.semester}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>
    </c:if>
</main>

<jsp:include page="/views/layout/footer.jsp"/>
