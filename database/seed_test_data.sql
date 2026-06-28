/*
============================================================
  TPMS — Test Data Seed Script
  Run AFTER tpmsV1_to_V2_migration.sql
  
  Test account:
    Email:    designer@gmail.com
    Password: 123456
    Role:     Syllabus Designer (RoleID=5)
============================================================
*/

USE [TPMS_DB]
GO

-- ============================================================
-- 1) Insert Syllabus Designer test account
--    Password: 123456 (BCrypt hash)
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM dbo.[User] WHERE Email = 'designer@gmail.com')
BEGIN
    INSERT INTO dbo.[User] (RoleID, Email, PasswordHash, FullName, Status, CreatedAt)
    VALUES (
        5,  -- Syllabus Designer
        N'designer@gmail.com',
        N'$2a$10$3tznDY.vkg82w3mY/wdCzeiiDgHGX1tukoCjF1W6S2NPcPw7joeau',
        N'Syllabus Designer Test',
        N'Active',
        GETDATE()
    );
    PRINT 'INSERT User [designer@gmail.com]: Done.'
END
ELSE
    PRINT 'User [designer@gmail.com]: Already exists — skipped.'
GO

-- ============================================================
-- 2) Insert sample Subjects (WaitingForSyllabus)
-- ============================================================

-- Get the designer's UserID for CreatedBy
DECLARE @designerId INT = (SELECT TOP 1 UserID FROM dbo.[User] WHERE Email = 'designer@gmail.com');

IF NOT EXISTS (SELECT 1 FROM dbo.[Subject] WHERE SubjectCode = 'SWP391')
BEGIN
    INSERT INTO dbo.[Subject] (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@designerId, N'SWP391', N'Software Development Project', 3,
            N'This course guides students through the full SDLC by working on a real-world team project.',
            N'WaitingForSyllabus');
    PRINT 'INSERT Subject [SWP391]: Done.'
END

IF NOT EXISTS (SELECT 1 FROM dbo.[Subject] WHERE SubjectCode = 'PRJ301')
BEGIN
    INSERT INTO dbo.[Subject] (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@designerId, N'PRJ301', N'Java Web Application Development', 3,
            N'Building web applications using Java Servlet, JSP, and JDBC.',
            N'WaitingForSyllabus');
    PRINT 'INSERT Subject [PRJ301]: Done.'
END

IF NOT EXISTS (SELECT 1 FROM dbo.[Subject] WHERE SubjectCode = 'SWE201c')
BEGIN
    INSERT INTO dbo.[Subject] (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@designerId, N'SWE201c', N'Introduction to Software Engineering', 3,
            N'Fundamental concepts of software engineering, SDLC models, and requirements analysis.',
            N'WaitingForSyllabus');
    PRINT 'INSERT Subject [SWE201c]: Done.'
END

IF NOT EXISTS (SELECT 1 FROM dbo.[Subject] WHERE SubjectCode = 'PRN231')
BEGIN
    INSERT INTO dbo.[Subject] (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@designerId, N'PRN231', N'.NET Web Application Development', 3,
            N'Building web applications using ASP.NET Core MVC and Entity Framework.',
            N'WaitingForSyllabus');
    PRINT 'INSERT Subject [PRN231]: Done.'
END

IF NOT EXISTS (SELECT 1 FROM dbo.[Subject] WHERE SubjectCode = 'DBI202')
BEGIN
    INSERT INTO dbo.[Subject] (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@designerId, N'DBI202', N'Database Systems', 3,
            N'Relational database design, SQL programming, and database administration.',
            N'WaitingForSyllabus');
    PRINT 'INSERT Subject [DBI202]: Done.'
END
GO

PRINT '============================================================'
PRINT '  Test data seeded successfully!'
PRINT '  Login: designer@gmail.com / 123456'
PRINT '============================================================'
GO
