package model;

public class ProgramLearningOutcome {
    private int ploId;
    private int curriculumId;
    private String ploName;
    private String ploDescription;

    public ProgramLearningOutcome() {
    }

    public ProgramLearningOutcome(int ploId, int curriculumId, String ploName, String ploDescription) {
        this.ploId = ploId;
        this.curriculumId = curriculumId;
        this.ploName = ploName;
        this.ploDescription = ploDescription;
    }

    public int getPloId() {
        return ploId;
    }

    public void setPloId(int ploId) {
        this.ploId = ploId;
    }

    public int getCurriculumId() {
        return curriculumId;
    }

    public void setCurriculumId(int curriculumId) {
        this.curriculumId = curriculumId;
    }

    public String getPloName() {
        return ploName;
    }

    public void setPloName(String ploName) {
        this.ploName = ploName;
    }

    public String getPloDescription() {
        return ploDescription;
    }

    public void setPloDescription(String ploDescription) {
        this.ploDescription = ploDescription;
    }

    @Override
    public String toString() {
        return "ProgramLearningOutcome{" +
                "ploId=" + ploId +
                ", curriculumId=" + curriculumId +
                ", ploName='" + ploName + '\'' +
                ", ploDescription='" + ploDescription + '\'' +
                '}';
    }
}
