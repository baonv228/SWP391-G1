package dto;

import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class CurriculumDTO {
    private int curriculumId;
    // From Training_Program join
    private String programCode;
    private String programName;
    private String majorName;
    private String academicYear;
    // From Curriculum table
    private String curriculumName;
    private String description;
    private String status;
    // Computed from Curriculum_Subject
    private int totalCredits;
    private Map<Integer, List<SubjectDTO>> semesterSubjects;

    public CurriculumDTO() {
        this.semesterSubjects = new TreeMap<>();
    }

    // Alias: curriculumCode → programCode for JSP compatibility
    public String getCurriculumCode() { return programCode; }

    public int getCurriculumId() { return curriculumId; }
    public void setCurriculumId(int curriculumId) { this.curriculumId = curriculumId; }

    public String getProgramCode() { return programCode; }
    public void setProgramCode(String programCode) { this.programCode = programCode; }

    public String getProgramName() { return programName; }
    public void setProgramName(String programName) { this.programName = programName; }

    public String getMajorName() { return majorName; }
    public void setMajorName(String majorName) { this.majorName = majorName; }

    public String getAcademicYear() { return academicYear; }
    public void setAcademicYear(String academicYear) { this.academicYear = academicYear; }

    public String getCurriculumName() { return curriculumName; }
    public void setCurriculumName(String curriculumName) { this.curriculumName = curriculumName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getTotalCredits() { return totalCredits; }
    public void setTotalCredits(int totalCredits) { this.totalCredits = totalCredits; }

    public Map<Integer, List<SubjectDTO>> getSemesterSubjects() { return semesterSubjects; }
    public void setSemesterSubjects(Map<Integer, List<SubjectDTO>> semesterSubjects) { this.semesterSubjects = semesterSubjects; }
}
