/*
============================================================
  TPMS V2 — Comprehensive Seed Data Script
  Purpose: Populates the TPMS_DB with standard test accounts,
           subjects, training programs, curriculums, and 
           detailed syllabus information (CLO, Sessions, etc.)
  Date: 2026-06-23
============================================================
*/

USE [TPMS_DB]
GO

-- ============================================================
-- 1) CLEAN EXISTING DATA (in correct order of dependencies)
-- ============================================================
PRINT 'Cleaning existing tables...'

DELETE FROM dbo.[Assessment_CLO];
DELETE FROM dbo.[Session_CLO];
DELETE FROM dbo.[Syllabus_Assessment];
DELETE FROM dbo.[Syllabus_Session];
DELETE FROM dbo.[CLO];
DELETE FROM dbo.[Syllabus_Material];
DELETE FROM dbo.[Chatbot_Query_Log];
DELETE FROM dbo.[Syllabus_Feedback];
DELETE FROM dbo.[Syllabus_Approval_Request];
DELETE FROM dbo.[Learning_Material];
DELETE FROM dbo.[Syllabus];
DELETE FROM dbo.[Combo_Subject];
DELETE FROM dbo.[Combo];
DELETE FROM dbo.[Curriculum_Elective];
DELETE FROM dbo.[Curriculum_Subject];
DELETE FROM dbo.[Curriculum];
DELETE FROM dbo.[Subject_Prerequisite];
DELETE FROM dbo.[Subject];
DELETE FROM dbo.[Training_Program];
DELETE FROM dbo.[User];

PRINT 'Cleaning tables: Done.'
GO

-- ============================================================
-- 2) SEED USERS
--    Passwords are "123456" (hashed using BCrypt)
-- ============================================================
PRINT 'Seeding Users...'

-- Ensure roles exist (just in case)
-- Note: Roles are already seeded in tpmsV2.sql

INSERT INTO dbo.[User] (RoleID, Email, PasswordHash, FullName, Status, CreatedAt)
VALUES 
    (1, N'admin@tpms.com', N'$2a$10$3tznDY.vkg82w3mY/wdCzeiiDgHGX1tukoCjF1W6S2NPcPw7joeau', N'Nguyễn Văn Admin', N'Active', GETDATE()),
    (2, N'student@tpms.com', N'$2a$10$3tznDY.vkg82w3mY/wdCzeiiDgHGX1tukoCjF1W6S2NPcPw7joeau', N'Lê Văn Học Sinh', N'Active', GETDATE()),
    (3, N'teacher@tpms.com', N'$2a$10$3tznDY.vkg82w3mY/wdCzeiiDgHGX1tukoCjF1W6S2NPcPw7joeau', N'Trần Thị Giảng Viên', N'Active', GETDATE()),
    (4, N'training@tpms.com', N'$2a$10$3tznDY.vkg82w3mY/wdCzeiiDgHGX1tukoCjF1W6S2NPcPw7joeau', N'Phạm Văn Đào Tạo', N'Active', GETDATE()),
    (5, N'designer@tpms.com', N'$2a$10$3tznDY.vkg82w3mY/wdCzeiiDgHGX1tukoCjF1W6S2NPcPw7joeau', N'Đỗ Văn Biên Soạn', N'Active', GETDATE());

PRINT 'Seeding Users: Done.'
GO

-- ============================================================
-- 3) SEED TRAINING PROGRAMS
-- ============================================================
PRINT 'Seeding Training Programs...'

DECLARE @trainingStaffId INT = (SELECT TOP 1 UserID FROM dbo.[User] WHERE Email = 'training@tpms.com');

INSERT INTO dbo.[Training_Program] (CreatedBy, ProgramCode, ProgramName, AcademicYear, MajorName, PNO, Description, Status)
VALUES
    (@trainingStaffId, N'KTPM_2023', N'Kỹ thuật phần mềm', N'2023-2027', N'Kỹ thuật phần mềm', N'QĐ-123/ĐHFPT', N'Chương trình đào tạo Kỹ thuật Phần mềm chuẩn chất lượng cao FPT.', N'Active'),
    (@trainingStaffId, N'KHMT_2023', N'Khoa học máy tính', N'2023-2027', N'Khoa học máy tính', N'QĐ-124/ĐHFPT', N'Chương trình đào tạo Khoa học máy tính, tập trung vào AI và dữ liệu lớn.', N'Active');

PRINT 'Seeding Training Programs: Done.'
GO

-- ============================================================
-- 4) SEED SUBJECTS
-- ============================================================
PRINT 'Seeding Subjects...'

DECLARE @designerId INT = (SELECT TOP 1 UserID FROM dbo.[User] WHERE Email = 'designer@tpms.com');

INSERT INTO dbo.[Subject] (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
VALUES
    (@designerId, N'MAD101', N'Discrete Mathematics', 3, N'Toán rời rạc cung cấp kiến thức nền tảng về logic, đồ thị và tập hợp.', N'Active'),
    (@designerId, N'DBI202', N'Database Systems', 3, N'Hệ quản trị Cơ sở dữ liệu, thiết kế ERD và truy vấn SQL Server.', N'Active'),
    (@designerId, N'SWE201c', N'Introduction to Software Engineering', 3, N'Nhập môn Kỹ thuật phần mềm, các mô hình phát triển phần mềm Agile/Waterfall.', N'Active'),
    (@designerId, N'PRJ301', N'Java Web Application Development', 3, N'Phát triển ứng dụng Web động sử dụng Servlet, JSP, JSTL, JDBC và mô hình MVC.', N'Active'),
    (@designerId, N'SWP391', N'Software Development Project', 3, N'Dự án Phát triển phần mềm theo nhóm, thực hiện toàn bộ quy trình phát triển.', N'WaitingForSyllabus');

PRINT 'Seeding Subjects: Done.'
GO

-- ============================================================
-- 5) SEED SUBJECT PREREQUISITES
-- ============================================================
PRINT 'Seeding Subject Prerequisites...'

DECLARE @dbiId INT = (SELECT SubjectID FROM dbo.[Subject] WHERE SubjectCode = 'DBI202');
DECLARE @prjId INT = (SELECT SubjectID FROM dbo.[Subject] WHERE SubjectCode = 'PRJ301');
DECLARE @swpId INT = (SELECT SubjectID FROM dbo.[Subject] WHERE SubjectCode = 'SWP391');

INSERT INTO dbo.[Subject_Prerequisite] (SubjectID, RequiredSubjectID, ConditionType, Description)
VALUES
    (@prjId, @dbiId, N'Prerequisite', N'Học sinh phải hoàn thành học phần DBI202 trước khi học PRJ301.'),
    (@swpId, @prjId, N'Prerequisite', N'Học sinh phải hoàn thành học phần PRJ301 trước khi làm dự án SWP391.');

PRINT 'Seeding Subject Prerequisites: Done.'
GO

-- ============================================================
-- 6) SEED CURRICULUMS
-- ============================================================
PRINT 'Seeding Curriculums...'

DECLARE @programSeId INT = (SELECT ProgramID FROM dbo.[Training_Program] WHERE ProgramCode = 'KTPM_2023');
DECLARE @adminId INT = (SELECT TOP 1 UserID FROM dbo.[User] WHERE Email = 'admin@tpms.com');

INSERT INTO dbo.[Curriculum] (ProgramID, CreatedBy, CurriculumName, Description, Status)
VALUES
    (@programSeId, @adminId, N'Khung chương trình Kỹ thuật Phần mềm K19', N'Khung chương trình chuẩn áp dụng cho sinh viên ngành Kỹ thuật Phần mềm từ K19.', N'Active');

PRINT 'Seeding Curriculums: Done.'
GO

-- ============================================================
-- 7) SEED CURRICULUM SUBJECTS (MAP TO SEMESTERS)
-- ============================================================
PRINT 'Seeding Curriculum Subjects...'

DECLARE @curriculumId INT = (SELECT CurriculumID FROM dbo.[Curriculum] WHERE CurriculumName = N'Khung chương trình Kỹ thuật Phần mềm K19');
DECLARE @madId INT = (SELECT SubjectID FROM dbo.[Subject] WHERE SubjectCode = 'MAD101');
DECLARE @dbiId INT = (SELECT SubjectID FROM dbo.[Subject] WHERE SubjectCode = 'DBI202');
DECLARE @sweId INT = (SELECT SubjectID FROM dbo.[Subject] WHERE SubjectCode = 'SWE201c');
DECLARE @prjId INT = (SELECT SubjectID FROM dbo.[Subject] WHERE SubjectCode = 'PRJ301');
DECLARE @swpId INT = (SELECT SubjectID FROM dbo.[Subject] WHERE SubjectCode = 'SWP391');

INSERT INTO dbo.[Curriculum_Subject] (CurriculumID, SubjectID, SemesterNo, SubjectGroup, IsRequired, DisplayOrder)
VALUES
    (@curriculumId, @madId, 1, N'Cơ bản', 1, 1),
    (@curriculumId, @dbiId, 3, N'Chuyên ngành', 1, 2),
    (@curriculumId, @sweId, 3, N'Chuyên ngành', 1, 3),
    (@curriculumId, @prjId, 4, N'Chuyên ngành', 1, 4),
    (@curriculumId, @swpId, 5, N'Chuyên ngành', 1, 5);

PRINT 'Seeding Curriculum Subjects: Done.'
GO

-- ============================================================
-- 8) SEED SYLLABI
-- ============================================================
PRINT 'Seeding Syllabi...'

DECLARE @prjId INT = (SELECT SubjectID FROM dbo.[Subject] WHERE SubjectCode = 'PRJ301');
DECLARE @swpId INT = (SELECT SubjectID FROM dbo.[Subject] WHERE SubjectCode = 'SWP391');
DECLARE @designerId INT = (SELECT TOP 1 UserID FROM dbo.[User] WHERE Email = 'designer@tpms.com');
DECLARE @adminId INT = (SELECT TOP 1 UserID FROM dbo.[User] WHERE Email = 'admin@tpms.com');

-- Syllabus for PRJ301 (Approved)
INSERT INTO dbo.[Syllabus] (
    SubjectID, CreatedBy, ApprovedBy, VersionNo, SyllabusTitle, Description, 
    LearningOutcome, AssessmentMethod, Status, IsCurrentVersion, CreatedAt, ApprovedAt,
    SyllabusName, SyllabusEnglish, DegreeLevel, TimeAllocation, PreRequisiteText,
    StudentTasks, Tools, ScoringScale, DecisionNo, Note, MinAvgMarkToPass, IsActive
)
VALUES (
    @prjId, @designerId, @adminId, N'2.0', N'Syllabus Phát triển ứng dụng Web với Java (PRJ301)', 
    N'Khóa học này giới thiệu cho sinh viên kiến trúc ứng dụng web Java, hoạt động của máy khách/máy chủ và cách xây dựng các trang web động kết nối cơ sở dữ liệu.',
    N'Hiểu và xây dựng ứng dụng web MVC sử dụng JSP/Servlet và SQL Server.',
    N'Đánh giá qua quá trình bao gồm Lab, Quiz, Assignment và thi Project cuối kỳ.',
    N'Approved', 1, GETDATE(), GETDATE(),
    N'Phát triển ứng dụng Web với Java', N'Java Web Application Development',
    N'Đại học', N'30 giờ lý thuyết, 15 giờ thực hành/lab', N'DBI202 (Hệ quản trị Cơ sở dữ liệu)',
    N'Đọc tài liệu chuẩn bị bài trước khi lên lớp, hoàn thành đầy đủ bài lab cá nhân và bài tập lớn nhóm đúng hạn.',
    N'NetBeans / IntelliJ IDEA, SQL Server, Tomcat Server, JDK 17',
    10, N'QĐ-456/ĐHFPT', N'Syllabus cập nhật bổ sung JSTL và Filter bảo mật.',
    5.0, 1
);

-- Syllabus for SWP391 (Draft)
INSERT INTO dbo.[Syllabus] (
    SubjectID, CreatedBy, ApprovedBy, VersionNo, SyllabusTitle, Description, 
    LearningOutcome, AssessmentMethod, Status, IsCurrentVersion, CreatedAt, ApprovedAt,
    SyllabusName, SyllabusEnglish, DegreeLevel, TimeAllocation, PreRequisiteText,
    StudentTasks, Tools, ScoringScale, DecisionNo, Note, MinAvgMarkToPass, IsActive
)
VALUES (
    @swpId, @designerId, NULL, N'1.0', N'Syllabus Dự án Phát triển phần mềm (SWP391)', 
    N'Học phần dự án thực tế giúp sinh viên làm việc nhóm thiết kế và hoàn thiện một hệ thống phần mềm hoàn chỉnh.',
    N'Phát triển hoàn chỉnh một ứng dụng phần mềm có khả năng áp dụng thực tế theo quy trình Scrum/Agile.',
    N'Đánh giá tiến độ hàng tuần và bảo vệ đồ án trước hội đồng chấm thi.',
    N'Draft', 1, GETDATE(), NULL,
    N'Dự án Phát triển phần mềm', N'Software Development Project',
    N'Đại học', N'45 giờ làm việc nhóm và hướng dẫn của giáo viên hướng dẫn', N'PRJ301 hoặc PRN231',
    N'Tham gia họp nhóm hàng tuần, hoàn thiện các task được giao trên Jira, viết tài liệu đặc tả và mã nguồn đúng chuẩn.',
    N'GitHub, Jira, Draw.io, IDE phù hợp theo công nghệ nhóm chọn',
    10, NULL, N'Bản thảo thiết kế ban đầu.',
    5.0, 1
);

PRINT 'Seeding Syllabi: Done.'
GO

-- ============================================================
-- 9) SEED SYLLABUS MATERIALS
-- ============================================================
PRINT 'Seeding Syllabus Materials...'

DECLARE @prjSyllabusId INT = (SELECT SyllabusID FROM dbo.[Syllabus] WHERE SyllabusTitle = N'Syllabus Phát triển ứng dụng Web với Java (PRJ301)');
DECLARE @swpSyllabusId INT = (SELECT SyllabusID FROM dbo.[Syllabus] WHERE SyllabusTitle = N'Syllabus Dự án Phát triển phần mềm (SWP391)');

-- For PRJ301
INSERT INTO dbo.[Syllabus_Material] (SyllabusID, MaterialDescription, Author, Publisher, PublishedDate, Edition, ISBN, IsMainMaterial, IsHardCopy, IsOnline, Note, DisplayOrder)
VALUES
    (@prjSyllabusId, N'Murach''s Java Servlets and JSP', N'Joel Murach', N'Mike Murach & Associates', N'2014', N'3rd Edition', N'978-1-890774-78-3', 1, 1, 0, N'Tài liệu bắt buộc học trên lớp.', 1),
    (@prjSyllabusId, N'Java EE 8 Tuttle & Reference', N'Herbert Schildt', N'Oracle Press', N'2018', N'1st Edition', N'978-1-260117-91-2', 0, 0, 1, N'Tài liệu tham khảo bổ sung trực tuyến.', 2);

-- For SWP391
INSERT INTO dbo.[Syllabus_Material] (SyllabusID, MaterialDescription, Author, Publisher, PublishedDate, Edition, ISBN, IsMainMaterial, IsHardCopy, IsOnline, Note, DisplayOrder)
VALUES
    (@swpSyllabusId, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2019', N'9th Edition', N'978-1-259872-97-6', 1, 1, 1, N'Tài liệu tham khảo chính về quy trình phát triển.', 1);

PRINT 'Seeding Syllabus Materials: Done.'
GO

-- ============================================================
-- 10) SEED CLO (Course Learning Outcomes)
-- ============================================================
PRINT 'Seeding CLO (Course Learning Outcomes)...'

DECLARE @prjSyllabusId INT = (SELECT SyllabusID FROM dbo.[Syllabus] WHERE SyllabusTitle = N'Syllabus Phát triển ứng dụng Web với Java (PRJ301)');
DECLARE @swpSyllabusId INT = (SELECT SyllabusID FROM dbo.[Syllabus] WHERE SyllabusTitle = N'Syllabus Dự án Phát triển phần mềm (SWP391)');

-- For PRJ301
INSERT INTO dbo.[CLO] (SyllabusID, CLOName, CLODetails, LODetails, DisplayOrder)
VALUES
    (@prjSyllabusId, N'CLO_1', N'Database Connection & Retrieval', N'Thiết kế CSDL, tạo kết nối JDBC và thao tác truy xuất dữ liệu an toàn.', 1),
    (@prjSyllabusId, N'CLO_2', N'Servlet/JSP Development', N'Xây dựng luồng xử lý yêu cầu với Servlet và giao diện động hiển thị bằng JSP.', 2),
    (@prjSyllabusId, N'CLO_3', N'MVC Design Pattern', N'Tách biệt Controller, Model và View để ứng dụng dễ bảo trì và mở rộng.', 3),
    (@prjSyllabusId, N'CLO_4', N'Security & Filter', N'Triển khai Filter và Session để kiểm tra trạng thái đăng nhập và phân quyền truy cập.', 4);

-- For SWP391
INSERT INTO dbo.[CLO] (SyllabusID, CLOName, CLODetails, LODetails, DisplayOrder)
VALUES
    (@swpSyllabusId, N'CLO_1', N'Requirements Analysis & Design', N'Lấy yêu cầu, vẽ sơ đồ UML, thiết kế CSDL và kiến trúc ứng dụng.', 1),
    (@swpSyllabusId, N'CLO_2', N'Team Work & Agile/Scrum', N'Áp dụng quy trình Agile/Scrum, phân chia công việc qua Jira và quản lý mã nguồn qua GitHub.', 2),
    (@swpSyllabusId, N'CLO_3', N'Coding & Deployment', N'Lập trình hoàn chỉnh tính năng, kiểm thử chất lượng và triển khai ứng dụng lên máy chủ.', 3);

PRINT 'Seeding CLO: Done.'
GO

-- ============================================================
-- 11) SEED SYLLABUS SESSIONS
-- ============================================================
PRINT 'Seeding Syllabus Sessions...'

DECLARE @prjSyllabusId INT = (SELECT SyllabusID FROM dbo.[Syllabus] WHERE SyllabusTitle = N'Syllabus Phát triển ứng dụng Web với Java (PRJ301)');
DECLARE @swpSyllabusId INT = (SELECT SyllabusID FROM dbo.[Syllabus] WHERE SyllabusTitle = N'Syllabus Dự án Phát triển phần mềm (SWP391)');

-- For PRJ301
INSERT INTO dbo.[Syllabus_Session] (SyllabusID, SessionNumber, Topic, LearningTeachingType, ITU, StudentMaterials, SDownload, StudentTasks, URLs, DisplayOrder)
VALUES
    (@prjSyllabusId, 1, N'Web Application Fundamentals & HTTP Protocol', N'Lý thuyết & Thảo luận', N'Introduce', N'Chương 1 Murach Book', N'Slide 1', N'Đọc cấu trúc gói tin HTTP request/response', N'https://developer.mozilla.org/en-US/docs/Web/HTTP', 1),
    (@prjSyllabusId, 2, N'Servlet Lifecycle & Request Handling', N'Thực hành Lab', N'Teach', N'Chương 2, 3 Murach Book', N'Lab 1 Instruction', N'Viết Servlet nhận dữ liệu từ Form đăng ký', NULL, 2),
    (@prjSyllabusId, 3, N'Database Connectivity with JDBC', N'Lý thuyết & Thực hành', N'Teach & Utilize', N'Chương 6 Murach Book', N'DBHelper Template', N'Kết nối ứng dụng Web tới SQL Server', NULL, 3),
    (@prjSyllabusId, 4, N'JSP Expression Language (EL) & JSTL', N'Lý thuyết & Thảo luận', N'Utilize', N'Chương 4, 5 Murach Book', N'Slide 4', N'Sử dụng thẻ c:forEach để duyệt danh sách hiển thị trên JSP', NULL, 4),
    (@prjSyllabusId, 5, N'Building complete MVC application', N'Thực hành Lab', N'Utilize & Assess', N'Tài liệu tổng hợp MVC', N'Assignment Template', N'Hoàn thành bài tập lớn mô hình quản lý người dùng MVC', NULL, 5);

-- For SWP391
INSERT INTO dbo.[Syllabus_Session] (SyllabusID, SessionNumber, Topic, LearningTeachingType, ITU, StudentMaterials, SDownload, StudentTasks, URLs, DisplayOrder)
VALUES
    (@swpSyllabusId, 1, N'Project Initiation & Kick-off', N'Họp nhóm & Mentor', N'Introduce', N'SWP Guidelines', N'Project Proposal Form', N'Lập nhóm, chọn đề tài, phân chia vai trò thành viên', NULL, 1),
    (@swpSyllabusId, 2, N'Requirements Specification & Backlog creation', N'Họp nhóm', N'Teach', N'Template SRS', N'Scrum Board Setup Guide', N'Thiết kế Product Backlog trên Jira, viết tài liệu SRS', NULL, 2),
    (@swpSyllabusId, 3, N'System Architecture Design', N'Mentor review', N'Teach & Utilize', N'Software Architecture Doc Template', N'Design review checklist', N'Thiết kế sơ đồ ERD chi tiết, sơ đồ Class Diagram', NULL, 3);

PRINT 'Seeding Syllabus Sessions: Done.'
GO

-- ============================================================
-- 12) SEED SESSION <-> CLO JUNCTION (Session_CLO)
-- ============================================================
PRINT 'Seeding Session_CLO mappings...'

DECLARE @prjSyllabusId INT = (SELECT SyllabusID FROM dbo.[Syllabus] WHERE SyllabusTitle = N'Syllabus Phát triển ứng dụng Web với Java (PRJ301)');

DECLARE @sess1Id INT = (SELECT SessionID FROM dbo.[Syllabus_Session] WHERE SyllabusID = @prjSyllabusId AND SessionNumber = 1);
DECLARE @sess2Id INT = (SELECT SessionID FROM dbo.[Syllabus_Session] WHERE SyllabusID = @prjSyllabusId AND SessionNumber = 2);
DECLARE @sess3Id INT = (SELECT SessionID FROM dbo.[Syllabus_Session] WHERE SyllabusID = @prjSyllabusId AND SessionNumber = 3);
DECLARE @sess4Id INT = (SELECT SessionID FROM dbo.[Syllabus_Session] WHERE SyllabusID = @prjSyllabusId AND SessionNumber = 4);
DECLARE @sess5Id INT = (SELECT SessionID FROM dbo.[Syllabus_Session] WHERE SyllabusID = @prjSyllabusId AND SessionNumber = 5);

DECLARE @clo1Id INT = (SELECT CLOID FROM dbo.[CLO] WHERE SyllabusID = @prjSyllabusId AND CLOName = 'CLO_1');
DECLARE @clo2Id INT = (SELECT CLOID FROM dbo.[CLO] WHERE SyllabusID = @prjSyllabusId AND CLOName = 'CLO_2');
DECLARE @clo3Id INT = (SELECT CLOID FROM dbo.[CLO] WHERE SyllabusID = @prjSyllabusId AND CLOName = 'CLO_3');
DECLARE @clo4Id INT = (SELECT CLOID FROM dbo.[CLO] WHERE SyllabusID = @prjSyllabusId AND CLOName = 'CLO_4');

INSERT INTO dbo.[Session_CLO] (SessionID, CLOID)
VALUES
    (@sess1Id, @clo2Id),
    (@sess2Id, @clo2Id),
    (@sess3Id, @clo1Id),
    (@sess4Id, @clo2Id),
    (@sess5Id, @clo3Id),
    (@sess5Id, @clo4Id);

PRINT 'Seeding Session_CLO mappings: Done.'
GO

-- ============================================================
-- 13) SEED SYLLABUS ASSESSMENTS
-- ============================================================
PRINT 'Seeding Syllabus Assessments...'

DECLARE @prjSyllabusId INT = (SELECT SyllabusID FROM dbo.[Syllabus] WHERE SyllabusTitle = N'Syllabus Phát triển ứng dụng Web với Java (PRJ301)');
DECLARE @swpSyllabusId INT = (SELECT SyllabusID FROM dbo.[Syllabus] WHERE SyllabusTitle = N'Syllabus Dự án Phát triển phần mềm (SWP391)');

-- For PRJ301
INSERT INTO dbo.[Syllabus_Assessment] (
    SyllabusID, Category, Type, Part, Weight, CompletionCriteria, Duration, 
    QuestionType, NoQuestion, KnowledgeAndSkill, GradingGuide, Note, DisplayOrder
)
VALUES
    (@prjSyllabusId, N'Progress Assessment', N'Quiz', 1, 10.00, N'Điểm mỗi Quiz >= 0', N'15 phút/quiz', N'Trắc nghiệm chọn phương án đúng', N'10 câu/quiz', N'Lý thuyết Servlet, JSP, JDBC, HTTP', N'Chấm tự động trên LMS', N'Tổng cộng gồm 5 bài quiz ngắn trực tuyến.', 1),
    (@prjSyllabusId, N'Practical Assessment', N'Lab', 2, 15.00, N'Điểm trung bình Lab >= 5.0', N'Làm tại lớp & nhà', N'Lập trình bài thực hành trên máy', N'Theo file mô tả Lab', N'Viết Servlet kết nối JDBC, hiển thị dữ liệu', N'Giảng viên kiểm tra mã nguồn và chấm điểm', N'Gồm 5 bài Lab thực tế cá nhân.', 2),
    (@prjSyllabusId, N'Midterm Exam', N'Practical Exam', 3, 25.00, N'Điểm thi >= 4.0', N'90 phút', N'Lập trình thực hành xây dựng chức năng web', N'1 đề bài thi thiết kế giao diện động và kết nối DB', N'Kết hợp Servlet + JSP + JSTL + JDBC', N'Chấm thực hành chạy ứng dụng và code review', N'Thi tập trung tại phòng máy.', 3),
    (@prjSyllabusId, N'Final Project', N'Project Defense', 4, 50.00, N'Điểm đồ án nhóm >= 5.0', N'Hoàn thành trong 4 tuần cuối', N'Bảo vệ đồ án nhóm', N'Xây dựng web app MVC hoàn chỉnh', N'Tập hợp đầy đủ kiến thức bao gồm quản lý, giỏ hàng, bảo mật', N'Bảo vệ thuyết trình và trả lời câu hỏi trực tiếp', N'Làm việc theo nhóm tối đa 5 người.', 4);

-- For SWP391
INSERT INTO dbo.[Syllabus_Assessment] (
    SyllabusID, Category, Type, Part, Weight, CompletionCriteria, Duration, 
    QuestionType, NoQuestion, KnowledgeAndSkill, GradingGuide, Note, DisplayOrder
)
VALUES
    (@swpSyllabusId, N'Weekly Evaluation', N'Jira Sprint Review', 1, 30.00, N'Hoàn thành tối thiểu 80% task được giao', N'Hàng tuần', N'Đánh giá đóng góp từng cá nhân trên GitHub/Jira', N'Không áp dụng', N'Kỹ năng lập trình, quản lý công việc và tiến độ', N'Giảng viên hướng dẫn đánh giá tiến độ', N'Đóng góp đều đặn hàng tuần.', 1),
    (@swpSyllabusId, N'Final Project Defense', N'Project Presentation', 2, 70.00, N'Điểm đồ án nhóm >= 5.0 và cá nhân >= 4.0', N'Bảo vệ cuối kỳ', N'Thuyết trình sản phẩm và phản biện hội đồng', N'Sản phẩm phần mềm chạy thực tế', N'Kiến trúc ứng dụng, chất lượng mã nguồn, tài liệu kiểm thử', N'Hội đồng 3 thành viên đánh giá phản biện', N'Bắt buộc có sản phẩm hoạt động để bảo vệ.', 2);

PRINT 'Seeding Syllabus Assessments: Done.'
GO

-- ============================================================
-- 14) SEED ASSESSMENT <-> CLO JUNCTION (Assessment_CLO)
-- ============================================================
PRINT 'Seeding Assessment_CLO mappings...'

DECLARE @prjSyllabusId INT = (SELECT SyllabusID FROM dbo.[Syllabus] WHERE SyllabusTitle = N'Syllabus Phát triển ứng dụng Web với Java (PRJ301)');

DECLARE @assessQuizId INT = (SELECT AssessmentID FROM dbo.[Syllabus_Assessment] WHERE SyllabusID = @prjSyllabusId AND Category = N'Progress Assessment');
DECLARE @assessLabId INT = (SELECT AssessmentID FROM dbo.[Syllabus_Assessment] WHERE SyllabusID = @prjSyllabusId AND Category = N'Practical Assessment');
DECLARE @assessMidtermId INT = (SELECT AssessmentID FROM dbo.[Syllabus_Assessment] WHERE SyllabusID = @prjSyllabusId AND Category = N'Midterm Exam');
DECLARE @assessFinalId INT = (SELECT AssessmentID FROM dbo.[Syllabus_Assessment] WHERE SyllabusID = @prjSyllabusId AND Category = N'Final Project');

DECLARE @clo1Id INT = (SELECT CLOID FROM dbo.[CLO] WHERE SyllabusID = @prjSyllabusId AND CLOName = 'CLO_1');
DECLARE @clo2Id INT = (SELECT CLOID FROM dbo.[CLO] WHERE SyllabusID = @prjSyllabusId AND CLOName = 'CLO_2');
DECLARE @clo3Id INT = (SELECT CLOID FROM dbo.[CLO] WHERE SyllabusID = @prjSyllabusId AND CLOName = 'CLO_3');
DECLARE @clo4Id INT = (SELECT CLOID FROM dbo.[CLO] WHERE SyllabusID = @prjSyllabusId AND CLOName = 'CLO_4');

INSERT INTO dbo.[Assessment_CLO] (AssessmentID, CLOID)
VALUES
    (@assessQuizId, @clo2Id),
    (@assessLabId, @clo1Id),
    (@assessLabId, @clo2Id),
    (@assessMidtermId, @clo1Id),
    (@assessMidtermId, @clo2Id),
    (@assessMidtermId, @clo3Id),
    (@assessFinalId, @clo1Id),
    (@assessFinalId, @clo2Id),
    (@assessFinalId, @clo3Id),
    (@assessFinalId, @clo4Id);

PRINT 'Seeding Assessment_CLO mappings: Done.'
GO

-- ============================================================
-- 15) REPORT SUCCESS
-- ============================================================
PRINT '============================================================'
PRINT '  TPMS V2 Database Seeded Successfully with Rich Test Data!'
PRINT '  Available Test Accounts (Password: 123456):'
PRINT '    - Admin: admin@tpms.com'
PRINT '    - Student: student@tpms.com'
PRINT '    - Teacher: teacher@tpms.com'
PRINT '    - Training Dept: training@tpms.com'
PRINT '    - Syllabus Designer: designer@tpms.com'
PRINT '  Created Syllabi:'
PRINT '    - Approved: Java Web Application Development (PRJ301) - v2.0'
PRINT '    - Draft: Software Development Project (SWP391) - v1.0'
PRINT '============================================================'
GO
