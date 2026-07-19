package controller;

import com.google.gson.Gson;
import dao.PLODAO;
import dao.SubjectDAO;
import dao.SyllabusDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.*;

@WebServlet(name = "SyllabusServlet", urlPatterns = {"/syllabus-manage"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 100,      // 100MB
    maxRequestSize = 1024 * 1024 * 105    // 105MB
)
public class SyllabusServlet extends HttpServlet {

    private final SyllabusDAO syllabusDAO = new SyllabusDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final PLODAO ploDAO = new PLODAO();

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
            case "edit":
                showEditForm(request, response);
                break;
            case "ajax_init":
                handleAjaxInit(request, response);
                break;
            case "ajax_plos":
                handleAjaxPlos(request, response);
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

        switch (action) {
            case "create":
                processCreate(request, response, user);
                break;
            case "edit":
                processEdit(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/syllabus-manage?action=list");
                break;
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

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int syllabusId = parseInt(request.getParameter("id"), 0);
        Syllabus syllabus = syllabusDAO.getSyllabusById(syllabusId);
        if (syllabus == null) {
            response.sendRedirect(request.getContextPath() + "/syllabus-manage?action=list");
            return;
        }

        // Always refresh Pre-Requisite from Subject table
        String preReq = subjectDAO.getPreRequisiteText(syllabus.getSubjectId());
        if (preReq != null && !preReq.isEmpty()) {
            syllabus.setPreRequisiteText(preReq);
        }

        // Load all children
        List<SyllabusMaterial> materials = syllabusDAO.getMaterials(syllabusId);
        List<CLO> clos = syllabusDAO.getCLOs(syllabusId);
        List<SyllabusSession> sessions = syllabusDAO.getSessions(syllabusId);
        List<SyllabusAssessment> assessments = syllabusDAO.getAssessments(syllabusId);

        String latestFile = syllabusDAO.getLatestMaterialFilePath(syllabusId);
        if (latestFile != null) {
            syllabus.setMaterialFilePath(latestFile);
        }

        request.setAttribute("syllabus", syllabus);
        request.setAttribute("materials", materials);
        request.setAttribute("clos", clos);
        request.setAttribute("sessions", sessions);
        request.setAttribute("assessments", assessments);

        // Also pass Training Programs for the subject
        List<TrainingProgram> programs = ploDAO.getTrainingProgramsForSubject(syllabus.getSubjectId());
        request.setAttribute("programs", programs);

        request.getRequestDispatcher("/syllabus/edit.jsp").forward(request, response);
    }

    private void showList(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Syllabus> syllabuses = syllabusDAO.getSyllabusesByCreator(user.getUserId());
        request.setAttribute("syllabuses", syllabuses);
        request.getRequestDispatcher("/syllabus/list.jsp").forward(request, response);
    }

    // =========================================================================
    // AJAX handlers
    // =========================================================================
    private void handleAjaxInit(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int subjectId = parseInt(request.getParameter("subjectId"), 0);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, String> data = new HashMap<>();

        if (subjectId > 0) {
            Subject sub = subjectDAO.getSubjectById(subjectId);
            if (sub != null) {
                data.put("syllabusTitle", sub.getSubjectName());
                data.put("syllabusName", sub.getSubjectName());
            }
            data.put("versionNo", syllabusDAO.getNextVersionNo(subjectId));
            data.put("preRequisiteText", subjectDAO.getPreRequisiteText(subjectId));
        }

        response.getWriter().write(new Gson().toJson(data));
    }

    private void handleAjaxPlos(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int programId = parseInt(request.getParameter("programId"), 0);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        List<PLO> plos = new ArrayList<>();
        if (programId > 0) {
            plos = ploDAO.getPLOsByProgramId(programId);
        }
        response.getWriter().write(new Gson().toJson(plos));
    }

    // =========================================================================
    // POST handlers
    // =========================================================================

    private void processCreate(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            Syllabus syllabus = parseSyllabusDetails(request, user.getUserId());
            String saveType = request.getParameter("saveType"); // "draft" or "submit"

            if (syllabus.getSubjectId() <= 0) {
                request.setAttribute("error", "Vui lòng chọn Subject.");
                showCreateForm(request, response);
                return;
            }

            if (syllabusDAO.hasDraftForSubject(syllabus.getSubjectId(), 0)) {
                request.setAttribute("error", "Đã tồn tại một bản Draft cho Subject này.");
                showCreateForm(request, response);
                return;
            }

            // Save parent first to get ID
            int syllabusId = syllabusDAO.createDraftSyllabus(syllabus);
            if (syllabusId <= 0) {
                request.setAttribute("error", "Lỗi tạo Draft.");
                showCreateForm(request, response);
                return;
            }

            syllabus.setSyllabusId(syllabusId);

            // Parse children
            List<SyllabusMaterial> materials = parseMaterials(request);
            List<CLO> clos = parseCLOs(request);
            List<SyllabusSession> sessions = parseSessions(request);
            List<SyllabusAssessment> assessments = parseAssessments(request);

            // Handle file upload
            handleFileUpload(request, syllabusId, user.getUserId());

            syllabusDAO.saveAllChildren(syllabusId, materials, clos, sessions, assessments);

            if ("submit".equals(saveType)) {
                syllabusDAO.updateStatus(syllabusId, "Pending Approval");
                response.sendRedirect(request.getContextPath() + "/syllabus-manage?action=list&success=submit");
            } else {
                response.sendRedirect(request.getContextPath() + "/syllabus-manage?action=edit&id=" + syllabusId + "&success=draft");
            }

        } catch (Exception e) {
            System.out.println("processCreate error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    private void processEdit(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int syllabusId = parseInt(request.getParameter("syllabusId"), 0);
            if (syllabusId <= 0) {
                response.sendRedirect(request.getContextPath() + "/syllabus-manage?action=list");
                return;
            }

            Syllabus syllabus = parseSyllabusDetails(request, user.getUserId());
            syllabus.setSyllabusId(syllabusId);
            String saveType = request.getParameter("saveType"); // "draft" or "submit"

            syllabusDAO.updateSyllabusDetails(syllabus);

            List<SyllabusMaterial> materials = parseMaterials(request);
            List<CLO> clos = parseCLOs(request);
            List<SyllabusSession> sessions = parseSessions(request);
            List<SyllabusAssessment> assessments = parseAssessments(request);

            // Handle file upload
            handleFileUpload(request, syllabusId, user.getUserId());

            syllabusDAO.saveAllChildren(syllabusId, materials, clos, sessions, assessments);

            if ("submit".equals(saveType)) {
                syllabusDAO.updateStatus(syllabusId, "Pending Approval");
                response.sendRedirect(request.getContextPath() + "/syllabus-manage?action=list&success=submit");
            } else {
                response.sendRedirect(request.getContextPath() + "/syllabus-manage?action=edit&id=" + syllabusId + "&success=update");
            }

        } catch (Exception e) {
            System.out.println("processEdit error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            showEditForm(request, response); // This will reload edit form with db values unfortunately, so inline error might be lost. Needs refactor if full state retention is desired, but good enough for now.
        }
    }

    /**
     * Base upload directory: {user.home}/tpms-uploads
     * Mỗi máy tự động đúng, không mất file khi redeploy.
     */
    public static String getUploadBasePath() {
        return System.getProperty("user.home") + File.separator + "tpms-uploads";
    }

    private void handleFileUpload(HttpServletRequest request, int syllabusId, int userId) throws IOException, ServletException {
        Part filePart = request.getPart("student_material_file");
        if (filePart != null && filePart.getSize() > 0) {
            // Validate: chỉ cho phép .zip
            String submittedName = filePart.getSubmittedFileName();
            if (submittedName == null || !submittedName.toLowerCase().endsWith(".zip")) {
                System.out.println("Rejected upload: not a .zip file -> " + submittedName);
                return;
            }

            String uploadDir = getUploadBasePath() + File.separator + "syllabus" + File.separator + syllabusId;
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            String fileName = "material.zip";
            String filePath = dir.getAbsolutePath() + File.separator + fileName;

            // Write file
            try (var input = filePart.getInputStream();
                 var output = new java.io.FileOutputStream(filePath)) {
                input.transferTo(output);
            }

            // Save path to DB (relative for portability)
            String dbPath = "syllabus/" + syllabusId + "/" + fileName;
            syllabusDAO.saveMaterialFile(syllabusId, userId, dbPath);
        }
    }

    // =========================================================================
    // Parsers
    // =========================================================================

    private Syllabus parseSyllabusDetails(HttpServletRequest request, int userId) {
        Syllabus syllabus = new Syllabus();
        syllabus.setSubjectId(parseInt(request.getParameter("subjectId"), 0));
        syllabus.setCreatedBy(userId);
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
        syllabus.setIsActive(true);
        return syllabus;
    }

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

            // Parse mapped PLO IDs
            List<Integer> ploIds = new ArrayList<>();
            String[] ploParams = request.getParameterValues("clo_plo_" + i);
            if (ploParams != null) {
                for (String ploIdStr : ploParams) {
                    int ploId = parseInt(ploIdStr, 0);
                    if (ploId > 0) ploIds.add(ploId);
                }
            }
            c.setPloIds(ploIds);

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

            List<Integer> cloOrders = new ArrayList<>();
            String[] cloParams = request.getParameterValues("ses_clo_" + i);
            if (cloParams != null) {
                for (String cloStr : cloParams) {
                    int cloOrder = parseInt(cloStr, 0);
                    if (cloOrder > 0) cloOrders.add(cloOrder);
                }
            }
            s.setCloIds(cloOrders);
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

            List<Integer> cloOrders = new ArrayList<>();
            String[] cloParams = request.getParameterValues("asm_clo_" + i);
            if (cloParams != null) {
                for (String cloStr : cloParams) {
                    int cloOrder = parseInt(cloStr, 0);
                    if (cloOrder > 0) cloOrders.add(cloOrder);
                }
            }
            a.setCloIds(cloOrders);
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
