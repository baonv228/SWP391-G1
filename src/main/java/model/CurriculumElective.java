package model;

public class CurriculumElective {
    private int curriculumElectiveId;
    private int curriculumId;
    private int subjectId;
    private String electiveGroupName;
    private Integer requiredCredits;
    private Integer requiredSubjectCount;
    private Integer displayOrder;
    private String status;

    public CurriculumElective() {
    }

    public CurriculumElective(int curriculumElectiveId, int curriculumId, int subjectId, String electiveGroupName, Integer requiredCredits, Integer requiredSubjectCount, Integer displayOrder, String status) {
        this.curriculumElectiveId = curriculumElectiveId;
        this.curriculumId = curriculumId;
        this.subjectId = subjectId;
        this.electiveGroupName = electiveGroupName;
        this.requiredCredits = requiredCredits;
        this.requiredSubjectCount = requiredSubjectCount;
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

    public Integer getRequiredCredits() {
        return requiredCredits;
    }

    public void setRequiredCredits(Integer requiredCredits) {
        this.requiredCredits = requiredCredits;
    }

    public Integer getRequiredSubjectCount() {
        return requiredSubjectCount;
    }

    public void setRequiredSubjectCount(Integer requiredSubjectCount) {
        this.requiredSubjectCount = requiredSubjectCount;
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
}
