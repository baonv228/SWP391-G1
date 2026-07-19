package model;

import java.sql.Timestamp;

public class LearningMaterial {
    private int materialId;
    private int syllabusId;
    private int uploadedBy;
    private String materialName;
    private String filePath;
    private String materialType;
    private String visibility;
    private String status;
    private Timestamp uploadedAt;

    public LearningMaterial() {
    }

    public LearningMaterial(int materialId, int syllabusId, int uploadedBy, String materialName, String filePath, String materialType, String visibility, String status, Timestamp uploadedAt) {
        this.materialId = materialId;
        this.syllabusId = syllabusId;
        this.uploadedBy = uploadedBy;
        this.materialName = materialName;
        this.filePath = filePath;
        this.materialType = materialType;
        this.visibility = visibility;
        this.status = status;
        this.uploadedAt = uploadedAt;
    }

    public int getMaterialId() {
        return materialId;
    }

    public void setMaterialId(int materialId) {
        this.materialId = materialId;
    }

    public int getSyllabusId() {
        return syllabusId;
    }

    public void setSyllabusId(int syllabusId) {
        this.syllabusId = syllabusId;
    }

    public int getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(int uploadedBy) {
        this.uploadedBy = uploadedBy;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getMaterialType() {
        return materialType;
    }

    public void setMaterialType(String materialType) {
        this.materialType = materialType;
    }

    public String getVisibility() {
        return visibility;
    }

    public void setVisibility(String visibility) {
        this.visibility = visibility;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}
