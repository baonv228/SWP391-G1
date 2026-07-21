package model;

public class ProgramOutcome {
    private int poId;
    private int curriculumId;
    private String poName;
    private String poDescription;

    public ProgramOutcome() {
    }

    public ProgramOutcome(int poId, int curriculumId, String poName, String poDescription) {
        this.poId = poId;
        this.curriculumId = curriculumId;
        this.poName = poName;
        this.poDescription = poDescription;
    }

    public int getPoId() {
        return poId;
    }

    public void setPoId(int poId) {
        this.poId = poId;
    }

    public int getCurriculumId() {
        return curriculumId;
    }

    public void setCurriculumId(int curriculumId) {
        this.curriculumId = curriculumId;
    }

    public String getPoName() {
        return poName;
    }

    public void setPoName(String poName) {
        this.poName = poName;
    }

    public String getPoDescription() {
        return poDescription;
    }

    public void setPoDescription(String poDescription) {
        this.poDescription = poDescription;
    }

    @Override
    public String toString() {
        return "ProgramOutcome{" +
                "poId=" + poId +
                ", curriculumId=" + curriculumId +
                ", poName='" + poName + '\'' +
                ", poDescription='" + poDescription + '\'' +
                '}';
    }
}
