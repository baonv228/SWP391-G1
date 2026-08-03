<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="model.CurriculumSubjectPLO"%>
<%@page import="model.CurriculumSubject"%>
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

    private String js(Object value) {
        if (value == null) {
            return "";
        }
        return String.valueOf(value)
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("</", "<\\/");
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
    List<CurriculumSubject> curriculumSubjects = (List<CurriculumSubject>) request.getAttribute("curriculumSubjects");
    List<CurriculumSubjectPLO> subjectPLOs = (List<CurriculumSubjectPLO>) request.getAttribute("subjectPLOs");
    String error = (String) request.getAttribute("error");
    Object totalCreditsAttr = request.getAttribute("totalCredits");
    Map<Integer, Subject> subjectById = new HashMap<>();
    if (subjects != null) {
        for (Subject subject : subjects) {
            subjectById.put(subject.getSubjectId(), subject);
        }
    }

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
    <%@ include file="header.jsp" %>
        <main class="curriculum-page">
            <header class="page-header">
                <a class="back-link" href="<%=request.getContextPath()%>/training-program?action=detail&id=<%= selectedProgramId %>">Back</a>
                <h1>Create Curriculum</h1>

            </header>

            <% if (error != null && !error.isBlank()) { %>
            <div class="alert-error"><%= h(error) %></div>
            <% } %>

            <form id="curriculumForm" method="post" action="<%=request.getContextPath()%>/curriculum-manage" class="curriculum-shell">
                <input type="hidden" name="action" value="create" />
                <section class="info-card">
                    <div class="card-title">
                        <span>Curriculum Information</span>
                    </div>

                    <div class="tab-list" role="tablist" aria-label="Curriculum create sections">
                        <button type="button" class="tab-button active" data-tab="infoPanel">Info</button>
                        <button type="button" class="tab-button" data-tab="ploPanel">PLO</button>
                        <button type="button" class="tab-button" data-tab="poPanel">PO</button>
                    </div>

                    <div class="tab-panel active" id="infoPanel">
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Department</label>
                                <% if (selectedProgram != null) { %>
                                <input type="hidden" name="programId" value="<%= selectedProgram.getProgramId() %>" />
                                <input type="text" value="<%= h(selectedProgram.getProgramCode()) %> - <%= h(selectedProgram.getProgramName()) %>" readonly />
                                <% } else { %>
                                <select name="programId" required>
                                    <option value="">Select department</option>
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
                                <input type="text" name="curriculumName" value="<%= h(curriculumName) %>" placeholder="Example: BIT SE K20" required />
                            </div>

                            <div class="form-group wide">
                                <label>Purpose</label>
                                <textarea name="description" rows="3" placeholder="Enter curriculum purpose" required><%= h(description) %></textarea>
                            </div>

                            <div class="form-group credit-box">
                                <label>Credit</label>
                                <input id="requiredCredits" type="number" name="totalCredits" min="1" value="<%= h(totalCredits) %>" placeholder="Total credits" required />
                            </div>
                        </div>
                    </div>

                    <div class="tab-panel" id="ploPanel">
                        <div class="outcome-toolbar">
                            <div>
                                <h2>PLO</h2>
                                <p>Add Program Learning Outcome for this curriculum.</p>
                            </div>
                            <button type="button" class="secondary-button" id="addPloButton">Add PLO</button>
                        </div>
                        <div class="outcome-list" id="ploRows">
                            <% if (plos != null && !plos.isEmpty()) {
                                int ploIndex = 0;
                                for (PLO plo : plos) {
                                    String ploKey = plo.getClientKey() != null && !plo.getClientKey().isBlank()
                                            ? plo.getClientKey()
                                            : "plo_" + ploIndex++;
                            %>
                            <div class="outcome-row">
                                <input type="hidden" name="ploKeys" value="<%= h(ploKey) %>" />
                                <input type="text" name="ploCode" value="<%= h(plo.getPloCode()) %>" placeholder="PLO code" />
                                <textarea name="ploDescription" rows="2" placeholder="PLO description"><%= h(plo.getPloDescription()) %></textarea>
                                <button type="button" class="remove-button remove-outcome">Remove</button>
                            </div>
                            <%  }
                            } else { %>
                            <div class="empty-outcome">No PLO yet. Click Add PLO if needed.</div>
                            <% } %>
                        </div>
                    </div>

                    <div class="tab-panel" id="poPanel">
                        <div class="outcome-toolbar">
                            <div>
                                <h2>PO</h2>
                                <p>Add Program Objective for this curriculum.</p>
                            </div>
                            <button type="button" class="secondary-button" id="addPoButton">Add PO</button>
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
                            <div class="empty-outcome">No PO yet. Click Add PO if needed.</div>
                            <% } %>
                        </div>
                    </div>
                </section>

                <section class="subject-card">
                    <div class="section-heading">
                        <div>
                            <h2>Course List</h2>
                            <p>Add courses by semester. The system checks prerequisites before adding a course.</p>
                        </div>
                        <button type="button" class="secondary-button" id="openSubjectModal">Add course</button>
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
                                    <th>Action / PLO</th>
                                </tr>
                            </thead>
                            <tbody id="subjectRows">
                                <tr class="empty-row">
                                    <td colspan="6">No course has been added to this curriculum.</td>
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
    <%@ include file="footer.jsp" %>

        <div class="modal-backdrop" id="subjectModal" aria-hidden="true">
            <div class="modal">
                <div class="modal-header">
                    <h3>Add course</h3>
                    <button type="button" class="icon-button" data-close="subjectModal">x</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Semester</label>
                        <input id="semesterInput" type="number" min="1" placeholder="Example: 1" />
                    </div>
                    <div class="form-group">
                        <label>Search course</label>
                        <input id="subjectSearch" type="text" placeholder="Enter course name or code" />
                    </div>
                    <div class="form-group">
                        <label>Select course</label>
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
                                    data-status="<%= h(subject.getStatus()) %>"
                                    data-prereqs="<%= h(prerequisiteIds) %>"
                                    data-prereqtext="<%= h(prerequisiteText) %>">
                                <%= h(subject.getSubjectCode()) %> - <%= h(subject.getSubjectName()) %> (<%= subject.getCredits() %> credits)
                            </option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <aside class="prerequisite-preview">
                        <div class="preview-title">Prerequisite</div>
                        <div id="subjectPrereqPreview">Select a course to view prerequisites.</div>
                    </aside>
                    <div class="modal-message" id="subjectMessage"></div>
                </div>
                <div class="modal-actions">
                    <button type="button" class="outline-button" data-close="subjectModal">Cancel</button>
                    <button type="button" class="primary-button" id="confirmAddSubject">Confirm add</button>
                </div>
            </div>
        </div>

        <div class="modal-backdrop" id="confirmModal" aria-hidden="true">
            <div class="modal confirm-modal">
                <div class="modal-header">
                    <h3>Confirm create curriculum</h3>
                    <button type="button" class="icon-button" data-close="confirmModal">x</button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to create this curriculum?</p>
                </div>
                <div class="modal-actions">
                    <button type="button" class="outline-button" data-close="confirmModal">Cancel</button>
                    <button type="button" class="primary-button" id="confirmCreate">Create Curriculum</button>
                </div>
            </div>
        </div>

        <div class="modal-backdrop" id="subjectPloModal" aria-hidden="true">
            <div class="modal confirm-modal">
                <div class="modal-header">
                    <h3>Add PLO for course</h3>
                    <button type="button" class="icon-button" data-close="subjectPloModal">x</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Select PLO from the PLO tab</label>
                        <div id="subjectPloChecklist" class="plo-checklist"></div>
                        <div class="field-hint">Tick one or more PLOs to link with this course.</div>
                    </div>
                    <div class="form-group">
                        <label>Contribution level</label>
                        <select id="subjectPloContribution">
                            <option value="">None</option>
                            <option value="I">I - Introduce</option>
                            <option value="R">R - Reinforce</option>
                            <option value="M">M - Master</option>
                        </select>
                    </div>
                    <div class="modal-message" id="subjectPloMessage"></div>
                </div>
                <div class="modal-actions">
                    <button type="button" class="outline-button" data-close="subjectPloModal">Cancel</button>
                    <button type="button" class="primary-button" id="confirmAddSubjectPlo">Add PLO</button>
                </div>
            </div>
        </div>

        <script>
            const selectedSubjects = [];
            let subjectKeyCounter = 0;
            let ploKeyCounter = document.querySelectorAll("#ploRows .outcome-row").length;
            const subjectModal = document.getElementById("subjectModal");
            const confirmModal = document.getElementById("confirmModal");
            const subjectPloModal = document.getElementById("subjectPloModal");
            const subjectSelect = document.getElementById("subjectSelect");
            const subjectSearch = document.getElementById("subjectSearch");
            const semesterInput = document.getElementById("semesterInput");
            const subjectMessage = document.getElementById("subjectMessage");
            const subjectPrereqPreview = document.getElementById("subjectPrereqPreview");
            const subjectPloChecklist = document.getElementById("subjectPloChecklist");
            const subjectPloContribution = document.getElementById("subjectPloContribution");
            const subjectPloMessage = document.getElementById("subjectPloMessage");
            const subjectRows = document.getElementById("subjectRows");
            const hiddenSubjects = document.getElementById("hiddenSubjects");
            const selectedCredits = document.getElementById("selectedCredits");
            const requiredCredits = document.getElementById("requiredCredits");
            const curriculumForm = document.getElementById("curriculumForm");
            const ploRows = document.getElementById("ploRows");
            const poRows = document.getElementById("poRows");
            let activeSubjectKeyForPlo = null;

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
                const keyInput = codeName === "ploCode"
                        ? '<input type="hidden" name="ploKeys" value="plo_' + (ploKeyCounter++) + '">'
                        : "";
                row.innerHTML =
                        keyInput +
                        '<input type="text" name="' + codeName + '" placeholder="' + codePlaceholder + '">' +
                        '<textarea name="' + descriptionName + '" rows="2" placeholder="' + descriptionPlaceholder + '"></textarea>' +
                        '<button type="button" class="remove-button remove-outcome">Remove</button>';
                container.appendChild(row);
                bindOutcomeRemove(row.querySelector(".remove-outcome"));
            }

            function bindOutcomeRemove(button) {
                button.addEventListener("click", function () {
                    const container = button.closest(".outcome-list");
                    const row = button.closest(".outcome-row");
                    const ploKeyInput = row.querySelector('input[name="ploKeys"]');
                    if (ploKeyInput) {
                        removePloFromAllSubjects(ploKeyInput.value);
                    }
                    row.remove();
                    if (!container.querySelector(".outcome-row")) {
                        const empty = document.createElement("div");
                        empty.className = "empty-outcome";
                        empty.textContent = container.id === "ploRows"
                                ? "No PLO yet. Click Add PLO if needed."
                                : "No PO yet. Click Add PO if needed.";
                        container.appendChild(empty);
                    }
                });
            }

            document.querySelectorAll(".remove-outcome").forEach(bindOutcomeRemove);

            function removePloFromAllSubjects(ploKey) {
                selectedSubjects.forEach(function (item) {
                    item.plos = item.plos.filter(function (mapping) {
                        return mapping.ploKey !== ploKey;
                    });
                });
                renderSubjects();
            }

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
                updateSubjectPrerequisitePreview();
                openModal(subjectModal);
            });

            document.querySelectorAll("[data-close]").forEach(function (button) {
                button.addEventListener("click", function () {
                    closeModal(document.getElementById(button.dataset.close));
                });
            });

            subjectSearch.addEventListener("input", function () {
                filterSubjects(subjectSearch.value);
                updateSubjectPrerequisitePreview();
            });

            subjectSelect.addEventListener("change", updateSubjectPrerequisitePreview);

            function filterSubjects(keyword) {
                const normalized = keyword.trim().toLowerCase();
                Array.from(subjectSelect.options).forEach(function (option) {
                    option.hidden = normalized !== "" && !option.textContent.toLowerCase().includes(normalized);
                });
            }

            function updateSubjectPrerequisitePreview() {
                const option = subjectSelect.selectedOptions[0];
                if (!option || option.hidden) {
                    subjectPrereqPreview.textContent = "Select a course to view prerequisites.";
                    return;
                }
                subjectPrereqPreview.textContent = option.dataset.prereqtext || "none";
            }

            document.getElementById("confirmAddSubject").addEventListener("click", function () {
                const semester = Number(semesterInput.value);
                const option = subjectSelect.selectedOptions[0];
                if (!semester || semester <= 0) {
                    subjectMessage.textContent = "Please enter a valid semester.";
                    return;
                }
                if (!option || option.hidden) {
                    subjectMessage.textContent = "Please select a course.";
                    return;
                }

                const subjectId = Number(option.value);
                if (selectedSubjects.some(function (item) { return item.subjectId === subjectId; })) {
                    subjectMessage.textContent = "This course has already been added to the curriculum.";
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
                    subjectMessage.textContent = "Prerequisite courses must be added in earlier semesters first.";
                    return;
                }

                selectedSubjects.push({
                    key: "subject_" + (subjectKeyCounter++),
                    subjectId: subjectId,
                    semester: semester,
                    code: option.dataset.code,
                    name: option.dataset.name,
                    credits: Number(option.dataset.credits),
                    status: option.dataset.status || "",
                    prerequisiteText: option.dataset.prereqtext || "none",
                    plos: []
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
                    subjectRows.innerHTML = '<tr class="empty-row"><td colspan="6">No course has been added to this curriculum.</td></tr>';
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
                            '<td>' +
                            '<div class="subject-action-cell">' +
                            '<button type="button" class="remove-button subject-remove-button" data-index="' + index + '">Remove</button>' +
                            '<button type="button" class="secondary-button subject-plo-button" data-key="' + item.key + '">Add PLO</button>' +
                            '<div class="subject-plo-tags">' + renderPloTags(item.plos) + '</div>' +
                            '</div>' +
                            '</td>';
                    subjectRows.appendChild(row);

                    hiddenSubjects.insertAdjacentHTML("beforeend",
                            '<input type="hidden" name="subjectKeys" value="' + item.key + '">' +
                            '<input type="hidden" name="subjectIds" value="' + item.subjectId + '">' +
                            '<input type="hidden" name="semesterNos" value="' + item.semester + '">');
                    item.plos.forEach(function (mapping) {
                        hiddenSubjects.insertAdjacentHTML("beforeend",
                                '<input type="hidden" name="subjectPloSubjectKey" value="' + item.key + '">' +
                                '<input type="hidden" name="subjectPloPloKey" value="' + mapping.ploKey + '">' +
                                '<input type="hidden" name="subjectPloContributionLevel" value="' + escapeHtml(mapping.level || "") + '">');
                    });
                });
                selectedCredits.textContent = total;

                document.querySelectorAll(".subject-remove-button").forEach(function (button) {
                    button.addEventListener("click", function () {
                        selectedSubjects.splice(Number(button.dataset.index), 1);
                        renderSubjects();
                    });
                });
                document.querySelectorAll(".subject-plo-button").forEach(function (button) {
                    button.addEventListener("click", function () {
                        openSubjectPloModal(button.dataset.key);
                    });
                });
            }

            function renderPloTags(plos) {
                if (!plos || plos.length === 0) {
                    return '<span class="empty-plo-tag">No PLO added</span>';
                }
                return plos.map(function (mapping) {
                    const label = getPloLabel(mapping.ploKey);
                    const level = mapping.level ? " (" + mapping.level + ")" : "";
                    return '<span class="plo-tag">' + escapeHtml(label + level) + '</span>';
                }).join("");
            }

            function getCurrentPLOOptions() {
                return Array.from(ploRows.querySelectorAll(".outcome-row")).map(function (row) {
                    const keyInput = row.querySelector('input[name="ploKeys"]');
                    const codeInput = row.querySelector('input[name="ploCode"]');
                    const descriptionInput = row.querySelector('textarea[name="ploDescription"]');
                    return {
                        key: keyInput ? keyInput.value : "",
                        code: codeInput ? codeInput.value.trim() : "",
                        description: descriptionInput ? descriptionInput.value.trim() : ""
                    };
                }).filter(function (item) {
                    return item.key && item.code;
                });
            }

            function getPloLabel(ploKey) {
                const option = getCurrentPLOOptions().find(function (item) {
                    return item.key === ploKey;
                });
                return option ? option.code : ploKey;
            }

            function openSubjectPloModal(subjectKey) {
                activeSubjectKeyForPlo = subjectKey;
                subjectPloMessage.textContent = "";
                subjectPloContribution.value = "";
                subjectPloChecklist.innerHTML = "";
                const subject = selectedSubjects.find(function (item) {
                    return item.key === subjectKey;
                });
                const existingKeys = subject ? subject.plos.map(function (item) { return item.ploKey; }) : [];
                const options = getCurrentPLOOptions().filter(function (item) {
                    return !existingKeys.includes(item.key);
                });
                if (options.length === 0) {
                    subjectPloChecklist.innerHTML = '<div class="empty-outcome">No available PLO. Add PLO in the PLO tab first.</div>';
                } else {
                    options.forEach(function (item) {
                        const label = document.createElement("label");
                        label.className = "plo-check-item";
                        label.innerHTML =
                                '<input type="checkbox" value="' + escapeHtml(item.key) + '">' +
                                '<span><strong>' + escapeHtml(item.code) + '</strong>' +
                                (item.description ? '<small>' + escapeHtml(item.description) + '</small>' : '') +
                                '</span>';
                        subjectPloChecklist.appendChild(label);
                    });
                }
                openModal(subjectPloModal);
            }

            document.getElementById("confirmAddSubjectPlo").addEventListener("click", function () {
                const selectedPloInputs = Array.from(subjectPloChecklist.querySelectorAll('input[type="checkbox"]:checked'))
                        .filter(function (input) {
                            return input.value;
                        });
                if (!activeSubjectKeyForPlo || selectedPloInputs.length === 0) {
                    subjectPloMessage.textContent = "Please select PLO.";
                    return;
                }
                const subject = selectedSubjects.find(function (item) {
                    return item.key === activeSubjectKeyForPlo;
                });
                if (!subject) {
                    subjectPloMessage.textContent = "Invalid course.";
                    return;
                }
                selectedPloInputs.forEach(function (input) {
                    subject.plos.push({
                        ploKey: input.value,
                        level: subjectPloContribution.value
                    });
                });
                renderSubjects();
                closeModal(subjectPloModal);
            });

            document.getElementById("openCreateConfirm").addEventListener("click", function () {
                renderSubjects();
                if (!curriculumForm.reportValidity()) {
                    return;
                }
                const required = Number(requiredCredits.value);
                const actual = selectedSubjects.reduce(function (sum, item) {
                    return sum + item.credits;
                }, 0);
                if (selectedSubjects.length === 0) {
                    alert("Please add at least one course.");
                    return;
                }
                if (actual < required) {
                    alert("Not enough credits. Current selected credits: " + actual + ", required credits: " + required + ".");
                    return;
                }
                openModal(confirmModal);
            });

            document.getElementById("confirmCreate").addEventListener("click", function () {
                renderSubjects();
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

            <% if (curriculumSubjects != null && !curriculumSubjects.isEmpty()) {
                for (CurriculumSubject curriculumSubject : curriculumSubjects) {
                    Subject restoredSubject = subjectById.get(curriculumSubject.getSubjectId());
                    if (restoredSubject == null) {
                        continue;
                    }
                    String subjectKey = curriculumSubject.getClientKey() != null && !curriculumSubject.getClientKey().isBlank()
                            ? curriculumSubject.getClientKey()
                            : "subject_restore_" + curriculumSubject.getSubjectId();
                    String prerequisiteText = prerequisiteTextMap != null ? prerequisiteTextMap.get(restoredSubject.getSubjectId()) : "";
                    if (prerequisiteText == null || prerequisiteText.isBlank()) {
                        prerequisiteText = "none";
                    }
            %>
            selectedSubjects.push({
                key: "<%= js(subjectKey) %>",
                subjectId: <%= restoredSubject.getSubjectId() %>,
                semester: <%= curriculumSubject.getSemesterNo() != null ? curriculumSubject.getSemesterNo() : 0 %>,
                code: "<%= js(restoredSubject.getSubjectCode()) %>",
                name: "<%= js(restoredSubject.getSubjectName()) %>",
                credits: <%= restoredSubject.getCredits() %>,
                status: "<%= js(restoredSubject.getStatus()) %>",
                prerequisiteText: "<%= js(prerequisiteText) %>",
                plos: [
                    <% boolean firstMapping = true;
                    if (subjectPLOs != null) {
                        for (CurriculumSubjectPLO mapping : subjectPLOs) {
                            if (!subjectKey.equals(mapping.getCurriculumSubjectClientKey())) {
                                continue;
                            }
                            if (!firstMapping) { %>,<% }
                            firstMapping = false;
                    %>
                    {
                        ploKey: "<%= js(mapping.getPloClientKey()) %>",
                        level: "<%= js(mapping.getContributionLevel()) %>"
                    }
                    <%  }
                    } %>
                ]
            });
            <%  }
            } %>
            if (selectedSubjects.length > 0) {
                subjectKeyCounter = selectedSubjects.reduce(function (max, item) {
                    const match = String(item.key || "").match(/^subject_(\d+)$/);
                    return match ? Math.max(max, Number(match[1]) + 1) : max;
                }, selectedSubjects.length);
                renderSubjects();
            }
        </script>
    </body>
</html>


