<%@page import="java.util.List"%>
<%@page import="model.Subject"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String creatorName = (String) request.getAttribute("creatorName");
    Subject course = (Subject) request.getAttribute("course");
    List<Subject> courseOptions = (List<Subject>) request.getAttribute("courseOptions");
    List<Integer> selectedPrerequisiteIds = (List<Integer>) request.getAttribute("selectedPrerequisiteIds");

    if (creatorName == null) {
        creatorName = "";
    }
    if (course == null) {
        course = new Subject();
        course.setStatus("WaitingForSyllabus");
    }
    String creditsValue = course.getCredits() > 0 ? String.valueOf(course.getCredits()) : "";
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Create Course</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/CreateCourse.css" />
    </head>
    <body>
        <main class="create-course-page">
            <header class="page-header">
                <a class="back-link" href="<%=request.getContextPath()%>/course?action=list">Back to list</a>
                <h1>Training Program Management System</h1>
            </header>

            <section class="create-shell">
                <div class="section-title">
                    <span>Course</span>
                    <strong>Create Course</strong>
                </div>

                <% if (error != null) { %>
                <div class="error"><%= error %></div>
                <% } %>

                <form id="createCourseForm" method="post" action="<%=request.getContextPath()%>/course" onsubmit="return confirmCreateCourse();">
                    <input type="hidden" name="action" value="create" />

                    <fieldset class="course-info">
                        <legend>Course Information</legend>

                        <div class="form-grid">
                            <label>
                                <span>Course Code</span>
                                <input name="subjectCode" value="<%= course.getSubjectCode() != null ? course.getSubjectCode() : "" %>" placeholder="VD: SWP391" maxlength="50" required />
                            </label>

                            <label>
                                <span>Course Name</span>
                                <input name="subjectName" value="<%= course.getSubjectName() != null ? course.getSubjectName() : "" %>" placeholder="Software Project" required />
                            </label>

                            <label>
                                <span>Credits</span>
                                <input type="number" name="credits" value="<%= creditsValue %>" min="1" max="20" placeholder="3" required />
                            </label>

                            <label>
                                <span>Created By</span>
                                <input value="<%= creatorName %>" readonly />
                            </label>

                            <label class="span-2">
                                <span>Description</span>
                                <textarea name="description" rows="5" placeholder="Nhập mô tả môn học" required><%= course.getDescription() != null ? course.getDescription() : "" %></textarea>
                            </label>

                            <div class="span-2 prerequisite-builder">
                                <span class="field-label">Môn điều kiện</span>
                                <div class="prerequisite-search-row">
                                    <input id="prerequisiteSearch" list="prerequisiteOptions" placeholder="Tìm theo mã hoặc tên môn, VD: SWP391 hoặc Software Project" autocomplete="off" />
                                    <button class="add-prerequisite-button" type="button" onclick="addPrerequisite()">Add</button>
                                </div>
                                <datalist id="prerequisiteOptions">
                                    <% if (courseOptions != null) {
                                        for (Subject option : courseOptions) {
                                            String code = option.getSubjectCode() != null ? option.getSubjectCode() : "";
                                            String name = option.getSubjectName() != null ? option.getSubjectName() : "";
                                            String label = code + " - " + name;
                                    %>
                                    <option value="<%= label %>" data-id="<%= option.getSubjectId() %>"></option>
                                    <%  }
                                    } %>
                                </datalist>
                                <div id="selectedPrerequisiteList" class="selected-prerequisites">
                                    <% if (courseOptions != null && selectedPrerequisiteIds != null) {
                                        for (Subject option : courseOptions) {
                                            if (!selectedPrerequisiteIds.contains(option.getSubjectId())) {
                                                continue;
                                            }
                                            String code = option.getSubjectCode() != null ? option.getSubjectCode() : "";
                                            String name = option.getSubjectName() != null ? option.getSubjectName() : "";
                                            String label = code + " - " + name;
                                    %>
                                    <span class="selected-prerequisite" data-id="<%= option.getSubjectId() %>">
                                        <input type="hidden" name="prerequisiteSubjectId" value="<%= option.getSubjectId() %>" />
                                        <span><%= label %></span>
                                        <button type="button" onclick="removePrerequisite(this)">Remove</button>
                                    </span>
                                    <%  }
                                    } %>
                                </div>
                                <small>Có thể tìm theo mã hoặc tên môn. Có thể thêm 1 hoặc nhiều môn điều kiện, hoặc bỏ trống nếu không có.</small>
                            </div>

                            <label>
                                <span>Status</span>
                                <input value="WaitingForSyllabus" readonly />
                            </label>
                        </div>
                    </fieldset>

                    <div class="form-actions">
                        <button class="submit-button" type="submit">Create Course</button>
                        <a class="cancel-button" href="<%=request.getContextPath()%>/course?action=list">Cancel</a>
                    </div>
                </form>
            </section>
        </main>

        <script>
            const selectedPrerequisiteIds = new Set(
                Array.from(document.querySelectorAll('#selectedPrerequisiteList input[name="prerequisiteSubjectId"]'))
                    .map(function (input) { return input.value; })
            );

            function getPrerequisiteOptions() {
                return Array.from(document.querySelectorAll('#prerequisiteOptions option')).map(function (option) {
                    return {
                        id: option.dataset.id,
                        label: option.value
                    };
                });
            }

            function addPrerequisite() {
                const input = document.getElementById('prerequisiteSearch');
                const keyword = input.value.trim().toLowerCase();
                if (!keyword) {
                    alert('Vui lòng nhập mã hoặc tên môn điều kiện.');
                    return;
                }

                const options = getPrerequisiteOptions();
                const matched = options.find(function (option) {
                    return option.label.toLowerCase() === keyword;
                }) || options.find(function (option) {
                    return option.label.toLowerCase().includes(keyword);
                });

                if (!matched) {
                    alert('Không tìm thấy môn học phù hợp.');
                    return;
                }

                if (selectedPrerequisiteIds.has(matched.id)) {
                    alert('Môn điều kiện này đã được thêm.');
                    input.value = '';
                    return;
                }

                selectedPrerequisiteIds.add(matched.id);
                const item = document.createElement('span');
                item.className = 'selected-prerequisite';
                item.dataset.id = matched.id;
                item.innerHTML =
                    '<input type="hidden" name="prerequisiteSubjectId" value="' + matched.id + '" />' +
                    '<span></span>' +
                    '<button type="button" onclick="removePrerequisite(this)">Remove</button>';
                item.querySelector('span').textContent = matched.label;
                document.getElementById('selectedPrerequisiteList').appendChild(item);
                input.value = '';
            }

            function removePrerequisite(button) {
                const item = button.closest('.selected-prerequisite');
                selectedPrerequisiteIds.delete(item.dataset.id);
                item.remove();
            }

            function confirmCreateCourse() {
                const form = document.getElementById('createCourseForm');
                if (!form.checkValidity()) {
                    form.reportValidity();
                    return false;
                }
                return confirm('Bạn có chắc chắn muốn tạo course này không?');
            }
        </script>
    </body>
</html>