package model;

import java.util.ArrayList;
import java.util.List;

public class SyllabusAssessment {
    private int assessmentId;
    private int syllabusId;
    private String category;
    private String type;
    private Integer part;
    private double weight;
    private String completionCriteria;
    private String duration;
    private String questionType;
    private String noQuestion;
    private String knowledgeAndSkill;
    private String gradingGuide;
    private String note;
    private int displayOrder;

    // Transient — for CLO junction
    private List<Integer> cloIds = new ArrayList<>();

    public SyllabusAssessment() {}

    public int getAssessmentId() { return assessmentId; }
    public void setAssessmentId(int assessmentId) { this.assessmentId = assessmentId; }

    public int getSyllabusId() { return syllabusId; }
    public void setSyllabusId(int syllabusId) { this.syllabusId = syllabusId; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Integer getPart() { return part; }
    public void setPart(Integer part) { this.part = part; }

    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }

    public String getCompletionCriteria() { return completionCriteria; }
    public void setCompletionCriteria(String completionCriteria) { this.completionCriteria = completionCriteria; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }

    public String getNoQuestion() { return noQuestion; }
    public void setNoQuestion(String noQuestion) { this.noQuestion = noQuestion; }

    public String getKnowledgeAndSkill() { return knowledgeAndSkill; }
    public void setKnowledgeAndSkill(String knowledgeAndSkill) { this.knowledgeAndSkill = knowledgeAndSkill; }

    public String getGradingGuide() { return gradingGuide; }
    public void setGradingGuide(String gradingGuide) { this.gradingGuide = gradingGuide; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }

    public List<Integer> getCloIds() { return cloIds; }
    public void setCloIds(List<Integer> cloIds) { this.cloIds = cloIds; }
}
