package model;

import java.sql.Timestamp;

public class SyllabusFeedback {
    private int feedbackId;
    private int syllabusId;
    private int userId;
    private String feedbackContent;
    private String status;
    private Timestamp createdAt;

    public SyllabusFeedback() {
    }

    public SyllabusFeedback(int feedbackId, int syllabusId, int userId, String feedbackContent, String status, Timestamp createdAt) {
        this.feedbackId = feedbackId;
        this.syllabusId = syllabusId;
        this.userId = userId;
        this.feedbackContent = feedbackContent;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getSyllabusId() {
        return syllabusId;
    }

    public void setSyllabusId(int syllabusId) {
        this.syllabusId = syllabusId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFeedbackContent() {
        return feedbackContent;
    }

    public void setFeedbackContent(String feedbackContent) {
        this.feedbackContent = feedbackContent;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
