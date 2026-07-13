package model;

import java.sql.Timestamp;

/** A report row generated from a version of a course syllabus. */
public class CourseReportItem {
    private int reportId;
    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private String courseDescription;
    private int credits;
    private String syllabusStatus;
    private String reportType;
    private String versionNo;
    private String associatedCurriculums;
    private String associatedPrograms;
    private String createdBy;
    private String modifiedBy;
    private Timestamp createdDate;
    private Timestamp lastModifiedDate;
    private int numberOfChanges;
    private String changeDetails;
    private String reviewer;
    private Timestamp reviewDate;

    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }
    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }
    public String getCourseDescription() { return courseDescription; }
    public void setCourseDescription(String courseDescription) { this.courseDescription = courseDescription; }
    public int getCredits() { return credits; }
    public void setCredits(int credits) { this.credits = credits; }
    public String getSyllabusStatus() { return syllabusStatus; }
    public void setSyllabusStatus(String syllabusStatus) { this.syllabusStatus = syllabusStatus; }
    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }
    public String getVersionNo() { return versionNo; }
    public void setVersionNo(String versionNo) { this.versionNo = versionNo; }
    public String getAssociatedCurriculums() { return associatedCurriculums; }
    public void setAssociatedCurriculums(String associatedCurriculums) { this.associatedCurriculums = associatedCurriculums; }
    public String getAssociatedPrograms() { return associatedPrograms; }
    public void setAssociatedPrograms(String associatedPrograms) { this.associatedPrograms = associatedPrograms; }
    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public String getModifiedBy() { return modifiedBy; }
    public void setModifiedBy(String modifiedBy) { this.modifiedBy = modifiedBy; }
    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }
    public Timestamp getLastModifiedDate() { return lastModifiedDate; }
    public void setLastModifiedDate(Timestamp lastModifiedDate) { this.lastModifiedDate = lastModifiedDate; }
    public int getNumberOfChanges() { return numberOfChanges; }
    public void setNumberOfChanges(int numberOfChanges) { this.numberOfChanges = numberOfChanges; }
    public String getChangeDetails() { return changeDetails; }
    public void setChangeDetails(String changeDetails) { this.changeDetails = changeDetails; }
    public String getReviewer() { return reviewer; }
    public void setReviewer(String reviewer) { this.reviewer = reviewer; }
    public Timestamp getReviewDate() { return reviewDate; }
    public void setReviewDate(Timestamp reviewDate) { this.reviewDate = reviewDate; }
}
