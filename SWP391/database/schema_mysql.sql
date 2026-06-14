-- =====================================================================
-- TPMS - Training Program Management System
-- MySQL schema for the User Authentication module (in charge: Linhnn)
-- Run this script in MySQL Workbench / IntelliJ Database tool before
-- starting the application.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS tpms_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE tpms_db;

-- ---------------------------------------------------------------------
-- Role: stores the system roles used for authorization (SDS 1.3.3)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Role` (
    RoleID      INT AUTO_INCREMENT PRIMARY KEY,
    RoleName    VARCHAR(50)  NOT NULL UNIQUE,
    Description VARCHAR(255)
);

-- ---------------------------------------------------------------------
-- User: stores all users of the system (SDS 1.3.2)
-- One user is assigned exactly one role (SRS 1.3.1).
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `User` (
    UserID       INT AUTO_INCREMENT PRIMARY KEY,
    RoleID       INT          NOT NULL,
    FullName     VARCHAR(100),
    Email        VARCHAR(150) NOT NULL UNIQUE,
    Phone        VARCHAR(20),
    PasswordHash VARCHAR(255) NOT NULL,
    Status       VARCHAR(20)  NOT NULL DEFAULT 'Active',
    CreatedAt    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_role FOREIGN KEY (RoleID) REFERENCES `Role` (RoleID)
);

-- ---------------------------------------------------------------------
-- PasswordResetToken: supports the Password Reset use case.
-- A one-time token is generated when a user requests a password reset.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS PasswordResetToken (
    TokenID   INT AUTO_INCREMENT PRIMARY KEY,
    UserID    INT          NOT NULL,
    Token     VARCHAR(100) NOT NULL UNIQUE,
    ExpiresAt DATETIME     NOT NULL,
    Used      TINYINT(1)   NOT NULL DEFAULT 0,
    CONSTRAINT fk_prt_user FOREIGN KEY (UserID) REFERENCES `User` (UserID)
);

-- ---------------------------------------------------------------------
-- Seed data: roles (SRS 1.3.1 Actors)
-- ---------------------------------------------------------------------
INSERT INTO `Role` (RoleName, Description) VALUES
    ('Admin',             'System administrator'),
    ('TrainingDepartment','Manages academic programs and curricula'),
    ('SyllabusDesigner',  'Creates and updates syllabus content'),
    ('Teacher',           'Uploads materials and views course content'),
    ('Student',           'Views curricula, syllabi and learning materials')
AS new_role
ON DUPLICATE KEY UPDATE Description = new_role.Description;

-- ---------------------------------------------------------------------
-- Seed data: a sample admin account.
-- Email:    admin@gmail.com
-- Password: 123456   (BCrypt hash below)
-- ---------------------------------------------------------------------
INSERT INTO `User` (RoleID, FullName, Email, PasswordHash, Status)
SELECT r.RoleID, 'System Admin', 'admin@gmail.com',
       '$2a$10$ruCqlMghNghMlbmGfj8DCeZowmDYSJKRuuuZzTiG/tsoXWvUIrJp6', 'Active'
FROM `Role` r
WHERE r.RoleName = 'Admin'
  AND NOT EXISTS (SELECT 1 FROM `User` u WHERE u.Email = 'admin@gmail.com');
