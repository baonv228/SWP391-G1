package dto;

public class SubjectDTO {
    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private int credits;
    private int semester;
    private String status;
    private boolean required;

    public SubjectDTO() {}

    public SubjectDTO(int subjectId, String subjectCode, String subjectName, int credits, int semester, String status) {
        this.subjectId = subjectId;
        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
        this.credits = credits;
        this.semester = semester;
        this.status = status;
    }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    public int getCredits() { return credits; }
    public void setCredits(int credits) { this.credits = credits; }
    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public boolean isRequired() { return required; }
    public void setRequired(boolean required) { this.required = required; }
}
