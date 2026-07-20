<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Submit Design Request - Teacher" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>
<main class="container-fluid main-content">
    <div class="d-flex align-items-center gap-3 mb-3">
        <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-back"><i class="bi bi-arrow-left me-1"></i>Dashboard</a>
        <h2 class="page-title mb-0">Submit Design / Modification Request</h2>
    </div>
    <c:if test="${not empty param.success}"><div class="alert alert-success"><i class="bi bi-check-circle-fill me-2"></i>${param.success}</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div></c:if>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="teacher-card">
                <div class="teacher-card-header"><i class="bi bi-pencil-square me-2"></i>New Request</div>
                <div class="teacher-card-body">
                    <form action="${pageContext.request.contextPath}/teacher/submit-request" method="post" onsubmit="return validateReqForm()">
                        <div class="mb-3">
                            <label for="syllabusId" class="form-label fw-semibold">Syllabus <span class="text-danger">*</span></label>
                            <select name="syllabusId" id="syllabusId" class="form-select" required>
                                <option value="">— Select Syllabus —</option>
                                <c:forEach var="s" items="${syllabi}">
                                    <option value="${s.syllabusId}">[${s.subjectCode}] ${s.syllabusTitle} (v${s.versionNo})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Request Type <span class="text-danger">*</span></label>
                            <div class="request-type-grid">
                                <label class="request-type-option" id="rt-new">
                                    <input type="radio" name="requestType" value="New" required/>
                                    <i class="bi bi-plus-circle-fill rt-icon text-success"></i>
                                    <span class="fw-semibold">New Design</span>
                                    <small class="text-muted d-block">Create a new course design</small>
                                </label>
                                <label class="request-type-option" id="rt-modify">
                                    <input type="radio" name="requestType" value="Modify"/>
                                    <i class="bi bi-pencil-fill rt-icon text-warning"></i>
                                    <span class="fw-semibold">Modification</span>
                                    <small class="text-muted d-block">Modify existing course design</small>
                                </label>
                                <label class="request-type-option" id="rt-deactivate">
                                    <input type="radio" name="requestType" value="Deactivate"/>
                                    <i class="bi bi-x-circle-fill rt-icon text-danger"></i>
                                    <span class="fw-semibold">Deactivate</span>
                                    <small class="text-muted d-block">Request course deactivation</small>
                                </label>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="reviewNote" class="form-label fw-semibold">Notes / Justification</label>
                            <textarea name="reviewNote" id="reviewNote" class="form-control" rows="5" maxlength="2000"
                                      placeholder="Describe the reason, proposed changes, or any supporting context..."></textarea>
                            <div class="text-end text-muted" style="font-size:.78rem;"><span id="char-count">0</span>/2000</div>
                        </div>
                        <div id="req-form-error" class="text-danger small mb-2"></div>
                        <button type="submit" class="btn btn-upload-submit w-100" id="btn-submit-req">
                            <i class="bi bi-send-fill me-2"></i>Submit Request
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="teacher-card">
                <div class="teacher-card-header"><i class="bi bi-clock-history me-2"></i>My Request History <span class="ms-2 badge bg-secondary">${totalRequests}</span></div>
                <div class="teacher-card-body">
                    <c:choose>
                        <c:when test="${empty myRequests}">
                            <p class="text-muted text-center py-4"><i class="bi bi-inbox fs-2 d-block mb-2"></i>No requests submitted yet.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="fpt-table" id="my-requests-table">
                                    <thead><tr><th>#</th><th>Subject</th><th>Syllabus</th><th>Type</th><th>Status</th><th>Submitted</th></tr></thead>
                                    <tbody>
                                        <c:forEach var="r" items="${myRequests}" varStatus="s">
                                            <tr class="${s.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                                                <td>${r.requestId}</td>
                                                <td><strong>${r.subjectCode}</strong></td>
                                                <td style="font-size:.83rem;">${r.syllabusTitle}</td>
                                                <td><span class="badge bg-secondary">${r.requestType}</span></td>
                                                <td><span class="badge ${r.statusBadgeClass}">${r.status}</span></td>
                                                <td style="font-size:.78rem;" class="text-muted">${r.requestedAt}</td>
                                            </tr>
                                            <c:if test="${not empty r.reviewNote}">
                                                <tr class="${s.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                                                    <td colspan="6" class="review-note-cell"><i class="bi bi-chat-left-text-fill text-muted me-1"></i><em>${fn:escapeXml(r.reviewNote)}</em></td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <c:if test="${pagination.totalPages > 1}">
                                <nav class="mt-2"><ul class="pagination fpt-pagination mb-0">
                                    <c:if test="${pagination.hasPrevious()}">
                                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/teacher/submit-request?page=${pagination.previousPage}">Previous</a></li>
                                    </c:if>
                                    <c:forEach begin="1" end="${pagination.totalPages}" var="p">
                                        <li class="page-item ${p == pagination.currentPage ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/teacher/submit-request?page=${p}">${p}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${pagination.hasNext()}">
                                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/teacher/submit-request?page=${pagination.nextPage}">Next</a></li>
                                    </c:if>
                                </ul></nav>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>
<script>
document.getElementById('reviewNote').addEventListener('input', function() {
    document.getElementById('char-count').textContent = this.value.length;
});
document.querySelectorAll('.request-type-option input').forEach(function(r) {
    r.addEventListener('change', function() {
        document.querySelectorAll('.request-type-option').forEach(o => o.classList.remove('selected'));
        this.closest('.request-type-option').classList.add('selected');
    });
});
function validateReqForm() {
    const err = document.getElementById('req-form-error');
    if (!document.getElementById('syllabusId').value) { err.textContent='Please select a syllabus.'; return false; }
    if (!document.querySelector('input[name="requestType"]:checked')) { err.textContent='Please select a request type.'; return false; }
    err.textContent='';
    const btn=document.getElementById('btn-submit-req');
    btn.innerHTML='<span class="spinner-border spinner-border-sm me-2"></span>Submitting...';
    btn.disabled=true;
    return true;
}
</script>
<jsp:include page="/views/layout/footer.jsp"/>
