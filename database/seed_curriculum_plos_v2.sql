USE [TPMS_DB]
GO

DECLARE @designerId INT = (SELECT TOP 1 UserID FROM [User] WHERE RoleID = 5); -- Syllabus Designer
DECLARE @subjectId INT = (SELECT TOP 1 SubjectID FROM Subject WHERE SubjectCode = 'SWP391');

IF @subjectId IS NOT NULL
BEGIN
    DECLARE @programId INT;

    -- 1. Create or Get Training Program (Academic Program)
    IF NOT EXISTS (SELECT 1 FROM Training_Program WHERE ProgramCode = 'SE')
    BEGIN
        INSERT INTO Training_Program (CreatedBy, ProgramCode, ProgramName, AcademicYear, MajorName, Description, Status)
        VALUES (@designerId, N'SE', N'Software Engineering (SE)', N'2026', N'Software Engineering', N'Bachelor of Software Engineering', N'Active');
        SET @programId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @programId = (SELECT TOP 1 ProgramID FROM Training_Program WHERE ProgramCode = 'SE');
    END
    
    -- 2. Create or Get Curriculum (Khung chương trình)
    DECLARE @curriculumId INT;
    IF NOT EXISTS (SELECT 1 FROM Curriculum WHERE ProgramID = @programId AND CurriculumName = 'SE Curriculum K17 (2026)')
    BEGIN
        INSERT INTO Curriculum (ProgramID, CreatedBy, CurriculumName, Description, Status)
        VALUES (@programId, @designerId, N'SE Curriculum K17 (2026)', N'Standard curriculum for SE K17', N'Active');
        SET @curriculumId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SET @curriculumId = (SELECT TOP 1 CurriculumID FROM Curriculum WHERE ProgramID = @programId AND CurriculumName = 'SE Curriculum K17 (2026)');
    END

    -- 3. Create PLOs for this specific Curriculum if they don't exist
    IF NOT EXISTS (SELECT 1 FROM PLO WHERE CurriculumID = @curriculumId)
    BEGIN
        INSERT INTO PLO (CurriculumID, PloCode, PloDescription) VALUES
        (@curriculumId, N'PLO1-K17', N'Apply knowledge of mathematics, science, and engineering to software development (K17 Standard)'),
        (@curriculumId, N'PLO2-K17', N'Design and conduct experiments, as well as analyze and interpret data (K17 Standard)'),
        (@curriculumId, N'PLO3-K17', N'Design a system, component, or process to meet desired needs (K17 Standard)'),
        (@curriculumId, N'PLO4-K17', N'Function on multidisciplinary teams (K17 Standard)'),
        (@curriculumId, N'PLO5-K17', N'Identify, formulate, and solve engineering problems (K17 Standard)'),
        (@curriculumId, N'PLO6-K17', N'Understand professional and ethical responsibility (K17 Standard)');
    END
    
    -- 4. Link Subject (SWP391) to Curriculum
    IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID = @curriculumId AND SubjectID = @subjectId)
    BEGIN
        INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, SubjectGroup, IsRequired, DisplayOrder)
        VALUES (@curriculumId, @subjectId, 5, N'Major', 1, 1);
    END
    
    PRINT 'Test Training Program, Curriculum K17, and PLOs created and linked to SWP391 successfully.'
END
ELSE
BEGIN
    PRINT 'Subject SWP391 not found. Please ensure seed_test_data.sql was run.'
END
GO
