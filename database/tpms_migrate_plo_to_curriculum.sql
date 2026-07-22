USE [TPMS_DB]
GO


-- 1. drop database PLO
DROP TABLE PLO;
GO

-- 1. Add CurriculumID to PLO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.PLO') AND name = 'CurriculumID')
BEGIN
    ALTER TABLE dbo.[PLO] ADD CurriculumID INT;
END
GO

-- 2. Map existing PLOs to the first Curriculum of their Program
UPDATE p
SET p.CurriculumID = (SELECT TOP 1 CurriculumID FROM dbo.[Curriculum] c WHERE c.ProgramID = p.ProgramID)
FROM dbo.[PLO] p
WHERE p.CurriculumID IS NULL;
GO

-- 3. Delete PLOs that don't belong to any Curriculum to avoid FK violation
DELETE FROM dbo.[PLO] WHERE CurriculumID IS NULL;
GO

-- 4. Add FK to Curriculum
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE parent_object_id = OBJECT_ID('dbo.PLO') AND referenced_object_id = OBJECT_ID('dbo.Curriculum'))
BEGIN
    ALTER TABLE dbo.[PLO] ADD CONSTRAINT FK_PLO_Curriculum FOREIGN KEY (CurriculumID) REFERENCES dbo.[Curriculum](CurriculumID) ON DELETE CASCADE;
END
GO

-- 5. Drop FK constraint on ProgramID
DECLARE @ConstraintName nvarchar(200)
SELECT @ConstraintName = Name FROM sys.foreign_keys WHERE parent_object_id = OBJECT_ID('dbo.PLO') AND parent_column_id = (SELECT column_id FROM sys.columns WHERE object_id = OBJECT_ID('dbo.PLO') AND name = 'ProgramID')
IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE dbo.[PLO] DROP CONSTRAINT ' + @ConstraintName)
END
GO

-- 6. Drop ProgramID column
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.PLO') AND name = 'ProgramID')
BEGIN
    ALTER TABLE dbo.[PLO] DROP COLUMN ProgramID;
END
GO
