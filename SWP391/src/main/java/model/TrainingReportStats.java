package model;

public class TrainingReportStats {
    private int totalPrograms;
    private int totalCurriculums;
    private int totalSubjects;
    private int totalSyllabuses;

    public TrainingReportStats() {
    }

    public TrainingReportStats(int totalPrograms, int totalCurriculums, int totalSubjects, int totalSyllabuses) {
        this.totalPrograms = totalPrograms;
        this.totalCurriculums = totalCurriculums;
        this.totalSubjects = totalSubjects;
        this.totalSyllabuses = totalSyllabuses;
    }

    public int getTotalPrograms() {
        return totalPrograms;
    }

    public void setTotalPrograms(int totalPrograms) {
        this.totalPrograms = totalPrograms;
    }

    public int getTotalCurriculums() {
        return totalCurriculums;
    }

    public void setTotalCurriculums(int totalCurriculums) {
        this.totalCurriculums = totalCurriculums;
    }

    public int getTotalSubjects() {
        return totalSubjects;
    }

    public void setTotalSubjects(int totalSubjects) {
        this.totalSubjects = totalSubjects;
    }

    public int getTotalSyllabuses() {
        return totalSyllabuses;
    }

    public void setTotalSyllabuses(int totalSyllabuses) {
        this.totalSyllabuses = totalSyllabuses;
    }
}
