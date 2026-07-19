package model;

import java.sql.Timestamp;

public class CurriculumSubjectPLO {
    private int curriculumSubjectPloId;
    private int curriculumId;
    private int curriculumSubjectId;
    private int ploId;
    private String contributionLevel;
    private String description;
    private Timestamp createdAt;
    private String curriculumSubjectClientKey;
    private String ploClientKey;

    public CurriculumSubjectPLO() {
    }

    public CurriculumSubjectPLO(int curriculumSubjectPloId, int curriculumId, int curriculumSubjectId,
                                int ploId, String contributionLevel, String description, Timestamp createdAt) {
        this.curriculumSubjectPloId = curriculumSubjectPloId;
        this.curriculumId = curriculumId;
        this.curriculumSubjectId = curriculumSubjectId;
        this.ploId = ploId;
        this.contributionLevel = contributionLevel;
        this.description = description;
        this.createdAt = createdAt;
    }

    public int getCurriculumSubjectPloId() {
        return curriculumSubjectPloId;
    }

    public void setCurriculumSubjectPloId(int curriculumSubjectPloId) {
        this.curriculumSubjectPloId = curriculumSubjectPloId;
    }

    public int getCurriculumId() {
        return curriculumId;
    }

    public void setCurriculumId(int curriculumId) {
        this.curriculumId = curriculumId;
    }

    public int getCurriculumSubjectId() {
        return curriculumSubjectId;
    }

    public void setCurriculumSubjectId(int curriculumSubjectId) {
        this.curriculumSubjectId = curriculumSubjectId;
    }

    public int getPloId() {
        return ploId;
    }

    public void setPloId(int ploId) {
        this.ploId = ploId;
    }

    public String getContributionLevel() {
        return contributionLevel;
    }

    public void setContributionLevel(String contributionLevel) {
        this.contributionLevel = contributionLevel;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCurriculumSubjectClientKey() {
        return curriculumSubjectClientKey;
    }

    public void setCurriculumSubjectClientKey(String curriculumSubjectClientKey) {
        this.curriculumSubjectClientKey = curriculumSubjectClientKey;
    }

    public String getPloClientKey() {
        return ploClientKey;
    }

    public void setPloClientKey(String ploClientKey) {
        this.ploClientKey = ploClientKey;
    }
}
