package dto;

import java.util.List;

public class PrerequisiteDetailDTO {
    private SubjectDTO currentSubject;
    private List<SubjectDTO> prerequisites;
    private List<SubjectDTO> subsequents;

    public PrerequisiteDetailDTO() {}

    public SubjectDTO getCurrentSubject() { return currentSubject; }
    public void setCurrentSubject(SubjectDTO currentSubject) { this.currentSubject = currentSubject; }
    public List<SubjectDTO> getPrerequisites() { return prerequisites; }
    public void setPrerequisites(List<SubjectDTO> prerequisites) { this.prerequisites = prerequisites; }
    public List<SubjectDTO> getSubsequents() { return subsequents; }
    public void setSubsequents(List<SubjectDTO> subsequents) { this.subsequents = subsequents; }
}
