package model;

public class CurriculumElective {
    private int curriculumElectiveId;
    private int curriculumId;
    private int subjectId;
    private String electiveGroupName;
    private Integer displayOrder;
    private String status;
    private String subjectCode;
    private String subjectName;
    private int credits;

    public CurriculumElective() {
    }

    public CurriculumElective(int curriculumElectiveId, int curriculumId, int subjectId, String electiveGroupName, Integer displayOrder, String status) {
        this.curriculumElectiveId = curriculumElectiveId;
        this.curriculumId = curriculumId;
        this.subjectId = subjectId;
        this.electiveGroupName = electiveGroupName;
        this.displayOrder = displayOrder;
        this.status = status;
    }

    public int getCurriculumElectiveId() {
        return curriculumElectiveId;
    }

    public void setCurriculumElectiveId(int curriculumElectiveId) {
        this.curriculumElectiveId = curriculumElectiveId;
    }

    public int getCurriculumId() {
        return curriculumId;
    }

    public void setCurriculumId(int curriculumId) {
        this.curriculumId = curriculumId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getElectiveGroupName() {
        return electiveGroupName;
    }

    public void setElectiveGroupName(String electiveGroupName) {
        this.electiveGroupName = electiveGroupName;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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
}
