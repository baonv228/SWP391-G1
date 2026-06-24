<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.*" %>
<%
    User user = (User) session.getAttribute("user");
    Syllabus syllabus = (Syllabus) request.getAttribute("syllabus");
    List<SyllabusMaterial> materials = (List<SyllabusMaterial>) request.getAttribute("materials");
    List<CLO> clos = (List<CLO>) request.getAttribute("clos");
    List<SyllabusSession> sessions = (List<SyllabusSession>) request.getAttribute("sessions");
    List<SyllabusAssessment> assessments = (List<SyllabusAssessment>) request.getAttribute("assessments");
    List<TrainingProgram> programs = (List<TrainingProgram>) request.getAttribute("programs");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Edit Syllabus — TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/syllabus.css"/>
    <script>
        const contextPath = '<%=request.getContextPath()%>';
    </script>
</head>
<body class="syllabus-page">
<div class="syl-container">

    <!-- Header -->
    <div class="syl-header">
        <h1>Chỉnh sửa Syllabus: <%= syllabus.getSubjectCode() %> (v<%= syllabus.getVersionNo() %>)</h1>
        <a class="btn-syl btn-outline-syl" href="<%=request.getContextPath()%>/syllabus?action=list">
            ← Quay lại danh sách
        </a>
    </div>

    <!-- Error/Validation Wrapper -->
    <div id="validationAlert" class="alert alert-error" style="display:none;"></div>
    <% if (error != null && !error.isEmpty()) { %>
    <div class="alert alert-error"><%= error %></div>
    <% } %>
    <% if ("draft".equals(request.getParameter("success"))) { %>
    <div class="alert alert-success" style="background:#e8f5e9; color:#2e7d32; padding:10px; margin-bottom:20px; border-radius:4px;">
        Đã lưu Draft thành công! Bạn có thể tiếp tục chỉnh sửa.
    </div>
    <% } else if ("update".equals(request.getParameter("success"))) { %>
    <div class="alert alert-success" style="background:#e8f5e9; color:#2e7d32; padding:10px; margin-bottom:20px; border-radius:4px;">
        Cập nhật Draft thành công!
    </div>
    <% } %>

    <!-- Section Nav -->
    <nav class="section-nav">
        <a href="#sec-details">1. Chi tiết</a>
        <a href="#sec-materials">2. Tài liệu</a>
        <a href="#sec-clos">3. CLOs</a>
        <a href="#sec-sessions">4. Sessions</a>
        <a href="#sec-assessments">5. Đánh giá</a>
    </nav>

    <form id="syllabusForm" method="post" enctype="multipart/form-data"
          action="<%=request.getContextPath()%>/syllabus?action=edit" accept-charset="UTF-8">
        
        <input type="hidden" name="syllabusId" value="<%= syllabus.getSyllabusId() %>">
        <input type="hidden" name="subjectId" value="<%= syllabus.getSubjectId() %>">
        <input type="hidden" name="saveType" id="saveType" value="draft">

        <!-- ================================================================ -->
        <!-- SECTION 1: Syllabus Details                                      -->
        <!-- ================================================================ -->
        <div class="syl-card" id="sec-details">
            <h2>1. Syllabus Details</h2>

            <div class="form-row">
                <div class="form-group">
                    <label>Subject</label>
                    <input type="text" class="form-control" value="<%= syllabus.getSubjectCode() %> — <%= syllabus.getSubjectName() %>" readonly style="background:#f0f0f0;">
                </div>
                <div class="form-group">
                    <label>Version No</label>
                    <input type="text" name="versionNo" class="form-control" value="<%= syllabus.getVersionNo() %>" readonly style="background:#f0f0f0;"/>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Syllabus Title <span class="required">*</span></label>
                    <input type="text" name="syllabusTitle" class="form-control"
                           value="<%= syllabus.getSyllabusTitle() %>" required/>
                </div>
                <div class="form-group">
                    <label>Tên tiếng Việt</label>
                    <input type="text" name="syllabusName" class="form-control"
                           value="<%= syllabus.getSyllabusName() != null ? syllabus.getSyllabusName() : "" %>"/>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Syllabus English</label>
                    <input type="text" name="syllabusEnglish" class="form-control"
                           value="<%= syllabus.getSyllabusEnglish() != null ? syllabus.getSyllabusEnglish() : "" %>"/>
                </div>
                <div class="form-group">
                    <label>Degree Level</label>
                    <select name="degreeLevel" class="form-control">
                        <option value="">-- Chọn --</option>
                        <option value="Bachelor" <%= "Bachelor".equals(syllabus.getDegreeLevel()) ? "selected" : "" %>>Bachelor</option>
                        <option value="Master" <%= "Master".equals(syllabus.getDegreeLevel()) ? "selected" : "" %>>Master</option>
                        <option value="PhD" <%= "PhD".equals(syllabus.getDegreeLevel()) ? "selected" : "" %>>PhD</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Time Allocation</label>
                    <input type="text" name="timeAllocation" class="form-control"
                           value="<%= syllabus.getTimeAllocation() != null ? syllabus.getTimeAllocation() : "" %>"/>
                </div>
                <div class="form-group">
                    <label>Pre-Requisite</label>
                    <input type="text" name="preRequisiteText" class="form-control"
                           value="<%= syllabus.getPreRequisiteText() != null ? syllabus.getPreRequisiteText() : "" %>" readonly style="background:#f0f0f0;"/>
                </div>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description" class="form-control" rows="3"><%= syllabus.getDescription() != null ? syllabus.getDescription() : "" %></textarea>
            </div>

            <div class="form-group">
                <label>Student Tasks</label>
                <textarea name="studentTasks" class="form-control" rows="4"><%= syllabus.getStudentTasks() != null ? syllabus.getStudentTasks() : "" %></textarea>
            </div>

            <div class="form-group">
                <label>Tools</label>
                <textarea name="tools" class="form-control" rows="3"><%= syllabus.getTools() != null ? syllabus.getTools() : "" %></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Scoring Scale</label>
                    <select name="scoringScale" id="scoringScale" class="form-control" onchange="updateScale()">
                        <option value="10" <%= Integer.valueOf(10).equals(syllabus.getScoringScale()) ? "selected" : "" %>>10</option>
                        <option value="4" <%= Integer.valueOf(4).equals(syllabus.getScoringScale()) ? "selected" : "" %>>4</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Min Avg Mark To Pass</label>
                    <input type="number" name="minAvgMarkToPass" id="minAvgMarkToPass" class="form-control"
                           step="0.1" min="0" max="10" value="<%= syllabus.getMinAvgMarkToPass() != null ? syllabus.getMinAvgMarkToPass() : "" %>"/>
                </div>
                <div class="form-group">
                    <label>Decision No</label>
                    <input type="text" name="decisionNo" class="form-control"
                           value="<%= syllabus.getDecisionNo() != null ? syllabus.getDecisionNo() : "" %>"/>
                </div>
            </div>

            <div class="form-group">
                <label>Note</label>
                <textarea name="note" class="form-control" rows="2"><%= syllabus.getNote() != null ? syllabus.getNote() : "" %></textarea>
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
                        <% if(materials != null) {
                            for(int i=0; i<materials.size(); i++) {
                                SyllabusMaterial m = materials.get(i);
                        %>
                        <tr id="matRow_<%= i %>">
                            <td><%= i+1 %></td>
                            <td><input type="text" name="mat_description" class="form-control" value="<%= m.getMaterialDescription() %>" required/></td>
                            <td><input type="text" name="mat_author" class="form-control" value="<%= m.getAuthor()!=null?m.getAuthor():"" %>"/></td>
                            <td><input type="text" name="mat_publisher" class="form-control" value="<%= m.getPublisher()!=null?m.getPublisher():"" %>"/></td>
                            <td><input type="text" name="mat_publishedDate" class="form-control" value="<%= m.getPublishedDate()!=null?m.getPublishedDate():"" %>"/></td>
                            <td><input type="text" name="mat_edition" class="form-control" value="<%= m.getEdition()!=null?m.getEdition():"" %>"/></td>
                            <td><input type="text" name="mat_isbn" class="form-control" value="<%= m.getIsbn()!=null?m.getIsbn():"" %>"/></td>
                            <td><input type="checkbox" name="mat_isMain_<%= i %>" <%= m.getIsMainMaterial()?"checked":"" %>/></td>
                            <td><input type="checkbox" name="mat_isHard_<%= i %>" <%= m.getIsHardCopy()?"checked":"" %>/></td>
                            <td><input type="checkbox" name="mat_isOnline_<%= i %>" <%= m.getIsOnline()?"checked":"" %>/></td>
                            <td><input type="text" name="mat_note" class="form-control" value="<%= m.getNote()!=null?m.getNote():"" %>"/></td>
                            <td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeRow('matRow_<%= i %>')">×</button></td>
                        </tr>
                        <% } } %>
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
                        <% if(clos != null) {
                            for(int i=0; i<clos.size(); i++) {
                                CLO c = clos.get(i);
                        %>
                        <tr id="cloRow_<%= i %>">
                            <td><input type="text" name="clo_name" class="form-control" value="<%= c.getCloName() %>" readonly style="width:70px;background:#f0f0f0;"/></td>
                            <td><input type="text" name="clo_details" class="form-control" value="<%= c.getCloDetails()!=null?c.getCloDetails():"" %>"/></td>
                            <td><input type="text" name="clo_loDetails" class="form-control" value="<%= c.getLoDetails() %>" required/></td>
                            <td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeCLORow('cloRow_<%= i %>', <%= i+1 %>)">×</button></td>
                        </tr>
                        <% } } %>
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
            
            <div class="form-group" style="padding: 15px; background: #e3f2fd; border-radius: 6px; margin-bottom: 20px;">
                <label>Student Material Package (ZIP file) <span class="required">*</span></label>
                <% if(syllabus.getMaterialFilePath() != null) { %>
                <div style="margin-bottom:10px; color:#1565c0; font-weight:bold;">
                    Đã tải lên: <%= syllabus.getMaterialFilePath() %>
                </div>
                <% } %>
                <input type="file" name="student_material_file" accept=".zip" class="form-control" style="background:#fff;">
                <small style="color:var(--muted);">Tải lên tài liệu học tập mới để thay thế bản cũ (nếu có). Chỉ hỗ trợ file .zip, tối đa 100MB.</small>
            </div>

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
                        <!-- Loaded via JS because of CLO checkboxes -->
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
                        <!-- Loaded via JS -->
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
        <div style="text-align:center; padding: 20px 0 40px; display: flex; gap: 20px; justify-content: center;">
            <button type="button" class="btn-syl btn-outline-syl" style="min-width:200px; font-size:16px; padding:14px 32px;" onclick="doSave('draft')">
                Cập nhật Draft
            </button>
            <button type="button" class="btn-syl btn-primary-syl" style="min-width:200px; font-size:16px; padding:14px 32px;" id="btnSubmitApproval" onclick="doSave('submit')">
                Submit for Approval
            </button>
        </div>

    </form>
</div>

<script>
    let matCount = <%= materials != null ? materials.size() : 0 %>;
    let cloCount = <%= clos != null ? clos.size() : 0 %>;
    let sesCount = 0;
    let asmCount = 0;

    function doSave(type) {
        document.getElementById('saveType').value = type;
        if(type === 'draft') {
            document.getElementById('syllabusForm').submit();
        } else {
            if(validateForm()) {
                document.getElementById('syllabusForm').submit();
            }
        }
    }

    function updateScale() {
        let max = document.getElementById('scoringScale').value;
        document.getElementById('minAvgMarkToPass').max = max;
    }

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
        const num = i + 1; // Need a better index finding logic if deletions occur, but for simplicity we append
        const row = document.createElement('tr');
        row.id = 'cloRow_' + i;
        row.innerHTML =
            '<td><input type="text" name="clo_name" class="form-control" value="CLO' + num + '" readonly style="width:70px;background:#f0f0f0;"/></td>' +
            '<td><input type="text" name="clo_details" class="form-control" value="CLO' + num + '"/></td>' +
            '<td><input type="text" name="clo_loDetails" class="form-control" required placeholder="Mô tả LO..."/></td>' +
            '<td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeCLORow(\'cloRow_' + i + '\', ' + num + ')">×</button></td>';
        document.getElementById('cloBody').appendChild(row);
        updateCLOCheckboxes();
        checkValidationStatus();
    }
    
    function removeCLORow(rowId, cloNum) {
        const isUsed = document.querySelector('input[name^="ses_clo_"][name$="_' + cloNum + '"]:checked') ||
                       document.querySelector('input[name^="asm_clo_"][name$="_' + cloNum + '"]:checked');
        if(isUsed) {
            alert('Không thể xóa CLO này vì nó đang được map trong Session hoặc Assessment!');
            return;
        }
        removeRow(rowId);
        updateCLOCheckboxes();
        checkValidationStatus();
    }

    // ---- Sessions ----
    function addSessionRow(data = {}) {
        const i = sesCount++;
        const row = document.createElement('tr');
        row.id = 'sesRow_' + i;
        row.className = 'session-row';
        row.innerHTML =
            '<td style="text-align:center" class="ses-idx">' + (i + 1) + '</td>' +
            '<td><input type="text" name="ses_topic" class="form-control" required value="' + (data.topic || '') + '"/></td>' +
            '<td><input type="text" name="ses_type" class="form-control" value="' + (data.type || '') + '"/></td>' +
            '<td id="sesClo_' + i + '">' + buildCLOCheckboxes('ses', i, data.clos || []) + '</td>' +
            '<td><input type="text" name="ses_itu" class="form-control" value="' + (data.itu || '') + '"/></td>' +
            '<td><input type="text" name="ses_materials" class="form-control" value="' + (data.materials || '') + '"/></td>' +
            '<td><input type="text" name="ses_download" class="form-control" value="' + (data.download || '') + '"/></td>' +
            '<td><input type="text" name="ses_tasks" class="form-control" value="' + (data.tasks || '') + '"/></td>' +
            '<td><input type="text" name="ses_urls" class="form-control" value="' + (data.urls || '') + '"/></td>' +
            '<td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeRow(\'sesRow_' + i + '\')">×</button></td>';
        document.getElementById('sesBody').appendChild(row);
        checkValidationStatus();
    }

    // ---- Assessments ----
    function addAssessmentRow(data = {}) {
        const i = asmCount++;
        const row = document.createElement('tr');
        row.id = 'asmRow_' + i;
        row.innerHTML =
            '<td style="text-align:center">' + (i + 1) + '</td>' +
            '<td><input type="text" name="asm_category" class="form-control" required value="' + (data.category || '') + '"/></td>' +
            '<td><select name="asm_type" class="form-control"><option value="on-going" ' + (data.type==='on-going'?'selected':'') + '>on-going</option><option value="final" ' + (data.type==='final'?'selected':'') + '>final</option></select></td>' +
            '<td><input type="number" name="asm_weight" class="form-control asm-weight" step="0.1" min="0" max="100" value="' + (data.weight || 0) + '" onchange="updateWeightTotal()"/></td>' +
            '<td id="asmClo_' + i + '">' + buildCLOCheckboxes('asm', i, data.clos || []) + '</td>' +
            '<td><input type="text" name="asm_criteria" class="form-control" value="' + (data.criteria || '') + '"/></td>' +
            '<td><input type="text" name="asm_duration" class="form-control" value="' + (data.duration || '') + '"/></td>' +
            '<td><textarea name="asm_questionType" class="form-control" rows="2">' + (data.questionType || '') + '</textarea></td>' +
            '<td><textarea name="asm_knowledge" class="form-control" rows="2">' + (data.knowledge || '') + '</textarea></td>' +
            '<td><textarea name="asm_gradingGuide" class="form-control" rows="2">' + (data.gradingGuide || '') + '</textarea></td>' +
            '<td><input type="text" name="asm_note" class="form-control" value="' + (data.note || '') + '"/></td>' +
            '<td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeRow(\'asmRow_' + i + '\')">×</button></td>';
        document.getElementById('asmBody').appendChild(row);
        checkValidationStatus();
        updateWeightTotal();
    }

    // ---- Helpers ----
    function removeRow(rowId) {
        const row = document.getElementById(rowId);
        if (row) row.remove();
        updateWeightTotal();
        checkValidationStatus();
    }

    function buildCLOCheckboxes(prefix, rowIdx, checkedIds = []) {
        let html = '<div style="display:flex;gap:4px;flex-wrap:wrap;">';
        let found = false;
        document.querySelectorAll('#cloBody tr').forEach((tr) => {
            const num = parseInt(tr.querySelector('input[name="clo_name"]').value.replace('CLO',''));
            const isChecked = checkedIds.includes(num) ? 'checked' : '';
            html += '<label style="font-size:12px;white-space:nowrap;">' +
                '<input type="checkbox" onchange="checkValidationStatus()" class="' + prefix + '-clo-cb" name="' + prefix + '_clo_' + rowIdx + '_' + num + '" value="' + num + '" ' + isChecked + '/> CLO' + num +
                '</label>';
            found = true;
        });
        if (!found) html += '<span style="color:var(--muted);font-size:12px;">Thêm CLO trước</span>';
        html += '</div>';
        return html;
    }

    function updateCLOCheckboxes() {
        const checkedMap = {};
        document.querySelectorAll('input[type="checkbox"]:checked').forEach(cb => {
            checkedMap[cb.name] = true;
        });

        document.querySelectorAll('[id^="sesClo_"]').forEach(function (td) {
            const idx = td.id.split('_')[1];
            td.innerHTML = buildCLOCheckboxes('ses', idx);
        });
        document.querySelectorAll('[id^="asmClo_"]').forEach(function (td) {
            const idx = td.id.split('_')[1];
            td.innerHTML = buildCLOCheckboxes('asm', idx);
        });

        document.querySelectorAll('input[type="checkbox"]').forEach(cb => {
            if(checkedMap[cb.name]) cb.checked = true;
        });
    }

    function updateWeightTotal() {
        let total = 0;
        document.querySelectorAll('.asm-weight').forEach(function (input) {
            total += parseFloat(input.value) || 0;
        });
        const el = document.getElementById('weightTotal');
        el.textContent = 'Tổng weight: ' + total.toFixed(1) + '%';
        el.style.color = (Math.abs(total - 100) < 0.01) ? '#2e7d32' : '#c62828';
        checkValidationStatus();
    }

    function checkValidationStatus() {
        const cloCountActual = document.querySelectorAll('#cloBody tr').length;
        const sesCountActual = document.querySelectorAll('.session-row').length;
        
        let totalWeight = 0;
        document.querySelectorAll('.asm-weight').forEach(function (input) {
            totalWeight += parseFloat(input.value) || 0;
        });

        let isValid = true;
        let titleAttr = [];

        if (Math.abs(totalWeight - 100) > 0.01) {
            isValid = false;
            titleAttr.push('• Assessment weight must be 100%');
        }
        if (cloCountActual < 3 || cloCountActual > 10) {
            isValid = false;
            titleAttr.push('• CLOs must be between 3 and 10');
        }
        if (sesCountActual < 10 || sesCountActual > 60) {
            isValid = false;
            titleAttr.push('• Sessions must be between 10 and 60');
        }

        const btn = document.getElementById('btnSubmitApproval');
        if (isValid) {
            btn.disabled = false;
            btn.title = "Submit Syllabus for Approval";
        } else {
            btn.disabled = true;
            btn.title = "Submit for Approval is unavailable until:\n" + titleAttr.join("\n");
        }
    }

    function validateForm() {
        let errors = [];
        const cloCountActual = document.querySelectorAll('#cloBody tr').length;
        const sesCountActual = document.querySelectorAll('.session-row').length;
        
        if (cloCountActual < 3 || cloCountActual > 10) {
            errors.push('Section 3: Phải có từ 3 đến 10 CLOs.');
        }

        if (sesCountActual < 10 || sesCountActual > 60) {
            errors.push('Section 4: Phải có từ 10 đến 60 Sessions.');
        }

        let sessionCloMissing = false;
        document.querySelectorAll('[id^="sesClo_"]').forEach(td => {
            if (td.closest('tr') && td.querySelectorAll('input:checked').length === 0) {
                sessionCloMissing = true;
            }
        });
        if (sessionCloMissing) errors.push('Section 4: Mỗi Session phải gắn với ít nhất 1 CLO.');

        let totalWeight = 0;
        document.querySelectorAll('.asm-weight').forEach(input => {
            totalWeight += parseFloat(input.value) || 0;
        });
        if (Math.abs(totalWeight - 100) > 0.01) {
            errors.push('Section 5: Tổng Weight phải đúng 100%.');
        }

        let asmCloMissing = false;
        document.querySelectorAll('[id^="asmClo_"]').forEach(td => {
            if (td.closest('tr') && td.querySelectorAll('input:checked').length === 0) {
                asmCloMissing = true;
            }
        });
        if (asmCloMissing) errors.push('Section 5: Mỗi Assessment phải gắn với ít nhất 1 CLO.');

        const validationAlert = document.getElementById('validationAlert');
        if (errors.length > 0) {
            validationAlert.innerHTML = errors.join('<br/>');
            validationAlert.style.display = 'block';
            window.scrollTo(0, 0);
            return false;
        }

        validationAlert.style.display = 'none';
        return true;
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

        // Load sessions and assessments from data
        <% if(sessions != null) {
            for(SyllabusSession s : sessions) { 
                String cloArr = "[";
                if(s.getCloIds() != null) {
                    for(int i=0; i<s.getCloIds().size(); i++) {
                        cloArr += s.getCloIds().get(i);
                        if(i < s.getCloIds().size()-1) cloArr += ",";
                    }
                }
                cloArr += "]";
        %>
            addSessionRow({
                topic: "<%= s.getTopic().replace("\"", "\\\"") %>",
                type: "<%= s.getLearningTeachingType()!=null?s.getLearningTeachingType().replace("\"", "\\\""):"" %>",
                itu: "<%= s.getItu()!=null?s.getItu().replace("\"", "\\\""):"" %>",
                materials: "<%= s.getStudentMaterials()!=null?s.getStudentMaterials().replace("\"", "\\\""):"" %>",
                download: "<%= s.getSDownload()!=null?s.getSDownload().replace("\"", "\\\""):"" %>",
                tasks: "<%= s.getStudentTasks()!=null?s.getStudentTasks().replace("\"", "\\\""):"" %>",
                urls: "<%= s.getUrls()!=null?s.getUrls().replace("\"", "\\\""):"" %>",
                clos: <%= cloArr %>
            });
        <% } } %>

        <% if(assessments != null) {
            for(SyllabusAssessment a : assessments) { 
                String cloArr = "[";
                if(a.getCloIds() != null) {
                    for(int i=0; i<a.getCloIds().size(); i++) {
                        cloArr += a.getCloIds().get(i);
                        if(i < a.getCloIds().size()-1) cloArr += ",";
                    }
                }
                cloArr += "]";
        %>
            addAssessmentRow({
                category: "<%= a.getCategory().replace("\"", "\\\"") %>",
                type: "<%= a.getType()!=null?a.getType().replace("\"", "\\\""):"" %>",
                weight: <%= a.getWeight() %>,
                criteria: "<%= a.getCompletionCriteria()!=null?a.getCompletionCriteria().replace("\"", "\\\""):"" %>",
                duration: "<%= a.getDuration()!=null?a.getDuration().replace("\"", "\\\""):"" %>",
                questionType: "<%= a.getQuestionType()!=null?a.getQuestionType().replace("\"", "\\\"").replace("\n", "\\n"):"" %>",
                knowledge: "<%= a.getKnowledgeAndSkill()!=null?a.getKnowledgeAndSkill().replace("\"", "\\\"").replace("\n", "\\n"):"" %>",
                gradingGuide: "<%= a.getGradingGuide()!=null?a.getGradingGuide().replace("\"", "\\\"").replace("\n", "\\n"):"" %>",
                note: "<%= a.getNote()!=null?a.getNote().replace("\"", "\\\""):"" %>",
                clos: <%= cloArr %>
            });
        <% } } %>

        checkValidationStatus();
    });
</script>
</body>
</html>
