package controller;

import dao.CurriculumDAO;
import dto.CurriculumDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Curriculum;
import model.User;
import service.ServiceResult;
import service.UserService;
import com.google.gson.Gson;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final CurriculumDAO curriculumDAO = new CurriculumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User current = getLoggedInUser(request);
        if (current == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User fresh = userService.getById(current.getUserId());
        if (fresh != null) {
            request.getSession().setAttribute("user", fresh);
        }

        // Fetch curricula list
        List<Curriculum> curriculums = curriculumDAO.getCurriculums();
        request.setAttribute("curriculums", curriculums);

        // Fetch selected curriculum for tree diagram
        CurriculumDTO selectedCurriculum = null;
        if (curriculums != null && !curriculums.isEmpty()) {
            Object sessionCurId = request.getSession().getAttribute("profileCurriculumId");
            int curId = resolveCurriculumId(curriculums, sessionCurId);
            try {
                selectedCurriculum = curriculumDAO.getCurriculumById(curId);
                if (selectedCurriculum != null
                        && (selectedCurriculum.getSemesterSubjects() == null
                        || selectedCurriculum.getSemesterSubjects().isEmpty())) {
                    int fallbackId = findCurriculumWithSubjects(curriculums);
                    if (fallbackId > 0 && fallbackId != curId) {
                        selectedCurriculum = curriculumDAO.getCurriculumById(fallbackId);
                        curId = fallbackId;
                        request.setAttribute("curriculumFallbackNotice",
                                "Ngành đã chọn chưa có môn học. Đang hiển thị chương trình có dữ liệu.");
                    }
                }
                request.setAttribute("selectedCurId", curId);
            } catch (SQLException e) {
                System.err.println("Error loading selected curriculum: " + e.getMessage());
            }
        }
        request.setAttribute("selectedCurriculum", selectedCurriculum);

        // Fetch subject prerequisites map
        Map<String, List<String>> prereqs = new HashMap<>();
        try (Connection con = new dao.DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT s.SubjectCode AS TargetCode, req.SubjectCode AS RequiredCode " +
                 "FROM dbo.Subject_Prerequisite sp " +
                 "JOIN dbo.Subject s ON sp.SubjectID = s.SubjectID " +
                 "JOIN dbo.Subject req ON sp.RequiredSubjectID = req.SubjectID")) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    prereqs.computeIfAbsent(rs.getString("TargetCode"), k -> new ArrayList<>())
                           .add(rs.getString("RequiredCode"));
                }
            }
        } catch (Exception e) {
            System.err.println("Prerequisite load error: " + e.getMessage());
        }
        request.setAttribute("prereqsJson", new Gson().toJson(prereqs));

        request.getRequestDispatcher("/view/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User current = getLoggedInUser(request);
        if (current == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = safeTrim(request.getParameter("fullName"));
        String curIdStr = request.getParameter("curriculumId");

        // Handle curriculum configuration update in session
        if (curIdStr != null && !curIdStr.isEmpty()) {
            try {
                int curId = Integer.parseInt(curIdStr);
                request.getSession().setAttribute("profileCurriculumId", curId);
            } catch (NumberFormatException e) {
                // Ignore invalid input
            }
        }

        if (fullName.isEmpty()) {
            request.setAttribute("error", "Họ tên không được để trống.");
            doGet(request, response);
            return;
        }

        ServiceResult result = userService.updateProfile(current.getUserId(), fullName);
        if (result.isSuccess()) {
            User fresh = userService.getById(current.getUserId());
            request.getSession().setAttribute("user", fresh);
            request.setAttribute("message", result.getMessage());
        } else {
            request.setAttribute("error", result.getMessage());
        }

        doGet(request, response);
    }

    private User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object user = session.getAttribute("user");
        return user instanceof User ? (User) user : null;
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private int resolveCurriculumId(List<Curriculum> curriculums, Object sessionCurId) {
        if (sessionCurId instanceof Integer sessionId) {
            boolean exists = curriculums.stream()
                    .anyMatch(c -> c.getCurriculumId() == sessionId);
            if (exists) {
                return sessionId;
            }
        }
        return findCurriculumWithSubjects(curriculums);
    }

    private int findCurriculumWithSubjects(List<Curriculum> curriculums) {
        for (Curriculum curriculum : curriculums) {
            if (curriculum.getSubjectCount() > 0) {
                return curriculum.getCurriculumId();
            }
        }
        return curriculums.get(0).getCurriculumId();
    }
}
