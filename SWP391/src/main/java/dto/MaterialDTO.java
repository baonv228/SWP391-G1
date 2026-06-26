package dto;

import java.sql.Timestamp;

/**
 * Represents a single learning material entry from the Learning_Material table.
 * Used in Syllabus Detail page for the downloadable materials section.
 */
public class MaterialDTO {
    private int materialId;
    private int syllabusId;
    private String materialName;
    private String filePath;        // Server-side relative path, e.g. /materials/lab211/lab01.zip
    private String materialType;    // ZIP, PDF, PPTX, etc.
    private String visibility;      // Public / Private
    private String status;          // Active / Inactive
    private Timestamp uploadedAt;
    private long fileSizeBytes;     // 0 if not tracked

    public MaterialDTO() {}

    // Convenience: derive a user-friendly file size string
    public String getFileSizeDisplay() {
        if (fileSizeBytes <= 0) return "—";
        if (fileSizeBytes >= 1_048_576)
            return String.format("%.1f MB", fileSizeBytes / 1_048_576.0);
        if (fileSizeBytes >= 1024)
            return String.format("%.0f KB", fileSizeBytes / 1024.0);
        return fileSizeBytes + " B";
    }

    // Convenience: Bootstrap icon class by type
    public String getTypeIconClass() {
        if (materialType == null) return "bi-file-earmark";
        switch (materialType.toUpperCase()) {
            case "ZIP":  return "bi-file-earmark-zip-fill";
            case "PDF":  return "bi-file-earmark-pdf-fill";
            case "PPTX":
            case "PPT":  return "bi-file-earmark-slides-fill";
            case "DOCX":
            case "DOC":  return "bi-file-earmark-word-fill";
            case "MP4":
            case "AVI":  return "bi-film";
            default:     return "bi-file-earmark-arrow-down-fill";
        }
    }

    public int getMaterialId() { return materialId; }
    public void setMaterialId(int materialId) { this.materialId = materialId; }

    public int getSyllabusId() { return syllabusId; }
    public void setSyllabusId(int syllabusId) { this.syllabusId = syllabusId; }

    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public String getMaterialType() { return materialType; }
    public void setMaterialType(String materialType) { this.materialType = materialType; }

    public String getVisibility() { return visibility; }
    public void setVisibility(String visibility) { this.visibility = visibility; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }

    public long getFileSizeBytes() { return fileSizeBytes; }
    public void setFileSizeBytes(long fileSizeBytes) { this.fileSizeBytes = fileSizeBytes; }
}
