USE TPMS_DB;
GO

IF OBJECT_ID('dbo.[Training_Program]', 'U') IS NOT NULL
   AND COL_LENGTH('dbo.[Training_Program]', 'AcademicYear') IS NULL
BEGIN
    ALTER TABLE dbo.[Training_Program]
        ADD AcademicYear NVARCHAR(20) NULL;
END
GO

