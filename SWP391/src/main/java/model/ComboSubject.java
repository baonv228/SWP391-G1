package model;

public class ComboSubject {
    private int comboId;
    private int subjectId;
    private String note;
    
    // Transient fields for displaying subject details
    private String subjectCode;
    private String subjectName;

    public ComboSubject() {
    }

    public ComboSubject(int comboId, int subjectId, String note) {
        this.comboId = comboId;
        this.subjectId = subjectId;
        this.note = note;
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

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
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
}
