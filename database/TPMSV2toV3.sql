

-- Nếu bảng Training_Program còn cột PNO thì xóa
IF COL_LENGTH('Training_Program', 'PNO') IS NOT NULL
BEGIN
    ALTER TABLE Training_Program DROP COLUMN PNO;
END
GO

CREATE TABLE PLO (
    PloID INT IDENTITY(1,1) PRIMARY KEY,
    ProgramID INT NOT NULL,
    PloCode NVARCHAR(50) NOT NULL,
    PloDescription NVARCHAR(MAX),

    CONSTRAINT FK_PLO_TrainingProgram
        FOREIGN KEY (ProgramID)
        REFERENCES Training_Program(ProgramID),

    CONSTRAINT UQ_PLO_Program_Code
        UNIQUE (ProgramID, PloCode)
);
GO

CREATE TABLE PO (
    po_id INT IDENTITY(1,1) PRIMARY KEY,
    ProgramID INT NOT NULL,
    po_code NVARCHAR(50) NOT NULL,
    po_description NVARCHAR(MAX),

    CONSTRAINT FK_PO_TrainingProgram
        FOREIGN KEY (ProgramID) REFERENCES Training_Program(ProgramID),

    CONSTRAINT UQ_PO_Program_Code
        UNIQUE (ProgramID, po_code)
);
GO