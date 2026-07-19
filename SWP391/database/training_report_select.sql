-- =====================================================================
-- View Training Report — Step 1: SELECT queries only
-- NO schema change. Uses existing tables:
--   Subject, [User], Curriculum, Curriculum_Subject,
--   Syllabus, Syllabus_Approval_Request
-- Mapping notes:
--   ReportID          = Syllabus_Approval_Request.RequestID
--   CourseID          = Subject.SubjectID
--   CourseCode        = Subject.SubjectCode  (search by code/name)
--   CourseName        = Subject.SubjectName
--   CurriculumName    = aggregated Curriculum.CurriculumName
--   CourseDescription = Subject.Description
--   CreatedBy         = user who created the Subject
--   ModifiedBy        = RequestedBy (submitter of create/update request)
--   CreatedDate       = Syllabus.CreatedAt
--   LastModifiedDate  = ISNULL(ReviewedAt, RequestedAt)
--   Status            = Approval Request Status (Draft/Pending/Approved/Rejected)
--   ReportType        = RequestType (Created/Updated or as stored)
--   NumberOfChanges   = count of feedback rows for the syllabus (proxy)
--   ChangeDetails     = ReviewNote
--   Reviewer          = ReviewedBy user name
--   ReviewDate        = ReviewedAt
-- =====================================================================

-- ---------------------------------------------------------------------
-- LIST: search (keyword), filter status + date range, sort last modified
-- Parameters (PreparedStatement order):
--   1 keyword pattern (for SubjectCode)
--   2 keyword pattern (for SubjectName)
--   3 status        (exact; use '%' or skip via dynamic SQL if empty)
--   4 fromDate      (date; filter on ISNULL(ReviewedAt, RequestedAt))
--   5 toDate        (date)
-- Sort: LastModifiedDate DESC (fixed for this feature requirement)
-- ---------------------------------------------------------------------
SELECT
    r.RequestID                                              AS ReportID,
    s.SubjectID                                              AS CourseID,
    s.SubjectCode                                            AS CourseCode,
    s.SubjectName                                            AS CourseName,
    (
        SELECT STRING_AGG(c.CurriculumName, ', ')
        FROM dbo.Curriculum_Subject cs
        INNER JOIN dbo.Curriculum c ON c.CurriculumID = cs.CurriculumID
        WHERE cs.SubjectID = s.SubjectID
    )                                                        AS CurriculumName,
    s.Description                                            AS CourseDescription,
    creator.FullName                                         AS CreatedBy,
    ISNULL(modifier.FullName, requester.FullName)            AS ModifiedBy,
    sy.CreatedAt                                             AS CreatedDate,
    ISNULL(r.ReviewedAt, r.RequestedAt)                      AS LastModifiedDate,
    r.Status                                                 AS Status,
    r.RequestType                                            AS ReportType,
    (
        SELECT COUNT(*)
        FROM dbo.Syllabus_Feedback f
        WHERE f.SyllabusID = sy.SyllabusID
    )                                                        AS NumberOfChanges,
    r.ReviewNote                                             AS ChangeDetails,
    reviewer.FullName                                        AS Reviewer,
    r.ReviewedAt                                             AS ReviewDate
FROM dbo.Syllabus_Approval_Request r
INNER JOIN dbo.Syllabus sy
    ON sy.SyllabusID = r.SyllabusID
INNER JOIN dbo.Subject s
    ON s.SubjectID = sy.SubjectID
LEFT JOIN dbo.[User] creator
    ON creator.UserID = s.CreatedBy
LEFT JOIN dbo.[User] requester
    ON requester.UserID = r.RequestedBy
LEFT JOIN dbo.[User] reviewer
    ON reviewer.UserID = r.ReviewedBy
LEFT JOIN dbo.[User] modifier
    ON modifier.UserID = ISNULL(r.ReviewedBy, r.RequestedBy)
WHERE
    (
        ? IS NULL
        OR LTRIM(RTRIM(?)) = ''
        OR s.SubjectCode LIKE ?
        OR s.SubjectName LIKE ?
    )
    AND (
        ? IS NULL
        OR LTRIM(RTRIM(?)) = ''
        OR r.Status = ?
    )
    AND (
        ? IS NULL
        OR CAST(ISNULL(r.ReviewedAt, r.RequestedAt) AS date) >= CAST(? AS date)
    )
    AND (
        ? IS NULL
        OR CAST(ISNULL(r.ReviewedAt, r.RequestedAt) AS date) <= CAST(? AS date)
    )
ORDER BY
    ISNULL(r.ReviewedAt, r.RequestedAt) DESC;

-- ---------------------------------------------------------------------
-- DETAIL: one report by ReportID (RequestID) — read-only
-- Parameter: RequestID
-- ---------------------------------------------------------------------
SELECT
    r.RequestID                                              AS ReportID,
    s.SubjectID                                              AS CourseID,
    s.SubjectCode                                            AS CourseCode,
    s.SubjectName                                            AS CourseName,
    (
        SELECT STRING_AGG(c.CurriculumName, ', ')
        FROM dbo.Curriculum_Subject cs
        INNER JOIN dbo.Curriculum c ON c.CurriculumID = cs.CurriculumID
        WHERE cs.SubjectID = s.SubjectID
    )                                                        AS CurriculumName,
    s.Description                                            AS CourseDescription,
    creator.FullName                                         AS CreatedBy,
    ISNULL(modifier.FullName, requester.FullName)            AS ModifiedBy,
    sy.CreatedAt                                             AS CreatedDate,
    ISNULL(r.ReviewedAt, r.RequestedAt)                      AS LastModifiedDate,
    r.Status                                                 AS Status,
    r.RequestType                                            AS ReportType,
    (
        SELECT COUNT(*)
        FROM dbo.Syllabus_Feedback f
        WHERE f.SyllabusID = sy.SyllabusID
    )                                                        AS NumberOfChanges,
    r.ReviewNote                                             AS ChangeDetails,
    reviewer.FullName                                        AS Reviewer,
    r.ReviewedAt                                             AS ReviewDate,
    sy.SyllabusID,
    sy.SyllabusTitle,
    sy.VersionNo
FROM dbo.Syllabus_Approval_Request r
INNER JOIN dbo.Syllabus sy
    ON sy.SyllabusID = r.SyllabusID
INNER JOIN dbo.Subject s
    ON s.SubjectID = sy.SubjectID
LEFT JOIN dbo.[User] creator
    ON creator.UserID = s.CreatedBy
LEFT JOIN dbo.[User] requester
    ON requester.UserID = r.RequestedBy
LEFT JOIN dbo.[User] reviewer
    ON reviewer.UserID = r.ReviewedBy
LEFT JOIN dbo.[User] modifier
    ON modifier.UserID = ISNULL(r.ReviewedBy, r.RequestedBy)
WHERE r.RequestID = ?;
