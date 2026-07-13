/*
============================================================
 TPMS Database Migration Script: V3 -> V4 (Updated)
 Changes:
   1. Remove AcademicYear from Training_Program.
   2. Ensure PO belongs to Curriculum.
   3. Recreate PLO (the old PLO table has already been deleted)
      and link PLO directly to Curriculum.
   4. Create CLO_PLO junction table for the N:N relationship
      between CLO and PLO.

 SQL Server script - safe to run again where possible.
============================================================
*/

USE [TPMS_DB];
GO




-- 1. drop database PLO
DROP TABLE PLO;
GO

/* =========================================================
   STEP 1: REMOVE AcademicYear FROM Training_Program
   ========================================================= */


IF COL_LENGTH('dbo.Training_Program', 'AcademicYear') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Training_Program]
    DROP COLUMN [AcademicYear];

    PRINT 'Training_Program.AcademicYear: Dropped.';
END
ELSE
BEGIN
    PRINT 'Training_Program.AcademicYear: Does not exist - skipped.';
END
GO

/* =========================================================
   STEP 2: CREATE OR STANDARDIZE PO
   PO belongs to Curriculum instead of Training_Program.
   ========================================================= */
IF OBJECT_ID('dbo.PO', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[PO] (
        [PoID]          INT IDENTITY(1,1) NOT NULL,
        [CurriculumID]  INT NOT NULL,
        [PoCode]        NVARCHAR(50) NOT NULL,
        [PoDescription] NVARCHAR(MAX) NULL,

        CONSTRAINT [PK_PO]
            PRIMARY KEY CLUSTERED ([PoID]),

        CONSTRAINT [FK_PO_Curriculum]
            FOREIGN KEY ([CurriculumID])
            REFERENCES [dbo].[Curriculum]([CurriculumID])
            ON DELETE CASCADE,

        CONSTRAINT [UQ_PO_Curriculum_Code]
            UNIQUE ([CurriculumID], [PoCode])
    );

    PRINT 'CREATE TABLE dbo.PO: Done.';
END
ELSE
BEGIN
    PRINT 'TABLE dbo.PO: Already exists - skipped.';
END
GO

/* Rename old PO columns when the table already exists with snake_case names. */
IF OBJECT_ID('dbo.PO', 'U') IS NOT NULL
   AND COL_LENGTH('dbo.PO', 'po_id') IS NOT NULL
   AND COL_LENGTH('dbo.PO', 'PoID') IS NULL
BEGIN
    EXEC sp_rename 'dbo.PO.po_id', 'PoID', 'COLUMN';
    PRINT 'Renamed PO.po_id to PO.PoID.';
END
GO

IF OBJECT_ID('dbo.PO', 'U') IS NOT NULL
   AND COL_LENGTH('dbo.PO', 'po_code') IS NOT NULL
   AND COL_LENGTH('dbo.PO', 'PoCode') IS NULL
BEGIN
    EXEC sp_rename 'dbo.PO.po_code', 'PoCode', 'COLUMN';
    PRINT 'Renamed PO.po_code to PO.PoCode.';
END
GO

IF OBJECT_ID('dbo.PO', 'U') IS NOT NULL
   AND COL_LENGTH('dbo.PO', 'po_description') IS NOT NULL
   AND COL_LENGTH('dbo.PO', 'PoDescription') IS NULL
BEGIN
    EXEC sp_rename 'dbo.PO.po_description', 'PoDescription', 'COLUMN';
    PRINT 'Renamed PO.po_description to PO.PoDescription.';
END
GO

/* =========================================================
   STEP 3: CREATE PLO AGAIN
   The old PLO table was deleted, so no ProgramID migration is
   required. PLO is created directly under Curriculum.
   ========================================================= */
IF OBJECT_ID('dbo.PLO', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[PLO] (
        [PloID]          INT IDENTITY(1,1) NOT NULL,
        [CurriculumID]   INT NOT NULL,
        [PloCode]        NVARCHAR(50) NOT NULL,
        [PloDescription] NVARCHAR(MAX) NULL,

        CONSTRAINT [PK_PLO]
            PRIMARY KEY CLUSTERED ([PloID]),

        CONSTRAINT [FK_PLO_Curriculum]
            FOREIGN KEY ([CurriculumID])
            REFERENCES [dbo].[Curriculum]([CurriculumID])
            ON DELETE CASCADE,

        CONSTRAINT [UQ_PLO_Curriculum_Code]
            UNIQUE ([CurriculumID], [PloCode])
    );

    PRINT 'CREATE TABLE dbo.PLO: Done.';
END
ELSE
BEGIN
    PRINT 'TABLE dbo.PLO: Already exists - skipped.';
END
GO

/* =========================================================
   STEP 4: CREATE CLO_PLO JUNCTION TABLE
   One CLO can map to many PLOs, and one PLO can map to many CLOs.
   ========================================================= */
IF OBJECT_ID('dbo.CLO', 'U') IS NULL
BEGIN
    THROW 50001, 'Table dbo.CLO does not exist. Create CLO before running the CLO_PLO step.', 1;
END
GO

IF OBJECT_ID('dbo.PLO', 'U') IS NULL
BEGIN
    THROW 50002, 'Table dbo.PLO does not exist. PLO creation failed.', 1;
END
GO

IF OBJECT_ID('dbo.CLO_PLO', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[CLO_PLO] (
        [CloPloID] INT IDENTITY(1,1) NOT NULL,
        [CLOID]    INT NOT NULL,
        [PloID]    INT NOT NULL,

        CONSTRAINT [PK_CLO_PLO]
            PRIMARY KEY CLUSTERED ([CloPloID]),

        CONSTRAINT [FK_CLOPLO_CLO]
            FOREIGN KEY ([CLOID])
            REFERENCES [dbo].[CLO]([CLOID]),

        CONSTRAINT [FK_CLOPLO_PLO]
            FOREIGN KEY ([PloID])
            REFERENCES [dbo].[PLO]([PloID]),

        CONSTRAINT [UQ_CLO_PLO]
            UNIQUE ([CLOID], [PloID])
    );

    CREATE INDEX [IX_CLO_PLO_CLOID]
        ON [dbo].[CLO_PLO]([CLOID]);

    CREATE INDEX [IX_CLO_PLO_PloID]
        ON [dbo].[CLO_PLO]([PloID]);

    PRINT 'CREATE TABLE dbo.CLO_PLO: Done.';
END
ELSE
BEGIN
    PRINT 'TABLE dbo.CLO_PLO: Already exists - skipped.';
END
GO
