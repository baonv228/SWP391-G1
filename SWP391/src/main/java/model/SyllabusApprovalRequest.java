package model;

import java.sql.Timestamp;

public class SyllabusApprovalRequest {
    private int requestId;
    private int syllabusId;
    private int requestedBy;
    private Integer reviewedBy;
    private String requestType;
    private String status;
    private String reviewNote;
    private Timestamp requestedAt;
    private Timestamp reviewedAt;

    public SyllabusApprovalRequest() {
    }

    public SyllabusApprovalRequest(int requestId, int syllabusId, int requestedBy, Integer reviewedBy, String requestType, String status, String reviewNote, Timestamp requestedAt, Timestamp reviewedAt) {
        this.requestId = requestId;
        this.syllabusId = syllabusId;
        this.requestedBy = requestedBy;
        this.reviewedBy = reviewedBy;
        this.requestType = requestType;
        this.status = status;
        this.reviewNote = reviewNote;
        this.requestedAt = requestedAt;
        this.reviewedAt = reviewedAt;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getSyllabusId() {
        return syllabusId;
    }

    public void setSyllabusId(int syllabusId) {
        this.syllabusId = syllabusId;
    }

    public int getRequestedBy() {
        return requestedBy;
    }

    public void setRequestedBy(int requestedBy) {
        this.requestedBy = requestedBy;
    }

    public Integer getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReviewNote() {
        return reviewNote;
    }

    public void setReviewNote(String reviewNote) {
        this.reviewNote = reviewNote;
    }

    public Timestamp getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
    }

    public Timestamp getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(Timestamp reviewedAt) {
        this.reviewedAt = reviewedAt;
    }
}
