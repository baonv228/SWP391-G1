USE TPMS_DB;
GO

IF COL_LENGTH('dbo.Learning_Material', 'FileSize') IS NULL
BEGIN
    ALTER TABLE dbo.Learning_Material
        ADD FileSize BIGINT NOT NULL
            CONSTRAINT DF_Learning_Material_FileSize DEFAULT (0);
END
GO
