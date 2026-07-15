package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebFilter(filterName = "AdminFilter", urlPatterns = {
    "/admin/*",
    "/view/AdminHome.jsp",
    "/view/admin_users.jsp",
    "/view/admin_roles.jsp",
    "/view/admin_system_reports.jsp"
})
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        User currentUser = null;
        String roleName = null;

        if (session != null) {
            currentUser = (User) session.getAttribute("user");
            roleName = (String) session.getAttribute("roleName");
            if (roleName == null && currentUser != null && currentUser.getRole() != null) {
                roleName = currentUser.getRole().getRoleName();
                session.setAttribute("roleName", roleName);
            }
        }

        if (currentUser == null || roleName == null || !"Admin".equalsIgnoreCase(roleName.trim())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
