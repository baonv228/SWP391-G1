package model;

public class ElectiveSubject {
    private int electiveId;
    private int subjectId;

    public ElectiveSubject() {
    }

    public ElectiveSubject(int electiveId, int subjectId) {
        this.electiveId = electiveId;
        this.subjectId = subjectId;
    }

    public int getElectiveId() {
        return electiveId;
    }

    public void setElectiveId(int electiveId) {
        this.electiveId = electiveId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }
}
