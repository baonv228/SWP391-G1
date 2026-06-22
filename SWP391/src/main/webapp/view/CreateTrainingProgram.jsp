<%@page import="java.util.List"%>
<%@page import="model.PLO"%>
<%@page import="model.PO"%>
<%@page import="model.TrainingProgram"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    TrainingProgram program = (TrainingProgram) request.getAttribute("program");
    List<PLO> plos = (List<PLO>) request.getAttribute("plos");
    List<PO> pos = (List<PO>) request.getAttribute("pos");

    if (program == null) {
        program = new TrainingProgram();
        program.setStatus("Active");
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Create Training Program</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/CreateTrainingProgram.css" />
    </head>
    <body>
        <main class="create-page">
            <header class="page-header">
                <a class="back-link" href="<%=request.getContextPath()%>/training-program?action=list">← Back to list</a>
                <h1>Training Program Management System</h1>
            </header>

            <section class="create-shell">
                <div class="section-title">
                    <span>Training Program</span>
                    <strong>Create Training Program</strong>
                </div>

                <% if (error != null) { %>
                <div class="error"><%= error %></div>
                <% } %>

                <form id="createTrainingProgramForm" method="post" action="<%=request.getContextPath()%>/training-program" onsubmit="return validateCreateForm();">
                    <input type="hidden" name="action" value="create" />

                    <div class="tabs" role="tablist">
                        <button class="tab active" type="button" data-tab="main">Thông tin chính</button>
                        <button class="tab" type="button" data-tab="plo">PLO</button>
                        <button class="tab" type="button" data-tab="po">PO</button>
                    </div>

                    <section id="tab-main" class="tab-panel active">
                        <div class="form-grid">
                            <label>
                                <span>Tên ngành</span>
                                <input name="majorName" value="<%= program.getMajorName() != null ? program.getMajorName() : "" %>" placeholder="Kỹ thuật phần mềm" required />
                            </label>
                            <label>
                                <span>Mã ngành</span>
                                <input name="programCode" value="<%= program.getProgramCode() != null ? program.getProgramCode() : "" %>" placeholder="SE" maxlength="50" required />
                            </label>
                            <label>
                                <span>Tên chương trình</span>
                                <input name="programName" value="<%= program.getProgramName() != null ? program.getProgramName() : "" %>" placeholder="Software Engineering" required />
                            </label>
                            <label>
                                <span>Năm học</span>
                                <input name="academicYear" value="<%= program.getAcademicYear() != null ? program.getAcademicYear() : "" %>" placeholder="2026" required />
                            </label>
                            <label class="span-2">
                                <span>Mục đích</span>
                                <textarea name="description" rows="5" placeholder="Mô tả mục đích của chương trình đào tạo" required><%= program.getDescription() != null ? program.getDescription() : "" %></textarea>
                            </label>
                        </div>
                    </section>

                    <section id="tab-plo" class="tab-panel">
                        <div class="tab-heading">
                            <div>
                                <h2>PLO</h2>
                                <p>Thêm Program Learning Outcomes. Không được để trống mã hoặc mô tả.</p>
                            </div>
                            <button class="add-row" type="button" onclick="addOutcomeRow('plo')">+ Add PLO</button>
                        </div>
                        <div id="ploRows" class="outcome-list">
                            <% if (plos != null && !plos.isEmpty()) {
                                for (PLO plo : plos) {
                            %>
                            <div class="outcome-row">
                                <input name="ploCode" value="<%= plo.getPloCode() != null ? plo.getPloCode() : "" %>" placeholder="PLO1" required />
                                <textarea name="ploDescription" rows="2" placeholder="Mô tả PLO" required><%= plo.getPloDescription() != null ? plo.getPloDescription() : "" %></textarea>
                                <button type="button" class="remove-row" onclick="removeOutcomeRow(this)">Remove</button>
                            </div>
                            <%  }
                            } else { %>
                            <div class="outcome-row">
                                <input name="ploCode" placeholder="PLO1" required />
                                <textarea name="ploDescription" rows="2" placeholder="Mô tả PLO" required></textarea>
                                <button type="button" class="remove-row" onclick="removeOutcomeRow(this)">Remove</button>
                            </div>
                            <% } %>
                        </div>
                    </section>

                    <section id="tab-po" class="tab-panel">
                        <div class="tab-heading">
                            <div>
                                <h2>PO</h2>
                                <p>Thêm Program Objectives. Không được để trống mã hoặc mô tả.</p>
                            </div>
                            <button class="add-row" type="button" onclick="addOutcomeRow('po')">+ Add PO</button>
                        </div>
                        <div id="poRows" class="outcome-list">
                            <% if (pos != null && !pos.isEmpty()) {
                                for (PO po : pos) {
                            %>
                            <div class="outcome-row">
                                <input name="poCode" value="<%= po.getPoCode() != null ? po.getPoCode() : "" %>" placeholder="PO1" required />
                                <textarea name="poDescription" rows="2" placeholder="Mô tả PO" required><%= po.getPoDescription() != null ? po.getPoDescription() : "" %></textarea>
                                <button type="button" class="remove-row" onclick="removeOutcomeRow(this)">Remove</button>
                            </div>
                            <%  }
                            } else { %>
                            <div class="outcome-row">
                                <input name="poCode" placeholder="PO1" required />
                                <textarea name="poDescription" rows="2" placeholder="Mô tả PO" required></textarea>
                                <button type="button" class="remove-row" onclick="removeOutcomeRow(this)">Remove</button>
                            </div>
                            <% } %>
                        </div>
                    </section>

                    <div class="form-actions">
                        <a class="ghost-button" href="<%=request.getContextPath()%>/training-program?action=list">Cancel</a>
                        <button class="submit-button" type="submit">Create Training Program</button>
                    </div>
                </form>
            </section>
        </main>

        <script>
            document.querySelectorAll(".tab").forEach(function (button) {
                button.addEventListener("click", function () {
                    const tabName = button.dataset.tab;
                    document.querySelectorAll(".tab").forEach(function (tab) {
                        tab.classList.remove("active");
                    });
                    document.querySelectorAll(".tab-panel").forEach(function (panel) {
                        panel.classList.remove("active");
                    });
                    button.classList.add("active");
                    document.getElementById("tab-" + tabName).classList.add("active");
                });
            });

            function addOutcomeRow(type) {
                const container = document.getElementById(type + "Rows");
                const nextNumber = container.querySelectorAll(".outcome-row").length + 1;
                const row = document.createElement("div");
                row.className = "outcome-row";
                row.innerHTML =
                    '<input name="' + type + 'Code" placeholder="' + type.toUpperCase() + nextNumber + '" required />' +
                    '<textarea name="' + type + 'Description" rows="2" placeholder="Mô tả ' + type.toUpperCase() + '" required></textarea>' +
                    '<button type="button" class="remove-row" onclick="removeOutcomeRow(this)">Remove</button>';
                container.appendChild(row);
            }

            function removeOutcomeRow(button) {
                const container = button.closest(".outcome-list");
                if (container.querySelectorAll(".outcome-row").length <= 1) {
                    alert("Phải có ít nhất một dòng.");
                    return;
                }
                button.closest(".outcome-row").remove();
            }

            function validateCreateForm() {
                const form = document.getElementById("createTrainingProgramForm");
                if (!form.checkValidity()) {
                    form.reportValidity();
                    return false;
                }
                if (document.querySelectorAll("#ploRows .outcome-row").length === 0) {
                    alert("Vui lòng thêm ít nhất một PLO.");
                    return false;
                }
                if (document.querySelectorAll("#poRows .outcome-row").length === 0) {
                    alert("Vui lòng thêm ít nhất một PO.");
                    return false;
                }
                return confirm("Bạn có chắc chắn muốn tạo Training Program này không?");
            }
        </script>
    </body>
</html>
