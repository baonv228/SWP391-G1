package model;

import java.util.ArrayList;
import java.util.List;

public class SyllabusSession {
    private int sessionId;
    private int syllabusId;
    private int sessionNumber;
    private String topic;
    private String learningTeachingType;
    private String itu;
    private String studentMaterials;
    private String sDownload;
    private String studentTasks;
    private String urls;
    private int displayOrder;

    // Transient — for CLO junction
    private List<Integer> cloIds = new ArrayList<>();

    public SyllabusSession() {}

    public int getSessionId() { return sessionId; }
    public void setSessionId(int sessionId) { this.sessionId = sessionId; }

    public int getSyllabusId() { return syllabusId; }
    public void setSyllabusId(int syllabusId) { this.syllabusId = syllabusId; }

    public int getSessionNumber() { return sessionNumber; }
    public void setSessionNumber(int sessionNumber) { this.sessionNumber = sessionNumber; }

    public String getTopic() { return topic; }
    public void setTopic(String topic) { this.topic = topic; }

    public String getLearningTeachingType() { return learningTeachingType; }
    public void setLearningTeachingType(String learningTeachingType) { this.learningTeachingType = learningTeachingType; }

    public String getItu() { return itu; }
    public void setItu(String itu) { this.itu = itu; }

    public String getStudentMaterials() { return studentMaterials; }
    public void setStudentMaterials(String studentMaterials) { this.studentMaterials = studentMaterials; }

    public String getSDownload() { return sDownload; }
    public void setSDownload(String sDownload) { this.sDownload = sDownload; }

    public String getStudentTasks() { return studentTasks; }
    public void setStudentTasks(String studentTasks) { this.studentTasks = studentTasks; }

    public String getUrls() { return urls; }
    public void setUrls(String urls) { this.urls = urls; }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }

    public List<Integer> getCloIds() { return cloIds; }
    public void setCloIds(List<Integer> cloIds) { this.cloIds = cloIds; }
}
