USE TPMS_DB;
GO

IF OBJECT_ID('dbo.Syllabus_Constructive_Question', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Syllabus_Constructive_Question (
        QuestionID  INT IDENTITY(1,1) PRIMARY KEY,
        SyllabusID  INT NOT NULL,
        SessionNo   INT NOT NULL,
        Name        NVARCHAR(255) NOT NULL,
        Details     NVARCHAR(MAX) NULL,
        DisplayOrder INT NOT NULL DEFAULT 0,
        CONSTRAINT FK_ConstructiveQuestion_Syllabus
            FOREIGN KEY (SyllabusID) REFERENCES dbo.Syllabus(SyllabusID)
            ON DELETE CASCADE
    );

    CREATE INDEX IX_ConstructiveQuestion_Syllabus
        ON dbo.Syllabus_Constructive_Question(SyllabusID, DisplayOrder, SessionNo);
END;
GO
