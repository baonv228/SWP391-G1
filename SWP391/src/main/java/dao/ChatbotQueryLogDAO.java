package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.ChatbotQueryLog;

public class ChatbotQueryLogDAO extends DBContext {

    public int insertLog(ChatbotQueryLog log) {
        String sql = "INSERT INTO dbo.Chatbot_Query_Log (UserID, Question, Answer, SourceType, CreatedAt) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (log.getUserId() != null) {
                ps.setInt(1, log.getUserId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setString(2, log.getQuestion());
            ps.setString(3, log.getAnswer());
            ps.setString(4, log.getSourceType());
            ps.setTimestamp(5, log.getCreatedAt() != null ? log.getCreatedAt() : new Timestamp(System.currentTimeMillis()));
            
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("insertLog error: " + e.getMessage());
        }
        return -1;
    }

    public List<ChatbotQueryLog> getLogsByUserId(int userId) {
        List<ChatbotQueryLog> list = new ArrayList<>();
        String sql = "SELECT QueryID, UserID, Question, Answer, SourceType, CreatedAt FROM dbo.Chatbot_Query_Log WHERE UserID = ? ORDER BY CreatedAt ASC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatbotQueryLog log = new ChatbotQueryLog();
                    log.setQueryId(rs.getInt("QueryID"));
                    log.setUserId(rs.getInt("UserID"));
                    log.setQuestion(rs.getString("Question"));
                    log.setAnswer(rs.getString("Answer"));
                    log.setSourceType(rs.getString("SourceType"));
                    log.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    list.add(log);
                }
            }
        } catch (SQLException e) {
            System.err.println("getLogsByUserId error: " + e.getMessage());
        }
        return list;
    }
}
