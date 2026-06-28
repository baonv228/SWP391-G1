package controller;

import dao.SubjectDAO;
import dao.SyllabusDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.*;

@WebServlet(name = "SyllabusServlet", urlPatterns = {"/syllabus-management"})
public class SyllabusServlet extends HttpServlet {

    private final SyllabusDAO syllabusDAO = new SyllabusDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getLoggedInDesigner(request, response);
        if (user == null) return;

        String action = safeTrim(request.getParameter("action"));

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "list":
            default:
                showList(request, response, user);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        User user = getLoggedInDesigner(request, response);
        if (user == null) return;

        String action = safeTrim(request.getParameter("action"));

        if ("create".equals(action)) {
            processCreate(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/syllabus?action=list");
        }
    }

    // =========================================================================
    // GET handlers
    // =========================================================================

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Subject> subjects = subjectDAO.getSubjectsWaitingForSyllabus();
        request.setAttribute("subjects", subjects);
        request.getRequestDispatcher("/syllabus/create.jsp").forward(request, response);
    }

    private void showList(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Syllabus> syllabuses = syllabusDAO.getSyllabusesByCreator(user.getUserId());
        request.setAttribute("syllabuses", syllabuses);
        request.getRequestDispatcher("/syllabus/list.jsp").forward(request, response);
    }

    // =========================================================================
    // POST handler — Create Syllabus
    // =========================================================================

    private void processCreate(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        try {
            // --- 1) Parse Syllabus Details ---
            Syllabus syllabus = new Syllabus();
            syllabus.setSubjectId(parseInt(request.getParameter("subjectId"), 0));
            syllabus.setCreatedBy(user.getUserId());
            syllabus.setVersionNo(safeTrim(request.getParameter("versionNo")));
            syllabus.setSyllabusTitle(safeTrim(request.getParameter("syllabusTitle")));
            syllabus.setSyllabusName(safeTrim(request.getParameter("syllabusName")));
            syllabus.setSyllabusEnglish(safeTrim(request.getParameter("syllabusEnglish")));
            syllabus.setDescription(safeTrim(request.getParameter("description")));
            syllabus.setDegreeLevel(safeTrim(request.getParameter("degreeLevel")));
            syllabus.setTimeAllocation(safeTrim(request.getParameter("timeAllocation")));
            syllabus.setPreRequisiteText(safeTrim(request.getParameter("preRequisiteText")));
            syllabus.setStudentTasks(safeTrim(request.getParameter("studentTasks")));
            syllabus.setTools(safeTrim(request.getParameter("tools")));
            syllabus.setScoringScale(parseIntOrNull(request.getParameter("scoringScale")));
            syllabus.setDecisionNo(safeTrim(request.getParameter("decisionNo")));
            syllabus.setNote(safeTrim(request.getParameter("note")));
            syllabus.setMinAvgMarkToPass(parseDoubleOrNull(request.getParameter("minAvgMarkToPass")));
            syllabus.setStatus("Draft");
            syllabus.setCurrentVersion(false);
            syllabus.setIsActive(true);

            // Validate required fields
            if (syllabus.getSubjectId() <= 0 || syllabus.getSyllabusTitle().isEmpty()
                    || syllabus.getVersionNo().isEmpty()) {
                request.setAttribute("error", "Subject, Syllabus Title, và Version là bắt buộc.");
                showCreateForm(request, response);
                return;
            }

            // --- 2) Parse Materials ---
            List<SyllabusMaterial> materials = parseMaterials(request);

            // --- 3) Parse CLOs ---
            List<CLO> clos = parseCLOs(request);

            // --- 4) Parse Sessions ---
            List<SyllabusSession> sessions = parseSessions(request);

            // --- 5) Parse Assessments ---
            List<SyllabusAssessment> assessments = parseAssessments(request);

            // --- 6) Save to DB ---
            int syllabusId = syllabusDAO.createFullSyllabus(syllabus, materials, clos, sessions, assessments);

            if (syllabusId > 0) {
                response.sendRedirect(request.getContextPath()
                        + "/syllabus?action=list&success=1");
            } else {
                request.setAttribute("error", "Lỗi khi lưu Syllabus. Vui lòng thử lại.");
                showCreateForm(request, response);
            }

        } catch (Exception e) {
            System.out.println("processCreate error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    // =========================================================================
    // Parsers — extract arrays from form parameters
    // =========================================================================

    private List<SyllabusMaterial> parseMaterials(HttpServletRequest request) {
        List<SyllabusMaterial> list = new ArrayList<>();
        String[] descriptions = request.getParameterValues("mat_description");
        if (descriptions == null) return list;

        String[] authors = request.getParameterValues("mat_author");
        String[] publishers = request.getParameterValues("mat_publisher");
        String[] publishedDates = request.getParameterValues("mat_publishedDate");
        String[] editions = request.getParameterValues("mat_edition");
        String[] isbns = request.getParameterValues("mat_isbn");
        String[] notes = request.getParameterValues("mat_note");

        for (int i = 0; i < descriptions.length; i++) {
            String desc = safeTrim(descriptions[i]);
            if (desc.isEmpty()) continue;

            SyllabusMaterial m = new SyllabusMaterial();
            m.setMaterialDescription(desc);
            m.setAuthor(safeGet(authors, i));
            m.setPublisher(safeGet(publishers, i));
            m.setPublishedDate(safeGet(publishedDates, i));
            m.setEdition(safeGet(editions, i));
            m.setIsbn(safeGet(isbns, i));
            m.setIsMainMaterial("on".equals(request.getParameter("mat_isMain_" + i)));
            m.setIsHardCopy("on".equals(request.getParameter("mat_isHard_" + i)));
            m.setIsOnline("on".equals(request.getParameter("mat_isOnline_" + i)));
            m.setNote(safeGet(notes, i));
            m.setDisplayOrder(i + 1);
            list.add(m);
        }
        return list;
    }

    private List<CLO> parseCLOs(HttpServletRequest request) {
        List<CLO> list = new ArrayList<>();
        String[] names = request.getParameterValues("clo_name");
        if (names == null) return list;

        String[] details = request.getParameterValues("clo_details");
        String[] loDetails = request.getParameterValues("clo_loDetails");

        for (int i = 0; i < names.length; i++) {
            String name = safeTrim(names[i]);
            if (name.isEmpty()) continue;

            CLO c = new CLO();
            c.setCloName(name);
            c.setCloDetails(safeGet(details, i));
            c.setLoDetails(safeGet(loDetails, i));
            c.setDisplayOrder(i + 1);
            list.add(c);
        }
        return list;
    }

    private List<SyllabusSession> parseSessions(HttpServletRequest request) {
        List<SyllabusSession> list = new ArrayList<>();
        String[] topics = request.getParameterValues("ses_topic");
        if (topics == null) return list;

        String[] types = request.getParameterValues("ses_type");
        String[] itus = request.getParameterValues("ses_itu");
        String[] materials = request.getParameterValues("ses_materials");
        String[] downloads = request.getParameterValues("ses_download");
        String[] tasks = request.getParameterValues("ses_tasks");
        String[] urls = request.getParameterValues("ses_urls");

        for (int i = 0; i < topics.length; i++) {
            String topic = safeTrim(topics[i]);
            if (topic.isEmpty()) continue;

            SyllabusSession s = new SyllabusSession();
            s.setSessionNumber(i + 1);
            s.setTopic(topic);
            s.setLearningTeachingType(safeGet(types, i));
            s.setItu(safeGet(itus, i));
            s.setStudentMaterials(safeGet(materials, i));
            s.setSDownload(safeGet(downloads, i));
            s.setStudentTasks(safeGet(tasks, i));
            s.setUrls(safeGet(urls, i));
            s.setDisplayOrder(i + 1);

            // Parse CLO checkboxes: ses_clo_0_1, ses_clo_0_2, ...
            List<Integer> cloIds = new ArrayList<>();
            for (int c = 1; c <= 20; c++) {
                if ("on".equals(request.getParameter("ses_clo_" + i + "_" + c))) {
                    cloIds.add(c);
                }
            }
            s.setCloIds(cloIds);
            list.add(s);
        }
        return list;
    }

    private List<SyllabusAssessment> parseAssessments(HttpServletRequest request) {
        List<SyllabusAssessment> list = new ArrayList<>();
        String[] categories = request.getParameterValues("asm_category");
        if (categories == null) return list;

        String[] types = request.getParameterValues("asm_type");
        String[] weights = request.getParameterValues("asm_weight");
        String[] criteria = request.getParameterValues("asm_criteria");
        String[] durations = request.getParameterValues("asm_duration");
        String[] questionTypes = request.getParameterValues("asm_questionType");
        String[] knowledges = request.getParameterValues("asm_knowledge");
        String[] guides = request.getParameterValues("asm_gradingGuide");
        String[] notes = request.getParameterValues("asm_note");

        for (int i = 0; i < categories.length; i++) {
            String category = safeTrim(categories[i]);
            if (category.isEmpty()) continue;

            SyllabusAssessment a = new SyllabusAssessment();
            a.setCategory(category);
            a.setType(safeGet(types, i));
            a.setPart(i + 1);
            a.setWeight(parseDouble(safeGet(weights, i), 0));
            a.setCompletionCriteria(safeGet(criteria, i));
            a.setDuration(safeGet(durations, i));
            a.setQuestionType(safeGet(questionTypes, i));
            a.setKnowledgeAndSkill(safeGet(knowledges, i));
            a.setGradingGuide(safeGet(guides, i));
            a.setNote(safeGet(notes, i));
            a.setDisplayOrder(i + 1);

            // Parse CLO checkboxes: asm_clo_0_1, asm_clo_0_2, ...
            List<Integer> cloIds = new ArrayList<>();
            for (int c = 1; c <= 20; c++) {
                if ("on".equals(request.getParameter("asm_clo_" + i + "_" + c))) {
                    cloIds.add(c);
                }
            }
            a.setCloIds(cloIds);
            list.add(a);
        }
        return list;
    }

    // =========================================================================
    // Auth helper
    // =========================================================================

    private User getLoggedInDesigner(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        User user = (User) session.getAttribute("user");
        if (user.getRole() == null || !"Syllabus Designer".equals(user.getRole().getRoleName())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap.");
            return null;
        }
        return user;
    }

    // =========================================================================
    // Utility methods
    // =========================================================================

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private String safeGet(String[] arr, int index) {
        if (arr == null || index >= arr.length) return "";
        return arr[index] == null ? "" : arr[index].trim();
    }

    private int parseInt(String value, int defaultValue) {
        try { return Integer.parseInt(value.trim()); }
        catch (Exception e) { return defaultValue; }
    }

    private Integer parseIntOrNull(String value) {
        try { return Integer.parseInt(value.trim()); }
        catch (Exception e) { return null; }
    }

    private Double parseDoubleOrNull(String value) {
        try { return Double.parseDouble(value.trim()); }
        catch (Exception e) { return null; }
    }

    private double parseDouble(String value, double defaultValue) {
        try { return Double.parseDouble(value.trim()); }
        catch (Exception e) { return defaultValue; }
    }
}
