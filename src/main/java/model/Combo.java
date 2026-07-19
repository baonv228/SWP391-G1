package model;

public class Combo {
    private int comboId;
    private int curriculumId;
    private String comboCode;
    private String comboName;
    private String description;

    public Combo() {
    }

    public Combo(int comboId, int curriculumId, String comboCode, String comboName, String description) {
        this.comboId = comboId;
        this.curriculumId = curriculumId;
        this.comboCode = comboCode;
        this.comboName = comboName;
        this.description = description;
    }

    public int getComboId() {
        return comboId;
    }

    public void setComboId(int comboId) {
        this.comboId = comboId;
    }

    public int getCurriculumId() {
        return curriculumId;
    }

    public void setCurriculumId(int curriculumId) {
        this.curriculumId = curriculumId;
    }

    public String getComboCode() {
        return comboCode;
    }

    public void setComboCode(String comboCode) {
        this.comboCode = comboCode;
    }

    public String getComboName() {
        return comboName;
    }

    public void setComboName(String comboName) {
        this.comboName = comboName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Combo{" +
                "comboId=" + comboId +
                ", curriculumId=" + curriculumId +
                ", comboCode='" + comboCode + '\'' +
                ", comboName='" + comboName + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
