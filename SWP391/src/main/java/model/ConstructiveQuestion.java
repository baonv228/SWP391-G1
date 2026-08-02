package model;

public class ConstructiveQuestion {
    private int questionId;
    private int syllabusId;
    private int sessionNo;
    private String name;
    private String details;
    private int displayOrder;

    public int getQuestionId() { return questionId; }
    public void setQuestionId(int value) { questionId = value; }
    public int getSyllabusId() { return syllabusId; }
    public void setSyllabusId(int value) { syllabusId = value; }
    public int getSessionNo() { return sessionNo; }
    public void setSessionNo(int value) { sessionNo = value; }
    public String getName() { return name; }
    public void setName(String value) { name = value; }
    public String getDetails() { return details; }
    public void setDetails(String value) { details = value; }
    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int value) { displayOrder = value; }
}
