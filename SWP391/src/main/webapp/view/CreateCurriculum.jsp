<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="model.PLO"%>
<%@page import="model.PO"%>
<%@page import="model.Subject"%>
<%@page import="model.TrainingProgram"%>
<%@page import="model.Curriculum"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
    private String h(Object value) {
        if (value == null) {
            return "";
        }
        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<%
    Curriculum curriculum = (Curriculum) request.getAttribute("curriculum");
    List<TrainingProgram> programs = (List<TrainingProgram>) request.getAttribute("programs");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    TrainingProgram selectedProgram = (TrainingProgram) request.getAttribute("selectedProgram");
    Map<Integer, String> prerequisiteTextMap = (Map<Integer, String>) request.getAttribute("prerequisiteTextMap");
    Map<Integer, String> prerequisiteIdsMap = (Map<Integer, String>) request.getAttribute("prerequisiteIdsMap");
    List<PLO> plos = (List<PLO>) request.getAttribute("plos");
    List<PO> pos = (List<PO>) request.getAttribute("pos");
    String error = (String) request.getAttribute("error");
    Object totalCreditsAttr = request.getAttribute("totalCredits");

    int selectedProgramId = 0;
    Object selectedProgramIdAttr = request.getAttribute("selectedProgramId");
    if (selectedProgramIdAttr instanceof Integer) {
        selectedProgramId = (Integer) selectedProgramIdAttr;
    }
    if (curriculum != null && curriculum.getProgramId() > 0) {
        selectedProgramId = curriculum.getProgramId();
    }

    String curriculumName = curriculum != null && curriculum.getCurriculumName() != null ? curriculum.getCurriculumName() : "";
    String description = curriculum != null && curriculum.getDescription() != null ? curriculum.getDescription() : "";
    String totalCredits = totalCreditsAttr != null ? String.valueOf(totalCreditsAttr) : "";
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Create Curriculum</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/CreateCurriculum.css" />
    </head>
    <body>
        <main class="curriculum-page">
            <header class="page-header">
                <a class="back-link" href="<%=request.getContextPath()%>/training-program?action=detail&id=<%= selectedProgramId %>">Back</a>
                <h1>Training Program Management System</h1>
                <p>Create Curriculum</p>
            </header>

            <% if (error != null && !error.isBlank()) { %>
            <div class="alert-error"><%= h(error) %></div>
            <% } %>

            <form id="curriculumForm" method="post" action="<%=request.getContextPath()%>/curriculum-manage" class="curriculum-shell">
                <input type="hidden" name="action" value="create" />
                <section class="info-card">
                    <div class="card-title">
                        <span>Create Curriculum</span>
                    </div>

                    <div class="tab-list" role="tablist" aria-label="Curriculum create sections">
                        <button type="button" class="tab-button active" data-tab="infoPanel">Info</button>
                        <button type="button" class="tab-button" data-tab="ploPanel">PLO</button>
                        <button type="button" class="tab-button" data-tab="poPanel">PO</button>
                    </div>

                    <div class="tab-panel active" id="infoPanel">
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Training Program</label>
                                <% if (selectedProgram != null) { %>
                                <input type="hidden" name="programId" value="<%= selectedProgram.getProgramId() %>" />
                                <input type="text" value="<%= h(selectedProgram.getProgramCode()) %> - <%= h(selectedProgram.getProgramName()) %>" readonly />
                                <% } else { %>
                                <select name="programId" required>
                                    <option value="">Select training program</option>
                                    <% if (programs != null) {
                                        for (TrainingProgram program : programs) {
                                            String selected = program.getProgramId() == selectedProgramId ? "selected" : "";
                                    %>
                                    <option value="<%= program.getProgramId() %>" <%= selected %>><%= h(program.getProgramCode()) %> - <%= h(program.getProgramName()) %></option>
                                    <%  }
                                    } %>
                                </select>
                                <% } %>
                            </div>

                            <div class="form-group">
                                <label>Curriculum Code / Name</label>
                                <input type="text" name="curriculumName" value="<%= h(curriculumName) %>" placeholder="Ví dụ: Bit Se k20" required />
                            </div>

                            <div class="form-group wide">
                                <label>Mục tiêu</label>
                                <textarea name="description" rows="3" placeholder="Nhập mục tiêu của khung chương trình" required><%= h(description) %></textarea>
                            </div>

                            <div class="form-group credit-box">
                                <label>Credit</label>
                                <input id="requiredCredits" type="number" name="totalCredits" min="1" value="<%= h(totalCredits) %>" placeholder="Tổng credit" required />
                            </div>
                        </div>
                    </div>

                    <div class="tab-panel" id="ploPanel">
                        <div class="outcome-toolbar">
                            <div>
                                <h2>PLO</h2>
                                <p>Thêm Program Learning Outcome cho khung chương trình.</p>
                            </div>
                            <button type="button" class="secondary-button" id="addPloButton">Thêm PLO</button>
                        </div>
                        <div class="outcome-list" id="ploRows">
                            <% if (plos != null && !plos.isEmpty()) {
                                for (PLO plo : plos) {
                            %>
                            <div class="outcome-row">
                                <input type="text" name="ploCode" value="<%= h(plo.getPloCode()) %>" placeholder="PLO code" />
                                <textarea name="ploDescription" rows="2" placeholder="PLO description"><%= h(plo.getPloDescription()) %></textarea>
                                <button type="button" class="remove-button remove-outcome">Remove</button>
                            </div>
                            <%  }
                            } else { %>
                            <div class="empty-outcome">Chưa có PLO. Nhấn Thêm PLO nếu cần.</div>
                            <% } %>
                        </div>
                    </div>

                    <div class="tab-panel" id="poPanel">
                        <div class="outcome-toolbar">
                            <div>
                                <h2>PO</h2>
                                <p>Thêm Program Objective cho khung chương trình.</p>
                            </div>
                            <button type="button" class="secondary-button" id="addPoButton">Thêm PO</button>
                        </div>
                        <div class="outcome-list" id="poRows">
                            <% if (pos != null && !pos.isEmpty()) {
                                for (PO po : pos) {
                            %>
                            <div class="outcome-row">
                                <input type="text" name="poCode" value="<%= h(po.getPoCode()) %>" placeholder="PO code" />
                                <textarea name="poDescription" rows="2" placeholder="PO description"><%= h(po.getPoDescription()) %></textarea>
                                <button type="button" class="remove-button remove-outcome">Remove</button>
                            </div>
                            <%  }
                            } else { %>
                            <div class="empty-outcome">Chưa có PO. Nhấn Thêm PO nếu cần.</div>
                            <% } %>
                        </div>
                    </div>
                </section>

                <section class="subject-card">
                    <div class="section-heading">
                        <div>
                            <h2>Danh sách môn học</h2>
                            <p>Thêm môn học theo từng kỳ. Hệ thống sẽ kiểm tra môn điều kiện trước khi thêm.</p>
                        </div>
                        <button type="button" class="secondary-button" id="openSubjectModal">Thêm môn học</button>
                    </div>

                    <div id="hiddenSubjects"></div>
                    <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th>Semester</th>
                                    <th>Course Code</th>
                                    <th>Course name</th>
                                    <th>NoCredit</th>
                                    <th>PreCondition</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="subjectRows">
                                <tr class="empty-row">
                                    <td colspan="6">Chưa có môn học trong khung chương trình.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="credit-summary">
                        <span>Total selected credit:</span>
                        <strong id="selectedCredits">0</strong>
                    </div>
                </section>

                <div class="action-row">
                    <a class="outline-button" href="<%=request.getContextPath()%>/training-program?action=detail&id=<%= selectedProgramId %>">Cancel</a>
                    <button type="button" class="primary-button" id="openCreateConfirm">Create Curriculum</button>
                </div>
            </form>
        </main>

        <div class="modal-backdrop" id="subjectModal" aria-hidden="true">
            <div class="modal">
                <div class="modal-header">
                    <h3>Thêm môn học</h3>
                    <button type="button" class="icon-button" data-close="subjectModal">×</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Kỳ học</label>
                        <input id="semesterInput" type="number" min="1" placeholder="Ví dụ: 1" />
                    </div>
                    <div class="form-group">
                        <label>Tìm tên môn học</label>
                        <input id="subjectSearch" type="text" placeholder="Nhập tên hoặc mã môn học" />
                    </div>
                    <div class="form-group">
                        <label>Chọn môn học</label>
                        <select id="subjectSelect" size="8">
                            <% if (subjects != null) {
                                for (Subject subject : subjects) {
                                    String prerequisiteText = prerequisiteTextMap != null ? prerequisiteTextMap.get(subject.getSubjectId()) : "";
                                    String prerequisiteIds = prerequisiteIdsMap != null ? prerequisiteIdsMap.get(subject.getSubjectId()) : "";
                                    if (prerequisiteText == null || prerequisiteText.isBlank()) {
                                        prerequisiteText = "none";
                                    }
                                    if (prerequisiteIds == null) {
                                        prerequisiteIds = "";
                                    }
                            %>
                            <option value="<%= subject.getSubjectId() %>"
                                    data-code="<%= h(subject.getSubjectCode()) %>"
                                    data-name="<%= h(subject.getSubjectName()) %>"
                                    data-credits="<%= subject.getCredits() %>"
                                    data-prereqs="<%= h(prerequisiteIds) %>"
                                    data-prereqtext="<%= h(prerequisiteText) %>">
                                <%= h(subject.getSubjectCode()) %> - <%= h(subject.getSubjectName()) %> (<%= subject.getCredits() %> credits)
                            </option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="modal-message" id="subjectMessage"></div>
                </div>
                <div class="modal-actions">
                    <button type="button" class="outline-button" data-close="subjectModal">Cancel</button>
                    <button type="button" class="primary-button" id="confirmAddSubject">Xác nhận thêm</button>
                </div>
            </div>
        </div>

        <div class="modal-backdrop" id="confirmModal" aria-hidden="true">
            <div class="modal confirm-modal">
                <div class="modal-header">
                    <h3>Xác nhận tạo curriculum</h3>
                    <button type="button" class="icon-button" data-close="confirmModal">×</button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc muốn tạo khung chương trình này không?</p>
                </div>
                <div class="modal-actions">
                    <button type="button" class="outline-button" data-close="confirmModal">Cancel</button>
                    <button type="button" class="primary-button" id="confirmCreate">Create Curriculum</button>
                </div>
            </div>
        </div>

        <script>
            const selectedSubjects = [];
            const subjectModal = document.getElementById("subjectModal");
            const confirmModal = document.getElementById("confirmModal");
            const subjectSelect = document.getElementById("subjectSelect");
            const subjectSearch = document.getElementById("subjectSearch");
            const semesterInput = document.getElementById("semesterInput");
            const subjectMessage = document.getElementById("subjectMessage");
            const subjectRows = document.getElementById("subjectRows");
            const hiddenSubjects = document.getElementById("hiddenSubjects");
            const selectedCredits = document.getElementById("selectedCredits");
            const requiredCredits = document.getElementById("requiredCredits");
            const curriculumForm = document.getElementById("curriculumForm");
            const ploRows = document.getElementById("ploRows");
            const poRows = document.getElementById("poRows");

            document.querySelectorAll(".tab-button").forEach(function (button) {
                button.addEventListener("click", function () {
                    document.querySelectorAll(".tab-button").forEach(function (item) {
                        item.classList.remove("active");
                    });
                    document.querySelectorAll(".tab-panel").forEach(function (panel) {
                        panel.classList.remove("active");
                    });
                    button.classList.add("active");
                    document.getElementById(button.dataset.tab).classList.add("active");
                });
            });

            document.getElementById("addPloButton").addEventListener("click", function () {
                addOutcomeRow(ploRows, "ploCode", "PLO code", "ploDescription", "PLO description");
            });

            document.getElementById("addPoButton").addEventListener("click", function () {
                addOutcomeRow(poRows, "poCode", "PO code", "poDescription", "PO description");
            });

            function addOutcomeRow(container, codeName, codePlaceholder, descriptionName, descriptionPlaceholder) {
                const empty = container.querySelector(".empty-outcome");
                if (empty) {
                    empty.remove();
                }
                const row = document.createElement("div");
                row.className = "outcome-row";
                row.innerHTML =
                        '<input type="text" name="' + codeName + '" placeholder="' + codePlaceholder + '">' +
                        '<textarea name="' + descriptionName + '" rows="2" placeholder="' + descriptionPlaceholder + '"></textarea>' +
                        '<button type="button" class="remove-button remove-outcome">Remove</button>';
                container.appendChild(row);
                bindOutcomeRemove(row.querySelector(".remove-outcome"));
            }

            function bindOutcomeRemove(button) {
                button.addEventListener("click", function () {
                    const container = button.closest(".outcome-list");
                    button.closest(".outcome-row").remove();
                    if (!container.querySelector(".outcome-row")) {
                        const empty = document.createElement("div");
                        empty.className = "empty-outcome";
                        empty.textContent = container.id === "ploRows"
                                ? "Chưa có PLO. Nhấn Thêm PLO nếu cần."
                                : "Chưa có PO. Nhấn Thêm PO nếu cần.";
                        container.appendChild(empty);
                    }
                });
            }

            document.querySelectorAll(".remove-outcome").forEach(bindOutcomeRemove);

            function openModal(modal) {
                modal.classList.add("show");
                modal.setAttribute("aria-hidden", "false");
            }

            function closeModal(modal) {
                modal.classList.remove("show");
                modal.setAttribute("aria-hidden", "true");
            }

            document.getElementById("openSubjectModal").addEventListener("click", function () {
                subjectMessage.textContent = "";
                semesterInput.value = "";
                subjectSearch.value = "";
                filterSubjects("");
                if (subjectSelect.options.length > 0) {
                    subjectSelect.selectedIndex = 0;
                }
                openModal(subjectModal);
            });

            document.querySelectorAll("[data-close]").forEach(function (button) {
                button.addEventListener("click", function () {
                    closeModal(document.getElementById(button.dataset.close));
                });
            });

            subjectSearch.addEventListener("input", function () {
                filterSubjects(subjectSearch.value);
            });

            function filterSubjects(keyword) {
                const normalized = keyword.trim().toLowerCase();
                Array.from(subjectSelect.options).forEach(function (option) {
                    option.hidden = normalized !== "" && !option.textContent.toLowerCase().includes(normalized);
                });
            }

            document.getElementById("confirmAddSubject").addEventListener("click", function () {
                const semester = Number(semesterInput.value);
                const option = subjectSelect.selectedOptions[0];
                if (!semester || semester <= 0) {
                    subjectMessage.textContent = "Vui lòng nhập kỳ học hợp lệ.";
                    return;
                }
                if (!option || option.hidden) {
                    subjectMessage.textContent = "Vui lòng chọn môn học.";
                    return;
                }

                const subjectId = Number(option.value);
                if (selectedSubjects.some(function (item) { return item.subjectId === subjectId; })) {
                    subjectMessage.textContent = "Môn học này đã được thêm vào curriculum.";
                    return;
                }

                const prerequisiteIds = option.dataset.prereqs
                        ? option.dataset.prereqs.split(",").filter(Boolean).map(Number)
                        : [];
                const missingPrerequisites = prerequisiteIds.filter(function (id) {
                    return !selectedSubjects.some(function (item) {
                        return item.subjectId === id && item.semester < semester;
                    });
                });

                if (missingPrerequisites.length > 0) {
                    subjectMessage.textContent = "Chưa có môn điều kiện của môn học trong các kỳ nhỏ hơn.";
                    return;
                }

                selectedSubjects.push({
                    subjectId: subjectId,
                    semester: semester,
                    code: option.dataset.code,
                    name: option.dataset.name,
                    credits: Number(option.dataset.credits),
                    prerequisiteText: option.dataset.prereqtext || "none"
                });
                selectedSubjects.sort(function (a, b) {
                    return a.semester - b.semester || a.code.localeCompare(b.code);
                });
                renderSubjects();
                closeModal(subjectModal);
            });

            function renderSubjects() {
                subjectRows.innerHTML = "";
                hiddenSubjects.innerHTML = "";
                if (selectedSubjects.length === 0) {
                    subjectRows.innerHTML = '<tr class="empty-row"><td colspan="6">Chưa có môn học trong khung chương trình.</td></tr>';
                }

                let total = 0;
                selectedSubjects.forEach(function (item, index) {
                    total += item.credits;
                    const row = document.createElement("tr");
                    row.innerHTML =
                            "<td>" + item.semester + "</td>" +
                            "<td>" + escapeHtml(item.code) + "</td>" +
                            "<td>" + escapeHtml(item.name) + "</td>" +
                            "<td>" + item.credits + "</td>" +
                            "<td>" + escapeHtml(item.prerequisiteText || "none") + "</td>" +
                            '<td><button type="button" class="remove-button" data-index="' + index + '">Remove</button></td>';
                    subjectRows.appendChild(row);

                    hiddenSubjects.insertAdjacentHTML("beforeend",
                            '<input type="hidden" name="subjectIds" value="' + item.subjectId + '">' +
                            '<input type="hidden" name="semesterNos" value="' + item.semester + '">');
                });
                selectedCredits.textContent = total;

                document.querySelectorAll(".remove-button").forEach(function (button) {
                    button.addEventListener("click", function () {
                        selectedSubjects.splice(Number(button.dataset.index), 1);
                        renderSubjects();
                    });
                });
            }

            document.getElementById("openCreateConfirm").addEventListener("click", function () {
                if (!curriculumForm.reportValidity()) {
                    return;
                }
                const required = Number(requiredCredits.value);
                const actual = selectedSubjects.reduce(function (sum, item) {
                    return sum + item.credits;
                }, 0);
                if (selectedSubjects.length === 0) {
                    alert("Vui lòng thêm ít nhất một môn học.");
                    return;
                }
                if (actual < required) {
                    alert("Không đủ tín chỉ. Tổng credit môn học hiện tại là " + actual + ", nhỏ hơn tổng credit đã nhập là " + required + ".");
                    return;
                }
                openModal(confirmModal);
            });

            document.getElementById("confirmCreate").addEventListener("click", function () {
                curriculumForm.submit();
            });

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
