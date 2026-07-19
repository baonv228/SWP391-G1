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

    // ===== V2 NEW FIELDS =====
    private String syllabusName;
    private String syllabusEnglish;
    private String degreeLevel;
    private String timeAllocation;
    private String preRequisiteText;
    private String studentTasks;
    private String tools;
    private Integer scoringScale;
    private String decisionNo;
    private String note;
    private Double minAvgMarkToPass;
    private boolean isActive;

    // Transient — for display only
    private String subjectCode;
    private String subjectName;
    private String createdByName;

    public Syllabus() {
        this.isActive = true;
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
        this.isActive = true;
    }

    // ===== GETTERS & SETTERS (V1 fields) =====

    public int getSyllabusId() { return syllabusId; }
    public void setSyllabusId(int syllabusId) { this.syllabusId = syllabusId; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public Integer getApprovedBy() { return approvedBy; }
    public void setApprovedBy(Integer approvedBy) { this.approvedBy = approvedBy; }

    public String getVersionNo() { return versionNo; }
    public void setVersionNo(String versionNo) { this.versionNo = versionNo; }

    public String getSyllabusTitle() { return syllabusTitle; }
    public void setSyllabusTitle(String syllabusTitle) { this.syllabusTitle = syllabusTitle; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLearningOutcome() { return learningOutcome; }
    public void setLearningOutcome(String learningOutcome) { this.learningOutcome = learningOutcome; }

    public String getAssessmentMethod() { return assessmentMethod; }
    public void setAssessmentMethod(String assessmentMethod) { this.assessmentMethod = assessmentMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isCurrentVersion() { return currentVersion; }
    public boolean getIsCurrentVersion() { return currentVersion; }
    public void setCurrentVersion(boolean currentVersion) { this.currentVersion = currentVersion; }
    public void setIsCurrentVersion(boolean currentVersion) { this.currentVersion = currentVersion; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }

    // ===== GETTERS & SETTERS (V2 new fields) =====

    public String getSyllabusName() { return syllabusName; }
    public void setSyllabusName(String syllabusName) { this.syllabusName = syllabusName; }

    public String getSyllabusEnglish() { return syllabusEnglish; }
    public void setSyllabusEnglish(String syllabusEnglish) { this.syllabusEnglish = syllabusEnglish; }

    public String getDegreeLevel() { return degreeLevel; }
    public void setDegreeLevel(String degreeLevel) { this.degreeLevel = degreeLevel; }

    public String getTimeAllocation() { return timeAllocation; }
    public void setTimeAllocation(String timeAllocation) { this.timeAllocation = timeAllocation; }

    public String getPreRequisiteText() { return preRequisiteText; }
    public void setPreRequisiteText(String preRequisiteText) { this.preRequisiteText = preRequisiteText; }

    public String getStudentTasks() { return studentTasks; }
    public void setStudentTasks(String studentTasks) { this.studentTasks = studentTasks; }

    public String getTools() { return tools; }
    public void setTools(String tools) { this.tools = tools; }

    public Integer getScoringScale() { return scoringScale; }
    public void setScoringScale(Integer scoringScale) { this.scoringScale = scoringScale; }

    public String getDecisionNo() { return decisionNo; }
    public void setDecisionNo(String decisionNo) { this.decisionNo = decisionNo; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Double getMinAvgMarkToPass() { return minAvgMarkToPass; }
    public void setMinAvgMarkToPass(Double minAvgMarkToPass) { this.minAvgMarkToPass = minAvgMarkToPass; }

    public boolean getIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }

    // ===== Transient display fields =====
    private String materialFilePath;
    private String approvedByName;

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public String getMaterialFilePath() { return materialFilePath; }
    public void setMaterialFilePath(String materialFilePath) { this.materialFilePath = materialFilePath; }

    public String getApprovedByName() { return approvedByName; }
    public void setApprovedByName(String approvedByName) { this.approvedByName = approvedByName; }
}
