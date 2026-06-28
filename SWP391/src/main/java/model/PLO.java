package model;

public class PLO {
    private int ploId;
    private int programId;
    private String ploCode;
    private String ploDescription;

    public PLO() {
    }

    public PLO(int ploId, int programId, String ploCode, String ploDescription) {
        this.ploId = ploId;
        this.programId = programId;
        this.ploCode = ploCode;
        this.ploDescription = ploDescription;
    }

    public int getPloId() {
        return ploId;
    }

    public void setPloId(int ploId) {
        this.ploId = ploId;
    }

    public int getProgramId() {
        return programId;
    }

    public void setProgramId(int programId) {
        this.programId = programId;
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
