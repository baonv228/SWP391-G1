package model;

/**
 * Program Learning Outcome — belongs to a Training_Program.
 * Table managed by Curriculum team.
 */
public class PLO {
    private int ploId;
    private int curriculumId;
    private String ploCode;
    private String ploDescription;

    public PLO() {
    }

    public PLO(int ploId, int curriculumId, String ploCode, String ploDescription) {
        this.ploId = ploId;
        this.curriculumId = curriculumId;
        this.ploCode = ploCode;
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

    public int getProgramId() {
        return curriculumId;
    }

    public void setProgramId(int programId) {
        this.curriculumId = programId;
    }

    public void setCurriculumId(int curriculumId) {
        this.curriculumId = curriculumId;
    }

    public String getPloCode() {
        return ploCode;
    }

    public void setPloCode(String ploCode) {
        this.ploCode = ploCode;
    }

    public String getPloDescription() {
        return ploDescription;
    }

    public void setPloDescription(String ploDescription) {
        this.ploDescription = ploDescription;
    }
}
