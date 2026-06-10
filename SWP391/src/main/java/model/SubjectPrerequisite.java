package model;

public class SubjectPrerequisite {
    private int prerequisiteId;
    private int subjectId;
    private int requiredSubjectId;
    private String conditionType;
    private String description;

    public SubjectPrerequisite() {
    }

    public SubjectPrerequisite(int prerequisiteId, int subjectId, int requiredSubjectId, String conditionType, String description) {
        this.prerequisiteId = prerequisiteId;
        this.subjectId = subjectId;
        this.requiredSubjectId = requiredSubjectId;
        this.conditionType = conditionType;
        this.description = description;
    }

    public int getPrerequisiteId() {
        return prerequisiteId;
    }

    public void setPrerequisiteId(int prerequisiteId) {
        this.prerequisiteId = prerequisiteId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public int getRequiredSubjectId() {
        return requiredSubjectId;
    }

    public void setRequiredSubjectId(int requiredSubjectId) {
        this.requiredSubjectId = requiredSubjectId;
    }

    public String getConditionType() {
        return conditionType;
    }

    public void setConditionType(String conditionType) {
        this.conditionType = conditionType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
