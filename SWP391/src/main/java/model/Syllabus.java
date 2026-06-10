package model;

import java.sql.Timestamp;

public class Syllabus {
    private int syllabusId;
    private int subjectId;
    private int createdBy;
    private Integer approvedBy;
    private String versionNo;
    private String syllabusTitle;
    private String description;
    private String learningOutcome;
    private String assessmentMethod;
    private String status;
    private boolean currentVersion;
    private Timestamp createdAt;
    private Timestamp approvedAt;

    public Syllabus() {
    }

    public Syllabus(int syllabusId, int subjectId, int createdBy, Integer approvedBy, String versionNo, String syllabusTitle, String description, String learningOutcome, String assessmentMethod, String status, boolean currentVersion, Timestamp createdAt, Timestamp approvedAt) {
        this.syllabusId = syllabusId;
        this.subjectId = subjectId;
        this.createdBy = createdBy;
        this.approvedBy = approvedBy;
        this.versionNo = versionNo;
        this.syllabusTitle = syllabusTitle;
        this.description = description;
        this.learningOutcome = learningOutcome;
        this.assessmentMethod = assessmentMethod;
        this.status = status;
        this.currentVersion = currentVersion;
        this.createdAt = createdAt;
        this.approvedAt = approvedAt;
    }

    public int getSyllabusId() {
        return syllabusId;
    }

    public void setSyllabusId(int syllabusId) {
        this.syllabusId = syllabusId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public String getVersionNo() {
        return versionNo;
    }

    public void setVersionNo(String versionNo) {
        this.versionNo = versionNo;
    }

    public String getSyllabusTitle() {
        return syllabusTitle;
    }

    public void setSyllabusTitle(String syllabusTitle) {
        this.syllabusTitle = syllabusTitle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLearningOutcome() {
        return learningOutcome;
    }

    public void setLearningOutcome(String learningOutcome) {
        this.learningOutcome = learningOutcome;
    }

    public String getAssessmentMethod() {
        return assessmentMethod;
    }

    public void setAssessmentMethod(String assessmentMethod) {
        this.assessmentMethod = assessmentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isCurrentVersion() {
        return currentVersion;
    }

    public boolean getIsCurrentVersion() {
        return currentVersion;
    }

    public void setCurrentVersion(boolean currentVersion) {
        this.currentVersion = currentVersion;
    }

    public void setIsCurrentVersion(boolean currentVersion) {
        this.currentVersion = currentVersion;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
    }
}
