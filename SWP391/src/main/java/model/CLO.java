package model;

public class CLO {
    private int cloId;
    private int syllabusId;
    private String cloName;
    private String cloDetails;
    private String loDetails;
    private int displayOrder;

    public CLO() {}

    public int getCloId() { return cloId; }
    public void setCloId(int cloId) { this.cloId = cloId; }

    public int getSyllabusId() { return syllabusId; }
    public void setSyllabusId(int syllabusId) { this.syllabusId = syllabusId; }

    public String getCloName() { return cloName; }
    public void setCloName(String cloName) { this.cloName = cloName; }

    public String getCloDetails() { return cloDetails; }
    public void setCloDetails(String cloDetails) { this.cloDetails = cloDetails; }

    public String getLoDetails() { return loDetails; }
    public void setLoDetails(String loDetails) { this.loDetails = loDetails; }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }
}
