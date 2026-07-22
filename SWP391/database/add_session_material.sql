USE TPMS_DB;
GO

-- Junction table linking a teacher's private-cloud materials to a specific
-- session of a syllabus. Anchored on (SyllabusID, SessionNumber) instead of
-- SessionID because SyllabusDAO.saveAllChildren wipes and recreates all
-- Syllabus_Session rows on every Designer save, regenerating SessionID.
-- SessionNumber is stable thanks to UQ_Session_Number(SyllabusID, SessionNumber).
IF OBJECT_ID(N'dbo.Session_Material', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Session_Material(
        SessionMaterialID INT IDENTITY(1,1) NOT NULL,
        SyllabusID        INT NOT NULL,
        SessionNumber     INT NOT NULL,
        MaterialID        INT NOT NULL,
        CONSTRAINT PK_Session_Material PRIMARY KEY CLUSTERED (SessionMaterialID),
        CONSTRAINT UQ_Session_Material UNIQUE (SyllabusID, SessionNumber, MaterialID),
        CONSTRAINT FK_SessionMaterial_Syllabus
            FOREIGN KEY (SyllabusID) REFERENCES dbo.Syllabus(SyllabusID),
        CONSTRAINT FK_SessionMaterial_Material
            FOREIGN KEY (MaterialID) REFERENCES dbo.Learning_Material(MaterialID)
    );
END
GO
