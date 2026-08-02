<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="My Uploaded Materials - Teacher" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-back">
                <i class="bi bi-arrow-left me-1"></i>Dashboard
            </a>
            <h2 class="page-title mb-0">My Uploaded Materials
                <span class="badge bg-secondary ms-1">${materialsCount}</span>
            </h2>
        </div>
        <a href="${pageContext.request.contextPath}/teacher/upload-material"
           class="btn btn-upload-submit">
            <i class="bi bi-cloud-upload-fill me-1"></i>Upload New
        </a>
    </div>

    <p class="text-muted mb-3">
        Tài liệu bạn đã đăng (chỉ teacher materials mới tải về để xem).
        Upload chỉ trong ngành được Training Department gán.
    </p>

    <div class="teacher-card">
        <div class="teacher-card-header">
            <i class="bi bi-folder2-open me-2"></i>Materials uploaded by you
        </div>
        <div class="teacher-card-body">
            <c:choose>
                <c:when test="${empty materials}">
                    <div class="empty-state text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <p class="mt-2 text-muted mb-3">Bạn chưa upload tài liệu nào.</p>
                        <a href="${pageContext.request.contextPath}/teacher/upload-material"
                           class="btn btn-upload-submit">
                            Upload Teacher Materials
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="fpt-table" id="my-materials-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Material</th>
                                    <th>Subject</th>
                                    <th>Syllabus</th>
                                    <th>Type</th>
                                    <th>Visibility</th>
                                    <th>Uploaded</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="m" items="${materials}" varStatus="s">
                                    <tr class="${s.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                                        <td>${s.index + 1}</td>
                                        <td>
                                            <i class="bi ${m.typeIconClass} me-1" style="color:#f3722c;"></i>
                                            <strong><c:out value="${m.materialName}"/></strong>
                                        </td>
                                        <td><strong>${m.subjectCode}</strong></td>
                                        <td style="font-size:.85rem;"><c:out value="${m.syllabusTitle}"/></td>
                                        <td><span class="badge bg-light text-dark border">${m.materialType}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.visibility == 'Public'}">
                                                    <span class="badge bg-success-subtle text-success border border-success">Public</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning-subtle text-warning border border-warning">Private</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="font-size:.8rem;" class="text-muted">${m.uploadedAt}</td>
                                        <td class="text-center">
                                            <c:if test="${not empty m.filePath}">
                                                <a href="${m.filePath}" target="_blank" rel="noopener"
                                                   class="btn btn-sm py-0 px-2 me-1"
                                                   style="background:#f3722c;color:#fff;"
                                                   title="Download / View">
                                                    <i class="bi bi-cloud-arrow-down-fill"></i>
                                                </a>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/teacher/upload-material?syllabusId=${m.syllabusId}"
                                               class="btn btn-sm btn-outline-secondary py-0 px-2"
                                               title="Manage uploads for this syllabus">
                                                <i class="bi bi-pencil-square"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
