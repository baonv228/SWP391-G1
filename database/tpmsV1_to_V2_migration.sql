/*
============================================================
  TPMS Database Migration Script: V1 → V2
  Purpose: Add Syllabus Detail module tables
  Date: 2026-06-17
  
  Run this script if you ALREADY have tpmsV1.sql deployed.
  This script is IDEMPOTENT — safe to run multiple times.
============================================================
*/

USE [TPMS_DB]
GO

-- ============================================================
-- STEP 1: ALTER TABLE [Syllabus] — Add new columns
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Syllabus') AND name = 'SyllabusName')
BEGIN
    ALTER TABLE [dbo].[Syllabus] ADD
        [SyllabusName]      NVARCHAR(300) NULL,
        [SyllabusEnglish]   NVARCHAR(300) NULL,
        [DegreeLevel]       NVARCHAR(50)  NULL,
        [TimeAllocation]    NVARCHAR(500) NULL,
        [PreRequisiteText]  NVARCHAR(500) NULL,
        [StudentTasks]      NVARCHAR(MAX) NULL,
        [Tools]             NVARCHAR(MAX) NULL,
        [ScoringScale]      INT           NULL,
        [DecisionNo]        NVARCHAR(200) NULL,
        [Note]              NVARCHAR(MAX) NULL,
        [MinAvgMarkToPass]  DECIMAL(3,1)  NULL,
        [IsActive]          BIT           NOT NULL DEFAULT 1;

    PRINT 'ALTER TABLE [Syllabus]: Added 12 new columns.'
END
ELSE
BEGIN
    PRINT 'ALTER TABLE [Syllabus]: Columns already exist — skipped.'
END
GO

-- ============================================================
-- STEP 2: CREATE TABLE [Syllabus_Material]
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.Syllabus_Material') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[Syllabus_Material] (
        [MaterialID]          INT IDENTITY(1,1) NOT NULL,
        [SyllabusID]          INT              NOT NULL,
        [MaterialDescription] NVARCHAR(500)    NOT NULL,
        [Author]              NVARCHAR(300)    NULL,
        [Publisher]            NVARCHAR(200)    NULL,
        [PublishedDate]        NVARCHAR(50)     NULL,
        [Edition]             NVARCHAR(50)     NULL,
        [ISBN]                NVARCHAR(50)     NULL,
        [IsMainMaterial]      BIT              NOT NULL DEFAULT 0,
        [IsHardCopy]          BIT              NOT NULL DEFAULT 0,
        [IsOnline]            BIT              NOT NULL DEFAULT 0,
        [Note]                NVARCHAR(MAX)    NULL,
        [DisplayOrder]        INT              NULL,

        CONSTRAINT [PK_Syllabus_Material] PRIMARY KEY CLUSTERED ([MaterialID]),
        CONSTRAINT [FK_SyllabusMaterial_Syllabus] FOREIGN KEY ([SyllabusID])
            REFERENCES [dbo].[Syllabus]([SyllabusID])
    );
    PRINT 'CREATE TABLE [Syllabus_Material]: Done.'
END
ELSE
    PRINT 'TABLE [Syllabus_Material]: Already exists — skipped.'
GO

-- ============================================================
-- STEP 3: CREATE TABLE [CLO]
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.CLO') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[CLO] (
        [CLOID]        INT IDENTITY(1,1) NOT NULL,
        [SyllabusID]   INT              NOT NULL,
        [CLOName]      NVARCHAR(50)     NOT NULL,
        [CLODetails]   NVARCHAR(200)    NULL,
        [LODetails]    NVARCHAR(MAX)    NOT NULL,
        [DisplayOrder] INT              NULL,

        CONSTRAINT [PK_CLO] PRIMARY KEY CLUSTERED ([CLOID]),
        CONSTRAINT [FK_CLO_Syllabus] FOREIGN KEY ([SyllabusID])
            REFERENCES [dbo].[Syllabus]([SyllabusID])
    );
    PRINT 'CREATE TABLE [CLO]: Done.'
END
ELSE
    PRINT 'TABLE [CLO]: Already exists — skipped.'
GO

-- ============================================================
-- STEP 4: CREATE TABLE [Syllabus_Session]
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.Syllabus_Session') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[Syllabus_Session] (
        [SessionID]            INT IDENTITY(1,1) NOT NULL,
        [SyllabusID]           INT              NOT NULL,
        [SessionNumber]        INT              NOT NULL,
        [Topic]                NVARCHAR(500)    NOT NULL,
        [LearningTeachingType] NVARCHAR(200)    NULL,
        [ITU]                  NVARCHAR(300)    NULL,
        [StudentMaterials]     NVARCHAR(500)    NULL,
        [SDownload]            NVARCHAR(200)    NULL,
        [StudentTasks]         NVARCHAR(MAX)    NULL,
        [URLs]                 NVARCHAR(MAX)    NULL,
        [DisplayOrder]         INT              NULL,

        CONSTRAINT [PK_Syllabus_Session] PRIMARY KEY CLUSTERED ([SessionID]),
        CONSTRAINT [FK_SyllabusSession_Syllabus] FOREIGN KEY ([SyllabusID])
            REFERENCES [dbo].[Syllabus]([SyllabusID]),
        CONSTRAINT [UQ_Session_Number] UNIQUE ([SyllabusID], [SessionNumber])
    );
    PRINT 'CREATE TABLE [Syllabus_Session]: Done.'
END
ELSE
    PRINT 'TABLE [Syllabus_Session]: Already exists — skipped.'
GO

-- ============================================================
-- STEP 5: CREATE TABLE [Session_CLO] (Junction)
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.Session_CLO') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[Session_CLO] (
        [SessionCLOID] INT IDENTITY(1,1) NOT NULL,
        [SessionID]    INT NOT NULL,
        [CLOID]        INT NOT NULL,

        CONSTRAINT [PK_Session_CLO] PRIMARY KEY CLUSTERED ([SessionCLOID]),
        CONSTRAINT [FK_SessionCLO_Session] FOREIGN KEY ([SessionID])
            REFERENCES [dbo].[Syllabus_Session]([SessionID]),
        CONSTRAINT [FK_SessionCLO_CLO] FOREIGN KEY ([CLOID])
            REFERENCES [dbo].[CLO]([CLOID]),
        CONSTRAINT [UQ_Session_CLO] UNIQUE ([SessionID], [CLOID])
    );
    PRINT 'CREATE TABLE [Session_CLO]: Done.'
END
ELSE
    PRINT 'TABLE [Session_CLO]: Already exists — skipped.'
GO

-- ============================================================
-- STEP 6: CREATE TABLE [Syllabus_Assessment]
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.Syllabus_Assessment') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[Syllabus_Assessment] (
        [AssessmentID]       INT IDENTITY(1,1) NOT NULL,
        [SyllabusID]         INT              NOT NULL,
        [Category]           NVARCHAR(300)    NOT NULL,
        [Type]               NVARCHAR(50)     NULL,
        [Part]               INT              NULL,
        [Weight]             DECIMAL(5,2)     NOT NULL,
        [CompletionCriteria] NVARCHAR(200)    NULL,
        [Duration]           NVARCHAR(100)    NULL,
        [QuestionType]       NVARCHAR(MAX)    NULL,
        [NoQuestion]         NVARCHAR(100)    NULL,
        [KnowledgeAndSkill]  NVARCHAR(MAX)    NULL,
        [GradingGuide]       NVARCHAR(MAX)    NULL,
        [Note]               NVARCHAR(MAX)    NULL,
        [DisplayOrder]       INT              NULL,

        CONSTRAINT [PK_Syllabus_Assessment] PRIMARY KEY CLUSTERED ([AssessmentID]),
        CONSTRAINT [FK_SyllabusAssessment_Syllabus] FOREIGN KEY ([SyllabusID])
            REFERENCES [dbo].[Syllabus]([SyllabusID])
    );
    PRINT 'CREATE TABLE [Syllabus_Assessment]: Done.'
END
ELSE
    PRINT 'TABLE [Syllabus_Assessment]: Already exists — skipped.'
GO

-- ============================================================
-- STEP 7: CREATE TABLE [Assessment_CLO] (Junction)
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.Assessment_CLO') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[Assessment_CLO] (
        [AssessmentCLOID] INT IDENTITY(1,1) NOT NULL,
        [AssessmentID]    INT NOT NULL,
        [CLOID]           INT NOT NULL,

        CONSTRAINT [PK_Assessment_CLO] PRIMARY KEY CLUSTERED ([AssessmentCLOID]),
        CONSTRAINT [FK_AssessmentCLO_Assessment] FOREIGN KEY ([AssessmentID])
            REFERENCES [dbo].[Syllabus_Assessment]([AssessmentID]),
        CONSTRAINT [FK_AssessmentCLO_CLO] FOREIGN KEY ([CLOID])
            REFERENCES [dbo].[CLO]([CLOID]),
        CONSTRAINT [UQ_Assessment_CLO] UNIQUE ([AssessmentID], [CLOID])
    );
    PRINT 'CREATE TABLE [Assessment_CLO]: Done.'
END
ELSE
    PRINT 'TABLE [Assessment_CLO]: Already exists — skipped.'
GO

PRINT '============================================================'
PRINT '  Migration V1 → V2 completed successfully!'
PRINT '  Tables added/modified:'
PRINT '    [Syllabus]            — 12 new columns'
PRINT '    [Syllabus_Material]   — NEW'
PRINT '    [CLO]                 — NEW'
PRINT '    [Syllabus_Session]    — NEW'
PRINT '    [Session_CLO]         — NEW'
PRINT '    [Syllabus_Assessment] — NEW'
PRINT '    [Assessment_CLO]      — NEW'
PRINT '============================================================'
GO
