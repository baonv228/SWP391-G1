package model;

public class Curriculum {
    private int curriculumId;
    private int programId;
    private int createdBy;
    private String curriculumName;
    private String description;
    private String status;

    public Curriculum() {
    }

    public Curriculum(int curriculumId, int programId, int createdBy, String curriculumName, String description, String status) {
        this.curriculumId = curriculumId;
        this.programId = programId;
        this.createdBy = createdBy;
        this.curriculumName = curriculumName;
        this.description = description;
        this.status = status;
    }

    public int getCurriculumId() {
        return curriculumId;
    }

    public void setCurriculumId(int curriculumId) {
        this.curriculumId = curriculumId;
    }

    public int getProgramId() {
        return programId;
    }

    public void setProgramId(int programId) {
        this.programId = programId;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public String getCurriculumName() {
        return curriculumName;
    }

    public void setCurriculumName(String curriculumName) {
        this.curriculumName = curriculumName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
