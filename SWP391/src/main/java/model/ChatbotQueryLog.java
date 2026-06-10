package model;

import java.sql.Timestamp;

public class ChatbotQueryLog {
    private int queryId;
    private Integer userId;
    private String question;
    private String answer;
    private String sourceType;
    private Timestamp createdAt;

    public ChatbotQueryLog() {
    }

    public ChatbotQueryLog(int queryId, Integer userId, String question, String answer, String sourceType, Timestamp createdAt) {
        this.queryId = queryId;
        this.userId = userId;
        this.question = question;
        this.answer = answer;
        this.sourceType = sourceType;
        this.createdAt = createdAt;
    }

    public int getQueryId() {
        return queryId;
    }

    public void setQueryId(int queryId) {
        this.queryId = queryId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getSourceType() {
        return sourceType;
    }

    public void setSourceType(String sourceType) {
        this.sourceType = sourceType;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
