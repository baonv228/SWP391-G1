<%@page import="java.util.List"%>
<%@page import="model.Combo"%>
<%@page import="model.Subject"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    dto.CurriculumDTO curriculum = (dto.CurriculumDTO) request.getAttribute("curriculum");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    Combo combo = (Combo) request.getAttribute("combo");
    String error = (String) request.getAttribute("error");
    if (combo == null) {
        combo = new Combo();
        combo.setStatus("Active");
    }
    String displayOrderValue = combo.getDisplayOrder() == null ? "" : String.valueOf(combo.getDisplayOrder());
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Create Combo</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/createCombo.css" />
    </head>
    <body>
        <main class="combo-create-page">
            <header class="combo-create-header">
                <a class="back-link" href="<%=request.getContextPath()%>/combo?action=list&curriculumId=<%= curriculum.getCurriculumId() %>">Back to Combo List</a>
                <h1>Create Combo</h1>
                <p><%= curriculum.getProgramCode() %> - <%= curriculum.getCurriculumName() %></p>
            </header>

            <% if (error != null && !error.isBlank()) { %>
            <div class="alert-error"><%= error %></div>
            <% } %>

            <form id="createComboForm" class="combo-create-shell" method="post" action="<%=request.getContextPath()%>/combo">
                <input type="hidden" name="action" value="create" />
                <input type="hidden" name="curriculumId" value="<%= curriculum.getCurriculumId() %>" />

                <section class="combo-card">
                    <div class="card-title">Combo Information</div>
                    <div class="form-grid">
                        <label>
                            <span>Combo Name</span>
                            <input name="comboName" value="<%= combo.getComboName() != null ? combo.getComboName() : "" %>" placeholder="VD: AI Combo" required />
                        </label>

                        <label>
                            <span>Status</span>
                            <select name="status" required>
                                <option value="Active" <%= combo.getStatus() == null || "Active".equalsIgnoreCase(combo.getStatus()) ? "selected" : "" %>>Active</option>
                                <option value="Inactive" <%= "Inactive".equalsIgnoreCase(combo.getStatus()) ? "selected" : "" %>>Inactive</option>
                            </select>
                        </label>

                        <label class="span-2">
                            <span>Description</span>
                            <textarea name="description" rows="4" placeholder="Nhập mô tả combo" required><%= combo.getDescription() != null ? combo.getDescription() : "" %></textarea>
                        </label>
                    </div>
                </section>

                <section class="combo-card">
                    <div class="section-heading">
                        <div>
                            <h2>Subjects in Combo</h2>
                            <p>Chọn một hoặc nhiều môn học để thêm vào combo.</p>
                        </div>
                    </div>

                    <div class="subject-picker">
                        <input id="subjectSearch" list="subjectOptions" placeholder="Tìm theo mã hoặc tên môn học" autocomplete="off" />
                        <input id="semesterInput" type="number" min="1" placeholder="Semester (optional)" />
                        <button type="button" class="secondary-button" id="addSubjectButton">Add Subject</button>
                    </div>

                    <datalist id="subjectOptions">
                        <% if (subjects != null) {
                            for (Subject subject : subjects) {
                                String code = subject.getSubjectCode() != null ? subject.getSubjectCode() : "";
                                String name = subject.getSubjectName() != null ? subject.getSubjectName() : "";
                                String label = code + " - " + name;
                        %>
                        <option value="<%= label %>" data-id="<%= subject.getSubjectId() %>" data-code="<%= code %>" data-name="<%= name %>" data-credits="<%= subject.getCredits() %>"></option>
                        <%  }
                        } %>
                    </datalist>

                    <div id="hiddenSubjects"></div>
                    <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th>No.</th>
                                    <th>Subject Code</th>
                                    <th>Subject Name</th>
                                    <th>Credits</th>
                                    <th>Semester</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="subjectRows">
                                <tr class="empty-row">
                                    <td colspan="6">Chưa có môn học trong combo.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </section>

                <div class="form-actions">
                    <button type="button" class="primary-button" id="openConfirmModal">Create Combo</button>
                    <a class="outline-button" href="<%=request.getContextPath()%>/combo?action=list&curriculumId=<%= curriculum.getCurriculumId() %>">Cancel</a>
                </div>
            </form>
        </main>

        <div class="modal-backdrop" id="confirmModal" aria-hidden="true">
            <div class="modal">
                <div class="modal-header">
                    <h3>Xác nhận tạo combo</h3>
                    <button type="button" class="icon-button" id="closeConfirmModal">×</button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc muốn tạo combo này không?</p>
                </div>
                <div class="modal-actions">
                    <button type="button" class="outline-button" id="cancelConfirmModal">Cancel</button>
                    <button type="button" class="primary-button" id="confirmCreateButton">Create Combo</button>
                </div>
            </div>
        </div>

        <script>
            const selectedSubjects = [];
            const selectedSubjectIds = new Set();
            const subjectRows = document.getElementById("subjectRows");
            const hiddenSubjects = document.getElementById("hiddenSubjects");
            const subjectSearch = document.getElementById("subjectSearch");
            const semesterInput = document.getElementById("semesterInput");
            const form = document.getElementById("createComboForm");
            const confirmModal = document.getElementById("confirmModal");

            function getSubjectOptions() {
                return Array.from(document.querySelectorAll("#subjectOptions option")).map(function (option) {
                    return {
                        id: option.dataset.id,
                        code: option.dataset.code,
                        name: option.dataset.name,
                        credits: Number(option.dataset.credits || 0),
                        label: option.value
                    };
                });
            }

            function addSubject() {
                const keyword = subjectSearch.value.trim().toLowerCase();
                if (!keyword) {
                    alert("Vui lòng nhập mã hoặc tên môn học.");
                    return;
                }

                const options = getSubjectOptions();
                const matched = options.find(function (item) {
                    return item.label.toLowerCase() === keyword;
                }) || options.find(function (item) {
                    return item.label.toLowerCase().includes(keyword);
                });

                if (!matched) {
                    alert("Không tìm thấy môn học phù hợp.");
                    return;
                }
                if (selectedSubjectIds.has(matched.id)) {
                    alert("Môn học này đã được thêm vào combo.");
                    subjectSearch.value = "";
                    return;
                }

                selectedSubjectIds.add(matched.id);
                selectedSubjects.push({
                    id: matched.id,
                    code: matched.code,
                    name: matched.name,
                    credits: matched.credits,
                    semester: semesterInput.value.trim()
                });
                subjectSearch.value = "";
                semesterInput.value = "";
                renderSubjects();
            }

            function removeSubject(index) {
                const removed = selectedSubjects.splice(index, 1)[0];
                if (removed) {
                    selectedSubjectIds.delete(removed.id);
                }
                renderSubjects();
            }

            function renderSubjects() {
                subjectRows.innerHTML = "";
                hiddenSubjects.innerHTML = "";
                if (selectedSubjects.length === 0) {
                    subjectRows.innerHTML = '<tr class="empty-row"><td colspan="6">Chưa có môn học trong combo.</td></tr>';
                    return;
                }

                selectedSubjects.forEach(function (item, index) {
                    const row = document.createElement("tr");
                    row.innerHTML =
                        "<td>" + (index + 1) + "</td>" +
                        "<td>" + escapeHtml(item.code) + "</td>" +
                        "<td>" + escapeHtml(item.name) + "</td>" +
                        "<td>" + item.credits + "</td>" +
                        "<td>" + (item.semester ? escapeHtml(item.semester) : "N/A") + "</td>" +
                        '<td><button type="button" class="remove-button" onclick="removeSubject(' + index + ')">Remove</button></td>';
                    subjectRows.appendChild(row);
                    hiddenSubjects.insertAdjacentHTML("beforeend",
                        '<input type="hidden" name="subjectIds" value="' + item.id + '">' +
                        '<input type="hidden" name="semesterNos" value="' + escapeHtml(item.semester || "") + '">');
                });
            }

            document.getElementById("addSubjectButton").addEventListener("click", addSubject);
            document.getElementById("openConfirmModal").addEventListener("click", function () {
                renderSubjects();
                if (!form.reportValidity()) {
                    return;
                }
                if (selectedSubjects.length === 0) {
                    alert("Vui lòng thêm ít nhất một môn học cho combo.");
                    return;
                }
                confirmModal.classList.add("show");
                confirmModal.setAttribute("aria-hidden", "false");
            });

            document.getElementById("closeConfirmModal").addEventListener("click", closeModal);
            document.getElementById("cancelConfirmModal").addEventListener("click", closeModal);
            document.getElementById("confirmCreateButton").addEventListener("click", function () {
                renderSubjects();
                form.submit();
            });

            function closeModal() {
                confirmModal.classList.remove("show");
                confirmModal.setAttribute("aria-hidden", "true");
            }

            function escapeHtml(value) {
                return String(value || "")
                    .replaceAll("&", "&amp;")
                    .replaceAll("<", "&lt;")
                    .replaceAll(">", "&gt;")
                    .replaceAll('"', "&quot;")
                    .replaceAll("'", "&#39;");
            }
        </script>
    </body>
</html>
