package controller;

import dao.CurriculumDAO;
import dao.SubjectDAO;
import dao.TrainingProgramDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.Curriculum;
import model.CurriculumSubject;
import model.PLO;
import model.PO;
import model.Subject;
import model.TrainingProgram;
import model.User;

@WebServlet(name = "CurriculumServlet", urlPatterns = {"/curriculum-manage"})
public class CurriculumServlet extends HttpServlet {

    private final CurriculumDAO curriculumDAO = new CurriculumDAO();
    private final TrainingProgramDAO trainingProgramDAO = new TrainingProgramDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = getLoggedInUser(request, response);
        if (user == null) {
            return;
        }

        String action = safeTrim(request.getParameter("action"));
        switch (action) {
            case "create":
                if (!isTrainingDepartment(user)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap.");
                    return;
                }
                showCreateForm(request, response);
                break;
            case "list":
            default:
                showList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        User user = getLoggedInUser(request, response);
        if (user == null) {
            return;
        }

        if (!isTrainingDepartment(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap.");
            return;
        }

        String action = safeTrim(request.getParameter("action"));
        if ("create".equals(action)) {
            processCreate(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/curriculum-manage?action=list");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Curriculum> curriculums = curriculumDAO.getCurriculums();
        request.setAttribute("curriculums", curriculums);
        request.getRequestDispatcher("/curriculum/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<TrainingProgram> programs = trainingProgramDAO.getTrainingPrograms("", 1, 1000);
        List<Subject> subjects = subjectDAO.getAllSubjects();
        int requestedProgramId = parseInt(request.getParameter("programId"), 0);
        Curriculum curriculum = (Curriculum) request.getAttribute("curriculum");
        if (curriculum != null && curriculum.getProgramId() > 0) {
            requestedProgramId = curriculum.getProgramId();
        }
        TrainingProgram selectedProgram = requestedProgramId > 0
                ? trainingProgramDAO.getTrainingProgramById(requestedProgramId)
                : null;

        Map<Integer, String> prerequisiteTextMap = new HashMap<>();
        Map<Integer, String> prerequisiteIdsMap = new HashMap<>();
        for (Subject subject : subjects) {
            List<Integer> prerequisiteIds = subjectDAO.getPrerequisiteSubjectIds(subject.getSubjectId());
            prerequisiteIdsMap.put(subject.getSubjectId(), joinIds(prerequisiteIds));
            String prerequisiteText = subjectDAO.getPreRequisiteText(subject.getSubjectId());
            prerequisiteTextMap.put(subject.getSubjectId(), prerequisiteText == null || prerequisiteText.isBlank() ? "none" : prerequisiteText);
        }

        request.setAttribute("programs", programs);
        request.setAttribute("subjects", subjects);
        request.setAttribute("selectedProgram", selectedProgram);
        request.setAttribute("selectedProgramId", requestedProgramId);
        request.setAttribute("prerequisiteTextMap", prerequisiteTextMap);
        request.setAttribute("prerequisiteIdsMap", prerequisiteIdsMap);
        request.getRequestDispatcher("/view/CreateCurriculum.jsp").forward(request, response);
    }

    private void processCreate(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        Curriculum curriculum = new Curriculum();
        curriculum.setProgramId(parseInt(request.getParameter("programId"), 0));
        curriculum.setCreatedBy(user.getUserId());
        curriculum.setCurriculumName(safeTrim(request.getParameter("curriculumName")));
        curriculum.setDescription(safeTrim(request.getParameter("description")));
        curriculum.setStatus("Active");

        int requiredTotalCredits = parseInt(request.getParameter("totalCredits"), 0);
        List<CurriculumSubject> curriculumSubjects = parseCurriculumSubjects(
                request.getParameterValues("subjectIds"),
                request.getParameterValues("semesterNos")
        );
        List<PLO> plos = parsePLOs(request);
        List<PO> pos = parsePOs(request);
        Map<Integer, Subject> subjectMap = buildSubjectMap(subjectDAO.getAllSubjects());

        String validationError = validateCreate(curriculum, requiredTotalCredits, curriculumSubjects, subjectMap, plos, pos);
        if (validationError != null) {
            request.setAttribute("error", validationError);
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("totalCredits", requiredTotalCredits);
            request.setAttribute("plos", plos);
            request.setAttribute("pos", pos);
            showCreateForm(request, response);
            return;
        }

        int id = curriculumDAO.createCurriculumWithSubjects(curriculum, curriculumSubjects, plos, pos);
        if (id > 0) {
            response.sendRedirect(request.getContextPath() + "/training-program?action=detail&id=" + curriculum.getProgramId());
        } else {
            request.setAttribute("error", "Khong the tao Curriculum.");
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("totalCredits", requiredTotalCredits);
            request.setAttribute("plos", plos);
            request.setAttribute("pos", pos);
            showCreateForm(request, response);
        }
    }

    private List<CurriculumSubject> parseCurriculumSubjects(String[] subjectIds, String[] semesterNos) {
        List<CurriculumSubject> list = new ArrayList<>();
        if (subjectIds == null || semesterNos == null) {
            return list;
        }
        int length = Math.min(subjectIds.length, semesterNos.length);
        for (int i = 0; i < length; i++) {
            int subjectId = parseInt(subjectIds[i], 0);
            int semesterNo = parseInt(semesterNos[i], 0);
            if (subjectId <= 0 || semesterNo <= 0) {
                continue;
            }
            CurriculumSubject item = new CurriculumSubject();
            item.setSubjectId(subjectId);
            item.setSemesterNo(semesterNo);
            item.setRequired(true);
            item.setDisplayOrder(i + 1);
            list.add(item);
        }
        return list;
    }

    private Map<Integer, Subject> buildSubjectMap(List<Subject> subjects) {
        Map<Integer, Subject> map = new HashMap<>();
        if (subjects == null) {
            return map;
        }
        for (Subject subject : subjects) {
            map.put(subject.getSubjectId(), subject);
        }
        return map;
    }

    private List<PLO> parsePLOs(HttpServletRequest request) {
        List<PLO> list = new ArrayList<>();
        String[] codes = request.getParameterValues("ploCode");
        String[] descriptions = request.getParameterValues("ploDescription");
        if (codes == null || descriptions == null) {
            return list;
        }
        int length = Math.min(codes.length, descriptions.length);
        for (int i = 0; i < length; i++) {
            String code = safeTrim(codes[i]).toUpperCase();
            String description = safeTrim(descriptions[i]);
            if (code.isEmpty() && description.isEmpty()) {
                continue;
            }
            PLO plo = new PLO();
            plo.setPloCode(code);
            plo.setPloDescription(description);
            list.add(plo);
        }
        return list;
    }

    private List<PO> parsePOs(HttpServletRequest request) {
        List<PO> list = new ArrayList<>();
        String[] codes = request.getParameterValues("poCode");
        String[] descriptions = request.getParameterValues("poDescription");
        if (codes == null || descriptions == null) {
            return list;
        }
        int length = Math.min(codes.length, descriptions.length);
        for (int i = 0; i < length; i++) {
            String code = safeTrim(codes[i]).toUpperCase();
            String description = safeTrim(descriptions[i]);
            if (code.isEmpty() && description.isEmpty()) {
                continue;
            }
            PO po = new PO();
            po.setPoCode(code);
            po.setPoDescription(description);
            list.add(po);
        }
        return list;
    }

    private String validateCreate(Curriculum curriculum, int requiredTotalCredits,
                                  List<CurriculumSubject> curriculumSubjects,
                                  Map<Integer, Subject> subjectMap,
                                  List<PLO> plos, List<PO> pos) {
        if (curriculum.getProgramId() <= 0) {
            return "Vui long chon Training Program.";
        }
        if (isBlank(curriculum.getCurriculumName())) {
            return "Vui long nhap ten khung chuong trinh.";
        }
        if (isBlank(curriculum.getDescription())) {
            return "Vui long nhap muc tieu cua khung chuong trinh.";
        }
        if (requiredTotalCredits <= 0) {
            return "Vui long nhap tong credit hop le.";
        }
        if (curriculumSubjects == null || curriculumSubjects.isEmpty()) {
            return "Vui long them it nhat mot mon hoc.";
        }

        int actualCredits = 0;
        Set<Integer> selectedSubjectIds = new HashSet<>();
        for (CurriculumSubject item : curriculumSubjects) {
            Subject subject = subjectMap.get(item.getSubjectId());
            if (subject == null) {
                return "Mon hoc khong hop le.";
            }
            if (item.getSemesterNo() == null || item.getSemesterNo() <= 0) {
                return "Ky hoc cua mon " + subject.getSubjectCode() + " khong hop le.";
            }
            if (!selectedSubjectIds.add(item.getSubjectId())) {
                return "Mon " + subject.getSubjectCode() + " da duoc them vao khung chuong trinh.";
            }
            actualCredits += subject.getCredits();
        }

        if (actualCredits < requiredTotalCredits) {
            return "Khong du tin chi. Tong credit mon hoc hien tai la " + actualCredits
                    + ", nho hon tong credit da nhap la " + requiredTotalCredits + ".";
        }

        for (CurriculumSubject item : curriculumSubjects) {
            List<Integer> prerequisiteIds = subjectDAO.getPrerequisiteSubjectIds(item.getSubjectId());
            if (prerequisiteIds.isEmpty()) {
                continue;
            }
            for (Integer prerequisiteId : prerequisiteIds) {
                if (!hasPrerequisiteInEarlierSemester(prerequisiteId, item.getSemesterNo(), curriculumSubjects)) {
                    Subject subject = subjectMap.get(item.getSubjectId());
                    Subject prerequisite = subjectMap.get(prerequisiteId);
                    String subjectCode = subject != null ? subject.getSubjectCode() : String.valueOf(item.getSubjectId());
                    String prerequisiteCode = prerequisite != null ? prerequisite.getSubjectCode() : String.valueOf(prerequisiteId);
                    return "Chua co mon dieu kien " + prerequisiteCode
                            + " o cac ky truoc cua mon " + subjectCode + ".";
                }
            }
        }

        for (PLO plo : plos) {
            if (isBlank(plo.getPloCode()) || isBlank(plo.getPloDescription())) {
                return "Khong duoc de trong ma hoac mo ta PLO.";
            }
        }
        for (PO po : pos) {
            if (isBlank(po.getPoCode()) || isBlank(po.getPoDescription())) {
                return "Khong duoc de trong ma hoac mo ta PO.";
            }
        }
        return null;
    }

    private boolean hasPrerequisiteInEarlierSemester(Integer prerequisiteId, Integer semesterNo,
                                                     List<CurriculumSubject> curriculumSubjects) {
        for (CurriculumSubject item : curriculumSubjects) {
            if (item.getSubjectId() == prerequisiteId
                    && item.getSemesterNo() != null
                    && semesterNo != null
                    && item.getSemesterNo() < semesterNo) {
                return true;
            }
        }
        return false;
    }

    private String joinIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return "";
        }
        StringBuilder builder = new StringBuilder();
        for (Integer id : ids) {
            if (id == null) {
                continue;
            }
            if (builder.length() > 0) {
                builder.append(',');
            }
            builder.append(id);
        }
        return builder.toString();
    }

    private User getLoggedInUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return (User) session.getAttribute("user");
    }

    private boolean isTrainingDepartment(User user) {
        return user != null
                && user.getRole() != null
                && "Training Department".equalsIgnoreCase(user.getRole().getRoleName());
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
