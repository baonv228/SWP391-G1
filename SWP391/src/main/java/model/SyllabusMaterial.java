package model;

public class SyllabusMaterial {
    private int materialId;
    private int syllabusId;
    private String materialDescription;
    private String author;
    private String publisher;
    private String publishedDate;
    private String edition;
    private String isbn;
    private boolean isMainMaterial;
    private boolean isHardCopy;
    private boolean isOnline;
    private String note;
    private int displayOrder;

    public SyllabusMaterial() {}

    public int getMaterialId() { return materialId; }
    public void setMaterialId(int materialId) { this.materialId = materialId; }

    public int getSyllabusId() { return syllabusId; }
    public void setSyllabusId(int syllabusId) { this.syllabusId = syllabusId; }

    public String getMaterialDescription() { return materialDescription; }
    public void setMaterialDescription(String materialDescription) { this.materialDescription = materialDescription; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }

    public String getPublishedDate() { return publishedDate; }
    public void setPublishedDate(String publishedDate) { this.publishedDate = publishedDate; }

    public String getEdition() { return edition; }
    public void setEdition(String edition) { this.edition = edition; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public boolean getIsMainMaterial() { return isMainMaterial; }
    public void setIsMainMaterial(boolean isMainMaterial) { this.isMainMaterial = isMainMaterial; }

    public boolean getIsHardCopy() { return isHardCopy; }
    public void setIsHardCopy(boolean isHardCopy) { this.isHardCopy = isHardCopy; }

    public boolean getIsOnline() { return isOnline; }
    public void setIsOnline(boolean isOnline) { this.isOnline = isOnline; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }
}
