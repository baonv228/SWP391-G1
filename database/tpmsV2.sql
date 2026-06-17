/*
============================================================
  TPMS Database — Version 2 (Full Script)
  Purpose: Complete database with Syllabus Detail module
  Date: 2026-06-17
  
  This is a FRESH install script. 
  Use tpmsV1_to_V2_migration.sql if you already have V1.
============================================================
*/

USE [master]
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'TPMS_DB')
BEGIN
    ALTER DATABASE [TPMS_DB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE [TPMS_DB]
END
GO

CREATE DATABASE [TPMS_DB]
GO

USE [TPMS_DB]
GO

-- ============================================================
-- CORE TABLES (from V1)
-- ============================================================

CREATE TABLE [dbo].[Role](
    [RoleID]      INT IDENTITY(1,1) NOT NULL,
    [RoleName]    NVARCHAR(50) NOT NULL,
    [Description] NVARCHAR(255) NULL,
    PRIMARY KEY CLUSTERED ([RoleID])
)
GO

CREATE TABLE [dbo].[User](
    [UserID]       INT IDENTITY(1,1) NOT NULL,
    [RoleID]       INT NOT NULL,
    [Email]        NVARCHAR(100) NOT NULL,
    [PasswordHash] NVARCHAR(255) NOT NULL,
    [FullName]     NVARCHAR(100) NOT NULL,
    [Status]       NVARCHAR(30) NOT NULL DEFAULT 'Active',
    [CreatedAt]    DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY CLUSTERED ([UserID]),
    CONSTRAINT [FK_User_Role] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Role]([RoleID])
)
GO

CREATE TABLE [dbo].[Training_Program](
    [ProgramID]    INT IDENTITY(1,1) NOT NULL,
    [CreatedBy]    INT NOT NULL,
    [ProgramCode]  NVARCHAR(50) NOT NULL,
    [ProgramName]  NVARCHAR(150) NOT NULL,
    [AcademicYear] NVARCHAR(20) NULL,
    [MajorName]    NVARCHAR(150) NULL,
    [PNO]          NVARCHAR(50) NULL,
    [Description]  NVARCHAR(MAX) NULL,
    [Status]       NVARCHAR(30) NOT NULL DEFAULT 'Active',
    PRIMARY KEY CLUSTERED ([ProgramID]),
    CONSTRAINT [FK_TrainingProgram_User] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User]([UserID])
)
GO

CREATE TABLE [dbo].[Subject](
    [SubjectID]   INT IDENTITY(1,1) NOT NULL,
    [CreatedBy]   INT NOT NULL,
    [SubjectCode] NVARCHAR(50) NOT NULL,
    [SubjectName] NVARCHAR(150) NOT NULL,
    [Credits]     INT NOT NULL,
    [Description] NVARCHAR(MAX) NULL,
    [Status]      NVARCHAR(30) NOT NULL DEFAULT 'WaitingForSyllabus',
    PRIMARY KEY CLUSTERED ([SubjectID]),
    CONSTRAINT [FK_Subject_User] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User]([UserID])
)
GO

CREATE TABLE [dbo].[Subject_Prerequisite](
    [PrerequisiteID]    INT IDENTITY(1,1) NOT NULL,
    [SubjectID]         INT NOT NULL,
    [RequiredSubjectID] INT NOT NULL,
    [ConditionType]     NVARCHAR(50) NULL,
    [Description]       NVARCHAR(MAX) NULL,
    PRIMARY KEY CLUSTERED ([PrerequisiteID]),
    CONSTRAINT [FK_SubjectPrerequisite_Subject] FOREIGN KEY ([SubjectID]) REFERENCES [dbo].[Subject]([SubjectID]),
    CONSTRAINT [FK_SubjectPrerequisite_RequiredSubject] FOREIGN KEY ([RequiredSubjectID]) REFERENCES [dbo].[Subject]([SubjectID]),
    CONSTRAINT [CK_SubjectPrerequisite_NotSelf] CHECK ([SubjectID] <> [RequiredSubjectID])
)
GO

CREATE TABLE [dbo].[Curriculum](
    [CurriculumID]   INT IDENTITY(1,1) NOT NULL,
    [ProgramID]      INT NOT NULL,
    [CreatedBy]      INT NOT NULL,
    [CurriculumName] NVARCHAR(150) NOT NULL,
    [Description]    NVARCHAR(MAX) NULL,
    [Status]         NVARCHAR(30) NOT NULL DEFAULT 'Active',
    PRIMARY KEY CLUSTERED ([CurriculumID]),
    CONSTRAINT [FK_Curriculum_TrainingProgram] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[Training_Program]([ProgramID]),
    CONSTRAINT [FK_Curriculum_User] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User]([UserID])
)
GO

CREATE TABLE [dbo].[Curriculum_Subject](
    [CurriculumSubjectID] INT IDENTITY(1,1) NOT NULL,
    [CurriculumID]        INT NOT NULL,
    [SubjectID]           INT NOT NULL,
    [SemesterNo]          INT NULL,
    [SubjectGroup]        NVARCHAR(50) NULL,
    [IsRequired]          BIT NOT NULL DEFAULT 1,
    [DisplayOrder]        INT NULL,
    PRIMARY KEY CLUSTERED ([CurriculumSubjectID]),
    CONSTRAINT [FK_CurriculumSubject_Curriculum] FOREIGN KEY ([CurriculumID]) REFERENCES [dbo].[Curriculum]([CurriculumID]),
    CONSTRAINT [FK_CurriculumSubject_Subject] FOREIGN KEY ([SubjectID]) REFERENCES [dbo].[Subject]([SubjectID]),
    CONSTRAINT [UQ_CurriculumSubject] UNIQUE ([CurriculumID], [SubjectID])
)
GO

CREATE TABLE [dbo].[Curriculum_Elective](
    [CurriculumElectiveID] INT IDENTITY(1,1) NOT NULL,
    [CurriculumID]         INT NOT NULL,
    [SubjectID]            INT NOT NULL,
    [ElectiveGroupName]    NVARCHAR(150) NULL,
    [RequiredCredits]      INT NULL,
    [RequiredSubjectCount] INT NULL,
    [DisplayOrder]         INT NULL,
    [Status]               NVARCHAR(30) NOT NULL DEFAULT 'Active',
    PRIMARY KEY CLUSTERED ([CurriculumElectiveID]),
    CONSTRAINT [FK_CurriculumElective_Curriculum] FOREIGN KEY ([CurriculumID]) REFERENCES [dbo].[Curriculum]([CurriculumID]),
    CONSTRAINT [FK_CurriculumElective_Subject] FOREIGN KEY ([SubjectID]) REFERENCES [dbo].[Subject]([SubjectID]),
    CONSTRAINT [UQ_CurriculumElective] UNIQUE ([CurriculumID], [SubjectID])
)
GO

CREATE TABLE [dbo].[Combo](
    [ComboID]      INT IDENTITY(1,1) NOT NULL,
    [CurriculumID] INT NOT NULL,
    [ComboName]    NVARCHAR(150) NOT NULL,
    [Description]  NVARCHAR(MAX) NULL,
    [Status]       NVARCHAR(30) NOT NULL DEFAULT 'Active',
    [DisplayOrder] INT NULL,
    PRIMARY KEY CLUSTERED ([ComboID]),
    CONSTRAINT [FK_Combo_Curriculum] FOREIGN KEY ([CurriculumID]) REFERENCES [dbo].[Curriculum]([CurriculumID])
)
GO

CREATE TABLE [dbo].[Combo_Subject](
    [ComboSubjectID] INT IDENTITY(1,1) NOT NULL,
    [ComboID]        INT NOT NULL,
    [SubjectID]      INT NOT NULL,
    [SemesterNo]     INT NULL,
    [DisplayOrder]   INT NULL,
    PRIMARY KEY CLUSTERED ([ComboSubjectID]),
    CONSTRAINT [FK_ComboSubject_Combo] FOREIGN KEY ([ComboID]) REFERENCES [dbo].[Combo]([ComboID]),
    CONSTRAINT [FK_ComboSubject_Subject] FOREIGN KEY ([SubjectID]) REFERENCES [dbo].[Subject]([SubjectID]),
    CONSTRAINT [UQ_ComboSubject] UNIQUE ([ComboID], [SubjectID])
)
GO

-- ============================================================
-- SYLLABUS TABLE (V2 — EXPANDED)
-- ============================================================

CREATE TABLE [dbo].[Syllabus](
    [SyllabusID]       INT IDENTITY(1,1) NOT NULL,
    [SubjectID]        INT NOT NULL,
    [CreatedBy]        INT NOT NULL,
    [ApprovedBy]       INT NULL,
    [VersionNo]        NVARCHAR(30) NOT NULL,
    [SyllabusTitle]    NVARCHAR(200) NOT NULL,
    [Description]      NVARCHAR(MAX) NULL,
    [LearningOutcome]  NVARCHAR(MAX) NULL,
    [AssessmentMethod] NVARCHAR(MAX) NULL,
    [Status]           NVARCHAR(30) NOT NULL DEFAULT 'Draft',
    [IsCurrentVersion] BIT NOT NULL DEFAULT 0,
    [CreatedAt]        DATETIME NOT NULL DEFAULT GETDATE(),
    [ApprovedAt]       DATETIME NULL,
    -- ===== V2 NEW COLUMNS =====
    [SyllabusName]     NVARCHAR(300) NULL,
    [SyllabusEnglish]  NVARCHAR(300) NULL,
    [DegreeLevel]      NVARCHAR(50) NULL,
    [TimeAllocation]   NVARCHAR(500) NULL,
    [PreRequisiteText] NVARCHAR(500) NULL,
    [StudentTasks]     NVARCHAR(MAX) NULL,
    [Tools]            NVARCHAR(MAX) NULL,
    [ScoringScale]     INT NULL,
    [DecisionNo]       NVARCHAR(200) NULL,
    [Note]             NVARCHAR(MAX) NULL,
    [MinAvgMarkToPass] DECIMAL(3,1) NULL,
    [IsActive]         BIT NOT NULL DEFAULT 1,

    PRIMARY KEY CLUSTERED ([SyllabusID]),
    CONSTRAINT [FK_Syllabus_Subject] FOREIGN KEY ([SubjectID]) REFERENCES [dbo].[Subject]([SubjectID]),
    CONSTRAINT [FK_Syllabus_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User]([UserID]),
    CONSTRAINT [FK_Syllabus_ApprovedBy] FOREIGN KEY ([ApprovedBy]) REFERENCES [dbo].[User]([UserID])
)
GO

-- ============================================================
-- SYLLABUS SUPPORT TABLES (from V1)
-- ============================================================

CREATE TABLE [dbo].[Learning_Material](
    [MaterialID]   INT IDENTITY(1,1) NOT NULL,
    [SyllabusID]   INT NOT NULL,
    [UploadedBy]   INT NOT NULL,
    [MaterialName] NVARCHAR(200) NOT NULL,
    [FilePath]     NVARCHAR(500) NOT NULL,
    [MaterialType] NVARCHAR(50) NULL,
    [Visibility]   NVARCHAR(30) NOT NULL DEFAULT 'Public',
    [Status]       NVARCHAR(30) NOT NULL DEFAULT 'Active',
    [UploadedAt]   DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY CLUSTERED ([MaterialID]),
    CONSTRAINT [FK_LearningMaterial_Syllabus] FOREIGN KEY ([SyllabusID]) REFERENCES [dbo].[Syllabus]([SyllabusID]),
    CONSTRAINT [FK_LearningMaterial_User] FOREIGN KEY ([UploadedBy]) REFERENCES [dbo].[User]([UserID])
)
GO

CREATE TABLE [dbo].[Syllabus_Approval_Request](
    [RequestID]   INT IDENTITY(1,1) NOT NULL,
    [SyllabusID]  INT NOT NULL,
    [RequestedBy] INT NOT NULL,
    [ReviewedBy]  INT NULL,
    [RequestType] NVARCHAR(50) NOT NULL,
    [Status]      NVARCHAR(30) NOT NULL DEFAULT 'Pending',
    [ReviewNote]  NVARCHAR(MAX) NULL,
    [RequestedAt] DATETIME NOT NULL DEFAULT GETDATE(),
    [ReviewedAt]  DATETIME NULL,
    PRIMARY KEY CLUSTERED ([RequestID]),
    CONSTRAINT [FK_ApprovalRequest_Syllabus] FOREIGN KEY ([SyllabusID]) REFERENCES [dbo].[Syllabus]([SyllabusID]),
    CONSTRAINT [FK_ApprovalRequest_RequestedBy] FOREIGN KEY ([RequestedBy]) REFERENCES [dbo].[User]([UserID]),
    CONSTRAINT [FK_ApprovalRequest_ReviewedBy] FOREIGN KEY ([ReviewedBy]) REFERENCES [dbo].[User]([UserID])
)
GO

CREATE TABLE [dbo].[Syllabus_Feedback](
    [FeedbackID]      INT IDENTITY(1,1) NOT NULL,
    [SyllabusID]      INT NOT NULL,
    [UserID]          INT NOT NULL,
    [FeedbackContent] NVARCHAR(MAX) NOT NULL,
    [Status]          NVARCHAR(30) NOT NULL DEFAULT 'Open',
    [CreatedAt]       DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY CLUSTERED ([FeedbackID]),
    CONSTRAINT [FK_SyllabusFeedback_Syllabus] FOREIGN KEY ([SyllabusID]) REFERENCES [dbo].[Syllabus]([SyllabusID]),
    CONSTRAINT [FK_SyllabusFeedback_User] FOREIGN KEY ([UserID]) REFERENCES [dbo].[User]([UserID])
)
GO

CREATE TABLE [dbo].[Chatbot_Query_Log](
    [QueryID]    INT IDENTITY(1,1) NOT NULL,
    [UserID]     INT NULL,
    [Question]   NVARCHAR(MAX) NOT NULL,
    [Answer]     NVARCHAR(MAX) NULL,
    [SourceType] NVARCHAR(100) NULL,
    [CreatedAt]  DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY CLUSTERED ([QueryID]),
    CONSTRAINT [FK_ChatbotQueryLog_User] FOREIGN KEY ([UserID]) REFERENCES [dbo].[User]([UserID])
)
GO

-- ============================================================
-- V2 NEW TABLES — SYLLABUS DETAIL MODULE
-- ============================================================

-- Syllabus_Material: Reference materials (textbooks, online courses)
CREATE TABLE [dbo].[Syllabus_Material](
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
)
GO

-- CLO: Course Learning Outcomes
CREATE TABLE [dbo].[CLO](
    [CLOID]        INT IDENTITY(1,1) NOT NULL,
    [SyllabusID]   INT              NOT NULL,
    [CLOName]      NVARCHAR(50)     NOT NULL,
    [CLODetails]   NVARCHAR(200)    NULL,
    [LODetails]    NVARCHAR(MAX)    NOT NULL,
    [DisplayOrder] INT              NULL,

    CONSTRAINT [PK_CLO] PRIMARY KEY CLUSTERED ([CLOID]),
    CONSTRAINT [FK_CLO_Syllabus] FOREIGN KEY ([SyllabusID])
        REFERENCES [dbo].[Syllabus]([SyllabusID])
)
GO

-- Syllabus_Session: Teaching plan per session (45 min each)
CREATE TABLE [dbo].[Syllabus_Session](
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
)
GO

-- Session_CLO: Many-to-many junction (Session <-> CLO)
CREATE TABLE [dbo].[Session_CLO](
    [SessionCLOID] INT IDENTITY(1,1) NOT NULL,
    [SessionID]    INT NOT NULL,
    [CLOID]        INT NOT NULL,

    CONSTRAINT [PK_Session_CLO] PRIMARY KEY CLUSTERED ([SessionCLOID]),
    CONSTRAINT [FK_SessionCLO_Session] FOREIGN KEY ([SessionID])
        REFERENCES [dbo].[Syllabus_Session]([SessionID]),
    CONSTRAINT [FK_SessionCLO_CLO] FOREIGN KEY ([CLOID])
        REFERENCES [dbo].[CLO]([CLOID]),
    CONSTRAINT [UQ_Session_CLO] UNIQUE ([SessionID], [CLOID])
)
GO

-- Syllabus_Assessment: Structured evaluation methods
CREATE TABLE [dbo].[Syllabus_Assessment](
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
)
GO

-- Assessment_CLO: Many-to-many junction (Assessment <-> CLO)
CREATE TABLE [dbo].[Assessment_CLO](
    [AssessmentCLOID] INT IDENTITY(1,1) NOT NULL,
    [AssessmentID]    INT NOT NULL,
    [CLOID]           INT NOT NULL,

    CONSTRAINT [PK_Assessment_CLO] PRIMARY KEY CLUSTERED ([AssessmentCLOID]),
    CONSTRAINT [FK_AssessmentCLO_Assessment] FOREIGN KEY ([AssessmentID])
        REFERENCES [dbo].[Syllabus_Assessment]([AssessmentID]),
    CONSTRAINT [FK_AssessmentCLO_CLO] FOREIGN KEY ([CLOID])
        REFERENCES [dbo].[CLO]([CLOID]),
    CONSTRAINT [UQ_Assessment_CLO] UNIQUE ([AssessmentID], [CLOID])
)
GO

-- ============================================================
-- SEED DATA
-- ============================================================

SET IDENTITY_INSERT [dbo].[Role] ON
INSERT [dbo].[Role] ([RoleID], [RoleName], [Description]) VALUES
    (1, N'Admin', N'System administrator'),
    (2, N'Student', N'Student user'),
    (3, N'Teacher', N'Teacher user'),
    (4, N'Training Department', N'Training program management staff'),
    (5, N'Syllabus Designer', N'User responsible for syllabus design')
SET IDENTITY_INSERT [dbo].[Role] OFF
GO

PRINT '============================================================'
PRINT '  TPMS Database V2 created successfully!'
PRINT '  Total tables: 21 (15 from V1 + 6 new)'
PRINT '============================================================'
GO
