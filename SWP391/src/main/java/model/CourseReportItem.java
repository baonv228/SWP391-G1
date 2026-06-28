package model;

public class CourseReportItem {
    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private int credits;
    private String syllabusStatus;
    private String associatedCurriculums;
    private String associatedPrograms;

    public CourseReportItem() {
    }

    public CourseReportItem(int subjectId, String subjectCode, String subjectName, int credits, String syllabusStatus, String associatedCurriculums, String associatedPrograms) {
        this.subjectId = subjectId;
        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
        this.credits = credits;
        this.syllabusStatus = syllabusStatus;
        this.associatedCurriculums = associatedCurriculums;
        this.associatedPrograms = associatedPrograms;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getSubjectCode() {
        return subjectCode;
    }

    public void setSubjectCode(String subjectCode) {
        this.subjectCode = subjectCode;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public int getCredits() {
        return credits;
    }

    public void setCredits(int credits) {
        this.credits = credits;
    }

    public String getSyllabusStatus() {
        return syllabusStatus;
    }

    public void setSyllabusStatus(String syllabusStatus) {
        this.syllabusStatus = syllabusStatus;
    }

    public String getAssociatedCurriculums() {
        return associatedCurriculums;
    }

    public void setAssociatedCurriculums(String associatedCurriculums) {
        this.associatedCurriculums = associatedCurriculums;
    }

    public String getAssociatedPrograms() {
        return associatedPrograms;
    }

    public void setAssociatedPrograms(String associatedPrograms) {
        this.associatedPrograms = associatedPrograms;
    }
}
