package model;

/**
 * Junction model: CLO ↔ PLO mapping.
 */
public class CloPlo {
    private int cloPloId;
    private int cloId;
    private int ploId;

    public CloPlo() {}

    public int getCloPloId() { return cloPloId; }
    public void setCloPloId(int cloPloId) { this.cloPloId = cloPloId; }

    public int getCloId() { return cloId; }
    public void setCloId(int cloId) { this.cloId = cloId; }

    public int getPloId() { return ploId; }
    public void setPloId(int ploId) { this.ploId = ploId; }
}
