


-- 1. Bỏ trường năm trong Training_Program
IF COL_LENGTH('Training_Program', 'AcademicYear') IS NOT NULL
BEGIN
    ALTER TABLE Training_Program DROP COLUMN AcademicYear;
END
GO

-- 2. Xóa bảng PO/PLO cũ nếu đã tạo sai nối với Training_Program
IF OBJECT_ID('PO', 'U') IS NOT NULL
    DROP TABLE PO;
GO

IF OBJECT_ID('PLO', 'U') IS NOT NULL
    DROP TABLE PLO;
GO

-- 3. Tạo lại bảng PO nối với Curriculum
CREATE TABLE PO (
    po_id INT IDENTITY(1,1) PRIMARY KEY,
    CurriculumID INT NOT NULL,
    po_code NVARCHAR(50) NOT NULL,
    po_description NVARCHAR(MAX),

    CONSTRAINT FK_PO_Curriculum
        FOREIGN KEY (CurriculumID) REFERENCES Curriculum(CurriculumID),

    CONSTRAINT UQ_PO_Curriculum_Code
        UNIQUE (CurriculumID, po_code)
);
GO

-- 4. Tạo lại bảng PLO nối với Curriculum
CREATE TABLE PLO (
    plo_id INT IDENTITY(1,1) PRIMARY KEY,
    CurriculumID INT NOT NULL,
    plo_code NVARCHAR(50) NOT NULL,
    plo_description NVARCHAR(MAX),

    CONSTRAINT FK_PLO_Curriculum
        FOREIGN KEY (CurriculumID) REFERENCES Curriculum(CurriculumID),

    CONSTRAINT UQ_PLO_Curriculum_Code
        UNIQUE (CurriculumID, plo_code)
);
GO