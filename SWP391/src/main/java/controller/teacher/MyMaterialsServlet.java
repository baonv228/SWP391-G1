package controller.teacher;

import dao.MaterialDAO;
import dto.MaterialDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.AuthUtil;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * NEW — Teacher views all materials they uploaded.
 * Linked from dashboard "My Uploaded Materials" stat card.
 * URL: /teacher/my-materials
 */
@WebServlet(name = "MyMaterialsServlet", urlPatterns = {"/teacher/my-materials"})
public class MyMaterialsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        User teacher = AuthUtil.getLoggedInUser(request);
        try {
            MaterialDAO materialDAO = new MaterialDAO();
            List<MaterialDTO> materials = materialDAO.getMaterialsByUploaderDetailed(teacher.getUserId());
            request.setAttribute("materials", materials);
            request.setAttribute("materialsCount", materials.size());
            request.getRequestDispatcher("/view/teacher/myMaterials.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("DB error in MyMaterialsServlet", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }
}
