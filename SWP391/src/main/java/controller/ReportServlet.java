package controller;

import dao.ReportDAO;
import dao.TrainingProgramDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.CourseReportItem;
import model.TrainingProgram;
import model.TrainingReportStats;

@WebServlet(name = "ReportServlet", urlPatterns = {"/report"})
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String programFilter = request.getParameter("programFilter");
        String searchKeyword = request.getParameter("searchKeyword");
        
        ReportDAO reportDAO = new ReportDAO();
        TrainingProgramDAO tpDAO = new TrainingProgramDAO();
        
        TrainingReportStats stats = reportDAO.getReportStats();
        List<CourseReportItem> reportItems = reportDAO.getCourseReport(programFilter, searchKeyword);
        List<TrainingProgram> programs = tpDAO.getTrainingPrograms("", 1, 1000); 
        
        request.setAttribute("stats", stats);
        request.setAttribute("reportItems", reportItems);
        request.setAttribute("programs", programs);
        
        // Preserve filter inputs
        request.setAttribute("programFilter", programFilter);
        request.setAttribute("searchKeyword", searchKeyword);
        
        request.getRequestDispatcher("/view/Report.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
