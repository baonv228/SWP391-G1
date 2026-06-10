package model;

public class CurriculumSubject {
    private int curriculumSubjectId;
    private int curriculumId;
    private int subjectId;
    private Integer semesterNo;
    private String subjectGroup;
    private boolean required;
    private Integer displayOrder;

    public CurriculumSubject() {
    }

    public CurriculumSubject(int curriculumSubjectId, int curriculumId, int subjectId, Integer semesterNo, String subjectGroup, boolean required, Integer displayOrder) {
        this.curriculumSubjectId = curriculumSubjectId;
        this.curriculumId = curriculumId;
        this.subjectId = subjectId;
        this.semesterNo = semesterNo;
        this.subjectGroup = subjectGroup;
        this.required = required;
        this.displayOrder = displayOrder;
    }

    public int getCurriculumSubjectId() {
        return curriculumSubjectId;
    }

    public void setCurriculumSubjectId(int curriculumSubjectId) {
        this.curriculumSubjectId = curriculumSubjectId;
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

    public Integer getSemesterNo() {
        return semesterNo;
    }

    public void setSemesterNo(Integer semesterNo) {
        this.semesterNo = semesterNo;
    }

    public String getSubjectGroup() {
        return subjectGroup;
    }

    public void setSubjectGroup(String subjectGroup) {
        this.subjectGroup = subjectGroup;
    }

    public boolean isRequired() {
        return required;
    }

    public boolean getIsRequired() {
        return required;
    }

    public void setRequired(boolean required) {
        this.required = required;
    }

    public void setIsRequired(boolean required) {
        this.required = required;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }
}
