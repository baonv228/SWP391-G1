USE TPMS_DB;
GO

IF COL_LENGTH('dbo.Curriculum', 'DecisionNo') IS NULL
BEGIN
    ALTER TABLE dbo.Curriculum ADD DecisionNo NVARCHAR(150) NULL;
END;
GO
