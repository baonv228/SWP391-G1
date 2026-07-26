package model;

public class PoPlo {
    private int poId;
    private int ploId;

    public PoPlo() {
    }

    public PoPlo(int poId, int ploId) {
        this.poId = poId;
        this.ploId = ploId;
    }

    public int getPoId() {
        return poId;
    }

    public void setPoId(int poId) {
        this.poId = poId;
    }

    public int getPloId() {
        return ploId;
    }

    public void setPloId(int ploId) {
        this.ploId = ploId;
    }
}
