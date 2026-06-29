package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

/**
 * AuthUtil — centralised authentication & authorisation helper.
 *
 * Role IDs (from Role table):
 *   1 = Admin
 *   2 = Student
 *   3 = Teacher
 *   4 = Training Department
 *   5 = Syllabus Designer
 */
public class AuthUtil {

    public static final int ROLE_ADMIN              = 1;
    public static final int ROLE_STUDENT            = 2;
    public static final int ROLE_TEACHER            = 3;
    public static final int ROLE_TRAINING_DEPT      = 4;
    public static final int ROLE_SYLLABUS_DESIGNER  = 5;

    /** Returns the logged-in User from session, or null if not logged in. */
    public static User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute("user");
    }

    /** True if a user is logged in. */
    public static boolean isLoggedIn(HttpServletRequest request) {
        return getLoggedInUser(request) != null;
    }

    /** True if logged-in user has the given roleId. */
    public static boolean hasRole(HttpServletRequest request, int roleId) {
        User u = getLoggedInUser(request);
        return u != null && u.getRoleId() == roleId;
    }

    /** True if the logged-in user is a Teacher (RoleID=3). */
    public static boolean isTeacher(HttpServletRequest request) {
        return hasRole(request, ROLE_TEACHER);
    }

    /** True if the logged-in user is an Admin (RoleID=1). */
    public static boolean isAdmin(HttpServletRequest request) {
        return hasRole(request, ROLE_ADMIN);
    }

    /**
     * Require login + specific role.
     * If not logged in → redirect to /login?returnUrl=...
     * If wrong role    → send 403 Forbidden
     * Returns true if access is granted (caller may continue processing).
     */
    public static boolean requireRole(HttpServletRequest request,
                                      HttpServletResponse response,
                                      int roleId) throws IOException {
        User u = getLoggedInUser(request);
        if (u == null) {
            String returnUrl = request.getRequestURI();
            String qs = request.getQueryString();
            if (qs != null) returnUrl += "?" + qs;
            response.sendRedirect(request.getContextPath()
                    + "/login?returnUrl=" + java.net.URLEncoder.encode(returnUrl,
                    java.nio.charset.StandardCharsets.UTF_8));
            return false;
        }
        if (u.getRoleId() != roleId && u.getRoleId() != ROLE_ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "You do not have permission to access this page.");
            return false;
        }
        return true;
    }

    /** Require Teacher or Admin access. */
    public static boolean requireTeacher(HttpServletRequest request,
                                         HttpServletResponse response) throws IOException {
        return requireRole(request, response, ROLE_TEACHER);
    }
}
