package dto;

import java.sql.Timestamp;

/**
 * DTO for the Syllabus_Approval_Request table.
 *
 * Table columns:
 *   RequestID, SyllabusID, RequestedBy, ReviewedBy,
 *   RequestType, Status, ReviewNote, RequestedAt, ReviewedAt
 */
public class SyllabusRequestDTO {
    private int requestId;
    private int syllabusId;
    private String syllabusTitle;   // from Syllabus join
    private String subjectCode;     // from Subject join
    private String subjectName;     // from Subject join
    private int requestedBy;
    private String requestedByName; // from User join
    private Integer reviewedBy;
    private String reviewedByName;
    private String requestType;     // "New" | "Modify" | "Deactivate"
    private String status;          // "Pending" | "Approved" | "Rejected"
    private String reviewNote;
    private Timestamp requestedAt;
    private Timestamp reviewedAt;

    public SyllabusRequestDTO() {}

    // Status badge helper
    public String getStatusBadgeClass() {
        if (status == null) return "bg-secondary";
        switch (status) {
            case "Approved": return "bg-success";
            case "Rejected": return "bg-danger";
            case "Pending":  return "bg-warning text-dark";
            default:         return "bg-secondary";
        }
    }

    // Getters & Setters
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getSyllabusId() { return syllabusId; }
    public void setSyllabusId(int syllabusId) { this.syllabusId = syllabusId; }

    public String getSyllabusTitle() { return syllabusTitle; }
    public void setSyllabusTitle(String syllabusTitle) { this.syllabusTitle = syllabusTitle; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public int getRequestedBy() { return requestedBy; }
    public void setRequestedBy(int requestedBy) { this.requestedBy = requestedBy; }

    public String getRequestedByName() { return requestedByName; }
    public void setRequestedByName(String requestedByName) { this.requestedByName = requestedByName; }

    public Integer getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }

    public String getReviewedByName() { return reviewedByName; }
    public void setReviewedByName(String reviewedByName) { this.reviewedByName = reviewedByName; }

    public String getRequestType() { return requestType; }
    public void setRequestType(String requestType) { this.requestType = requestType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getReviewNote() { return reviewNote; }
    public void setReviewNote(String reviewNote) { this.reviewNote = reviewNote; }

    public Timestamp getRequestedAt() { return requestedAt; }
    public void setRequestedAt(Timestamp requestedAt) { this.requestedAt = requestedAt; }

    public Timestamp getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(Timestamp reviewedAt) { this.reviewedAt = reviewedAt; }
}
