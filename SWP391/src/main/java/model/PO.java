package model;

public class PO {
    private int poId;
    private int curriculumId;
    private String poCode;
    private String poDescription;

    public PO() {
    }

    public PO(int poId, int curriculumId, String poCode, String poDescription) {
        this.poId = poId;
        this.curriculumId = curriculumId;
        this.poCode = poCode;
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

    public int getProgramId() {
        return curriculumId;
    }

    public void setProgramId(int programId) {
        this.curriculumId = programId;
    }

    public String getPoCode() {
        return poCode;
    }

    public void setPoCode(String poCode) {
        this.poCode = poCode;
    }

    public String getPoDescription() {
        return poDescription;
    }

    public void setPoDescription(String poDescription) {
        this.poDescription = poDescription;
    }
}
