package model;

public class ComboSubject {
    private int comboSubjectId;
    private int comboId;
    private int subjectId;
    private Integer semesterNo;
    private Integer displayOrder;

    public ComboSubject() {
    }

    public ComboSubject(int comboSubjectId, int comboId, int subjectId, Integer semesterNo, Integer displayOrder) {
        this.comboSubjectId = comboSubjectId;
        this.comboId = comboId;
        this.subjectId = subjectId;
        this.semesterNo = semesterNo;
        this.displayOrder = displayOrder;
    }

    public int getComboSubjectId() {
        return comboSubjectId;
    }

    public void setComboSubjectId(int comboSubjectId) {
        this.comboSubjectId = comboSubjectId;
    }

    public int getComboId() {
        return comboId;
    }

    public void setComboId(int comboId) {
        this.comboId = comboId;
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

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }
}
