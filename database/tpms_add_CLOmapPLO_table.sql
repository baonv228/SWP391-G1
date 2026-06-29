/*
============================================================
  TPMS Database Migration Script: V2 → V3
  Purpose: Add CLO-PLO mapping junction table
  Date: 2026-06-24
  
  Prerequisites:
    - tpmsV1_to_V2_migration.sql must be applied
    - PLO table must exist (created by Curriculum team)
  
  This script is IDEMPOTENT — safe to run multiple times.
============================================================
*/

USE [TPMS_DB]
GO

-- ============================================================
-- STEP 1: CREATE TABLE [CLO_PLO] (Junction: CLO ↔ PLO)
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.CLO_PLO') AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[CLO_PLO] (
        [CloPloID] INT IDENTITY(1,1) NOT NULL,
        [CLOID]    INT NOT NULL,
        [PloID]    INT NOT NULL,

        CONSTRAINT [PK_CLO_PLO] PRIMARY KEY CLUSTERED ([CloPloID]),
        CONSTRAINT [FK_CLOPLO_CLO] FOREIGN KEY ([CLOID])
            REFERENCES [dbo].[CLO]([CLOID]),
        CONSTRAINT [FK_CLOPLO_PLO] FOREIGN KEY ([PloID])
            REFERENCES [dbo].[PLO]([PloID]),
        CONSTRAINT [UQ_CLO_PLO] UNIQUE ([CLOID], [PloID])
    );
    PRINT 'CREATE TABLE [CLO_PLO]: Done.'
END
ELSE
    PRINT 'TABLE [CLO_PLO]: Already exists — skipped.'
GO

PRINT '============================================================'
PRINT '  Migration V2 → V3 completed successfully!'
PRINT '  Tables added: [CLO_PLO]'
PRINT '============================================================'
GO
