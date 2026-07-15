

/* =====================================================
   1. T?o unique index ?? s? d?ng composite foreign key
   ===================================================== */

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_CurriculumSubject_ID_Curriculum'
      AND object_id = OBJECT_ID('dbo.Curriculum_Subject')
)
BEGIN
    CREATE UNIQUE INDEX [UX_CurriculumSubject_ID_Curriculum]
    ON [dbo].[Curriculum_Subject]
    (
        [CurriculumSubjectID],
        [CurriculumID]
    );
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_PLO_ID_Curriculum'
      AND object_id = OBJECT_ID('dbo.PLO')
)
BEGIN
    CREATE UNIQUE INDEX [UX_PLO_ID_Curriculum]
    ON [dbo].[PLO]
    (
        [PloID],
        [CurriculumID]
    );
END
GO

/* =====================================================
   2. T?o b?ng Curriculum_Subject_PLO
   ===================================================== */

IF OBJECT_ID('dbo.Curriculum_Subject_PLO', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Curriculum_Subject_PLO]
    (
        [CurriculumSubjectPloID] INT IDENTITY(1,1) NOT NULL,
        [CurriculumID]           INT NOT NULL,
        [CurriculumSubjectID]    INT NOT NULL,
        [PloID]                  INT NOT NULL,

        [ContributionLevel]      VARCHAR(10) NULL,
        [Description]            NVARCHAR(500) NULL,
        [CreatedAt]              DATETIME2 NOT NULL
            CONSTRAINT [DF_CurriculumSubjectPLO_CreatedAt]
            DEFAULT SYSDATETIME(),

        CONSTRAINT [PK_Curriculum_Subject_PLO]
            PRIMARY KEY CLUSTERED ([CurriculumSubjectPloID]),

        CONSTRAINT [UQ_CurriculumSubject_PLO]
            UNIQUE ([CurriculumSubjectID], [PloID]),

        CONSTRAINT [FK_CurriculumSubjectPLO_Curriculum]
            FOREIGN KEY ([CurriculumID])
            REFERENCES [dbo].[Curriculum]([CurriculumID]),

        CONSTRAINT [FK_CurriculumSubjectPLO_CurriculumSubject]
            FOREIGN KEY ([CurriculumSubjectID], [CurriculumID])
            REFERENCES [dbo].[Curriculum_Subject]
            (
                [CurriculumSubjectID],
                [CurriculumID]
            ),

        CONSTRAINT [FK_CurriculumSubjectPLO_PLO]
            FOREIGN KEY ([PloID], [CurriculumID])
            REFERENCES [dbo].[PLO]
            (
                [PloID],
                [CurriculumID]
            ),

        CONSTRAINT [CK_CurriculumSubjectPLO_Level]
            CHECK (
                [ContributionLevel] IS NULL
                OR [ContributionLevel] IN ('I', 'R', 'M')
            )
    );

    PRINT 'CREATE TABLE Curriculum_Subject_PLO: Done.';
END
ELSE
BEGIN
    PRINT 'TABLE Curriculum_Subject_PLO already exists.';
END
GO