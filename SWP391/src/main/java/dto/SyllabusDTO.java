package dto;

import java.util.List;

import java.sql.Timestamp;


public class SyllabusDTO {
    private int syllabusId;
    private String syllabusTitle;        // SyllabusTitle from Syllabus table
    private String syllabusEnglishName;  // same as title if no separate field
    private String subjectCode;          // from Subject join
    private String subjectName;          // from Subject join
    private String versionNo;            // VersionNo
    private String status;               // Status
    private boolean isCurrentVersion;    // IsCurrentVersion → used as "IsActive"
    private boolean isApproved;          // ApprovedBy IS NOT NULL → approved
    private String description;          // Description
    private String learningOutcome;      // LearningOutcome (raw text)
    private String assessmentMethod;     // AssessmentMethod
    private int credits;                 // Subject.Credits
    private Timestamp createdAt;
    private Timestamp approvedAt;

    // Extra display fields
    private List<String> learningOutcomes; // parsed list from learningOutcome text
    private List<SessionDTO> sessions;
    private List<MaterialDTO> materials;  // from Learning_Material table

    public static class SessionDTO {
        private int sessionNo;
        private String topic;
        private String learningTeachingType;
        private String lo;
        private String itu;
        private String studentMaterials;
        private String sDownload;
        private String studentTasks;
        private String urls;

        public SessionDTO() {}

        public int getSessionNo() { return sessionNo; }
        public void setSessionNo(int sessionNo) { this.sessionNo = sessionNo; }
        public String getTopic() { return topic; }
        public void setTopic(String topic) { this.topic = topic; }
        public String getLearningTeachingType() { return learningTeachingType; }
        public void setLearningTeachingType(String v) { this.learningTeachingType = v; }
        public String getLo() { return lo; }
        public void setLo(String lo) { this.lo = lo; }
        public String getItu() { return itu; }
        public void setItu(String itu) { this.itu = itu; }
        public String getStudentMaterials() { return studentMaterials; }
        public void setStudentMaterials(String v) { this.studentMaterials = v; }
        public String getSDownload() { return sDownload; }
        public void setSDownload(String sDownload) { this.sDownload = sDownload; }
        public String getStudentTasks() { return studentTasks; }
        public void setStudentTasks(String v) { this.studentTasks = v; }
        public String getUrls() { return urls; }
        public void setUrls(String urls) { this.urls = urls; }
    }

    public SyllabusDTO() {}

    public int getSyllabusId() { return syllabusId; }
    public void setSyllabusId(int syllabusId) { this.syllabusId = syllabusId; }

    public String getSyllabusTitle() { return syllabusTitle; }
    public void setSyllabusTitle(String syllabusTitle) { this.syllabusTitle = syllabusTitle; }

    // Alias for JSP compatibility — some JSPs use syllabusName
    public String getSyllabusName() { return syllabusTitle; }

    public String getSyllabusEnglishName() { return syllabusEnglishName; }
    public void setSyllabusEnglishName(String v) { this.syllabusEnglishName = v; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getVersionNo() { return versionNo; }
    public void setVersionNo(String versionNo) { this.versionNo = versionNo; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isCurrentVersion() { return isCurrentVersion; }
    // isActive maps to isCurrentVersion for display
    public boolean isActive() { return isCurrentVersion; }
    public void setCurrentVersion(boolean v) { this.isCurrentVersion = v; }
    public void setActive(boolean v) { this.isCurrentVersion = v; }

    public boolean isApproved() { return isApproved; }
    public void setApproved(boolean isApproved) { this.isApproved = isApproved; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLearningOutcome() { return learningOutcome; }
    public void setLearningOutcome(String learningOutcome) { this.learningOutcome = learningOutcome; }

    public String getAssessmentMethod() { return assessmentMethod; }
    public void setAssessmentMethod(String assessmentMethod) { this.assessmentMethod = assessmentMethod; }

    public int getCredits() { return credits; }
    public void setCredits(int credits) { this.credits = credits; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }

    public List<String> getLearningOutcomes() { return learningOutcomes; }
    public void setLearningOutcomes(List<String> learningOutcomes) { this.learningOutcomes = learningOutcomes; }

    public List<SessionDTO> getSessions() { return sessions; }
    public void setSessions(List<SessionDTO> sessions) { this.sessions = sessions; }

    public List<MaterialDTO> getMaterials() { return materials; }
    public void setMaterials(List<MaterialDTO> materials) { this.materials = materials; }
}
