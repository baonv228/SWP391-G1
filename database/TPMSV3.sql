USE [master]
GO
/****** Object:  Database [TPMS_DB]    Script Date: 6/22/2026 2:45:43 PM ******/
CREATE DATABASE [TPMS_DB]
 

ALTER DATABASE [TPMS_DB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TPMS_DB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TPMS_DB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TPMS_DB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TPMS_DB] SET ARITHABORT OFF 
GO
ALTER DATABASE [TPMS_DB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TPMS_DB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TPMS_DB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TPMS_DB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TPMS_DB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TPMS_DB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TPMS_DB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TPMS_DB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TPMS_DB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TPMS_DB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [TPMS_DB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TPMS_DB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TPMS_DB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TPMS_DB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TPMS_DB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TPMS_DB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TPMS_DB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TPMS_DB] SET RECOVERY FULL 
GO
ALTER DATABASE [TPMS_DB] SET  MULTI_USER 
GO
ALTER DATABASE [TPMS_DB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TPMS_DB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TPMS_DB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TPMS_DB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TPMS_DB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TPMS_DB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'TPMS_DB', N'ON'
GO
ALTER DATABASE [TPMS_DB] SET QUERY_STORE = ON
GO
ALTER DATABASE [TPMS_DB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [TPMS_DB]
GO
/****** Object:  Table [dbo].[Assessment_CLO]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Assessment_CLO](
	[AssessmentCLOID] [int] IDENTITY(1,1) NOT NULL,
	[AssessmentID] [int] NOT NULL,
	[CLOID] [int] NOT NULL,
 CONSTRAINT [PK_Assessment_CLO] PRIMARY KEY CLUSTERED 
(
	[AssessmentCLOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Assessment_CLO] UNIQUE NONCLUSTERED 
(
	[AssessmentID] ASC,
	[CLOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Chatbot_Query_Log]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chatbot_Query_Log](
	[QueryID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[Question] [nvarchar](max) NOT NULL,
	[Answer] [nvarchar](max) NULL,
	[SourceType] [nvarchar](100) NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[QueryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CLO]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLO](
	[CLOID] [int] IDENTITY(1,1) NOT NULL,
	[SyllabusID] [int] NOT NULL,
	[CLOName] [nvarchar](50) NOT NULL,
	[CLODetails] [nvarchar](200) NULL,
	[LODetails] [nvarchar](max) NOT NULL,
	[DisplayOrder] [int] NULL,
 CONSTRAINT [PK_CLO] PRIMARY KEY CLUSTERED 
(
	[CLOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Combo]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Combo](
	[ComboID] [int] IDENTITY(1,1) NOT NULL,
	[CurriculumID] [int] NOT NULL,
	[ComboName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Status] [nvarchar](30) NOT NULL,
	[DisplayOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ComboID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Combo_Subject]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Combo_Subject](
	[ComboSubjectID] [int] IDENTITY(1,1) NOT NULL,
	[ComboID] [int] NOT NULL,
	[SubjectID] [int] NOT NULL,
	[SemesterNo] [int] NULL,
	[DisplayOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ComboSubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ComboSubject] UNIQUE NONCLUSTERED 
(
	[ComboID] ASC,
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Curriculum]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Curriculum](
	[CurriculumID] [int] IDENTITY(1,1) NOT NULL,
	[ProgramID] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CurriculumName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Status] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CurriculumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Curriculum_Elective]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Curriculum_Elective](
	[CurriculumElectiveID] [int] IDENTITY(1,1) NOT NULL,
	[CurriculumID] [int] NOT NULL,
	[SubjectID] [int] NOT NULL,
	[ElectiveGroupName] [nvarchar](150) NULL,
	[RequiredCredits] [int] NULL,
	[RequiredSubjectCount] [int] NULL,
	[DisplayOrder] [int] NULL,
	[Status] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CurriculumElectiveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_CurriculumElective] UNIQUE NONCLUSTERED 
(
	[CurriculumID] ASC,
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Curriculum_Subject]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Curriculum_Subject](
	[CurriculumSubjectID] [int] IDENTITY(1,1) NOT NULL,
	[CurriculumID] [int] NOT NULL,
	[SubjectID] [int] NOT NULL,
	[SemesterNo] [int] NULL,
	[SubjectGroup] [nvarchar](50) NULL,
	[IsRequired] [bit] NOT NULL,
	[DisplayOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CurriculumSubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_CurriculumSubject] UNIQUE NONCLUSTERED 
(
	[CurriculumID] ASC,
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Learning_Material]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Learning_Material](
	[MaterialID] [int] IDENTITY(1,1) NOT NULL,
	[SyllabusID] [int] NOT NULL,
	[UploadedBy] [int] NOT NULL,
	[MaterialName] [nvarchar](200) NOT NULL,
	[FilePath] [nvarchar](500) NOT NULL,
	[MaterialType] [nvarchar](50) NULL,
	[Visibility] [nvarchar](30) NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
	[UploadedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PLO]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PLO](
	[PloID] [int] IDENTITY(1,1) NOT NULL,
	[ProgramID] [int] NOT NULL,
	[PloCode] [nvarchar](50) NOT NULL,
	[PloDescription] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[PloID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_PLO_Program_Code] UNIQUE NONCLUSTERED 
(
	[ProgramID] ASC,
	[PloCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PO]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PO](
	[po_id] [int] IDENTITY(1,1) NOT NULL,
	[ProgramID] [int] NOT NULL,
	[po_code] [nvarchar](50) NOT NULL,
	[po_description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[po_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_PO_Program_Code] UNIQUE NONCLUSTERED 
(
	[ProgramID] ASC,
	[po_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Session_CLO]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Session_CLO](
	[SessionCLOID] [int] IDENTITY(1,1) NOT NULL,
	[SessionID] [int] NOT NULL,
	[CLOID] [int] NOT NULL,
 CONSTRAINT [PK_Session_CLO] PRIMARY KEY CLUSTERED 
(
	[SessionCLOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Session_CLO] UNIQUE NONCLUSTERED 
(
	[SessionID] ASC,
	[CLOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subject]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subject](
	[SubjectID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[SubjectCode] [nvarchar](50) NOT NULL,
	[SubjectName] [nvarchar](150) NOT NULL,
	[Credits] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Status] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SubjectCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subject_Prerequisite]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subject_Prerequisite](
	[PrerequisiteID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[RequiredSubjectID] [int] NOT NULL,
	[ConditionType] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[PrerequisiteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_SubjectPrerequisite] UNIQUE NONCLUSTERED 
(
	[SubjectID] ASC,
	[RequiredSubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Syllabus]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Syllabus](
	[SyllabusID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ApprovedBy] [int] NULL,
	[VersionNo] [nvarchar](30) NOT NULL,
	[SyllabusTitle] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[LearningOutcome] [nvarchar](max) NULL,
	[AssessmentMethod] [nvarchar](max) NULL,
	[Status] [nvarchar](30) NOT NULL,
	[IsCurrentVersion] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ApprovedAt] [datetime] NULL,
	[SyllabusName] [nvarchar](300) NULL,
	[SyllabusEnglish] [nvarchar](300) NULL,
	[DegreeLevel] [nvarchar](50) NULL,
	[TimeAllocation] [nvarchar](500) NULL,
	[PreRequisiteText] [nvarchar](500) NULL,
	[StudentTasks] [nvarchar](max) NULL,
	[Tools] [nvarchar](max) NULL,
	[ScoringScale] [int] NULL,
	[DecisionNo] [nvarchar](200) NULL,
	[Note] [nvarchar](max) NULL,
	[MinAvgMarkToPass] [decimal](3, 1) NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SyllabusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Syllabus_Version] UNIQUE NONCLUSTERED 
(
	[SubjectID] ASC,
	[VersionNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Syllabus_Approval_Request]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Syllabus_Approval_Request](
	[RequestID] [int] IDENTITY(1,1) NOT NULL,
	[SyllabusID] [int] NOT NULL,
	[RequestedBy] [int] NOT NULL,
	[ReviewedBy] [int] NULL,
	[RequestType] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
	[ReviewNote] [nvarchar](max) NULL,
	[RequestedAt] [datetime] NOT NULL,
	[ReviewedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Syllabus_Assessment]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Syllabus_Assessment](
	[AssessmentID] [int] IDENTITY(1,1) NOT NULL,
	[SyllabusID] [int] NOT NULL,
	[Category] [nvarchar](300) NOT NULL,
	[Type] [nvarchar](50) NULL,
	[Part] [int] NULL,
	[Weight] [decimal](5, 2) NOT NULL,
	[CompletionCriteria] [nvarchar](200) NULL,
	[Duration] [nvarchar](100) NULL,
	[QuestionType] [nvarchar](max) NULL,
	[NoQuestion] [nvarchar](100) NULL,
	[KnowledgeAndSkill] [nvarchar](max) NULL,
	[GradingGuide] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[DisplayOrder] [int] NULL,
 CONSTRAINT [PK_Syllabus_Assessment] PRIMARY KEY CLUSTERED 
(
	[AssessmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Syllabus_Feedback]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Syllabus_Feedback](
	[FeedbackID] [int] IDENTITY(1,1) NOT NULL,
	[SyllabusID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[FeedbackContent] [nvarchar](max) NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FeedbackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Syllabus_Material]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Syllabus_Material](
	[MaterialID] [int] IDENTITY(1,1) NOT NULL,
	[SyllabusID] [int] NOT NULL,
	[MaterialDescription] [nvarchar](500) NOT NULL,
	[Author] [nvarchar](300) NULL,
	[Publisher] [nvarchar](200) NULL,
	[PublishedDate] [nvarchar](50) NULL,
	[Edition] [nvarchar](50) NULL,
	[ISBN] [nvarchar](50) NULL,
	[IsMainMaterial] [bit] NOT NULL,
	[IsHardCopy] [bit] NOT NULL,
	[IsOnline] [bit] NOT NULL,
	[Note] [nvarchar](max) NULL,
	[DisplayOrder] [int] NULL,
 CONSTRAINT [PK_Syllabus_Material] PRIMARY KEY CLUSTERED 
(
	[MaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Syllabus_Session]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Syllabus_Session](
	[SessionID] [int] IDENTITY(1,1) NOT NULL,
	[SyllabusID] [int] NOT NULL,
	[SessionNumber] [int] NOT NULL,
	[Topic] [nvarchar](500) NOT NULL,
	[LearningTeachingType] [nvarchar](200) NULL,
	[ITU] [nvarchar](300) NULL,
	[StudentMaterials] [nvarchar](500) NULL,
	[SDownload] [nvarchar](200) NULL,
	[StudentTasks] [nvarchar](max) NULL,
	[URLs] [nvarchar](max) NULL,
	[DisplayOrder] [int] NULL,
 CONSTRAINT [PK_Syllabus_Session] PRIMARY KEY CLUSTERED 
(
	[SessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Session_Number] UNIQUE NONCLUSTERED 
(
	[SyllabusID] ASC,
	[SessionNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Training_Program]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Training_Program](
	[ProgramID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ProgramCode] [nvarchar](50) NOT NULL,
	[ProgramName] [nvarchar](150) NOT NULL,
	[AcademicYear] [nvarchar](20) NULL,
	[MajorName] [nvarchar](150) NULL,
	[Description] [nvarchar](max) NULL,
	[Status] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProgramID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ProgramCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 6/22/2026 2:45:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[PasswordHash] [nvarchar](255) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Chatbot_Query_Log] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Combo] ADD  DEFAULT ('Active') FOR [Status]
GO
ALTER TABLE [dbo].[Curriculum] ADD  DEFAULT ('Active') FOR [Status]
GO
ALTER TABLE [dbo].[Curriculum_Elective] ADD  DEFAULT ('Active') FOR [Status]
GO
ALTER TABLE [dbo].[Curriculum_Subject] ADD  DEFAULT ((1)) FOR [IsRequired]
GO
ALTER TABLE [dbo].[Learning_Material] ADD  DEFAULT ('Public') FOR [Visibility]
GO
ALTER TABLE [dbo].[Learning_Material] ADD  DEFAULT ('Active') FOR [Status]
GO
ALTER TABLE [dbo].[Learning_Material] ADD  DEFAULT (getdate()) FOR [UploadedAt]
GO
ALTER TABLE [dbo].[Subject] ADD  DEFAULT ('WaitingForSyllabus') FOR [Status]
GO
ALTER TABLE [dbo].[Syllabus] ADD  DEFAULT ('Draft') FOR [Status]
GO
ALTER TABLE [dbo].[Syllabus] ADD  DEFAULT ((0)) FOR [IsCurrentVersion]
GO
ALTER TABLE [dbo].[Syllabus] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Syllabus] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Syllabus_Approval_Request] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[Syllabus_Approval_Request] ADD  DEFAULT (getdate()) FOR [RequestedAt]
GO
ALTER TABLE [dbo].[Syllabus_Feedback] ADD  DEFAULT ('Open') FOR [Status]
GO
ALTER TABLE [dbo].[Syllabus_Feedback] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Syllabus_Material] ADD  DEFAULT ((0)) FOR [IsMainMaterial]
GO
ALTER TABLE [dbo].[Syllabus_Material] ADD  DEFAULT ((0)) FOR [IsHardCopy]
GO
ALTER TABLE [dbo].[Syllabus_Material] ADD  DEFAULT ((0)) FOR [IsOnline]
GO
ALTER TABLE [dbo].[Training_Program] ADD  DEFAULT ('Active') FOR [Status]
GO
ALTER TABLE [dbo].[User] ADD  DEFAULT ('Active') FOR [Status]
GO
ALTER TABLE [dbo].[User] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Assessment_CLO]  WITH CHECK ADD  CONSTRAINT [FK_AssessmentCLO_Assessment] FOREIGN KEY([AssessmentID])
REFERENCES [dbo].[Syllabus_Assessment] ([AssessmentID])
GO
ALTER TABLE [dbo].[Assessment_CLO] CHECK CONSTRAINT [FK_AssessmentCLO_Assessment]
GO
ALTER TABLE [dbo].[Assessment_CLO]  WITH CHECK ADD  CONSTRAINT [FK_AssessmentCLO_CLO] FOREIGN KEY([CLOID])
REFERENCES [dbo].[CLO] ([CLOID])
GO
ALTER TABLE [dbo].[Assessment_CLO] CHECK CONSTRAINT [FK_AssessmentCLO_CLO]
GO
ALTER TABLE [dbo].[Chatbot_Query_Log]  WITH CHECK ADD  CONSTRAINT [FK_ChatbotQueryLog_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Chatbot_Query_Log] CHECK CONSTRAINT [FK_ChatbotQueryLog_User]
GO
ALTER TABLE [dbo].[CLO]  WITH CHECK ADD  CONSTRAINT [FK_CLO_Syllabus] FOREIGN KEY([SyllabusID])
REFERENCES [dbo].[Syllabus] ([SyllabusID])
GO
ALTER TABLE [dbo].[CLO] CHECK CONSTRAINT [FK_CLO_Syllabus]
GO
ALTER TABLE [dbo].[Combo]  WITH CHECK ADD  CONSTRAINT [FK_Combo_Curriculum] FOREIGN KEY([CurriculumID])
REFERENCES [dbo].[Curriculum] ([CurriculumID])
GO
ALTER TABLE [dbo].[Combo] CHECK CONSTRAINT [FK_Combo_Curriculum]
GO
ALTER TABLE [dbo].[Combo_Subject]  WITH CHECK ADD  CONSTRAINT [FK_ComboSubject_Combo] FOREIGN KEY([ComboID])
REFERENCES [dbo].[Combo] ([ComboID])
GO
ALTER TABLE [dbo].[Combo_Subject] CHECK CONSTRAINT [FK_ComboSubject_Combo]
GO
ALTER TABLE [dbo].[Combo_Subject]  WITH CHECK ADD  CONSTRAINT [FK_ComboSubject_Subject] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
GO
ALTER TABLE [dbo].[Combo_Subject] CHECK CONSTRAINT [FK_ComboSubject_Subject]
GO
ALTER TABLE [dbo].[Curriculum]  WITH CHECK ADD  CONSTRAINT [FK_Curriculum_TrainingProgram] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Training_Program] ([ProgramID])
GO
ALTER TABLE [dbo].[Curriculum] CHECK CONSTRAINT [FK_Curriculum_TrainingProgram]
GO
ALTER TABLE [dbo].[Curriculum]  WITH CHECK ADD  CONSTRAINT [FK_Curriculum_User] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Curriculum] CHECK CONSTRAINT [FK_Curriculum_User]
GO
ALTER TABLE [dbo].[Curriculum_Elective]  WITH CHECK ADD  CONSTRAINT [FK_CurriculumElective_Curriculum] FOREIGN KEY([CurriculumID])
REFERENCES [dbo].[Curriculum] ([CurriculumID])
GO
ALTER TABLE [dbo].[Curriculum_Elective] CHECK CONSTRAINT [FK_CurriculumElective_Curriculum]
GO
ALTER TABLE [dbo].[Curriculum_Elective]  WITH CHECK ADD  CONSTRAINT [FK_CurriculumElective_Subject] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
GO
ALTER TABLE [dbo].[Curriculum_Elective] CHECK CONSTRAINT [FK_CurriculumElective_Subject]
GO
ALTER TABLE [dbo].[Curriculum_Subject]  WITH CHECK ADD  CONSTRAINT [FK_CurriculumSubject_Curriculum] FOREIGN KEY([CurriculumID])
REFERENCES [dbo].[Curriculum] ([CurriculumID])
GO
ALTER TABLE [dbo].[Curriculum_Subject] CHECK CONSTRAINT [FK_CurriculumSubject_Curriculum]
GO
ALTER TABLE [dbo].[Curriculum_Subject]  WITH CHECK ADD  CONSTRAINT [FK_CurriculumSubject_Subject] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
GO
ALTER TABLE [dbo].[Curriculum_Subject] CHECK CONSTRAINT [FK_CurriculumSubject_Subject]
GO
ALTER TABLE [dbo].[Learning_Material]  WITH CHECK ADD  CONSTRAINT [FK_LearningMaterial_Syllabus] FOREIGN KEY([SyllabusID])
REFERENCES [dbo].[Syllabus] ([SyllabusID])
GO
ALTER TABLE [dbo].[Learning_Material] CHECK CONSTRAINT [FK_LearningMaterial_Syllabus]
GO
ALTER TABLE [dbo].[Learning_Material]  WITH CHECK ADD  CONSTRAINT [FK_LearningMaterial_User] FOREIGN KEY([UploadedBy])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Learning_Material] CHECK CONSTRAINT [FK_LearningMaterial_User]
GO
ALTER TABLE [dbo].[PLO]  WITH CHECK ADD  CONSTRAINT [FK_PLO_TrainingProgram] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Training_Program] ([ProgramID])
GO
ALTER TABLE [dbo].[PLO] CHECK CONSTRAINT [FK_PLO_TrainingProgram]
GO
ALTER TABLE [dbo].[PO]  WITH CHECK ADD  CONSTRAINT [FK_PO_TrainingProgram] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Training_Program] ([ProgramID])
GO
ALTER TABLE [dbo].[PO] CHECK CONSTRAINT [FK_PO_TrainingProgram]
GO
ALTER TABLE [dbo].[Session_CLO]  WITH CHECK ADD  CONSTRAINT [FK_SessionCLO_CLO] FOREIGN KEY([CLOID])
REFERENCES [dbo].[CLO] ([CLOID])
GO
ALTER TABLE [dbo].[Session_CLO] CHECK CONSTRAINT [FK_SessionCLO_CLO]
GO
ALTER TABLE [dbo].[Session_CLO]  WITH CHECK ADD  CONSTRAINT [FK_SessionCLO_Session] FOREIGN KEY([SessionID])
REFERENCES [dbo].[Syllabus_Session] ([SessionID])
GO
ALTER TABLE [dbo].[Session_CLO] CHECK CONSTRAINT [FK_SessionCLO_Session]
GO
ALTER TABLE [dbo].[Subject]  WITH CHECK ADD  CONSTRAINT [FK_Subject_User] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Subject] CHECK CONSTRAINT [FK_Subject_User]
GO
ALTER TABLE [dbo].[Subject_Prerequisite]  WITH CHECK ADD  CONSTRAINT [FK_SubjectPrerequisite_RequiredSubject] FOREIGN KEY([RequiredSubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
GO
ALTER TABLE [dbo].[Subject_Prerequisite] CHECK CONSTRAINT [FK_SubjectPrerequisite_RequiredSubject]
GO
ALTER TABLE [dbo].[Subject_Prerequisite]  WITH CHECK ADD  CONSTRAINT [FK_SubjectPrerequisite_Subject] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
GO
ALTER TABLE [dbo].[Subject_Prerequisite] CHECK CONSTRAINT [FK_SubjectPrerequisite_Subject]
GO
ALTER TABLE [dbo].[Syllabus]  WITH CHECK ADD  CONSTRAINT [FK_Syllabus_ApprovedBy] FOREIGN KEY([ApprovedBy])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Syllabus] CHECK CONSTRAINT [FK_Syllabus_ApprovedBy]
GO
ALTER TABLE [dbo].[Syllabus]  WITH CHECK ADD  CONSTRAINT [FK_Syllabus_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Syllabus] CHECK CONSTRAINT [FK_Syllabus_CreatedBy]
GO
ALTER TABLE [dbo].[Syllabus]  WITH CHECK ADD  CONSTRAINT [FK_Syllabus_Subject] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
GO
ALTER TABLE [dbo].[Syllabus] CHECK CONSTRAINT [FK_Syllabus_Subject]
GO
ALTER TABLE [dbo].[Syllabus_Approval_Request]  WITH CHECK ADD  CONSTRAINT [FK_ApprovalRequest_RequestedBy] FOREIGN KEY([RequestedBy])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Syllabus_Approval_Request] CHECK CONSTRAINT [FK_ApprovalRequest_RequestedBy]
GO
ALTER TABLE [dbo].[Syllabus_Approval_Request]  WITH CHECK ADD  CONSTRAINT [FK_ApprovalRequest_ReviewedBy] FOREIGN KEY([ReviewedBy])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Syllabus_Approval_Request] CHECK CONSTRAINT [FK_ApprovalRequest_ReviewedBy]
GO
ALTER TABLE [dbo].[Syllabus_Approval_Request]  WITH CHECK ADD  CONSTRAINT [FK_ApprovalRequest_Syllabus] FOREIGN KEY([SyllabusID])
REFERENCES [dbo].[Syllabus] ([SyllabusID])
GO
ALTER TABLE [dbo].[Syllabus_Approval_Request] CHECK CONSTRAINT [FK_ApprovalRequest_Syllabus]
GO
ALTER TABLE [dbo].[Syllabus_Assessment]  WITH CHECK ADD  CONSTRAINT [FK_SyllabusAssessment_Syllabus] FOREIGN KEY([SyllabusID])
REFERENCES [dbo].[Syllabus] ([SyllabusID])
GO
ALTER TABLE [dbo].[Syllabus_Assessment] CHECK CONSTRAINT [FK_SyllabusAssessment_Syllabus]
GO
ALTER TABLE [dbo].[Syllabus_Feedback]  WITH CHECK ADD  CONSTRAINT [FK_SyllabusFeedback_Syllabus] FOREIGN KEY([SyllabusID])
REFERENCES [dbo].[Syllabus] ([SyllabusID])
GO
ALTER TABLE [dbo].[Syllabus_Feedback] CHECK CONSTRAINT [FK_SyllabusFeedback_Syllabus]
GO
ALTER TABLE [dbo].[Syllabus_Feedback]  WITH CHECK ADD  CONSTRAINT [FK_SyllabusFeedback_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Syllabus_Feedback] CHECK CONSTRAINT [FK_SyllabusFeedback_User]
GO
ALTER TABLE [dbo].[Syllabus_Material]  WITH CHECK ADD  CONSTRAINT [FK_SyllabusMaterial_Syllabus] FOREIGN KEY([SyllabusID])
REFERENCES [dbo].[Syllabus] ([SyllabusID])
GO
ALTER TABLE [dbo].[Syllabus_Material] CHECK CONSTRAINT [FK_SyllabusMaterial_Syllabus]
GO
ALTER TABLE [dbo].[Syllabus_Session]  WITH CHECK ADD  CONSTRAINT [FK_SyllabusSession_Syllabus] FOREIGN KEY([SyllabusID])
REFERENCES [dbo].[Syllabus] ([SyllabusID])
GO
ALTER TABLE [dbo].[Syllabus_Session] CHECK CONSTRAINT [FK_SyllabusSession_Syllabus]
GO
ALTER TABLE [dbo].[Training_Program]  WITH CHECK ADD  CONSTRAINT [FK_TrainingProgram_User] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Training_Program] CHECK CONSTRAINT [FK_TrainingProgram_User]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_Role] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Role] ([RoleID])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_Role]
GO
ALTER TABLE [dbo].[Subject_Prerequisite]  WITH CHECK ADD  CONSTRAINT [CK_SubjectPrerequisite_NotSelf] CHECK  (([SubjectID]<>[RequiredSubjectID]))
GO
ALTER TABLE [dbo].[Subject_Prerequisite] CHECK CONSTRAINT [CK_SubjectPrerequisite_NotSelf]
GO
USE [master]
GO
ALTER DATABASE [TPMS_DB] SET  READ_WRITE 
GO
