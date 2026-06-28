package dto;

import java.util.List;
import java.util.Map;

public class LearningPathDTO {
    private int syllabusId;
    private String subjectCode;
    private String subjectName;
    private String syllabusName;
    private String decisionNo;
    // Key = subjectCode, Value = list of prerequisite descriptions (e.g. "Pass PRF192")
    private Map<String, List<String>> prerequisiteMap;

    public LearningPathDTO() {}

    public int getSyllabusId() { return syllabusId; }
    public void setSyllabusId(int syllabusId) { this.syllabusId = syllabusId; }
    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    public String getSyllabusName() { return syllabusName; }
    public void setSyllabusName(String syllabusName) { this.syllabusName = syllabusName; }
    public String getDecisionNo() { return decisionNo; }
    public void setDecisionNo(String decisionNo) { this.decisionNo = decisionNo; }
    public Map<String, List<String>> getPrerequisiteMap() { return prerequisiteMap; }
    public void setPrerequisiteMap(Map<String, List<String>> prerequisiteMap) { this.prerequisiteMap = prerequisiteMap; }
}
