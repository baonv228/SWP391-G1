<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Subject, model.User" %>
<%
    User user = (User) session.getAttribute("user");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Tạo Syllabus — TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/syllabus.css"/>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/theme-orange.css" />
</head>
<body class="syllabus-page">
<div class="syl-container">

    <!-- Header -->
    <div class="syl-header">
        <h1>Tạo Syllabus mới</h1>
        <a class="btn-syl btn-outline-syl" href="<%=request.getContextPath()%>/syllabus?action=list">
            ← Quay lại danh sách
        </a>
    </div>

    <!-- Error -->
    <% if (error != null && !error.isEmpty()) { %>
    <div class="alert alert-error"><%= error %></div>
    <% } %>

    <!-- Section Nav -->
    <nav class="section-nav">
        <a href="#sec-details">1. Chi tiết</a>
        <a href="#sec-materials">2. Tài liệu</a>
        <a href="#sec-clos">3. CLOs</a>
        <a href="#sec-sessions">4. Sessions</a>
        <a href="#sec-assessments">5. Đánh giá</a>
    </nav>

    <form id="syllabusForm" method="post"
          action="<%=request.getContextPath()%>/syllabus?action=create" accept-charset="UTF-8">

        <!-- ================================================================ -->
        <!-- SECTION 1: Syllabus Details                                      -->
        <!-- ================================================================ -->
        <div class="syl-card" id="sec-details">
            <h2>1. Syllabus Details</h2>

            <div class="form-row">
                <div class="form-group">
                    <label>Subject <span class="required">*</span></label>
                    <select name="subjectId" class="form-control" required>
                        <option value="">-- Chọn môn học --</option>
                        <% if (subjects != null) {
                            for (Subject s : subjects) { %>
                        <option value="<%= s.getSubjectId() %>">
                            <%= s.getSubjectCode() %> — <%= s.getSubjectName() %> (<%= s.getCredits() %> tín chỉ)
                        </option>
                        <% } } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Version No <span class="required">*</span></label>
                    <input type="text" name="versionNo" class="form-control" placeholder="VD: 1.0" required/>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Syllabus Title <span class="required">*</span></label>
                    <input type="text" name="syllabusTitle" class="form-control"
                           placeholder="VD: Software development project" required/>
                </div>
                <div class="form-group">
                    <label>Tên tiếng Việt</label>
                    <input type="text" name="syllabusName" class="form-control"
                           placeholder="VD: Dự án phát triển phần mềm"/>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Syllabus English</label>
                    <input type="text" name="syllabusEnglish" class="form-control"
                           placeholder="VD: Software Development Project"/>
                </div>
                <div class="form-group">
                    <label>Degree Level</label>
                    <select name="degreeLevel" class="form-control">
                        <option value="">-- Chọn --</option>
                        <option value="Bachelor">Bachelor</option>
                        <option value="Master">Master</option>
                        <option value="PhD">PhD</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Time Allocation</label>
                    <input type="text" name="timeAllocation" class="form-control"
                           placeholder="VD: Study hour (150h) = 45h contact + 104h self-study"/>
                </div>
                <div class="form-group">
                    <label>Pre-Requisite</label>
                    <input type="text" name="preRequisiteText" class="form-control"
                           placeholder="VD: PRJ301, SWE201c"/>
                </div>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description" class="form-control" rows="3"
                          placeholder="Mô tả tổng quan về đề cương..."></textarea>
            </div>

            <div class="form-group">
                <label>Student Tasks</label>
                <textarea name="studentTasks" class="form-control" rows="4"
                          placeholder="Nhiệm vụ của sinh viên (mỗi dòng 1 task)..."></textarea>
            </div>

            <div class="form-group">
                <label>Tools</label>
                <textarea name="tools" class="form-control" rows="3"
                          placeholder="Công cụ sử dụng..."></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Scoring Scale</label>
                    <select name="scoringScale" class="form-control">
                        <option value="10">10</option>
                        <option value="4">4</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Min Avg Mark To Pass</label>
                    <input type="number" name="minAvgMarkToPass" class="form-control"
                           step="0.1" min="0" max="10" placeholder="5.0"/>
                </div>
                <div class="form-group">
                    <label>Decision No</label>
                    <input type="text" name="decisionNo" class="form-control"
                           placeholder="VD: 377/QĐ-ĐHFPT dated 04/09/2026"/>
                </div>
            </div>

            <div class="form-group">
                <label>Note</label>
                <textarea name="note" class="form-control" rows="2" placeholder="Ghi chú..."></textarea>
            </div>
        </div>

        <!-- ================================================================ -->
        <!-- SECTION 2: Materials                                             -->
        <!-- ================================================================ -->
        <div class="syl-card" id="sec-materials">
            <h2>2. Tài liệu tham khảo (Materials)</h2>
            <div style="overflow-x:auto;">
                <table class="syl-table" id="tblMaterials">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Mô tả <span class="required">*</span></th>
                        <th>Tác giả</th>
                        <th>NXB</th>
                        <th>Năm XB</th>
                        <th>Edition</th>
                        <th>ISBN</th>
                        <th>Main</th>
                        <th>Hard</th>
                        <th>Online</th>
                        <th>Note/URL</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody id="matBody">
                    <!-- rows added by JS -->
                    </tbody>
                </table>
            </div>
            <button type="button" class="btn-syl btn-outline-syl btn-sm" style="margin-top:10px;"
                    onclick="addMaterialRow()">+ Thêm tài liệu
            </button>
        </div>

        <!-- ================================================================ -->
        <!-- SECTION 3: CLOs                                                  -->
        <!-- ================================================================ -->
        <div class="syl-card" id="sec-clos">
            <h2>3. Course Learning Outcomes (CLOs)</h2>
            <div style="overflow-x:auto;">
                <table class="syl-table" id="tblCLOs">
                    <thead>
                    <tr>
                        <th style="width:60px">CLO #</th>
                        <th style="width:100px">CLO Details</th>
                        <th>LO Details <span class="required">*</span></th>
                        <th style="width:50px"></th>
                    </tr>
                    </thead>
                    <tbody id="cloBody">
                    </tbody>
                </table>
            </div>
            <button type="button" class="btn-syl btn-outline-syl btn-sm" style="margin-top:10px;"
                    onclick="addCLORow()">+ Thêm CLO
            </button>
        </div>

        <!-- ================================================================ -->
        <!-- SECTION 4: Sessions                                              -->
        <!-- ================================================================ -->
        <div class="syl-card" id="sec-sessions">
            <h2>4. Kế hoạch giảng dạy (Sessions — 45'/session)</h2>
            <div style="overflow-x:auto;">
                <table class="syl-table" id="tblSessions">
                    <thead>
                    <tr>
                        <th style="width:50px">Session</th>
                        <th>Topic <span class="required">*</span></th>
                        <th>Learning-Teaching Type</th>
                        <th>CLOs</th>
                        <th>ITU</th>
                        <th>Student Materials</th>
                        <th>S-Download</th>
                        <th>Student Tasks</th>
                        <th>URLs</th>
                        <th style="width:50px"></th>
                    </tr>
                    </thead>
                    <tbody id="sesBody">
                    </tbody>
                </table>
            </div>
            <button type="button" class="btn-syl btn-outline-syl btn-sm" style="margin-top:10px;"
                    onclick="addSessionRow()">+ Thêm session
            </button>
        </div>

        <!-- ================================================================ -->
        <!-- SECTION 5: Assessments                                           -->
        <!-- ================================================================ -->
        <div class="syl-card" id="sec-assessments">
            <h2>5. Đánh giá (Assessments)</h2>
            <div style="overflow-x:auto;">
                <table class="syl-table" id="tblAssessments">
                    <thead>
                    <tr>
                        <th style="width:50px">#</th>
                        <th>Category <span class="required">*</span></th>
                        <th>Type</th>
                        <th style="width:80px">Weight %</th>
                        <th>CLOs</th>
                        <th>Completion Criteria</th>
                        <th>Duration</th>
                        <th>Question Type</th>
                        <th>Knowledge & Skill</th>
                        <th>Grading Guide</th>
                        <th>Note</th>
                        <th style="width:50px"></th>
                    </tr>
                    </thead>
                    <tbody id="asmBody">
                    </tbody>
                </table>
            </div>
            <div style="margin-top:10px; display:flex; align-items:center; gap:12px;">
                <button type="button" class="btn-syl btn-outline-syl btn-sm"
                        onclick="addAssessmentRow()">+ Thêm assessment
                </button>
                <span id="weightTotal" style="font-size:13px; color:var(--muted);">Tổng weight: 0%</span>
            </div>
        </div>

        <!-- Submit -->
        <div style="text-align:center; padding: 20px 0 40px;">
            <button type="submit" class="btn-syl btn-primary-syl" style="min-width:220px; font-size:16px; padding:14px 32px;">
                Lưu Syllabus (Draft)
            </button>
        </div>

    </form>
</div>

<!-- ================================================================ -->
<!-- JavaScript — Dynamic rows                                        -->
<!-- ================================================================ -->
<script>
    let matCount = 0, cloCount = 0, sesCount = 0, asmCount = 0;

    // ---- Materials ----
    function addMaterialRow() {
        const i = matCount++;
        const row = document.createElement('tr');
        row.id = 'matRow_' + i;
        row.innerHTML =
            '<td>' + (i + 1) + '</td>' +
            '<td><input type="text" name="mat_description" class="form-control" required/></td>' +
            '<td><input type="text" name="mat_author" class="form-control"/></td>' +
            '<td><input type="text" name="mat_publisher" class="form-control"/></td>' +
            '<td><input type="text" name="mat_publishedDate" class="form-control" placeholder="N/A"/></td>' +
            '<td><input type="text" name="mat_edition" class="form-control" placeholder="N/A"/></td>' +
            '<td><input type="text" name="mat_isbn" class="form-control" placeholder="N/A"/></td>' +
            '<td><input type="checkbox" name="mat_isMain_' + i + '"/></td>' +
            '<td><input type="checkbox" name="mat_isHard_' + i + '"/></td>' +
            '<td><input type="checkbox" name="mat_isOnline_' + i + '"/></td>' +
            '<td><input type="text" name="mat_note" class="form-control" placeholder="URL..."/></td>' +
            '<td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeRow(\'matRow_' + i + '\')">×</button></td>';
        document.getElementById('matBody').appendChild(row);
    }

    // ---- CLOs ----
    function addCLORow() {
        const i = cloCount++;
        const num = i + 1;
        const row = document.createElement('tr');
        row.id = 'cloRow_' + i;
        row.innerHTML =
            '<td><input type="text" name="clo_name" class="form-control" value="' + num + '" readonly style="width:50px;background:#f0f0f0;"/></td>' +
            '<td><input type="text" name="clo_details" class="form-control" value="CLO' + num + '"/></td>' +
            '<td><input type="text" name="clo_loDetails" class="form-control" required placeholder="Mô tả LO..."/></td>' +
            '<td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeRow(\'cloRow_' + i + '\')">×</button></td>';
        document.getElementById('cloBody').appendChild(row);
        updateCLOCheckboxes();
    }

    // ---- Sessions ----
    function addSessionRow() {
        const i = sesCount++;
        const row = document.createElement('tr');
        row.id = 'sesRow_' + i;
        row.innerHTML =
            '<td style="text-align:center">' + (i + 1) + '</td>' +
            '<td><input type="text" name="ses_topic" class="form-control" required/></td>' +
            '<td><input type="text" name="ses_type" class="form-control" placeholder="Lecture, Discussion"/></td>' +
            '<td id="sesClo_' + i + '">' + buildCLOCheckboxes('ses', i) + '</td>' +
            '<td><input type="text" name="ses_itu" class="form-control" placeholder="AI literacy..."/></td>' +
            '<td><input type="text" name="ses_materials" class="form-control"/></td>' +
            '<td><input type="text" name="ses_download" class="form-control"/></td>' +
            '<td><input type="text" name="ses_tasks" class="form-control"/></td>' +
            '<td><input type="text" name="ses_urls" class="form-control"/></td>' +
            '<td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeRow(\'sesRow_' + i + '\')">×</button></td>';
        document.getElementById('sesBody').appendChild(row);
    }

    // ---- Assessments ----
    function addAssessmentRow() {
        const i = asmCount++;
        const row = document.createElement('tr');
        row.id = 'asmRow_' + i;
        row.innerHTML =
            '<td style="text-align:center">' + (i + 1) + '</td>' +
            '<td><input type="text" name="asm_category" class="form-control" required/></td>' +
            '<td><select name="asm_type" class="form-control"><option value="on-going">on-going</option><option value="final">final</option></select></td>' +
            '<td><input type="number" name="asm_weight" class="form-control" step="0.1" min="0" max="100" value="0" onchange="updateWeightTotal()"/></td>' +
            '<td id="asmClo_' + i + '">' + buildCLOCheckboxes('asm', i) + '</td>' +
            '<td><input type="text" name="asm_criteria" class="form-control" placeholder=">0"/></td>' +
            '<td><input type="text" name="asm_duration" class="form-control" placeholder="20\'/group"/></td>' +
            '<td><textarea name="asm_questionType" class="form-control" rows="2"></textarea></td>' +
            '<td><textarea name="asm_knowledge" class="form-control" rows="2"></textarea></td>' +
            '<td><textarea name="asm_gradingGuide" class="form-control" rows="2"></textarea></td>' +
            '<td><input type="text" name="asm_note" class="form-control"/></td>' +
            '<td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeRow(\'asmRow_' + i + '\')">×</button></td>';
        document.getElementById('asmBody').appendChild(row);
    }

    // ---- Helpers ----
    function removeRow(rowId) {
        const row = document.getElementById(rowId);
        if (row) row.remove();
        updateWeightTotal();
    }

    function buildCLOCheckboxes(prefix, rowIdx) {
        let html = '<div style="display:flex;gap:4px;flex-wrap:wrap;">';
        for (let c = 0; c < cloCount; c++) {
            const num = c + 1;
            html += '<label style="font-size:12px;white-space:nowrap;">' +
                '<input type="checkbox" name="' + prefix + '_clo_' + rowIdx + '_' + num + '"/> CLO' + num +
                '</label>';
        }
        if (cloCount === 0) html += '<span style="color:var(--muted);font-size:12px;">Thêm CLO trước</span>';
        html += '</div>';
        return html;
    }

    function updateCLOCheckboxes() {
        // Rebuild CLO checkboxes in all session and assessment rows
        document.querySelectorAll('[id^="sesClo_"]').forEach(function (td) {
            const idx = td.id.split('_')[1];
            td.innerHTML = buildCLOCheckboxes('ses', idx);
        });
        document.querySelectorAll('[id^="asmClo_"]').forEach(function (td) {
            const idx = td.id.split('_')[1];
            td.innerHTML = buildCLOCheckboxes('asm', idx);
        });
    }

    function updateWeightTotal() {
        let total = 0;
        document.querySelectorAll('input[name="asm_weight"]').forEach(function (input) {
            total += parseFloat(input.value) || 0;
        });
        const el = document.getElementById('weightTotal');
        el.textContent = 'Tổng weight: ' + total.toFixed(1) + '%';
        el.style.color = (Math.abs(total - 100) < 0.01) ? '#2e7d32' : '#c62828';
    }

    // Scroll spy for section nav
    document.addEventListener('DOMContentLoaded', function () {
        const navLinks = document.querySelectorAll('.section-nav a');
        const sections = [];
        navLinks.forEach(function (link) {
            const id = link.getAttribute('href').substring(1);
            const sec = document.getElementById(id);
            if (sec) sections.push({el: sec, link: link});
        });

        window.addEventListener('scroll', function () {
            let current = sections[0];
            for (const s of sections) {
                if (window.scrollY >= s.el.offsetTop - 120) current = s;
            }
            navLinks.forEach(function (l) { l.classList.remove('active'); });
            if (current) current.link.classList.add('active');
        });

        // Add 1 default row each
        addMaterialRow();
        addCLORow();
        addSessionRow();
        addAssessmentRow();
    });
</script>
</body>
</html>
