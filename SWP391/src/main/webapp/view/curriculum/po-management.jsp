<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="PO Management - ${curriculum.curriculumName}" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <h2 class="page-title">PO Management</h2>

    <%-- Success & Error alerts --%>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert" id="po-success-alert">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("successMessage"); %>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert" id="po-error-alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("errorMessage"); %>
    </c:if>
    
    <div class="detail-section mb-4" id="curriculum-po-info">
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Curriculum ID:</div>
            <div class="col-md-10">
                <input type="text" class="form-control bg-light" id="input-curriculum-id" value="${fn:escapeXml(curriculum.curriculumCode)}" readonly />
            </div>
        </div>
        <div class="row align-items-center mb-3">
            <div class="col-md-2 text-md-end fw-bold text-secondary">Curriculum Name:</div>
            <div class="col-md-10">
                <input type="text" class="form-control bg-light" id="input-curriculum-name" value="${fn:escapeXml(curriculum.curriculumName)}" readonly />
            </div>
        </div>
        <div class="row">
            <div class="col-md-10 offset-md-2">
                <a href="${pageContext.request.contextPath}/curriculum/detail?curriculumId=${curriculum.curriculumId}" class="link-detail" id="btn-back-to-curriculum-detail">
                    <i class="bi bi-arrow-left"></i> Back to curriculum details
                </a>
            </div>
        </div>
    </div>

    <div class="result-count mb-2 d-flex justify-content-between align-items-center" id="po-list-result-count">
        <span>${fn:length(poList)} PO(s) found</span>
        <c:if test="${canManagePO}">
            <button type="button" class="btn btn-sm text-white" style="background-color: var(--fpt-orange); font-weight:600;" data-bs-toggle="modal" data-bs-target="#addPOModal" id="btn-add-po">
                <i class="bi bi-plus-lg me-1"></i>Add PO
            </button>
        </c:if>
    </div>

    <div class="table-responsive">
        <table class="fpt-table" id="po-table">
            <thead>
                <tr>
                    <th style="width: 15%">Curriculum PO ID</th>
                    <th style="width: 15%">PO Name</th>
                    <th style="width: 55%">PO Description</th>
                    <c:if test="${canManagePO}">
                        <th style="width: 15%">Action</th>
                    </c:if>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty poList}">
                        <tr>
                            <td colspan="${canManagePO ? 4 : 3}" class="text-center py-4 text-muted" id="td-empty-po">No Program Outcomes defined for this Curriculum.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="po" items="${poList}" varStatus="status">
                            <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}" id="po-row-${po.poId}">
                                <td>${po.poId}</td>
                                <td class="fw-bold">${fn:escapeXml(po.poName)}</td>
                                <td style="white-space: pre-wrap;">${fn:escapeXml(po.poDescription)}</td>
                                <c:if test="${canManagePO}">
                                    <td>
                                        <button type="button" class="btn btn-sm btn-link text-warning p-0 me-2 fw-semibold" onclick="openEditModal(${po.poId}, '${fn:escapeXml(po.poName)}', '${fn:escapeXml(po.poDescription)}')" style="text-decoration: none;" id="btn-edit-po-${po.poId}">
                                            <i class="bi bi-pencil-square me-1"></i>Edit
                                        </button>
                                        <a href="${pageContext.request.contextPath}/ProgramOutcomeServlet?action=delete&poId=${po.poId}&curriculumId=${curriculumId}" class="btn btn-sm btn-link text-danger p-0 fw-semibold" onclick="return confirm('Are you sure you want to delete this Program Outcome?');" style="text-decoration: none;" id="btn-delete-po-${po.poId}">
                                            <i class="bi bi-trash me-1"></i>Delete
                                        </a>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <%-- PLO Section --%>
    <h3 class="section-subtitle mt-5 mb-2" id="plo-section-title">${fn:length(ploList)} PLO(s) found</h3>
    <div class="table-responsive">
        <table class="fpt-table" id="plo-table">
            <thead>
                <tr>
                    <th style="width: 15%">PLO ID</th>
                    <th style="width: 15%">PLO Name</th>
                    <th style="width: 70%">PLO Description</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty ploList}">
                        <tr>
                            <td colspan="3" class="text-center py-4 text-muted" id="td-empty-plo">No Program Learning Outcomes defined for this Curriculum.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="plo" items="${ploList}" varStatus="status">
                            <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}" id="plo-row-${plo.ploId}">
                                <td>${plo.ploId}</td>
                                <td class="fw-bold">${fn:escapeXml(plo.ploName)}</td>
                                <td style="white-space: pre-wrap;">${fn:escapeXml(plo.ploDescription)}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <%-- Mapping PO to PLO Matrix --%>
    <h3 class="section-subtitle mt-5 mb-2" id="mapping-section-title">Mapping PO to PLO</h3>
    <div class="table-responsive mb-5">
        <table class="fpt-table text-center" id="mapping-matrix-table">
            <thead>
                <tr style="background-color: var(--fpt-orange); color: #fff;">
                    <th style="width: 15%; text-align: center; vertical-align: middle; font-weight: bold;">PLO(s)</th>
                    <c:forEach var="po" items="${poList}">
                        <th style="text-align: center; vertical-align: middle; font-weight: bold;">${fn:escapeXml(po.poName)}</th>
                    </c:forEach>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty ploList || empty poList}">
                        <tr>
                            <td colspan="${fn:length(poList) + 1}" class="text-center py-4 text-muted">No outcomes to map.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="plo" items="${ploList}" varStatus="status">
                            <tr class="${status.index % 2 == 0 ? 'row-even' : 'row-odd'}">
                                <td class="fw-bold text-start ps-3">${fn:escapeXml(plo.ploName)}</td>
                                <c:forEach var="po" items="${poList}">
                                    <c:set var="poId" value="${po.poId}" />
                                    <c:set var="ploId" value="${plo.ploId}" />
                                    <c:set var="mappedList" value="${poPloMapping[poId]}" />
                                    <td class="fw-bold text-success" style="font-size: 1.2rem;">
                                        <c:choose>
                                            <c:when test="${not empty mappedList && mappedList.contains(ploId)}">
                                                ✓
                                            </c:when>
                                            <c:otherwise>&nbsp;</c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:forEach>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

<%-- Add PO Modal --%>
<c:if test="${canManagePO}">
    <div class="modal fade" id="addPOModal" tabindex="-1" aria-labelledby="addPOModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header text-white" style="background-color: var(--fpt-orange);">
                    <h5 class="modal-title" id="addPOModalLabel"><i class="bi bi-plus-lg me-2"></i>Add Program Outcome</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/ProgramOutcomeServlet" method="post" id="form-add-po">
                    <input type="hidden" name="action" value="create" />
                    <input type="hidden" name="curriculumId" value="${curriculumId}" />
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="add_poName" class="form-label fw-bold">PO Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="add_poName" name="poName" placeholder="e.g. PO1" maxlength="50" required />
                        </div>
                        <div class="mb-3">
                            <label for="add_poDescription" class="form-label fw-bold">PO Description</label>
                            <textarea class="form-control" id="add_poDescription" name="poDescription" rows="4" placeholder="Enter detailed description..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn text-white" style="background-color: var(--fpt-orange); font-weight:600;">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- Edit PO Modal --%>
    <div class="modal fade" id="editPOModal" tabindex="-1" aria-labelledby="editPOModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header text-white" style="background-color: var(--fpt-orange);">
                    <h5 class="modal-title" id="editPOModalLabel"><i class="bi bi-pencil-square me-2"></i>Edit Program Outcome</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/ProgramOutcomeServlet" method="post" id="form-edit-po">
                    <input type="hidden" name="action" value="update" />
                    <input type="hidden" name="curriculumId" value="${curriculumId}" />
                    <input type="hidden" id="edit_poId" name="poId" value="${editingPO.poId}" />
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="edit_poName" class="form-label fw-bold">PO Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="edit_poName" name="poName" value="${fn:escapeXml(editingPO.poName)}" placeholder="e.g. PO1" maxlength="50" required />
                        </div>
                        <div class="mb-3">
                            <label for="edit_poDescription" class="form-label fw-bold">PO Description</label>
                            <textarea class="form-control" id="edit_poDescription" name="poDescription" rows="4" placeholder="Enter detailed description...">${fn:escapeXml(editingPO.poDescription)}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn text-white" style="background-color: var(--fpt-orange); font-weight:600;">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:if>

<script>
    function openEditModal(poId, poName, poDescription) {
        var editPoIdInput = document.getElementById('edit_poId');
        var editPoNameInput = document.getElementById('edit_poName');
        var editPoDescInput = document.getElementById('edit_poDescription');
        
        if (editPoIdInput) editPoIdInput.value = poId;
        if (editPoNameInput) editPoNameInput.value = poName;
        if (editPoDescInput) editPoDescInput.value = poDescription;
        
        var editModal = new bootstrap.Modal(document.getElementById('editPOModal'));
        editModal.show();
    }
</script>

<c:if test="${not empty editingPO}">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var editModal = new bootstrap.Modal(document.getElementById('editPOModal'));
            editModal.show();
        });
    </script>
</c:if>

<jsp:include page="/view/layout/footer.jsp"/>
