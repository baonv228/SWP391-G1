package model;

public class PO {
    private int poId;
    private int programId;
    private String poCode;
    private String poDescription;

    public PO() {
    }

    public PO(int poId, int programId, String poCode, String poDescription) {
        this.poId = poId;
        this.programId = programId;
        this.poCode = poCode;
        this.poDescription = poDescription;
    }

    public int getPoId() {
        return poId;
    }

    public void setPoId(int poId) {
        this.poId = poId;
    }

    public int getProgramId() {
        return programId;
    }

    public void setProgramId(int programId) {
        this.programId = programId;
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
