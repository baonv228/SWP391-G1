-- Optional Phase 3: User activity / login history for System Reports
-- Run in TPMS_DB when ready to track real login events.

USE TPMS_DB;
GO

IF OBJECT_ID('dbo.UserActivityLog', 'U') IS NULL
CREATE TABLE dbo.UserActivityLog (
    LogID       INT IDENTITY(1,1) PRIMARY KEY,
    UserID      INT           NULL,
    Email       NVARCHAR(150) NULL,
    ActionType  NVARCHAR(50)  NOT NULL, -- LOGIN_SUCCESS, LOGIN_FAIL, LOGOUT, USER_CREATE, USER_UPDATE, USER_DEACTIVATE
    Detail      NVARCHAR(500) NULL,
    IpAddress   NVARCHAR(64)  NULL,
    CreatedAt   DATETIME2     NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_UAL_User FOREIGN KEY (UserID) REFERENCES dbo.[User] (UserID)
);
GO

CREATE INDEX IX_UserActivityLog_CreatedAt ON dbo.UserActivityLog (CreatedAt);
GO
