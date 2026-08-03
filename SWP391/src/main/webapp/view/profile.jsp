<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="${requestScope.showCurriculumTree ? 'Hồ sơ cá nhân & Sơ đồ đào tạo' : 'Hồ sơ cá nhân'}" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<style>
    :root {
        --fpt-orange: #f59e3d;
        --fpt-orange-dark: #c76b12;
        --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        --border-color: #e2e8f0;
    }

    body {
        background-color: #f8fafc;
        color: #334155;
    }

    .profile-card {
        background: #ffffff;
        border-radius: 16px;
        box-shadow: var(--card-shadow);
        border: 1px solid var(--border-color);
        padding: 2rem;
        margin-bottom: 2rem;
    }

    .profile-header h3 {
        font-weight: 800;
        color: #1e293b;
        margin-bottom: 0.5rem;
    }

    .profile-subtitle {
        color: #64748b;
        font-size: 0.9rem;
        margin-bottom: 1.5rem;
    }

    .form-label {
        font-weight: 600;
        color: #475569;
        font-size: 0.9rem;
    }

    .form-control, .form-select {
        border-radius: 8px;
        padding: 0.75rem 1rem;
        border: 1px solid #cbd5e1;
    }

    .form-control:focus, .form-select:focus {
        border-color: var(--fpt-orange);
        box-shadow: 0 0 0 3px rgba(243, 114, 44, 0.15);
    }

    .btn-save {
        background-color: var(--fpt-orange);
        color: #ffffff;
        font-weight: 700;
        padding: 0.75rem 1.5rem;
        border-radius: 8px;
        border: none;
        transition: background-color 0.2s;
    }

    .btn-save:hover {
        background-color: var(--fpt-orange-dark);
        color: #ffffff;
    }

    /* Mindmap & Tree Diagram styling */
    .tree-section {
        background: #ffffff;
        border-radius: 16px;
        box-shadow: var(--card-shadow);
        border: 1px solid var(--border-color);
        padding: 2rem;
    }

    .tree-title {
        font-weight: 800;
        color: #1e293b;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-bottom: 0.25rem;
    }

    .tree-filter-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        flex-wrap: wrap;
        gap: 1rem;
    }

    /* Columns for Semesters */
    .semester-columns {
        display: flex;
        gap: 1.5rem;
        overflow-x: auto;
        padding-bottom: 1rem;
    }

    .semester-column {
        flex: 0 0 280px;
        background-color: #f8fafc;
        border-radius: 12px;
        border: 1px solid var(--border-color);
        padding: 1.25rem;
        display: flex;
        flex-direction: column;
        gap: 1rem;
        min-height: 400px;
    }

    .semester-header {
        font-weight: 700;
        color: #475569;
        font-size: 1rem;
        border-bottom: 2px solid var(--border-color);
        padding-bottom: 0.5rem;
        margin-bottom: 0.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .subject-node {
        background: #ffffff;
        border: 1px solid var(--border-color);
        border-radius: 10px;
        padding: 1rem;
        box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        cursor: pointer;
        transition: all 0.2s ease-in-out;
        position: relative;
    }

    .subject-node:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 16px rgba(243, 114, 44, 0.1);
        border-color: var(--fpt-orange);
    }

    .subject-node.highlighted {
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.25);
        background-color: #eff6ff;
    }

    .subject-node.prereq-highlight {
        border-color: #eab308;
        box-shadow: 0 0 0 3px rgba(234, 179, 8, 0.25);
        background-color: #fef9c3;
    }

    .subject-code {
        font-weight: 800;
        color: #0f172a;
        font-size: 0.95rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .subject-name {
        font-size: 0.85rem;
        color: #475569;
        margin: 0.25rem 0 0.5rem 0;
        line-height: 1.3;
    }

    .badge-req {
        font-size: 0.7rem;
        padding: 0.2rem 0.5rem;
        border-radius: 4px;
        font-weight: bold;
    }

    .badge-req.required {
        background-color: #fee2e2;
        color: #ef4444;
    }

    .badge-req.elective {
        background-color: #f1f5f9;
        color: #64748b;
    }

    .subject-meta {
        font-size: 0.75rem;
        color: #94a3b8;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-top: 1px dashed var(--border-color);
        padding-top: 0.5rem;
        margin-top: 0.5rem;
    }

    .prereq-badge {
        font-size: 0.7rem;
        background-color: #fef3c7;
        color: #d97706;
        padding: 0.15rem 0.4rem;
        border-radius: 4px;
        font-weight: 600;
        display: inline-block;
        margin-top: 0.25rem;
    }

    /* Stack list layout (alternative view) */
    .semester-stack {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }

    .semester-lane {
        background-color: #f8fafc;
        border-radius: 12px;
        border: 1px solid var(--border-color);
        padding: 1.25rem;
    }
</style>

<div class="container py-5">
    <div class="row">
        
        <!-- Left Side: Profile Setup -->
        <div class="${requestScope.showCurriculumTree ? 'col-md-4' : 'col-md-6 mx-auto'}">
            <div class="profile-card">
                <div class="profile-header">
                    <h3>Thông tin tài khoản</h3>
                    <div class="profile-subtitle">
                        <c:choose>
                            <c:when test="${requestScope.showCurriculumTree}">
                                Xem &amp; cấu hình hồ sơ và ngành học đào tạo.
                            </c:when>
                            <c:otherwise>
                                Xem &amp; cập nhật thông tin hồ sơ cá nhân.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <c:if test="${requestScope.showCurriculumTree and not empty requestScope.curriculumFallbackNotice}">
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${requestScope.curriculumFallbackNotice}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not empty requestScope.message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i> ${requestScope.message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not empty requestScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${requestScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/profile">
                    <!-- Email (Read-only) -->
                    <div class="mb-3">
                        <label class="form-label">Email đăng nhập</label>
                        <input type="text" class="form-control" value="${sessionScope.user.email}" readonly style="background-color: #f1f5f9; cursor: not-allowed;" />
                    </div>

                    <!-- Role (Read-only) -->
                    <div class="mb-3">
                        <label class="form-label">Vai trò người dùng</label>
                        <input type="text" class="form-control" value="${sessionScope.user.role.roleName}" readonly style="background-color: #f1f5f9; cursor: not-allowed;" />
                    </div>

                    <!-- Full Name -->
                    <div class="mb-3">
                        <label for="fullName" class="form-label">Họ và tên</label>
                        <input id="fullName" type="text" name="fullName" class="form-control" value="${sessionScope.user.fullName}" required />
                    </div>

                    <!-- Curriculum Select — only for Student / learner roles -->
                    <c:if test="${requestScope.showCurriculumTree}">
                        <div class="mb-4">
                            <label for="curriculumId" class="form-label">Ngành học &amp; Chương trình (Curriculum)</label>
                            <select name="curriculumId" id="curriculumId" class="form-select" onchange="this.form.submit()">
                                <c:forEach var="c" items="${requestScope.curriculums}">
                                    <option value="${c.curriculumId}" ${c.curriculumId == requestScope.selectedCurId ? 'selected' : ''}>
                                        ${c.curriculumName} (${c.programCode})
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="form-text" style="font-size: 0.8rem; margin-top: 0.4rem;">
                                <i class="bi bi-info-circle"></i> Sơ đồ cây đào tạo bên dưới sẽ tự động thay đổi dựa theo cấu hình ngành học này.
                            </div>
                        </div>
                    </c:if>

                    <button type="submit" class="btn btn-save w-100 mb-3">Lưu thay đổi hồ sơ</button>
                </form>

                <hr>
                <div class="d-flex justify-content-between pt-2">
                    <a href="${pageContext.request.contextPath}/change-password" class="btn btn-sm btn-outline-secondary"><i class="bi bi-shield-lock-fill"></i> Đổi mật khẩu</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-danger"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
                </div>
            </div>
        </div>

        <!-- Right Side: Interactive Study Tree Map (Student only) -->
        <c:if test="${requestScope.showCurriculumTree}">
        <div class="col-md-8">
            <div class="tree-section">
                
                <div class="tree-filter-bar">
                    <div>
                        <h3 class="tree-title">
                            <i class="bi bi-diagram-3-fill text-warning"></i> Sơ đồ cây chương trình đào tạo
                        </h3>
                        <p class="text-muted mb-0" style="font-size: 0.85rem;">
                            Ngành: <strong class="text-dark">${requestScope.selectedCurriculum.curriculumName}</strong> 
                            | Tổng tín chỉ: <span class="badge bg-secondary">${requestScope.selectedCurriculum.totalCredits}</span>
                        </p>
                    </div>
                    
                    <!-- Semester Filter and View Modes -->
                    <div class="d-flex gap-2">
                        <select class="form-select form-select-sm" id="semesterFilter" onchange="filterSemesters(this.value)">
                            <option value="all">Tất cả các kỳ</option>
                            <c:forEach var="entry" items="${requestScope.selectedCurriculum.semesterSubjects}">
                                <option value="${entry.key}">Học kỳ ${entry.key}</option>
                            </c:forEach>
                        </select>
                        
                        <div class="btn-group btn-group-sm" role="group">
                            <button type="button" class="btn btn-outline-secondary active" id="btn-view-tree" onclick="switchViewMode('tree')"><i class="bi bi-columns-gap"></i> Cột</button>
                            <button type="button" class="btn btn-outline-secondary" id="btn-view-list" onclick="switchViewMode('list')"><i class="bi bi-list-task"></i> Danh sách</button>
                        </div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty requestScope.selectedCurriculum.semesterSubjects}">
                        <div class="text-center py-5 text-muted">
                            <i class="bi bi-folder-x fs-1"></i>
                            <p class="mt-2">Chưa cấu hình danh sách môn học cho ngành học này.</p>
                            <p class="small">Hãy chọn <strong>SE Standard Curriculum 2024</strong> hoặc chạy script <code>database/tpms_seed_ai_curriculum.sql</code> trong SSMS.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        
                        <!-- 1) COLUMN TREE VIEW -->
                        <div class="semester-columns" id="view-mode-tree">
                            <c:forEach var="entry" items="${requestScope.selectedCurriculum.semesterSubjects}">
                                <div class="semester-column" id="col-sem-${entry.key}">
                                    <div class="semester-header">
                                        <span>Kỳ học ${entry.key}</span>
                                        <span class="badge bg-light text-dark">${fn:length(entry.value)} môn</span>
                                    </div>
                                    <c:forEach var="sub" items="${entry.value}">
                                        <div class="subject-node" id="sub-node-${sub.subjectCode}" 
                                             onclick="highlightPrerequisites('${sub.subjectCode}')"
                                             title="Click để xem liên kết điều kiện tiên quyết">
                                            <div class="subject-code">
                                                <span>${sub.subjectCode}</span>
                                                <span class="badge-req ${sub.required ? 'required' : 'elective'}">
                                                    ${sub.required ? 'Bắt buộc' : 'Tự chọn'}
                                                </span>
                                            </div>
                                            <div class="subject-name">${sub.subjectName}</div>
                                            
                                            <!-- Prerequisite list rendering -->
                                            <div id="prereq-container-${sub.subjectCode}"></div>

                                            <div class="subject-meta">
                                                <span><i class="bi bi-award"></i> ${sub.credits} tín chỉ</span>
                                                <span class="badge bg-success" style="font-size: 0.65rem;">Active</span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- 2) VERTICAL STACK LIST VIEW (Hidden by default) -->
                        <div class="semester-stack d-none" id="view-mode-list">
                            <c:forEach var="entry" items="${requestScope.selectedCurriculum.semesterSubjects}">
                                <div class="semester-lane" id="lane-sem-${entry.key}">
                                    <h5 class="fw-bold mb-3 border-bottom pb-2 text-secondary"><i class="bi bi-calendar3"></i> Học kỳ ${entry.key}</h5>
                                    <div class="row row-cols-1 row-cols-md-2 g-3">
                                        <c:forEach var="sub" items="${entry.value}">
                                            <div class="col">
                                                <div class="subject-node" id="sub-list-${sub.subjectCode}" onclick="highlightPrerequisites('${sub.subjectCode}')">
                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                        <strong class="text-dark fs-5">${sub.subjectCode}</strong>
                                                        <span class="badge-req ${sub.required ? 'required' : 'elective'}">
                                                            ${sub.required ? 'Bắt buộc' : 'Tự chọn'}
                                                        </span>
                                                    </div>
                                                    <div class="text-muted mb-2">${sub.subjectName}</div>
                                                    
                                                    <!-- Prerequisite listing -->
                                                    <div id="prereq-list-container-${sub.subjectCode}"></div>

                                                    <div class="d-flex justify-content-between align-items-center pt-2 border-top mt-2" style="font-size: 0.8rem;">
                                                        <span><i class="bi bi-book"></i> Tín chỉ: <strong>${sub.credits}</strong></span>
                                                        <span class="text-primary"><i class="bi bi-check-circle"></i> Sẵn sàng</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                    </c:otherwise>
                </c:choose>

            </div>
        </div>
        </c:if>

    </div>
</div>

<c:if test="${requestScope.showCurriculumTree}">
<script>
    // Deserialize prerequisites mapping from request
    const prerequisiteMap = JSON.parse('${requestScope.prereqsJson}');
    
    // Render prerequisites badges on page load
    document.addEventListener("DOMContentLoaded", () => {
        Object.keys(prerequisiteMap).forEach(target => {
            const reqList = prerequisiteMap[target];
            if (reqList && reqList.length > 0) {
                // For column layout
                const container = document.getElementById(`prereq-container-${target}`);
                if (container) {
                    reqList.forEach(req => {
                        container.innerHTML += `<span class="prereq-badge"><i class="bi bi-arrow-return-right"></i> Tiên quyết: ${req}</span>`;
                    });
                }
                // For list layout
                const listContainer = document.getElementById(`prereq-list-container-${target}`);
                if (listContainer) {
                    reqList.forEach(req => {
                        listContainer.innerHTML += `<span class="prereq-badge me-1"><i class="bi bi-arrow-return-right"></i> Tiên quyết: ${req}</span>`;
                    });
                }
            }
        });
    });

    // View filter modes: Tree (column) vs List (vertical lane)
    function switchViewMode(mode) {
        const treeView = document.getElementById('view-mode-tree');
        const listView = document.getElementById('view-mode-list');
        const btnTree = document.getElementById('btn-view-tree');
        const btnList = document.getElementById('btn-view-list');

        if (mode === 'tree') {
            treeView.classList.remove('d-none');
            listView.classList.add('d-none');
            btnTree.classList.add('active');
            btnList.classList.remove('active');
        } else {
            treeView.classList.add('d-none');
            listView.classList.remove('d-none');
            btnTree.classList.remove('active');
            btnList.classList.add('active');
        }
    }

    // Filter semesters
    function filterSemesters(semVal) {
        const totalSemesters = ${fn:length(requestScope.selectedCurriculum.semesterSubjects)};
        
        for (let i = 1; i <= 10; i++) {
            const col = document.getElementById(`col-sem-${i}`);
            const lane = document.getElementById(`lane-sem-${i}`);

            if (semVal === 'all') {
                if (col) col.classList.remove('d-none');
                if (lane) lane.classList.remove('d-none');
            } else {
                if (i.toString() === semVal) {
                    if (col) col.classList.remove('d-none');
                    if (lane) lane.classList.remove('d-none');
                } else {
                    if (col) col.classList.add('d-none');
                    if (lane) lane.classList.add('d-none');
                }
            }
        }
    }

    // Interactive glowing tracer highlighting prerequisite relationships
    let currentActiveCode = null;

    function highlightPrerequisites(subjectCode) {
        // Clear all previous highlight classes
        document.querySelectorAll('.subject-node').forEach(node => {
            node.classList.remove('highlighted');
            node.classList.remove('prereq-highlight');
        });

        if (currentActiveCode === subjectCode) {
            // Click twice to toggle clear highlighting
            currentActiveCode = null;
            return;
        }

        currentActiveCode = subjectCode;

        // Highlight selected node
        const colNode = document.getElementById(`sub-node-${subjectCode}`);
        const listNode = document.getElementById(`sub-list-${subjectCode}`);
        if (colNode) colNode.classList.add('highlighted');
        if (listNode) listNode.classList.add('highlighted');

        // Highlight its prerequisite parent subjects (if mapped)
        const parents = prerequisiteMap[subjectCode];
        if (parents && parents.length > 0) {
            parents.forEach(parentCode => {
                const parentColNode = document.getElementById(`sub-node-${parentCode}`);
                const parentListNode = document.getElementById(`sub-list-${parentCode}`);
                if (parentColNode) parentColNode.classList.add('prereq-highlight');
                if (parentListNode) parentListNode.classList.add('prereq-highlight');
            });
        }
    }
</script>
</c:if>

<jsp:include page="/view/layout/footer.jsp"/>
