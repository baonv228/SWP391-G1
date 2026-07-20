package controller.curriculum;

import dao.AcademicAssistantDAO;
import dao.ChatbotQueryLogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import model.ChatbotQueryLog;
import model.User;
import service.DeepSeekAIService;

@WebServlet(name = "AIAssistantServlet", urlPatterns = {"/ai-assistant"})
public class AIAssistantServlet extends HttpServlet {

    private final ChatbotQueryLogDAO logDAO = new ChatbotQueryLogDAO();
    private final AcademicAssistantDAO assistantDAO = new AcademicAssistantDAO();
    private final DeepSeekAIService aiService = new DeepSeekAIService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<ChatbotQueryLog> logs = logDAO.getLogsByUserId(user.getUserId());
        request.setAttribute("chatLogs", logs);

        request.getRequestDispatcher("/view/curriculum/ai-assistant.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendErrorJSON(response, "Unauthorized. Please log in.");
            return;
        }

        String question = request.getParameter("question");
        if (question == null || question.trim().isEmpty()) {
            sendErrorJSON(response, "Question cannot be empty.");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        try {
            // Retrieve latest database academic context dynamically
            String context = assistantDAO.getAcademicContext();
            
            // Get AI answer from DeepSeek
            String answer = aiService.askAssistant(question.trim(), context);

            // Log query transaction
            ChatbotQueryLog log = new ChatbotQueryLog();
            log.setUserId(user.getUserId());
            log.setQuestion(question.trim());
            log.setAnswer(answer);
            log.setSourceType("Web Chatbot");
            log.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            logDAO.insertLog(log);

            // Send successful response back to AJAX client
            sendSuccessJSON(response, answer);

        } catch (Exception e) {
            getServletContext().log("Error in AIAssistantServlet POST handler", e);
            sendErrorJSON(response, "Đã xảy ra lỗi khi kết nối với máy chủ AI. Vui lòng thử lại sau.");
        }
    }

    private void sendSuccessJSON(HttpServletResponse response, String answer) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Escape backslashes and double quotes in Gson / JSON
        com.google.gson.JsonObject obj = new com.google.gson.JsonObject();
        obj.addProperty("success", true);
        obj.addProperty("answer", answer);
        
        response.getWriter().write(obj.toString());
    }

    private void sendErrorJSON(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        com.google.gson.JsonObject obj = new com.google.gson.JsonObject();
        obj.addProperty("success", false);
        obj.addProperty("message", message);
        
        response.getWriter().write(obj.toString());
    }
}
