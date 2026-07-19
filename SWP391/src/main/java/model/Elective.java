package model;

public class Elective {
    private int electiveId;
    private int curriculumId;
    private String electiveCode;
    private String electiveName;
    private String note;

    public Elective() {
    }

    public Elective(int electiveId, int curriculumId, String electiveCode, String electiveName, String note) {
        this.electiveId = electiveId;
        this.curriculumId = curriculumId;
        this.electiveCode = electiveCode;
        this.electiveName = electiveName;
        this.note = note;
    }

    public int getElectiveId() {
        return electiveId;
    }

    public void setElectiveId(int electiveId) {
        this.electiveId = electiveId;
    }

    public int getCurriculumId() {
        return curriculumId;
    }

    public void setCurriculumId(int curriculumId) {
        this.curriculumId = curriculumId;
    }

    public String getElectiveCode() {
        return electiveCode;
    }

    public void setElectiveCode(String electiveCode) {
        this.electiveCode = electiveCode;
    }

    public String getElectiveName() {
        return electiveName;
    }

    public void setElectiveName(String electiveName) {
        this.electiveName = electiveName;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    @Override
    public String toString() {
        return "Elective{" +
                "electiveId=" + electiveId +
                ", curriculumId=" + curriculumId +
                ", electiveCode='" + electiveCode + '\'' +
                ", electiveName='" + electiveName + '\'' +
                ", note='" + note + '\'' +
                '}';
    }
}
