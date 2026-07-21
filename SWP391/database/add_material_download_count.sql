USE TPMS_DB;
GO

IF OBJECT_ID('dbo.[Learning_Material]', 'U') IS NOT NULL
   AND COL_LENGTH('dbo.[Learning_Material]', 'DownloadCount') IS NULL
BEGIN
    ALTER TABLE dbo.[Learning_Material]
    ADD DownloadCount INT NOT NULL
        CONSTRAINT DF_Learning_Material_DownloadCount DEFAULT 0;
END
GO
