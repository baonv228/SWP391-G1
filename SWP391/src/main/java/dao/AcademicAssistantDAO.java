package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AcademicAssistantDAO extends DBContext {

    public String getAcademicContext() {
        StringBuilder sb = new StringBuilder();
        sb.append("# FPT ACADEMIC REFERENCE CATALOG DATA\n\n");

        try (Connection con = getConnection()) {
            // 1) CURRICULUM CATALOG
            sb.append("## 1. CURRICULUM STRUCTURES\n");
            String sqlCurr = """
                SELECT c.CurriculumID, c.CurriculumName, tp.ProgramName, s.SubjectCode, s.SubjectName, s.Credits, cs.SemesterNo, cs.IsRequired, cs.SubjectGroup
                FROM dbo.Curriculum c
                JOIN dbo.Training_Program tp ON c.ProgramID = tp.ProgramID
                JOIN dbo.Curriculum_Subject cs ON c.CurriculumID = cs.CurriculumID
                JOIN dbo.Subject s ON cs.SubjectID = s.SubjectID
                ORDER BY c.CurriculumID, cs.SemesterNo, cs.DisplayOrder
                """;
            try (PreparedStatement ps = con.prepareStatement(sqlCurr);
                 ResultSet rs = ps.executeQuery()) {
                int lastCurId = -1;
                while (rs.next()) {
                    int curId = rs.getInt("CurriculumID");
                    if (curId != lastCurId) {
                        sb.append(String.format("\n- **Curriculum**: %s (ID: %d) under Program '%s'\n", 
                                rs.getString("CurriculumName"), curId, rs.getString("ProgramName")));
                        lastCurId = curId;
                    }
                    sb.append(String.format("  * Semester %d: Môn '%s' - %s (%d tín chỉ, %s, %s)\n",
                            rs.getInt("SemesterNo"),
                            rs.getString("SubjectCode"),
                            rs.getString("SubjectName"),
                            rs.getInt("Credits"),
                            rs.getBoolean("IsRequired") ? "Bắt buộc" : "Tự chọn",
                            rs.getString("SubjectGroup")));
                }
            }

            // 2) SUBJECT PREREQUISITES
            sb.append("\n## 2. SUBJECT PREREQUISITES (ĐIỀU KIỆN TIÊN QUYẾT)\n");
            String sqlPrereq = """
                SELECT s.SubjectCode AS TargetCode, req.SubjectCode AS RequiredCode, sp.ConditionType
                FROM dbo.Subject_Prerequisite sp
                JOIN dbo.Subject s ON sp.SubjectID = s.SubjectID
                JOIN dbo.Subject req ON sp.RequiredSubjectID = req.SubjectID
                """;
            try (PreparedStatement ps = con.prepareStatement(sqlPrereq);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sb.append(String.format("- Môn **%s** yêu cầu hoàn thành môn tiên quyết **%s** (%s).\n",
                            rs.getString("TargetCode"),
                            rs.getString("RequiredCode"),
                            rs.getString("ConditionType")));
                }
            }

            // 3) SYLLABI DETAILS & CLOs & ASSESSMENTS
            sb.append("\n## 3. COURSE SYLLABI & ASSESSMENTS\n");
            String sqlSyllabus = """
                SELECT sy.SyllabusID, s.SubjectCode, s.SubjectName, s.Description AS SubjectDesc,
                       sy.SyllabusTitle, sy.Description AS SyllabusDesc, sy.LearningOutcome, sy.AssessmentMethod,
                       sy.DegreeLevel, sy.TimeAllocation, sy.Tools, sy.MinAvgMarkToPass, sy.VersionNo,
                       sy.SyllabusName, sy.SyllabusEnglish, sy.PreRequisiteText, sy.StudentTasks,
                       sy.ScoringScale, sy.DecisionNo, sy.Note
                FROM dbo.Syllabus sy
                JOIN dbo.Subject s ON sy.SubjectID = s.SubjectID
                """;
            try (PreparedStatement ps = con.prepareStatement(sqlSyllabus);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int syllabusId = rs.getInt("SyllabusID");
                    String subCode = rs.getString("SubjectCode");
                    sb.append(String.format("\n### Course: %s - %s\n", subCode, rs.getString("SubjectName")));
                    sb.append(String.format("- **Link chi tiết đề cương & tài liệu**: [/syllabus/detail?syllabusId=%d](Xem syllabus %s)\n", syllabusId, subCode));
                    sb.append(String.format("- **Syllabus**: %s (Version: %s, ID: %d)\n", rs.getString("SyllabusTitle"), rs.getString("VersionNo"), syllabusId));
                    sb.append(String.format("- **Tên Tiếng Việt**: %s\n", rs.getString("SyllabusName")));
                    sb.append(String.format("- **Tên Tiếng Anh**: %s\n", rs.getString("SyllabusEnglish")));
                    sb.append(String.format("- **Mã Quyết Định (Decision No)**: %s\n", rs.getString("DecisionNo")));
                    sb.append(String.format("- **Mức Học (Degree Level)**: %s\n", rs.getString("DegreeLevel")));
                    sb.append(String.format("- **Thang Điểm (Scoring Scale)**: %s/10\n", rs.getString("ScoringScale")));
                    sb.append(String.format("- **Môn tiên quyết (Prerequisite Text)**: %s\n", rs.getString("PreRequisiteText")));
                    sb.append(String.format("- **Mô tả Môn Học (Subject Description)**: %s\n", rs.getString("SubjectDesc")));
                    sb.append(String.format("- **Mô tả Đề Cương (Syllabus Description)**: %s\n", rs.getString("SyllabusDesc")));
                    sb.append(String.format("- **Mục tiêu / LO (Learning Outcome)**: %s\n", rs.getString("LearningOutcome")));
                    sb.append(String.format("- **Nhiệm vụ Sinh viên (Student Tasks)**: %s\n", rs.getString("StudentTasks")));
                    sb.append(String.format("- **Thời lượng**: %s\n", rs.getString("TimeAllocation")));
                    sb.append(String.format("- **Công cụ (Tools)**: %s\n", rs.getString("Tools")));
                    sb.append(String.format("- **Điểm tối thiểu qua môn**: %s\n", rs.getString("MinAvgMarkToPass")));
                    sb.append(String.format("- **Ghi chú**: %s\n", rs.getString("Note")));

                    // Fetch Course Learning Outcomes (CLOs)
                    String sqlClo = "SELECT CLOName, CLODetails, LODetails FROM dbo.CLO WHERE SyllabusID = ? ORDER BY DisplayOrder";
                    try (PreparedStatement psClo = con.prepareStatement(sqlClo)) {
                        psClo.setInt(1, syllabusId);
                        try (ResultSet rsClo = psClo.executeQuery()) {
                            sb.append("- **Course Learning Outcomes (CLO)**:\n");
                            while (rsClo.next()) {
                                sb.append(String.format("  * **%s**: %s (%s)\n", 
                                        rsClo.getString("CLOName"), rsClo.getString("CLODetails"), rsClo.getString("LODetails")));
                            }
                        }
                    }

                    // Fetch Textbook / Syllabus Materials
                    String sqlTextbook = "SELECT MaterialDescription, Author, Publisher, PublishedDate, Edition, ISBN, IsMainMaterial, IsHardCopy, IsOnline, Note FROM dbo.Syllabus_Material WHERE SyllabusID = ? ORDER BY DisplayOrder";
                    try (PreparedStatement psTextbook = con.prepareStatement(sqlTextbook)) {
                        psTextbook.setInt(1, syllabusId);
                        try (ResultSet rsTextbook = psTextbook.executeQuery()) {
                            sb.append("- **Giáo trình & Tài liệu học tập (Textbooks)**:\n");
                            while (rsTextbook.next()) {
                                sb.append(String.format("  * **%s** của tác giả %s (NXB %s, Xuất bản: %s, Tái bản: %s, ISBN: %s) [%s, %s, %s] %s\n",
                                        rsTextbook.getString("MaterialDescription"),
                                        rsTextbook.getString("Author"),
                                        rsTextbook.getString("Publisher"),
                                        rsTextbook.getString("PublishedDate"),
                                        rsTextbook.getString("Edition"),
                                        rsTextbook.getString("ISBN"),
                                        rsTextbook.getBoolean("IsMainMaterial") ? "Tài liệu chính" : "Tài liệu phụ",
                                        rsTextbook.getBoolean("IsHardCopy") ? "Bản cứng" : "Không có bản cứng",
                                        rsTextbook.getBoolean("IsOnline") ? "Có bản online" : "Không có bản online",
                                        rsTextbook.getString("Note") != null ? "- Ghi chú: " + rsTextbook.getString("Note") : ""));
                            }
                        }
                    }

                    // Fetch Assessments
                    String sqlAssess = "SELECT Category, Type, Weight, CompletionCriteria, Duration, KnowledgeAndSkill, Note FROM dbo.Syllabus_Assessment WHERE SyllabusID = ? ORDER BY DisplayOrder";
                    try (PreparedStatement psAssess = con.prepareStatement(sqlAssess)) {
                        psAssess.setInt(1, syllabusId);
                        try (ResultSet rsAssess = psAssess.executeQuery()) {
                            sb.append("- **Cấu trúc đánh giá (Assessment Method & Weights)**:\n");
                            while (rsAssess.next()) {
                                sb.append(String.format("  * [%s / %s] Trọng số %s%% - Tiêu chí: %s (Thời gian: %s). Chi tiết: %s. %s\n",
                                        rsAssess.getString("Category"),
                                        rsAssess.getString("Type"),
                                        rsAssess.getBigDecimal("Weight"),
                                        rsAssess.getString("CompletionCriteria"),
                                        rsAssess.getString("Duration"),
                                        rsAssess.getString("KnowledgeAndSkill"),
                                        rsAssess.getString("Note")));
                            }
                        }
                    }
                }
            }

            // 4) LEARNING PATH & SESSIONS
            sb.append("\n## 4. STUDY SESSIONS & ROADMAPS (LEARNING PATH / PROGRESS)\n");
            String sqlSessions = """
                SELECT sy.SyllabusID, s.SubjectCode, ss.SessionNumber, ss.Topic, ss.LearningTeachingType, ss.StudentMaterials, ss.StudentTasks
                FROM dbo.Syllabus_Session ss
                JOIN dbo.Syllabus sy ON ss.SyllabusID = sy.SyllabusID
                JOIN dbo.Subject s ON sy.SubjectID = s.SubjectID
                ORDER BY s.SubjectCode, ss.SessionNumber
                """;
            try (PreparedStatement ps = con.prepareStatement(sqlSessions);
                 ResultSet rs = ps.executeQuery()) {
                String lastCode = "";
                while (rs.next()) {
                    String subCode = rs.getString("SubjectCode");
                    if (!subCode.equals(lastCode)) {
                        sb.append(String.format("\n### Roadmap cho môn %s:\n", subCode));
                        lastCode = subCode;
                    }
                    sb.append(String.format("- **Session %d**: %s [%s]\n",
                            rs.getInt("SessionNumber"),
                            rs.getString("Topic"),
                            rs.getString("LearningTeachingType")));
                    sb.append(String.format("  * Tài liệu: %s\n", rs.getString("StudentMaterials")));
                    sb.append(String.format("  * Nhiệm vụ sinh viên: %s\n", rs.getString("StudentTasks")));
                }
            }

            // 5) LEARNING MATERIALS (access via Syllabus Detail page)
            sb.append("\n## 5. LEARNING MATERIALS BY COURSE (tải tài liệu tại trang Syllabus Detail)\n");
            String sqlMaterials = """
                SELECT sy.SyllabusID, s.SubjectCode, s.SubjectName, lm.MaterialName, lm.MaterialType
                FROM dbo.Learning_Material lm
                JOIN dbo.Syllabus sy ON lm.SyllabusID = sy.SyllabusID
                JOIN dbo.Subject s ON sy.SubjectID = s.SubjectID
                WHERE lm.Status = 'Active'
                ORDER BY s.SubjectCode, lm.MaterialName
                """;
            try (PreparedStatement ps = con.prepareStatement(sqlMaterials);
                 ResultSet rs = ps.executeQuery()) {
                int lastSyllabusId = -1;
                while (rs.next()) {
                    int syllabusId = rs.getInt("SyllabusID");
                    if (syllabusId != lastSyllabusId) {
                        if (lastSyllabusId != -1) {
                            sb.append(String.format("  → [Xem chi tiết & tải tài liệu môn học](/syllabus/detail?syllabusId=%d)\n\n", lastSyllabusId));
                        }
                        sb.append(String.format("- Môn **%s** - %s:\n",
                                rs.getString("SubjectCode"),
                                rs.getString("SubjectName")));
                        lastSyllabusId = syllabusId;
                    }
                    sb.append(String.format("  * %s (%s)\n",
                            rs.getString("MaterialName"),
                            rs.getString("MaterialType")));
                }
                if (lastSyllabusId != -1) {
                    sb.append(String.format("  → [Xem chi tiết & tải tài liệu môn học](/syllabus/detail?syllabusId=%d)\n", lastSyllabusId));
                }
            }

            // 6) COMBOS
            sb.append("\n## 6. SPECIFIC COURSE COMBOS\n");
            String sqlCombos = """
                SELECT c.comboCode, c.comboName, c.description, s.SubjectCode, s.SubjectName
                FROM dbo.Combo c
                LEFT JOIN dbo.ComboSubject cs ON c.comboId = cs.comboId
                LEFT JOIN dbo.Subject s ON cs.subjectId = s.SubjectID
                ORDER BY c.comboCode
                """;
            try (PreparedStatement ps = con.prepareStatement(sqlCombos);
                 ResultSet rs = ps.executeQuery()) {
                String lastCombo = "";
                while (rs.next()) {
                    String code = rs.getString("comboCode");
                    if (!code.equals(lastCombo)) {
                        sb.append(String.format("\n- **Combo %s**: %s - %s\n", code, rs.getString("comboName"), rs.getString("description")));
                        sb.append("  * Danh sách môn học trong combo này:\n");
                        lastCombo = code;
                    }
                    if (rs.getString("SubjectCode") != null) {
                        sb.append(String.format("    - %s (%s)\n", rs.getString("SubjectCode"), rs.getString("SubjectName")));
                    }
                }
            }

            // 7) ELECTIVES
            sb.append("\n## 7. ELECTIVE GROUPS\n");
            String sqlElectives = """
                SELECT e.electiveCode, e.electiveName, e.note, s.SubjectCode, s.SubjectName
                FROM dbo.Elective e
                LEFT JOIN dbo.ElectiveSubject es ON e.electiveId = es.electiveId
                LEFT JOIN dbo.Subject s ON es.subjectId = s.SubjectID
                ORDER BY e.electiveCode
                """;
            try (PreparedStatement ps = con.prepareStatement(sqlElectives);
                 ResultSet rs = ps.executeQuery()) {
                String lastElective = "";
                while (rs.next()) {
                    String code = rs.getString("electiveCode");
                    if (!code.equals(lastElective)) {
                        sb.append(String.format("\n- **Elective Group %s**: %s (Ghi chú: %s)\n", code, rs.getString("electiveName"), rs.getString("note")));
                        sb.append("  * Môn học tùy chọn thuộc nhóm này:\n");
                        lastElective = code;
                    }
                    if (rs.getString("SubjectCode") != null) {
                        sb.append(String.format("    - %s (%s)\n", rs.getString("SubjectCode"), rs.getString("SubjectName")));
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("getAcademicContext error: " + e.getMessage());
            sb.append("\n*Lỗi truy xuất cơ sở dữ liệu học tập.*");
        }

        return sb.toString();
    }
}
