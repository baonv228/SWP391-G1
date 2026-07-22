<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User current = (User) session.getAttribute("user");
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
    String fullNameValue = current != null && current.getFullName() != null ? current.getFullName() : "";
    String emailValue = current != null && current.getEmail() != null ? current.getEmail() : "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hồ sơ</title>
    <style>
        :root {
            --orange: #f37021;
            --orange-dark: #d95f12;
            --text: #1f2937;
            --muted: #6b7280;
            --border: #eaded4;
            --danger: #dc3545;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            font-family: "Segoe UI", Arial, sans-serif;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.96), rgba(255, 241, 231, 0.98)),
                radial-gradient(circle at 15% 20%, rgba(243, 112, 33, 0.1), transparent 26%);
        }
        .card {
            width: 100%;
            max-width: 520px;
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            box-shadow: 0 14px 40px rgba(0, 0, 0, 0.12);
            padding: 22px;
        }
        h2 {
            margin: 0;
            text-align: center;
            color: var(--orange-dark);
            font-size: 22px;
            font-weight: 800;
        }
        .subtitle {
            text-align: center;
            margin-top: 6px;
            color: var(--muted);
            font-size: 13px;
        }
        .message, .error {
            margin: 14px 0 10px;
            padding: 10px 12px;
            border-radius: 10px;
            font-size: 13px;
            text-align: center;
            line-height: 1.5;
        }
        .message {
            border: 1px solid rgba(243, 112, 33, 0.22);
            background: #fff7f0;
            color: var(--orange-dark);
        }
        .error {
            border: 1px solid rgba(220, 53, 69, 0.35);
            background: rgba(220, 53, 69, 0.08);
            color: var(--danger);
        }
        .meta {
            margin-top: 14px;
            padding: 12px;
            border-radius: 10px;
            background: #fffaf6;
            border: 1px solid var(--border);
            font-size: 13px;
            color: #374151;
            line-height: 1.6;
        }
        form { margin-top: 14px; }
        .row { margin-bottom: 12px; }
        label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px;
        }
        input {
            width: 100%;
            padding: 10px 12px;
            border-radius: 10px;
            border: 1px solid var(--border);
            font-size: 14px;
            outline: none;
            background: #fff;
            color: var(--text);
        }
        input:focus {
            border-color: rgba(243, 112, 33, 0.9);
            box-shadow: 0 0 0 0.2rem rgba(243, 112, 33, 0.16);
        }
        .btn-primary {
            width: 100%;
            border: none;
            cursor: pointer;
            border-radius: 10px;
            padding: 10px 12px;
            background: var(--orange);
            color: #fff;
            font-size: 15px;
            font-weight: 700;
            margin-top: 6px;
        }
        .btn-primary:hover { background: var(--orange-dark); }
        .links {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            margin-top: 14px;
            flex-wrap: wrap;
            font-size: 13px;
        }
        .links a {
            color: var(--orange-dark);
            text-decoration: none;
            font-weight: 700;
        }
    </style>
    <script>
        function validateProfile() {
            const fullName = document.getElementById("fullName").value.trim();
            if (!fullName) {
                alert("Họ tên không được để trống.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div class="card">
    <h2>Hồ sơ cá nhân</h2>
    <div class="subtitle">Xem và cập nhật thông tin tài khoản.</div>

<<<<<<< Updated upstream
    <% if (message != null) { %>
    <div class="message"><%= message %></div>
    <% } %>
=======
<c:choose>
    <c:when test="${sessionScope.user.role.roleName eq 'Student' or sessionScope.user.role.roleName eq 'syllabusds'}">
        <c:set var="pageTitle" value="Hồ sơ cá nhân & Sơ đồ đào tạo" scope="request"/>
    </c:when>
    <c:otherwise>
        <c:set var="pageTitle" value="Hồ sơ cá nhân" scope="request"/>
    </c:otherwise>
</c:choose>
<jsp:include page="/view/layout/header.jsp"/>
>>>>>>> Stashed changes

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <div class="meta">
        <div><strong>Email:</strong> <%= emailValue %></div>
        <div><strong>Vai trò:</strong> <%= current != null && current.getRole() != null ? current.getRole().getRoleName() : "" %></div>
    </div>

<<<<<<< Updated upstream
    <form method="post" action="<%=request.getContextPath()%>/profile" onsubmit="return validateProfile();">
        <div class="row">
            <label for="fullName">Họ tên</label>
            <input id="fullName" type="text" name="fullName" value="<%= fullNameValue %>" />
        </div>


        <button class="btn-primary" type="submit">Lưu thay đổi</button>
    </form>
=======
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
        <div class="${(sessionScope.user.role.roleName eq 'Student' or sessionScope.user.role.roleName eq 'syllabusds') ? 'col-md-4' : 'col-md-6 mx-auto'}">
            <div class="profile-card">
                <div class="profile-header">
                    <h3>Thông tin tài khoản</h3>
                    <c:choose>
                        <c:when test="${sessionScope.user.role.roleName eq 'Student' or sessionScope.user.role.roleName eq 'syllabusds'}">
                            <div class="profile-subtitle">Xem & cấu hình hồ sơ và ngành học đào tạo.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="profile-subtitle">Xem và chỉnh sửa thông tin cá nhân của bạn.</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${not empty requestScope.curriculumFallbackNotice}">
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

                    <!-- Curriculum Select Dropdown - Only for Student and syllabusds -->
                    <c:if test="${sessionScope.user.role.roleName eq 'Student' or sessionScope.user.role.roleName eq 'syllabusds'}">
                        <div class="mb-4">
                            <label for="curriculumId" class="form-label">Ngành học & Chương trình (Curriculum)</label>
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

        <!-- Right Side: Interactive Study Tree Map - Only for Student and syllabusds -->
        <c:if test="${sessionScope.user.role.roleName eq 'Student' or sessionScope.user.role.roleName eq 'syllabusds'}">
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
>>>>>>> Stashed changes

    <div class="links">
        <a href="<%=request.getContextPath()%>/change-password">Đổi mật khẩu</a>
        <a href="<%=request.getContextPath()%>/logout">Đăng xuất</a>
    </div>
</div>
<<<<<<< Updated upstream
</body>
</html>
=======

<c:if test="${sessionScope.user.role.roleName eq 'Student' or sessionScope.user.role.roleName eq 'syllabusds'}">
<script>
    // Deserialize prerequisites mapping from request
    const prerequisiteMap = JSON.parse('${requestScope.prereqsJson}');
    
    // Render prerequisites badges on page load
    document.addEventListener("DOMContentLoaded", function() {
        Object.keys(prerequisiteMap).forEach(function(target) {
            const reqList = prerequisiteMap[target];
            if (reqList && reqList.length > 0) {
                // For column layout
                const container = document.getElementById('prereq-container-' + target);
                if (container) {
                    reqList.forEach(function(req) {
                        container.innerHTML += '<span class="prereq-badge"><i class="bi bi-arrow-return-right"></i> Tiên quyết: ' + req + '</span>';
                    });
                }
                // For list layout
                const listContainer = document.getElementById('prereq-list-container-' + target);
                if (listContainer) {
                    reqList.forEach(function(req) {
                        listContainer.innerHTML += '<span class="prereq-badge me-1"><i class="bi bi-arrow-return-right"></i> Tiên quyết: ' + req + '</span>';
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
            const col = document.getElementById('col-sem-' + i);
            const lane = document.getElementById('lane-sem-' + i);

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
        document.querySelectorAll('.subject-node').forEach(function(node) {
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
        const colNode = document.getElementById('sub-node-' + subjectCode);
        const listNode = document.getElementById('sub-list-' + subjectCode);
        if (colNode) colNode.classList.add('highlighted');
        if (listNode) listNode.classList.add('highlighted');

        // Highlight its prerequisite parent subjects (if mapped)
        const parents = prerequisiteMap[subjectCode];
        if (parents && parents.length > 0) {
            parents.forEach(function(parentCode) {
                const parentColNode = document.getElementById('sub-node-' + parentCode);
                const parentListNode = document.getElementById('sub-list-' + parentCode);
                if (parentColNode) parentColNode.classList.add('prereq-highlight');
                if (parentListNode) parentListNode.classList.add('prereq-highlight');
            });
        }
    }
</script>
</c:if>

<jsp:include page="/view/layout/footer.jsp"/>
>>>>>>> Stashed changes
