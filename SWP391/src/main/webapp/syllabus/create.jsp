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
    <script>
    function openPloModal(cloNum, btnEl) {
        const subjectInput = document.getElementById('subjectId') || document.querySelector('input[name="subjectId"]');
        const subjectId = subjectInput ? subjectInput.value : '';
        if (!subjectId) {
            alert('Vui lòng chọn Subject trước khi map PLO!');
            return;
        }
        document.getElementById('currentCloMappingNum').value = cloNum;
        document.getElementById('ploModalTitle').textContent = 'Map PLO cho CLO' + cloNum;
        const tr = btnEl.closest('tr');
        const existingInputs = tr.querySelectorAll('input[name^="clo_plo_"]');
        const mappedPloIds = Array.from(existingInputs).map(inp => inp.value);
        const container = document.getElementById('ploCheckboxContainer');
        container.innerHTML = '<em>Đang tải danh sách PLO...</em>';
        document.getElementById('ploModal').style.display = 'block';
        fetch(contextPath + '/syllabus-manage?action=ajax_plos&subjectId=' + subjectId)
            .then(res => res.json())
            .then(data => {
                if(!data || data.length === 0) {
                    container.innerHTML = '<span style="color:#d32f2f;">Không tìm thấy PLO nào cho môn học này! (Vui lòng kiểm tra Training Program)</span>';
                    return;
                }
                let html = '';
                data.forEach(p => {
                    const checked = mappedPloIds.includes(p.ploId.toString()) ? 'checked' : '';
                    html += '<div style="margin-bottom:8px;">' +
                            '<label style="cursor:pointer;"><input type="checkbox" class="plo-cb" value="'+p.ploId+'" '+checked+'> ' +
                            '<strong>' + p.ploCode + '</strong>: ' + p.ploDescription + '</label>' +
                            '</div>';
                });
                container.innerHTML = html;
            }).catch(err => {
                container.innerHTML = '<span style="color:#d32f2f;">Lỗi khi tải PLO. Vui lòng thử lại.</span>';
            });
    }
    function closePloModal() {
        document.getElementById('ploModal').style.display = 'none';
    }
    function savePloMapping() {
        const cloNum = document.getElementById('currentCloMappingNum').value;
        const tr = document.getElementById('cloBody').children[cloNum - 1];
        tr.querySelectorAll('input[name^="clo_plo_"]').forEach(inp => inp.remove());
        const idx = cloNum - 1;
        const selected = document.querySelectorAll('#ploCheckboxContainer input[type="checkbox"]:checked');
        let countText = '';
        if(selected.length > 0) countText = ' (' + selected.length + ')';
        selected.forEach(cb => {
            const inp = document.createElement('input');
            inp.type = 'hidden';
            inp.name = 'clo_plo_' + idx;
            inp.value = cb.value;
            tr.querySelector('td:last-child').appendChild(inp);
        });
        const btn = tr.querySelector('.btn-map-plo');
        if(btn) btn.innerHTML = 'Map PLO' + countText;
        closePloModal();
    }

        const contextPath = '<%=request.getContextPath()%>';
        function fetchInitData() {
            const subjectId = document.getElementById("subjectId").value;
            if(!subjectId) return;
            fetch(contextPath + "/syllabus-manage?action=ajax_init&subjectId=" + subjectId)
                .then(r => r.json())
                .then(data => {
                    document.getElementById("syllabusTitle").value = data.syllabusTitle || "";
                    document.getElementById("versionNo").value = data.versionNo || "1.0";
                    document.getElementById("preRequisiteText").value = data.preRequisiteText || "";
                });
        }
    </script>
</head>
<body class="syllabus-page">
<div class="syl-container">

    <!-- Header -->
    <div class="syl-header">
        <h1>Tạo Syllabus mới</h1>
        <a class="btn-syl btn-outline-syl" href="<%=request.getContextPath()%>/syllabus-manage?action=list">
            ← Quay lại danh sách
        </a>
    </div>

    <!-- Error/Validation Wrapper -->
    <div id="validationAlert" class="alert alert-error" style="display:none;"></div>
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

    <form id="syllabusForm" method="post" enctype="multipart/form-data"
          action="<%=request.getContextPath()%>/syllabus-manage?action=create" accept-charset="UTF-8" onsubmit="return validateForm()">
        
        <input type="hidden" name="saveType" id="saveType" value="draft">

        <!-- ================================================================ -->
        <!-- SECTION 1: Syllabus Details                                      -->
        <!-- ================================================================ -->
        <div class="syl-card" id="sec-details">
            <h2>1. Syllabus Details</h2>

            <div class="form-row">
                <div class="form-group">
                    <label>Subject <span class="required">*</span></label>
                    <select name="subjectId" id="subjectId" class="form-control" required onchange="fetchInitData()">
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
                    <input type="text" name="versionNo" id="versionNo" class="form-control" placeholder="VD: 1.0" required readonly style="background:#f0f0f0;"/>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Syllabus Title <span class="required">*</span></label>
                    <input type="text" name="syllabusTitle" id="syllabusTitle" class="form-control"
                           placeholder="Auto-fill từ Subject" required readonly style="background:#f0f0f0;"/>
                </div>
                <div class="form-group">
                    <label>Tên tiếng Việt</label>
                    <input type="text" name="syllabusName" id="syllabusName" class="form-control"
                           placeholder="VD: Phát triển ứng dụng Web với Java"/>
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
                    <input type="text" name="preRequisiteText" id="preRequisiteText" class="form-control"
                           placeholder="VD: PRJ301, SWE201c" readonly style="background:#f0f0f0;"/>
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
                    <select name="scoringScale" id="scoringScale" class="form-control" onchange="updateScale()">
                        <option value="10">10</option>
                        <option value="4">4</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Min Avg Mark To Pass</label>
                    <input type="number" name="minAvgMarkToPass" id="minAvgMarkToPass" class="form-control"
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
            
            <div class="form-group" style="padding: 15px; background: #e3f2fd; border-radius: 6px; margin-bottom: 20px;">
                <label>Student Material Package (ZIP file) <span class="required">*</span></label>
                <input type="file" name="student_material_file" accept=".zip" class="form-control" style="background:#fff;">
                <small style="color:var(--muted);">Tải lên tài liệu học tập cho sinh viên. Chỉ hỗ trợ file .zip, tối đa 100MB.</small>
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
        <div style="text-align:center; padding: 20px 0 40px; display: flex; gap: 20px; justify-content: center;">
            <button type="button" class="btn-syl btn-outline-syl" style="min-width:200px; font-size:16px; padding:14px 32px;" onclick="doSave('draft')">
                Lưu Draft
            </button>
            <button type="button" class="btn-syl btn-primary-syl" style="min-width:200px; font-size:16px; padding:14px 32px;" id="btnSubmitApproval" onclick="doSave('submit')">
                Submit for Approval
            </button>
        </div>

    </form>
</div>

<script>
    function openPloModal(cloNum, btnEl) {
        const subjectInput = document.getElementById('subjectId') || document.querySelector('input[name="subjectId"]');
        const subjectId = subjectInput ? subjectInput.value : '';
        if (!subjectId) {
            alert('Vui lòng chọn Subject trước khi map PLO!');
            return;
        }
        document.getElementById('currentCloMappingNum').value = cloNum;
        document.getElementById('ploModalTitle').textContent = 'Map PLO cho CLO' + cloNum;
        const tr = btnEl.closest('tr');
        const existingInputs = tr.querySelectorAll('input[name^="clo_plo_"]');
        const mappedPloIds = Array.from(existingInputs).map(inp => inp.value);
        const container = document.getElementById('ploCheckboxContainer');
        container.innerHTML = '<em>Đang tải danh sách PLO...</em>';
        document.getElementById('ploModal').style.display = 'block';
        fetch(contextPath + '/syllabus-manage?action=ajax_plos&subjectId=' + subjectId)
            .then(res => res.json())
            .then(data => {
                if(!data || data.length === 0) {
                    container.innerHTML = '<span style="color:#d32f2f;">Không tìm thấy PLO nào cho môn học này! (Vui lòng kiểm tra Training Program)</span>';
                    return;
                }
                let html = '';
                data.forEach(p => {
                    const checked = mappedPloIds.includes(p.ploId.toString()) ? 'checked' : '';
                    html += '<div style="margin-bottom:8px;">' +
                            '<label style="cursor:pointer;"><input type="checkbox" class="plo-cb" value="'+p.ploId+'" '+checked+'> ' +
                            '<strong>' + p.ploCode + '</strong>: ' + p.ploDescription + '</label>' +
                            '</div>';
                });
                container.innerHTML = html;
            }).catch(err => {
                container.innerHTML = '<span style="color:#d32f2f;">Lỗi khi tải PLO. Vui lòng thử lại.</span>';
            });
    }
    function closePloModal() {
        document.getElementById('ploModal').style.display = 'none';
    }
    function savePloMapping() {
        const cloNum = document.getElementById('currentCloMappingNum').value;
        const tr = document.getElementById('cloBody').children[cloNum - 1];
        tr.querySelectorAll('input[name^="clo_plo_"]').forEach(inp => inp.remove());
        const idx = cloNum - 1;
        const selected = document.querySelectorAll('#ploCheckboxContainer input[type="checkbox"]:checked');
        let countText = '';
        if(selected.length > 0) countText = ' (' + selected.length + ')';
        selected.forEach(cb => {
            const inp = document.createElement('input');
            inp.type = 'hidden';
            inp.name = 'clo_plo_' + idx;
            inp.value = cb.value;
            tr.querySelector('td:last-child').appendChild(inp);
        });
        const btn = tr.querySelector('.btn-map-plo');
        if(btn) btn.innerHTML = 'Map PLO' + countText;
        closePloModal();
    }

    let matCount = 0, cloCount = 0, sesCount = 0, asmCount = 0;

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
            '<td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeRow(this, \'mat\')">×</button></td>';
        document.getElementById('matBody').appendChild(row);
    }

    // ---- CLOs ----
    function addCLORow() {
        const i = cloCount++;
        const num = i + 1;
        const row = document.createElement('tr');
        row.id = 'cloRow_' + i;
        row.innerHTML =
            '<td><input type="text" name="clo_name" class="form-control" value="CLO' + num + '" readonly style="width:70px;background:#f0f0f0;"/></td>' +
            '<td><input type="text" name="clo_details" class="form-control" value="CLO' + num + '"/></td>' +
            '<td><input type="text" name="clo_loDetails" class="form-control" required placeholder="Mô tả LO..."/></td>' +
            '<td style="white-space:nowrap;">' +
 '<button type="button" class="btn-syl btn-sm btn-map-plo" style="margin-right:5px; background:#F5A623; color:#fff; border:none;" onclick="openPloModal(' + num + ', this)">Map PLO</button>' +
 '<button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeCLORow(this, ' + num + ')">×</button></td>';
        document.getElementById('cloBody').appendChild(row);
        updateCLOCheckboxes();
        checkValidationStatus();
    }
    
    function removeCLORow(btn, cloNum) {
        const isUsed = document.querySelector('input[name^="ses_clo_"][name$="_' + cloNum + '"]:checked') ||
                       document.querySelector('input[name^="asm_clo_"][name$="_' + cloNum + '"]:checked');
        if(isUsed) {
            alert('KhÃ´ng thá»ƒ xÃ³a CLO nÃ y vÃ¬ nÃ³ Ä‘ang Ä‘Æ°á»£c map trong Session hoáº·c Assessment!');
            return;
        }
        const checkedMap = {};
        document.querySelectorAll('input[type="checkbox"]:checked').forEach(cb => { checkedMap[cb.name] = true; });
        if(typeof btn === 'string') { const el = document.getElementById(btn); if(el) el.remove(); }
        else { btn.closest('tr').remove(); }
        const cloRows = document.querySelectorAll('#cloBody tr');
        const oldToNew = {};
        cloRows.forEach((tr, index) => {
            const num = index + 1;
            const nameInput = tr.querySelector('input[name="clo_name"]');
            const detailsInput = tr.querySelector('input[name="clo_details"]');
            const oldNum = parseInt(nameInput.value.replace('CLO', ''));
            oldToNew[oldNum] = num;
            nameInput.value = 'CLO' + num;
            if(detailsInput.value === 'CLO' + oldNum) detailsInput.value = 'CLO' + num;
            const actionBtn = tr.querySelector('.btn-danger-syl');
            if(actionBtn) actionBtn.setAttribute('onclick', 'removeCLORow(this, ' + num + ')');
            const mapBtn = tr.querySelector('.btn-map-plo');
            if(mapBtn) mapBtn.setAttribute('onclick', 'openPloModal(' + num + ', this)');
            tr.querySelectorAll('input[name^="clo_plo_"]').forEach(inp => { inp.name = 'clo_plo_' + (num - 1); });
        });
        cloCount = cloRows.length;
        const newCheckedMap = {};
        for(let key in checkedMap) {
            const parts = key.split('_');
            if(parts.length >= 4 && (parts[0] === 'ses' || parts[0] === 'asm') && parts[1] === 'clo') {
                const oldNum = parseInt(parts[3]);
                if(oldToNew[oldNum]) { parts[3] = oldToNew[oldNum]; newCheckedMap[parts.join('_')] = true; }
            } else { newCheckedMap[key] = true; }
        }
        document.querySelectorAll('[id^="sesClo_"]').forEach(function (td) {
            const idx = td.id.split('_')[1]; td.innerHTML = buildCLOCheckboxes('ses', idx);
        });
        document.querySelectorAll('[id^="asmClo_"]').forEach(function (td) {
            const idx = td.id.split('_')[1]; td.innerHTML = buildCLOCheckboxes('asm', idx);
        });
        document.querySelectorAll('input[type="checkbox"]').forEach(cb => {
            if(newCheckedMap[cb.name]) cb.checked = true;
        });
        checkValidationStatus();
    }

        function addSessionRow(data = null) {
        const i = sesCount++;
        const row = document.createElement('tr');
        row.id = 'sesRow_' + i;
        row.className = 'session-row';
        let topic = data ? data.topic : '';
        let type = data ? data.type : '';
        let itu = data ? data.itu : '';
        let mat = data ? data.materials : '';
        let down = data ? data.download : '';
        let tasks = data ? data.tasks : '';
        let urls = data ? data.urls : '';
        let clos = data ? data.clos : [];
        row.innerHTML =
            '<td style="text-align:center" class="ses-idx">' + (i + 1) + '</td>' +
            '<td><input type="text" name="ses_topic" class="form-control" value="'+topic+'" required/></td>' +
            '<td><input type="text" name="ses_type" class="form-control" value="'+type+'" placeholder="Lecture, Discussion"/></td>' +
            '<td id="sesClo_' + i + '">' + buildCLOCheckboxes('ses', i, clos) + '</td>' +
            '<td><input type="text" name="ses_itu" class="form-control" value="'+itu+'" placeholder="AI literacy..."/></td>' +
            '<td><input type="text" name="ses_materials" class="form-control" value="'+mat+'"/></td>' +
            '<td><input type="text" name="ses_download" class="form-control" value="'+down+'"/></td>' +
            '<td><input type="text" name="ses_tasks" class="form-control" value="'+tasks+'"/></td>' +
            '<td><input type="text" name="ses_urls" class="form-control" value="'+urls+'"/></td>' +
            '<td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeRow(this, \'ses\')">×</button></td>';
        document.getElementById('sesBody').appendChild(row);
        if(typeof checkValidationStatus === 'function') checkValidationStatus();
    }

    function addAssessmentRow(data = null) {
        const i = asmCount++;
        const row = document.createElement('tr');
        row.id = 'asmRow_' + i;
        row.className = 'assessment-row';
        let cat = data ? data.category : '';
        let type = data ? data.type : '';
        let weight = data ? data.weight : '';
        let criteria = data ? data.criteria : '';
        let duration = data ? data.duration : '';
        let qType = data ? data.qType : '';
        let kSkill = data ? data.knowledgeSkill : '';
        let guide = data ? data.gradingGuide : '';
        let note = data ? data.note : '';
        let clos = data ? data.clos : [];
        row.innerHTML =
            '<td style="text-align:center" class="asm-idx">' + (i + 1) + '</td>' +
            '<td><input type="text" name="asm_category" class="form-control" value="'+cat+'" required placeholder="Quizzes"/></td>' +
            '<td><input type="text" name="asm_type" class="form-control" value="'+type+'" placeholder="Multiple choice"/></td>' +
            '<td><input type="number" step="0.1" name="asm_weight" class="form-control asm-weight" oninput="updateWeightTotal()" value="'+weight+'" required style="width:60px;"/></td>' +
            '<td id="asmClo_' + i + '">' + buildCLOCheckboxes('asm', i, clos) + '</td>' +
            '<td><input type="text" name="asm_criteria" class="form-control" value="'+criteria+'"/></td>' +
            '<td><input type="text" name="asm_duration" class="form-control" value="'+duration+'"/></td>' +
            '<td><input type="text" name="asm_questionType" class="form-control" value="'+qType+'"/></td>' +
            '<td><input type="text" name="asm_knowledgeSkill" class="form-control" value="'+kSkill+'"/></td>' +
            '<td><input type="text" name="asm_gradingGuide" class="form-control" value="'+guide+'"/></td>' +
            '<td><input type="text" name="asm_note" class="form-control" value="'+note+'"/></td>' +
            '<td><button type="button" class="btn-syl btn-danger-syl btn-sm" onclick="removeRow(this, \'asm\')">×</button></td>';
        document.getElementById('asmBody').appendChild(row);
        if(typeof checkValidationStatus === 'function') checkValidationStatus();
    }

function removeRow(btn, type) {
        if(typeof btn === 'string') {
            const el = document.getElementById(btn);
            if(el) el.remove();
        } else {
            btn.closest('tr').remove();
        }
        if (type === 'mat') {
            const rows = document.querySelectorAll('#matBody tr');
            rows.forEach((tr, index) => {
                tr.cells[0].textContent = index + 1;
                const mainCb = tr.querySelector('input[name^="mat_isMain_"]'); if (mainCb) mainCb.name = 'mat_isMain_' + index;
                const hardCb = tr.querySelector('input[name^="mat_isHard_"]'); if (hardCb) hardCb.name = 'mat_isHard_' + index;
                const onlineCb = tr.querySelector('input[name^="mat_isOnline_"]'); if (onlineCb) onlineCb.name = 'mat_isOnline_' + index;
                const actionBtn = tr.querySelector('.btn-danger-syl');
                if(actionBtn) actionBtn.setAttribute('onclick', 'removeRow(this, \'mat\')');
            });
            matCount = rows.length;
        } else if (type === 'ses') {
            const rows = document.querySelectorAll('#sesBody tr');
            rows.forEach((tr, index) => {
                tr.cells[0].textContent = index + 1;
                const tdClo = tr.querySelector('td[id^="sesClo_"]');
                if(tdClo) {
                    tdClo.id = 'sesClo_' + index;
                    tdClo.querySelectorAll('input[type="checkbox"]').forEach(cb => {
                        const parts = cb.name.split('_');
                        if(parts.length >= 4) { parts[2] = index; cb.name = parts.join('_'); }
                    });
                }
                const actionBtn = tr.querySelector('.btn-danger-syl');
                if(actionBtn) actionBtn.setAttribute('onclick', 'removeRow(this, \'ses\')');
            });
            sesCount = rows.length;
        } else if (type === 'asm') {
            const rows = document.querySelectorAll('#asmBody tr');
            rows.forEach((tr, index) => {
                tr.cells[0].textContent = index + 1;
                const tdClo = tr.querySelector('td[id^="asmClo_"]');
                if(tdClo) {
                    tdClo.id = 'asmClo_' + index;
                    tdClo.querySelectorAll('input[type="checkbox"]').forEach(cb => {
                        const parts = cb.name.split('_');
                        if(parts.length >= 4) { parts[2] = index; cb.name = parts.join('_'); }
                    });
                }
                const actionBtn = tr.querySelector('.btn-danger-syl');
                if(actionBtn) actionBtn.setAttribute('onclick', 'removeRow(this, \'asm\')');
            });
            asmCount = rows.length;
        }
        updateWeightTotal();
        checkValidationStatus();
    }

    function buildCLOCheckboxes(prefix, rowIdx) {
        let html = '<div style="display:flex;gap:4px;flex-wrap:wrap;">';
        let found = false;
        document.querySelectorAll('#cloBody tr').forEach((tr) => {
            const num = parseInt(tr.querySelector('input[name="clo_name"]').value.replace('CLO',''));
            html += '<label style="font-size:12px;white-space:nowrap;">' +
                '<input type="checkbox" onchange="checkValidationStatus()" class="' + prefix + '-clo-cb" name="' + prefix + '_clo_' + rowIdx + '_' + num + '" value="' + num + '"/> CLO' + num +
                '</label>';
            found = true;
        });
        if (!found) html += '<span style="color:var(--muted);font-size:12px;">Thêm CLO trước</span>';
        html += '</div>';
        return html;
    }

    function updateCLOCheckboxes() {
        // Find existing checked values
        const checkedMap = {};
        document.querySelectorAll('input[type="checkbox"]:checked').forEach(cb => {
            checkedMap[cb.name] = true;
        });

        // Rebuild CLO checkboxes in all session and assessment rows
        document.querySelectorAll('[id^="sesClo_"]').forEach(function (td) {
            const idx = td.id.split('_')[1];
            td.innerHTML = buildCLOCheckboxes('ses', idx);
        });
        document.querySelectorAll('[id^="asmClo_"]').forEach(function (td) {
            const idx = td.id.split('_')[1];
            td.innerHTML = buildCLOCheckboxes('asm', idx);
        });

        // Restore checked values
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

        // Each session must have at least 1 CLO
        let sessionCloMissing = false;
        document.querySelectorAll('[id^="sesClo_"]').forEach(td => {
            if (td.closest('tr') && td.querySelectorAll('input:checked').length === 0) {
                sessionCloMissing = true;
            }
        });
        if (sessionCloMissing) errors.push('Section 4: Mỗi Session phải gắn với ít nhất 1 CLO.');

        // Total weight must be 100
        let totalWeight = 0;
        document.querySelectorAll('.asm-weight').forEach(input => {
            totalWeight += parseFloat(input.value) || 0;
        });
        if (Math.abs(totalWeight - 100) > 0.01) {
            errors.push('Section 5: Tổng Weight phải đúng 100%.');
        }

        // Each assessment must have at least 1 CLO
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

        // Add 1 default row each initially
        addMaterialRow();
        checkValidationStatus();
    });
</script>

    <!-- PLO Mapping Modal -->
    <div id="ploModal" style="display:none; position:fixed; z-index:1050; left:0; top:0; width:100%; height:100%; overflow:auto; background-color:rgba(0,0,0,0.4);">
        <div style="background-color:#fff; margin:10% auto; padding:20px; border:1px solid #888; width:50%; border-radius:8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
            <h3 id="ploModalTitle" style="margin-top:0; color:#2e7d32;">Map PLO cho CLO</h3>
            <input type="hidden" id="currentCloMappingNum">
            <div id="ploCheckboxContainer" style="margin:20px 0; max-height:300px; overflow-y:auto; border:1px solid #ddd; padding:10px; border-radius:4px;">
                <!-- Checkboxes go here -->
            </div>
            <div style="text-align:right;">
                <button type="button" class="btn-syl btn-outline-syl" onclick="closePloModal()">Hủy</button>
                <button type="button" class="btn-syl" style="background:#F5A623; color:#fff; border:none;" onclick="savePloMapping()">Lưu Mapping</button>
            </div>
        </div>
    </div>
</body>
</html>
