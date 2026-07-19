-- =====================================================
-- Seed: Thêm 5 môn vào Curriculum "SE Curriculum 2026" (CurriculumID = 2)
-- và mapping PLO cho từng môn
-- =====================================================

USE TPMS_DB;
GO

-- =============================================
-- Bước 1: Gắn 5 Subject vào Curriculum (nếu chưa có)
-- =============================================
-- SubjectID=1 (SWP391), SubjectID=2 (SWR302), SubjectID=3 (SWE201c),
-- SubjectID=4 (PRN231), SubjectID=5 (DBI202)

IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=2 AND SubjectID=1)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, SubjectGroup, IsRequired, DisplayOrder)
    VALUES (2, 1, 5, N'Major', 1, 1);

IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=2 AND SubjectID=2)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, SubjectGroup, IsRequired, DisplayOrder)
    VALUES (2, 2, 5, N'Major', 1, 2);

IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=2 AND SubjectID=3)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, SubjectGroup, IsRequired, DisplayOrder)
    VALUES (2, 3, 3, N'Major', 1, 3);

IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=2 AND SubjectID=4)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, SubjectGroup, IsRequired, DisplayOrder)
    VALUES (2, 4, 6, N'Major', 1, 4);

IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=2 AND SubjectID=5)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, SubjectGroup, IsRequired, DisplayOrder)
    VALUES (2, 5, 3, N'Major', 1, 5);
GO

-- =============================================
-- Bước 2: Mapping PLO cho từng môn trong Curriculum
-- PLO (CurriculumID=2): PLO1(2), PLO2(3), PLO3(4), PLO4(5), PLO5(6), PLO6(7)
-- =============================================

-- Lấy CurriculumSubjectID cho từng Subject
DECLARE @cs_swp INT, @cs_swr INT, @cs_swe INT, @cs_prn INT, @cs_dbi INT;
SELECT @cs_swp = CurriculumSubjectID FROM Curriculum_Subject WHERE CurriculumID=2 AND SubjectID=1;
SELECT @cs_swr = CurriculumSubjectID FROM Curriculum_Subject WHERE CurriculumID=2 AND SubjectID=2;
SELECT @cs_swe = CurriculumSubjectID FROM Curriculum_Subject WHERE CurriculumID=2 AND SubjectID=3;
SELECT @cs_prn = CurriculumSubjectID FROM Curriculum_Subject WHERE CurriculumID=2 AND SubjectID=4;
SELECT @cs_dbi = CurriculumSubjectID FROM Curriculum_Subject WHERE CurriculumID=2 AND SubjectID=5;

PRINT 'CurriculumSubjectIDs: SWP=' + CAST(@cs_swp AS VARCHAR) + ', SWR=' + CAST(@cs_swr AS VARCHAR)
    + ', SWE=' + CAST(@cs_swe AS VARCHAR) + ', PRN=' + CAST(@cs_prn AS VARCHAR) + ', DBI=' + CAST(@cs_dbi AS VARCHAR);

-- Xóa dữ liệu cũ (nếu có) để seed lại sạch
DELETE FROM Curriculum_Subject_PLO WHERE CurriculumID = 2;

-- SWP391 (Software Development Project) -> PLO3 (Design system), PLO4 (Teamwork), PLO5 (Problem solving)
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_swp, 4, 'M');
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_swp, 5, 'R');
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_swp, 6, 'R');

-- SWR302 (Software Requirement) -> PLO1 (Apply knowledge), PLO2 (Analyze data), PLO5 (Problem solving)
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_swr, 2, 'R');
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_swr, 3, 'M');
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_swr, 6, 'I');

-- SWE201c (Intro to SE) -> PLO1 (Apply knowledge), PLO2 (Analyze), PLO6 (Ethics)
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_swe, 2, 'I');
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_swe, 3, 'I');
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_swe, 7, 'I');

-- PRN231 (.NET Web Dev) -> PLO1 (Apply knowledge), PLO3 (Design system), PLO5 (Problem solving)
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_prn, 2, 'R');
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_prn, 4, 'M');
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_prn, 6, 'R');

-- DBI202 (Database Systems) -> PLO1 (Apply knowledge), PLO3 (Design system), PLO6 (Ethics)
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_dbi, 2, 'M');
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_dbi, 4, 'R');
INSERT INTO Curriculum_Subject_PLO (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel) VALUES (2, @cs_dbi, 7, 'I');

GO

-- Kiểm tra kết quả
SELECT cs.CurriculumSubjectID, s.SubjectCode, s.SubjectName, p.PloCode, csp.ContributionLevel
FROM Curriculum_Subject_PLO csp
JOIN Curriculum_Subject cs ON csp.CurriculumSubjectID = cs.CurriculumSubjectID
JOIN Subject s ON cs.SubjectID = s.SubjectID
JOIN PLO p ON csp.PloID = p.PloID
WHERE csp.CurriculumID = 2
ORDER BY s.SubjectCode, p.PloCode;
