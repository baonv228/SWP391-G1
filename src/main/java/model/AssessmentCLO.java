package model;

public class AssessmentCLO {
    private int assessmentCloId;
    private int assessmentId;
    private int cloId;

    public AssessmentCLO() {
    }

    public AssessmentCLO(int assessmentCloId, int assessmentId, int cloId) {
        this.assessmentCloId = assessmentCloId;
        this.assessmentId = assessmentId;
        this.cloId = cloId;
    }

    public int getAssessmentCloId() {
        return assessmentCloId;
    }

    public void setAssessmentCloId(int assessmentCloId) {
        this.assessmentCloId = assessmentCloId;
    }

    public int getAssessmentId() {
        return assessmentId;
    }

    public void setAssessmentId(int assessmentId) {
        this.assessmentId = assessmentId;
    }

    public int getCloId() {
        return cloId;
    }

    public void setCloId(int cloId) {
        this.cloId = cloId;
    }
}
