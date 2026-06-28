-- ============================================================
-- Sample Data for TPMS_DB
-- Run AFTER the main schema (tpmsV1.sql) has been applied.
-- ============================================================

USE [TPMS_DB];
GO

-- ============================================================
-- 1. Seed a system User (required by FK constraints)
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM [User] WHERE Email = 'admin@fpt.edu.vn')
BEGIN
    INSERT INTO [User] (RoleID, Email, PasswordHash, FullName, Status, CreatedAt)
    VALUES (1, 'admin@fpt.edu.vn', '$2a$10$xyzADMINhashplaceholder', N'System Admin', 'Active', GETDATE());
END;

-- Demo Admin
IF NOT EXISTS (SELECT 1 FROM [User] WHERE Email = 'admin.tpms@gmail.com')
BEGIN
    INSERT INTO [User] (RoleID, Email, PasswordHash, FullName, Status, CreatedAt)
    VALUES (1, 'admin.tpms@gmail.com', '$2a$10$OhbBpwWijP7xYpmbQT1YcezxGhkHkH44v2dffFXdIs2aht/Xt6ZLi', N'Demo Admin', 'Active', GETDATE());
END;

-- Demo Teacher
IF NOT EXISTS (SELECT 1 FROM [User] WHERE Email = 'teacher.tpms@gmail.com')
BEGIN
    INSERT INTO [User] (RoleID, Email, PasswordHash, FullName, Status, CreatedAt)
    VALUES (3, 'teacher.tpms@gmail.com', '$2a$10$OhbBpwWijP7xYpmbQT1YcezxGhkHkH44v2dffFXdIs2aht/Xt6ZLi', N'Demo Teacher', 'Active', GETDATE());
END;

-- Demo Student
IF NOT EXISTS (SELECT 1 FROM [User] WHERE Email = 'student.tpms@gmail.com')
BEGIN
    INSERT INTO [User] (RoleID, Email, PasswordHash, FullName, Status, CreatedAt)
    VALUES (2, 'student.tpms@gmail.com', '$2a$10$OhbBpwWijP7xYpmbQT1YcezxGhkHkH44v2dffFXdIs2aht/Xt6ZLi', N'Demo Student', 'Active', GETDATE());
END;
GO

DECLARE @adminId INT = (SELECT UserID FROM [User] WHERE Email = 'admin@fpt.edu.vn');

-- ============================================================
-- 2. Subjects
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'PRF192')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'PRF192', N'C Programming', 3,
            N'Introduction to C programming language, data types, control structures, functions, pointers.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'PRO192')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'PRO192', N'OOP with Java', 3,
            N'Object-Oriented Programming using Java: classes, inheritance, polymorphism, collections.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'LAB211')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'LAB211', N'OOP with Java Lab', 3,
            N'Practical lab course for OOP with Java. Students implement assignments independently.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'DBI202')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'DBI202', N'Database Systems', 3,
            N'Relational database design, SQL, stored procedures, transactions, and indexing.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'SWD391')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'SWD391', N'Software Design', 3,
            N'Design patterns, UML modeling, architectural patterns, and software best practices.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'SWP391')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'SWP391', N'Software Project', 3,
            N'Team-based software development project following agile methodology.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'MAD101')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'MAD101', N'Mobile App Development', 3,
            N'Introduction to mobile application development for Android and iOS platforms.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'CEA201')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'CEA201', N'Computer Organization and Architecture', 3,
            N'CPU organization, memory hierarchy, instruction sets, and I/O systems.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'OSG202')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'OSG202', N'Operating Systems', 3,
            N'Process management, memory management, file systems, and concurrency.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'MAS291')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'MAS291', N'Statistics and Probability', 3,
            N'Probability theory, statistical methods, hypothesis testing, and regression.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'NWC203c')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'NWC203c', N'Computer Networking', 3,
            N'OSI model, TCP/IP, routing, switching, and network security fundamentals.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'PRM391')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'PRM391', N'Mobile Programming', 3,
            N'Advanced mobile programming with Android SDK and cross-platform frameworks.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'SEP490')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'SEP490', N'Software Engineering Capstone Project', 3,
            N'Final capstone project integrating all software engineering competencies.',
            'Active');

IF NOT EXISTS (SELECT 1 FROM Subject WHERE SubjectCode = 'SSL101c')
    INSERT INTO Subject (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
    VALUES (@adminId, 'SSL101c', N'Academic Skills for University Study', 3,
            N'Study skills, academic writing, critical thinking, and time management.',
            'Active');
GO

-- ============================================================
-- 3. Subject Prerequisites
-- ============================================================
DECLARE @prf192 INT  = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'PRF192');
DECLARE @pro192 INT  = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'PRO192');
DECLARE @lab211 INT  = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'LAB211');
DECLARE @mad101 INT  = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'MAD101');
DECLARE @swd391 INT  = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'SWD391');
DECLARE @swp391 INT  = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'SWP391');
DECLARE @prm391 INT  = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'PRM391');
DECLARE @osg202 INT  = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'OSG202');
DECLARE @sep490 INT  = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'SEP490');
DECLARE @cea201 INT  = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'CEA201');

-- PRO192 requires PRF192
IF NOT EXISTS (SELECT 1 FROM Subject_Prerequisite WHERE SubjectID = @pro192 AND RequiredSubjectID = @prf192)
    INSERT INTO Subject_Prerequisite (SubjectID, RequiredSubjectID, ConditionType)
    VALUES (@pro192, @prf192, 'Pass');

-- LAB211 requires PRO192
IF NOT EXISTS (SELECT 1 FROM Subject_Prerequisite WHERE SubjectID = @lab211 AND RequiredSubjectID = @pro192)
    INSERT INTO Subject_Prerequisite (SubjectID, RequiredSubjectID, ConditionType)
    VALUES (@lab211, @pro192, 'Pass');

-- LAB211 requires PRF192
IF NOT EXISTS (SELECT 1 FROM Subject_Prerequisite WHERE SubjectID = @lab211 AND RequiredSubjectID = @prf192)
    INSERT INTO Subject_Prerequisite (SubjectID, RequiredSubjectID, ConditionType)
    VALUES (@lab211, @prf192, 'Pass');

-- MAD101 requires PRO192
IF NOT EXISTS (SELECT 1 FROM Subject_Prerequisite WHERE SubjectID = @mad101 AND RequiredSubjectID = @pro192)
    INSERT INTO Subject_Prerequisite (SubjectID, RequiredSubjectID, ConditionType)
    VALUES (@mad101, @pro192, 'Pass');

-- SWD391 requires PRO192
IF NOT EXISTS (SELECT 1 FROM Subject_Prerequisite WHERE SubjectID = @swd391 AND RequiredSubjectID = @pro192)
    INSERT INTO Subject_Prerequisite (SubjectID, RequiredSubjectID, ConditionType)
    VALUES (@swd391, @pro192, 'Pass');

-- SWP391 requires SWD391
IF NOT EXISTS (SELECT 1 FROM Subject_Prerequisite WHERE SubjectID = @swp391 AND RequiredSubjectID = @swd391)
    INSERT INTO Subject_Prerequisite (SubjectID, RequiredSubjectID, ConditionType)
    VALUES (@swp391, @swd391, 'Pass');

-- PRM391 requires MAD101
IF NOT EXISTS (SELECT 1 FROM Subject_Prerequisite WHERE SubjectID = @prm391 AND RequiredSubjectID = @mad101)
    INSERT INTO Subject_Prerequisite (SubjectID, RequiredSubjectID, ConditionType)
    VALUES (@prm391, @mad101, 'Pass');

-- OSG202 requires CEA201
IF NOT EXISTS (SELECT 1 FROM Subject_Prerequisite WHERE SubjectID = @osg202 AND RequiredSubjectID = @cea201)
    INSERT INTO Subject_Prerequisite (SubjectID, RequiredSubjectID, ConditionType)
    VALUES (@osg202, @cea201, 'Pass');

-- SEP490 requires SWP391
IF NOT EXISTS (SELECT 1 FROM Subject_Prerequisite WHERE SubjectID = @sep490 AND RequiredSubjectID = @swp391)
    INSERT INTO Subject_Prerequisite (SubjectID, RequiredSubjectID, ConditionType)
    VALUES (@sep490, @swp391, 'Pass');
GO

-- ============================================================
-- 4. Training Programs
-- ============================================================
DECLARE @adminId2 INT = (SELECT UserID FROM [User] WHERE Email = 'admin@fpt.edu.vn');

IF NOT EXISTS (SELECT 1 FROM Training_Program WHERE ProgramCode = 'SE')
    INSERT INTO Training_Program (CreatedBy, ProgramCode, ProgramName, AcademicYear, MajorName, Description, Status)
    VALUES (@adminId2, 'SE', N'Software Engineering', '2024-2028', N'Software Engineering', 
            N'Bachelor of Software Engineering — trains students in analysis, design, development and maintenance of software systems.', 'Active');

IF NOT EXISTS (SELECT 1 FROM Training_Program WHERE ProgramCode = 'AI')
    INSERT INTO Training_Program (CreatedBy, ProgramCode, ProgramName, AcademicYear, MajorName, Description, Status)
    VALUES (@adminId2, 'AI', N'Artificial Intelligence', '2024-2028', N'Artificial Intelligence',
            N'Bachelor of Artificial Intelligence — focuses on machine learning, deep learning, and AI applications.', 'Active');

IF NOT EXISTS (SELECT 1 FROM Training_Program WHERE ProgramCode = 'IA')
    INSERT INTO Training_Program (CreatedBy, ProgramCode, ProgramName, AcademicYear, MajorName, Description, Status)
    VALUES (@adminId2, 'IA', N'Information Assurance', '2024-2028', N'Information Assurance',
            N'Bachelor of Information Assurance and Cybersecurity.', 'Active');
GO

-- ============================================================
-- 5. Curricula
-- ============================================================
DECLARE @adminId3 INT = (SELECT UserID FROM [User] WHERE Email = 'admin@fpt.edu.vn');
DECLARE @seProg   INT = (SELECT ProgramID FROM Training_Program WHERE ProgramCode = 'SE');
DECLARE @aiProg   INT = (SELECT ProgramID FROM Training_Program WHERE ProgramCode = 'AI');

IF NOT EXISTS (SELECT 1 FROM Curriculum WHERE ProgramID = @seProg AND CurriculumName = N'SE Standard Curriculum 2024')
    INSERT INTO Curriculum (ProgramID, CreatedBy, CurriculumName, Description, Status)
    VALUES (@seProg, @adminId3, N'SE Standard Curriculum 2024',
            N'Standard 4-year curriculum for Software Engineering bachelor degree, cohort 2024.', 'Active');

IF NOT EXISTS (SELECT 1 FROM Curriculum WHERE ProgramID = @aiProg AND CurriculumName = N'AI Standard Curriculum 2024')
    INSERT INTO Curriculum (ProgramID, CreatedBy, CurriculumName, Description, Status)
    VALUES (@aiProg, @adminId3, N'AI Standard Curriculum 2024',
            N'Standard 4-year curriculum for Artificial Intelligence bachelor degree, cohort 2024.', 'Active');
GO

-- ============================================================
-- 6. Curriculum Subjects (SE)
-- ============================================================
DECLARE @seCurr  INT = (SELECT TOP 1 CurriculumID FROM Curriculum WHERE CurriculumName = N'SE Standard Curriculum 2024');
DECLARE @ssl101c INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'SSL101c');
DECLARE @prf192b INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'PRF192');
DECLARE @pro192b INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'PRO192');
DECLARE @lab211b INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'LAB211');
DECLARE @dbi202  INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'DBI202');
DECLARE @mas291  INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'MAS291');
DECLARE @cea201b INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'CEA201');
DECLARE @osg202b INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'OSG202');
DECLARE @mad101b INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'MAD101');
DECLARE @nwc203c INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'NWC203c');
DECLARE @swd391b INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'SWD391');
DECLARE @swp391b INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'SWP391');
DECLARE @prm391b INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'PRM391');
DECLARE @sep490b INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'SEP490');

-- Semester 1
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@ssl101c)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @ssl101c, 1, 1, 1);
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@prf192b)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @prf192b, 1, 1, 2);
-- Semester 2
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@pro192b)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @pro192b, 2, 1, 1);
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@lab211b)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @lab211b, 2, 1, 2);
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@dbi202)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @dbi202, 2, 1, 3);
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@mas291)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @mas291, 2, 1, 4);
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@cea201b)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @cea201b, 2, 1, 5);
-- Semester 3
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@osg202b)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @osg202b, 3, 1, 1);
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@mad101b)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @mad101b, 3, 1, 2);
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@nwc203c)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @nwc203c, 3, 1, 3);
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@swd391b)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @swd391b, 3, 1, 4);
-- Semester 4
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@swp391b)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @swp391b, 4, 1, 1);
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@prm391b)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @prm391b, 4, 1, 2);
-- Semester 5
IF NOT EXISTS (SELECT 1 FROM Curriculum_Subject WHERE CurriculumID=@seCurr AND SubjectID=@sep490b)
    INSERT INTO Curriculum_Subject (CurriculumID, SubjectID, SemesterNo, IsRequired, DisplayOrder)
    VALUES (@seCurr, @sep490b, 5, 1, 1);
GO

-- ============================================================
-- 7. Syllabi
-- ============================================================
DECLARE @adminId4 INT = (SELECT UserID FROM [User] WHERE Email = 'admin@fpt.edu.vn');
DECLARE @lab211s  INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'LAB211');
DECLARE @prf192s  INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'PRF192');
DECLARE @pro192s  INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'PRO192');
DECLARE @dbi202s  INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'DBI202');
DECLARE @swd391s  INT = (SELECT SubjectID FROM Subject WHERE SubjectCode = 'SWD391');

-- LAB211 Syllabus
IF NOT EXISTS (SELECT 1 FROM Syllabus WHERE SubjectID = @lab211s AND VersionNo = 'v1.0')
    INSERT INTO Syllabus (SubjectID, CreatedBy, ApprovedBy, VersionNo, SyllabusTitle, Description,
                          LearningOutcome, AssessmentMethod, Status, IsCurrentVersion, CreatedAt, ApprovedAt)
    VALUES (@lab211s, @adminId4, @adminId4, 'v1.0',
            N'OOP with Java Lab - Practical Object-Oriented Programming',
            N'This course focuses on basic problems related to Java programming skills. Students implement all assignments by themselves in lab rooms. Each assignment must be completed continuously within the defined time.',
            N'Implement Object-Oriented programming concepts using Java
Apply encapsulation, inheritance, and polymorphism in real programs
Use Java collections and exception handling effectively
Write clean, well-documented Java code following FPT coding standards',
            N'Lab exercises: 60%
Midterm practical test: 20%
Final practical exam: 20%',
            'Active', 1, GETDATE(), GETDATE());

-- PRF192 Syllabus
IF NOT EXISTS (SELECT 1 FROM Syllabus WHERE SubjectID = @prf192s AND VersionNo = 'v1.2')
    INSERT INTO Syllabus (SubjectID, CreatedBy, ApprovedBy, VersionNo, SyllabusTitle, Description,
                          LearningOutcome, AssessmentMethod, Status, IsCurrentVersion, CreatedAt, ApprovedAt)
    VALUES (@prf192s, @adminId4, @adminId4, 'v1.2',
            N'C Programming - Introduction to Programming with C Language',
            N'This course introduces the fundamental concepts of C programming language. Students will learn syntax, data types, control structures, functions, pointers and file I/O.',
            N'Write correct C programs using standard syntax and best practices
Apply pointer arithmetic and dynamic memory management
Implement file I/O operations using standard C library
Debug and test C programs effectively using systematic approaches',
            N'Assignments: 40%
Lab practical: 30%
Final exam: 30%',
            'Active', 1, GETDATE(), GETDATE());

-- PRO192 Syllabus
IF NOT EXISTS (SELECT 1 FROM Syllabus WHERE SubjectID = @pro192s AND VersionNo = 'v1.1')
    INSERT INTO Syllabus (SubjectID, CreatedBy, ApprovedBy, VersionNo, SyllabusTitle, Description,
                          LearningOutcome, AssessmentMethod, Status, IsCurrentVersion, CreatedAt, ApprovedAt)
    VALUES (@pro192s, @adminId4, @adminId4, 'v1.1',
            N'OOP with Java - Object-Oriented Programming using Java',
            N'This course covers Object-Oriented Programming principles using Java. Topics include classes, inheritance, polymorphism, encapsulation, interfaces, exceptions, and collections.',
            N'Design and implement class hierarchies using OOP principles
Apply design patterns to solve common software problems
Implement error handling using Java exception mechanism
Use Java standard library collections effectively',
            N'Assignments: 30%
Group project: 30%
Final exam: 40%',
            'Active', 1, GETDATE(), GETDATE());

-- DBI202 Syllabus
IF NOT EXISTS (SELECT 1 FROM Syllabus WHERE SubjectID = @dbi202s AND VersionNo = 'v1.0')
    INSERT INTO Syllabus (SubjectID, CreatedBy, VersionNo, SyllabusTitle, Description,
                          LearningOutcome, AssessmentMethod, Status, IsCurrentVersion, CreatedAt)
    VALUES (@dbi202s, @adminId4, 'v1.0',
            N'Database Systems - Relational Database Design and SQL',
            N'This course covers relational database design, SQL, stored procedures, transactions and indexing.',
            N'Design normalized relational database schemas
Write complex SQL queries including joins, subqueries, and aggregations
Implement stored procedures and triggers in SQL Server
Optimize database performance through proper indexing',
            N'Database design project: 40%
SQL assignments: 30%
Final exam: 30%',
            'Draft', 0, GETDATE());

-- SWD391 Syllabus
IF NOT EXISTS (SELECT 1 FROM Syllabus WHERE SubjectID = @swd391s AND VersionNo = 'v1.0')
    INSERT INTO Syllabus (SubjectID, CreatedBy, ApprovedBy, VersionNo, SyllabusTitle, Description,
                          LearningOutcome, AssessmentMethod, Status, IsCurrentVersion, CreatedAt, ApprovedAt)
    VALUES (@swd391s, @adminId4, @adminId4, 'v1.0',
            N'Software Design - Design Patterns and Software Architecture',
            N'This course teaches software design patterns, UML modeling, architectural patterns, and best practices in software engineering.',
            N'Apply Gang of Four design patterns to software problems
Create UML class, sequence, and deployment diagrams
Evaluate and select appropriate architectural patterns
Conduct code reviews and refactoring sessions',
            N'Pattern implementation: 40%
Architecture design project: 30%
Final exam: 30%',
            'Active', 1, GETDATE(), GETDATE());
GO

-- ============================================================
-- 8. Learning Materials (for LAB211 syllabus)
-- ============================================================
DECLARE @adminId5  INT = (SELECT UserID FROM [User] WHERE Email = 'admin@fpt.edu.vn');
DECLARE @lab211Syl INT = (SELECT TOP 1 SyllabusID FROM Syllabus
                          WHERE SubjectID = (SELECT SubjectID FROM Subject WHERE SubjectCode='LAB211'));

IF @lab211Syl IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Learning_Material WHERE SyllabusID = @lab211Syl)
BEGIN
    INSERT INTO Learning_Material (SyllabusID, UploadedBy, MaterialName, FilePath, MaterialType, Visibility, Status)
    VALUES
    (@lab211Syl, @adminId5, N'Lab01 - Java Basics Review',       '/materials/lab211/lab01.pdf',     'PDF',  'Public', 'Active'),
    (@lab211Syl, @adminId5, N'Lab02 - OOP Fundamentals',         '/materials/lab211/lab02.pdf',     'PDF',  'Public', 'Active'),
    (@lab211Syl, @adminId5, N'Lab03 - Inheritance & Polymorphism','/materials/lab211/lab03.pdf',    'PDF',  'Public', 'Active'),
    (@lab211Syl, @adminId5, N'Lab04 - Exception Handling',       '/materials/lab211/lab04.pdf',     'PDF',  'Public', 'Active'),
    (@lab211Syl, @adminId5, N'Lab05 - Collections Framework',    '/materials/lab211/lab05.pdf',     'PDF',  'Public', 'Active'),
    (@lab211Syl, @adminId5, N'Midterm Practice Set',             '/materials/lab211/midterm.zip',   'ZIP',  'Public', 'Active'),
    (@lab211Syl, @adminId5, N'Final Exam Practice',              '/materials/lab211/final.zip',     'ZIP',  'Public', 'Active');
END;
GO

PRINT 'Sample data inserted successfully.';
GO
