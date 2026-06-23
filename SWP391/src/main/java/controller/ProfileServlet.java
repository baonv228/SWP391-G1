package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import service.ServiceResult;
import service.UserService;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private final UserService userService = new UserService();

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

        if (fullName.isEmpty()) {
            request.setAttribute("error", "Họ tên không được để trống.");
            request.getRequestDispatcher("/view/profile.jsp").forward(request, response);
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
        request.getRequestDispatcher("/view/profile.jsp").forward(request, response);
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
}
