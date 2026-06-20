package model;

public class TrainingProgram {
    private int programId;
    private int createdBy;
    private String programCode;
    private String programName;
    private String academicYear;
    private String majorName;
    private String pno;
    private String description;
    private String status;
    private String createdByName;

    public TrainingProgram() {
    }

    public TrainingProgram(int programId, int createdBy, String programCode, String programName, String academicYear, String majorName, String pno, String description, String status) {
        this.programId = programId;
        this.createdBy = createdBy;
        this.programCode = programCode;
        this.programName = programName;
        this.academicYear = academicYear;
        this.majorName = majorName;
        this.pno = pno;
        this.description = description;
        this.status = status;
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

    public String getProgramCode() {
        return programCode;
    }

    public void setProgramCode(String programCode) {
        this.programCode = programCode;
    }

    public String getProgramName() {
        return programName;
    }

    public void setProgramName(String programName) {
        this.programName = programName;
    }

    public String getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(String academicYear) {
        this.academicYear = academicYear;
    }

    public String getMajorName() {
        return majorName;
    }

    public void setMajorName(String majorName) {
        this.majorName = majorName;
    }

    public String getPno() {
        return pno;
    }

    public void setPno(String pno) {
        this.pno = pno;
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

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }
}
