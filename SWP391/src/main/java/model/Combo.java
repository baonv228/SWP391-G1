package model;

public class Combo {
    private int comboId;
    private int curriculumId;
    private String comboName;
    private String description;
    private String status;
    private Integer displayOrder;

    public Combo() {
    }

    public Combo(int comboId, int curriculumId, String comboName, String description, String status, Integer displayOrder) {
        this.comboId = comboId;
        this.curriculumId = curriculumId;
        this.comboName = comboName;
        this.description = description;
        this.status = status;
        this.displayOrder = displayOrder;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }
}
