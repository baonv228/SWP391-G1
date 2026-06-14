-- =====================================================================
-- TPMS - Training Program Management System
-- SQL Server schema for the User Authentication module (in charge: Linhnn)
-- Run this script in SSMS / Azure Data Studio / IntelliJ Database tool
-- before starting the application.
-- =====================================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TPMS_DB')
    CREATE DATABASE TPMS_DB;
GO

USE TPMS_DB;
GO

-- ---------------------------------------------------------------------
-- Role: stores the system roles used for authorization (SDS 1.3.3)
-- ---------------------------------------------------------------------
IF OBJECT_ID('dbo.[Role]', 'U') IS NULL
CREATE TABLE dbo.[Role] (
    RoleID      INT IDENTITY(1,1) PRIMARY KEY,
    RoleName    NVARCHAR(50)  NOT NULL UNIQUE,
    Description NVARCHAR(255)
);
GO

-- ---------------------------------------------------------------------
-- User: stores all users of the system (SDS 1.3.2)
-- One user is assigned exactly one role (SRS 1.3.1).
-- ---------------------------------------------------------------------
IF OBJECT_ID('dbo.[User]', 'U') IS NULL
CREATE TABLE dbo.[User] (
    UserID       INT IDENTITY(1,1) PRIMARY KEY,
    RoleID       INT           NOT NULL,
    FullName     NVARCHAR(100),
    Email        NVARCHAR(150) NOT NULL UNIQUE,
    Phone        NVARCHAR(20),
    PasswordHash NVARCHAR(255) NOT NULL,
    Status       NVARCHAR(20)  NOT NULL DEFAULT 'Active',
    CreatedAt    DATETIME2     NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_User_Role FOREIGN KEY (RoleID) REFERENCES dbo.[Role] (RoleID)
);
GO

-- ---------------------------------------------------------------------
-- PasswordResetToken: supports the Password Reset use case.
-- A one-time token is generated when a user requests a password reset.
-- ---------------------------------------------------------------------
IF OBJECT_ID('dbo.PasswordResetToken', 'U') IS NULL
CREATE TABLE dbo.PasswordResetToken (
    TokenID   INT IDENTITY(1,1) PRIMARY KEY,
    UserID    INT           NOT NULL,
    Token     NVARCHAR(100) NOT NULL UNIQUE,
    ExpiresAt DATETIME2     NOT NULL,
    Used      BIT           NOT NULL DEFAULT 0,
    CONSTRAINT FK_PRT_User FOREIGN KEY (UserID) REFERENCES dbo.[User] (UserID)
);
GO

-- ---------------------------------------------------------------------
-- Seed data: roles (SRS 1.3.1 Actors)
-- ---------------------------------------------------------------------
MERGE dbo.[Role] AS target
USING (VALUES
    ('Admin',              'System administrator'),
    ('TrainingDepartment', 'Manages academic programs and curricula'),
    ('SyllabusDesigner',   'Creates and updates syllabus content'),
    ('Teacher',            'Uploads materials and views course content'),
    ('Student',            'Views curricula, syllabi and learning materials')
) AS source (RoleName, Description)
ON target.RoleName = source.RoleName
WHEN NOT MATCHED THEN
    INSERT (RoleName, Description) VALUES (source.RoleName, source.Description);
GO

-- ---------------------------------------------------------------------
-- Seed data: a sample admin account.
-- Email:    admin@gmail.com
-- Password: 123456   (BCrypt hash below)
-- ---------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM dbo.[User] WHERE Email = 'admin@gmail.com')
INSERT INTO dbo.[User] (RoleID, FullName, Email, PasswordHash, Status)
SELECT r.RoleID, 'System Admin', 'admin@gmail.com',
       '$2a$10$ruCqlMghNghMlbmGfj8DCeZowmDYSJKRuuuZzTiG/tsoXWvUIrJp6', 'Active'
FROM dbo.[Role] r
WHERE r.RoleName = 'Admin';
GO
