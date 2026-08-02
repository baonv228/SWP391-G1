-- ============================================================
-- NEW FEATURE: Assign Teacher to Training Program (major)
-- Only Training Department assigns teachers.
-- Teachers may upload materials only for syllabi under assigned programs.
-- Course List remains unfiltered (all majors visible).
-- ============================================================
-- Safe to re-run: skips create if table already exists.

IF OBJECT_ID(N'dbo.Teacher_Program', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Teacher_Program (
        TeacherProgramID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Teacher_Program PRIMARY KEY,
        UserID           INT NOT NULL,
        ProgramID        INT NOT NULL,
        AssignedAt       DATETIME2 NOT NULL CONSTRAINT DF_Teacher_Program_AssignedAt DEFAULT (SYSUTCDATETIME()),
        AssignedBy       INT NULL,
        CONSTRAINT UQ_Teacher_Program UNIQUE (UserID, ProgramID),
        CONSTRAINT FK_Teacher_Program_User
            FOREIGN KEY (UserID) REFERENCES dbo.[User](UserID),
        CONSTRAINT FK_Teacher_Program_Program
            FOREIGN KEY (ProgramID) REFERENCES dbo.Training_Program(ProgramID),
        CONSTRAINT FK_Teacher_Program_AssignedBy
            FOREIGN KEY (AssignedBy) REFERENCES dbo.[User](UserID)
    );

    CREATE INDEX IX_Teacher_Program_UserID ON dbo.Teacher_Program(UserID);
    CREATE INDEX IX_Teacher_Program_ProgramID ON dbo.Teacher_Program(ProgramID);
END
GO
