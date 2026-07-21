package model;

public class ConstructiveQuestion {
    private int questionId;
    private int syllabusId;
    private int sessionNo;
    private String name;
    private String details;
    private int displayOrder;

    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public int getSyllabusId() { return syllabusId; }
    public void setSyllabusId(int syllabusId) { this.syllabusId = syllabusId; }
    public int getSessionNo() { return sessionNo; }
    public void setSessionNo(int sessionNo) { this.sessionNo = sessionNo; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }
    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }
}
