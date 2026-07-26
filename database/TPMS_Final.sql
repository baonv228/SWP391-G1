USE [master]
GO
/****** Object:  Database [TPMS_DB]    Script Date: 7/27/2026 12:56:37 AM ******/
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
/****** Object:  Table [dbo].[Assessment_CLO]    Script Date: 7/27/2026 12:56:38 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Chatbot_Query_Log]    Script Date: 7/27/2026 12:56:38 AM ******/
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
/****** Object:  Table [dbo].[CLO]    Script Date: 7/27/2026 12:56:38 AM ******/
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
/****** Object:  Table [dbo].[CLO_PLO]    Script Date: 7/27/2026 12:56:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLO_PLO](
	[CloPloID] [int] IDENTITY(1,1) NOT NULL,
	[CLOID] [int] NOT NULL,
	[PloID] [int] NOT NULL,
 CONSTRAINT [PK_CLO_PLO] PRIMARY KEY CLUSTERED 
(
	[CloPloID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Combo]    Script Date: 7/27/2026 12:56:38 AM ******/
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
/****** Object:  Table [dbo].[Combo_Subject]    Script Date: 7/27/2026 12:56:38 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Curriculum]    Script Date: 7/27/2026 12:56:38 AM ******/
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
/****** Object:  Table [dbo].[Curriculum_Elective]    Script Date: 7/27/2026 12:56:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Curriculum_Elective](
	[CurriculumElectiveID] [int] IDENTITY(1,1) NOT NULL,
	[CurriculumID] [int] NOT NULL,
	[SubjectID] [int] NOT NULL,
	[ElectiveGroupName] [nvarchar](150) NULL,
	[DisplayOrder] [int] NULL,
	[Status] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CurriculumElectiveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Curriculum_Subject]    Script Date: 7/27/2026 12:56:38 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Curriculum_Subject_PLO]    Script Date: 7/27/2026 12:56:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Curriculum_Subject_PLO](
	[CurriculumSubjectPloID] [int] IDENTITY(1,1) NOT NULL,
	[CurriculumID] [int] NOT NULL,
	[CurriculumSubjectID] [int] NOT NULL,
	[PloID] [int] NOT NULL,
	[ContributionLevel] [varchar](10) NULL,
	[Description] [nvarchar](500) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Curriculum_Subject_PLO] PRIMARY KEY CLUSTERED 
(
	[CurriculumSubjectPloID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Learning_Material]    Script Date: 7/27/2026 12:56:38 AM ******/
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
/****** Object:  Table [dbo].[PLO]    Script Date: 7/27/2026 12:56:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PLO](
	[PloID] [int] IDENTITY(1,1) NOT NULL,
	[CurriculumID] [int] NOT NULL,
	[PloCode] [nvarchar](50) NOT NULL,
	[PloDescription] [nvarchar](max) NULL,
 CONSTRAINT [PK_PLO] PRIMARY KEY CLUSTERED 
(
	[PloID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PO]    Script Date: 7/27/2026 12:56:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PO](
	[PoID] [int] IDENTITY(1,1) NOT NULL,
	[CurriculumID] [int] NOT NULL,
	[PoCode] [nvarchar](50) NOT NULL,
	[PoDescription] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[PoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PO_PLO]    Script Date: 7/27/2026 12:56:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PO_PLO](
	[PoPloID] [int] IDENTITY(1,1) NOT NULL,
	[PoID] [int] NOT NULL,
	[PloID] [int] NOT NULL,
 CONSTRAINT [PK_PO_PLO] PRIMARY KEY CLUSTERED 
(
	[PoPloID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 7/27/2026 12:56:38 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Session_CLO]    Script Date: 7/27/2026 12:56:38 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subject]    Script Date: 7/27/2026 12:56:38 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subject_Prerequisite]    Script Date: 7/27/2026 12:56:38 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Syllabus]    Script Date: 7/27/2026 12:56:38 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Syllabus_Approval_Request]    Script Date: 7/27/2026 12:56:38 AM ******/
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
/****** Object:  Table [dbo].[Syllabus_Assessment]    Script Date: 7/27/2026 12:56:38 AM ******/
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
/****** Object:  Table [dbo].[Syllabus_Feedback]    Script Date: 7/27/2026 12:56:38 AM ******/
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
/****** Object:  Table [dbo].[Syllabus_Material]    Script Date: 7/27/2026 12:56:38 AM ******/
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
/****** Object:  Table [dbo].[Syllabus_Session]    Script Date: 7/27/2026 12:56:38 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Training_Program]    Script Date: 7/27/2026 12:56:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Training_Program](
	[ProgramID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ProgramCode] [nvarchar](50) NOT NULL,
	[ProgramName] [nvarchar](150) NOT NULL,
	[MajorName] [nvarchar](150) NULL,
	[Description] [nvarchar](max) NULL,
	[Status] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProgramID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 7/27/2026 12:56:38 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Assessment_CLO] ON 
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (1, 1, 1)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (2, 1, 2)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (3, 1, 3)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (4, 2, 1)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (5, 2, 2)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (6, 3, 1)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (7, 3, 2)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (8, 3, 3)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (9, 3, 4)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (10, 4, 5)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (11, 5, 3)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (12, 5, 4)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (13, 6, 6)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (14, 6, 7)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (15, 6, 8)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (16, 7, 6)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (17, 7, 7)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (18, 8, 6)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (19, 8, 7)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (20, 8, 8)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (21, 8, 9)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (22, 9, 10)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (23, 10, 8)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (24, 10, 9)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (25, 11, 11)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (26, 11, 12)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (27, 11, 13)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (28, 12, 11)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (29, 12, 12)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (30, 13, 11)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (31, 13, 12)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (32, 13, 13)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (33, 13, 14)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (34, 14, 15)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (35, 15, 13)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (36, 15, 14)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (37, 16, 16)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (38, 16, 17)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (39, 16, 18)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (40, 17, 16)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (41, 17, 17)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (42, 18, 16)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (43, 18, 17)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (44, 18, 18)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (45, 18, 19)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (46, 19, 20)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (47, 20, 18)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (48, 20, 19)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (49, 21, 21)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (50, 21, 22)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (51, 21, 23)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (52, 22, 21)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (53, 22, 22)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (54, 23, 21)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (55, 23, 22)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (56, 23, 23)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (57, 23, 24)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (58, 24, 25)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (59, 25, 23)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (60, 25, 24)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (61, 26, 26)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (62, 26, 27)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (63, 26, 28)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (64, 27, 26)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (65, 27, 27)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (66, 28, 26)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (67, 28, 27)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (68, 28, 28)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (69, 28, 29)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (70, 29, 30)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (71, 30, 28)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (72, 30, 29)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (73, 31, 31)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (74, 31, 32)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (75, 31, 33)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (76, 32, 31)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (77, 32, 32)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (78, 33, 31)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (79, 33, 32)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (80, 33, 33)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (81, 33, 34)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (82, 34, 35)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (83, 35, 33)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (84, 35, 34)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (85, 36, 36)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (86, 36, 37)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (87, 36, 38)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (88, 37, 36)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (89, 37, 37)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (90, 38, 36)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (91, 38, 37)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (92, 38, 38)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (93, 38, 39)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (94, 39, 40)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (95, 40, 38)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (96, 40, 39)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (97, 41, 41)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (98, 41, 42)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (99, 41, 43)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (100, 42, 41)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (101, 42, 42)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (102, 43, 41)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (103, 43, 42)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (104, 43, 43)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (105, 43, 44)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (106, 44, 45)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (107, 45, 43)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (108, 45, 44)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (109, 46, 46)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (110, 46, 47)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (111, 46, 48)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (112, 47, 46)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (113, 47, 47)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (114, 48, 46)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (115, 48, 47)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (116, 48, 48)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (117, 48, 49)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (118, 49, 50)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (119, 50, 48)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (120, 50, 49)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (121, 51, 51)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (122, 51, 52)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (123, 51, 53)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (124, 52, 51)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (125, 52, 52)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (126, 53, 51)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (127, 53, 52)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (128, 53, 53)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (129, 53, 54)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (130, 54, 55)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (131, 55, 53)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (132, 55, 54)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (133, 56, 56)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (134, 56, 57)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (135, 56, 58)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (136, 57, 56)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (137, 57, 57)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (138, 58, 56)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (139, 58, 57)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (140, 58, 58)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (141, 58, 59)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (142, 59, 60)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (143, 60, 58)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (144, 60, 59)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (145, 61, 61)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (146, 61, 62)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (147, 61, 63)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (148, 62, 61)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (149, 62, 62)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (150, 63, 61)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (151, 63, 62)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (152, 63, 63)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (153, 63, 64)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (154, 64, 65)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (155, 65, 63)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (156, 65, 64)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (157, 66, 66)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (158, 66, 67)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (159, 66, 68)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (160, 67, 66)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (161, 67, 67)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (162, 68, 66)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (163, 68, 67)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (164, 68, 68)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (165, 68, 69)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (166, 69, 70)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (167, 70, 68)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (168, 70, 69)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (169, 71, 71)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (170, 71, 72)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (171, 71, 73)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (172, 72, 71)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (173, 72, 72)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (174, 73, 71)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (175, 73, 72)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (176, 73, 73)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (177, 73, 74)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (178, 74, 75)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (179, 75, 73)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (180, 75, 74)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (181, 76, 76)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (182, 76, 77)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (183, 76, 78)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (184, 77, 76)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (185, 77, 77)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (186, 78, 76)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (187, 78, 77)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (188, 78, 78)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (189, 78, 79)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (190, 79, 80)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (191, 80, 78)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (192, 80, 79)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (193, 81, 81)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (194, 81, 82)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (195, 81, 83)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (196, 82, 81)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (197, 82, 82)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (198, 83, 81)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (199, 83, 82)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (200, 83, 83)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (201, 83, 84)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (202, 84, 85)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (203, 85, 83)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (204, 85, 84)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (205, 86, 86)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (206, 86, 87)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (207, 86, 88)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (208, 87, 86)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (209, 87, 87)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (210, 88, 86)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (211, 88, 87)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (212, 88, 88)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (213, 88, 89)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (214, 89, 90)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (215, 90, 88)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (216, 90, 89)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (217, 91, 91)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (218, 91, 92)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (219, 91, 93)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (220, 92, 91)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (221, 92, 92)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (222, 93, 91)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (223, 93, 92)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (224, 93, 93)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (225, 93, 94)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (226, 94, 95)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (227, 95, 93)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (228, 95, 94)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (229, 96, 96)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (230, 96, 97)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (231, 96, 98)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (232, 97, 96)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (233, 97, 97)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (234, 98, 96)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (235, 98, 97)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (236, 98, 98)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (237, 98, 99)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (238, 99, 100)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (239, 100, 98)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (240, 100, 99)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (241, 101, 101)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (242, 101, 102)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (243, 101, 103)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (244, 102, 101)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (245, 102, 102)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (246, 103, 101)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (247, 103, 102)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (248, 103, 103)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (249, 103, 104)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (250, 104, 105)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (251, 105, 103)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (252, 105, 104)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (253, 106, 106)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (254, 106, 107)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (255, 106, 108)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (256, 107, 106)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (257, 107, 107)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (258, 108, 106)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (259, 108, 107)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (260, 108, 108)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (261, 108, 109)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (262, 109, 110)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (263, 110, 108)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (264, 110, 109)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (265, 111, 111)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (266, 111, 112)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (267, 111, 113)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (268, 112, 111)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (269, 112, 112)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (270, 113, 111)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (271, 113, 112)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (272, 113, 113)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (273, 113, 114)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (274, 114, 115)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (275, 115, 113)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (276, 115, 114)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (277, 116, 116)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (278, 116, 117)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (279, 116, 118)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (280, 117, 116)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (281, 117, 117)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (282, 118, 116)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (283, 118, 117)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (284, 118, 118)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (285, 118, 119)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (286, 119, 120)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (287, 120, 118)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (288, 120, 119)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (289, 121, 121)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (290, 121, 122)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (291, 121, 123)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (292, 122, 121)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (293, 122, 122)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (294, 123, 121)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (295, 123, 122)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (296, 123, 123)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (297, 123, 124)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (298, 124, 125)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (299, 125, 123)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (300, 125, 124)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (301, 126, 126)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (302, 126, 127)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (303, 126, 128)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (304, 127, 126)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (305, 127, 127)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (306, 128, 126)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (307, 128, 127)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (308, 128, 128)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (309, 128, 129)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (310, 129, 130)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (311, 130, 128)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (312, 130, 129)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (313, 131, 131)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (314, 131, 132)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (315, 131, 133)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (316, 132, 131)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (317, 132, 132)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (318, 133, 131)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (319, 133, 132)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (320, 133, 133)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (321, 133, 134)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (322, 134, 135)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (323, 135, 133)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (324, 135, 134)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (325, 136, 136)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (326, 136, 137)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (327, 136, 138)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (328, 137, 136)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (329, 137, 137)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (330, 138, 136)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (331, 138, 137)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (332, 138, 138)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (333, 138, 139)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (334, 139, 140)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (335, 140, 138)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (336, 140, 139)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (337, 141, 141)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (338, 141, 142)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (339, 141, 143)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (340, 142, 141)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (341, 142, 142)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (342, 143, 141)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (343, 143, 142)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (344, 143, 143)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (345, 143, 144)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (346, 144, 145)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (347, 145, 143)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (348, 145, 144)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (349, 146, 146)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (350, 146, 147)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (351, 146, 148)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (352, 147, 146)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (353, 147, 147)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (354, 148, 146)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (355, 148, 147)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (356, 148, 148)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (357, 148, 149)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (358, 149, 150)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (359, 150, 148)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (360, 150, 149)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (361, 151, 151)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (362, 151, 152)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (363, 151, 153)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (364, 152, 151)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (365, 152, 152)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (366, 153, 151)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (367, 153, 152)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (368, 153, 153)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (369, 153, 154)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (370, 154, 155)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (371, 155, 153)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (372, 155, 154)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (373, 156, 156)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (374, 156, 157)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (375, 156, 158)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (376, 157, 156)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (377, 157, 157)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (378, 158, 156)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (379, 158, 157)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (380, 158, 158)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (381, 158, 159)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (382, 159, 160)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (383, 160, 158)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (384, 160, 159)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (385, 161, 161)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (386, 161, 162)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (387, 161, 163)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (388, 162, 161)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (389, 162, 162)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (390, 163, 161)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (391, 163, 162)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (392, 163, 163)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (393, 163, 164)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (394, 164, 165)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (395, 165, 163)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (396, 165, 164)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (397, 166, 166)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (398, 166, 167)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (399, 166, 168)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (400, 167, 166)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (401, 167, 167)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (402, 168, 166)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (403, 168, 167)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (404, 168, 168)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (405, 168, 169)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (406, 169, 170)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (407, 170, 168)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (408, 170, 169)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (409, 171, 171)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (410, 171, 172)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (411, 171, 173)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (412, 172, 171)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (413, 172, 172)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (414, 173, 171)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (415, 173, 172)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (416, 173, 173)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (417, 173, 174)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (418, 174, 175)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (419, 175, 173)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (420, 175, 174)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (445, 186, 186)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (446, 186, 187)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (447, 186, 188)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (448, 187, 186)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (449, 187, 187)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (450, 188, 186)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (451, 188, 187)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (452, 188, 188)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (453, 188, 189)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (454, 189, 190)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (455, 190, 188)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (456, 190, 189)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (469, 196, 196)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (470, 196, 197)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (471, 196, 198)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (472, 197, 196)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (473, 197, 197)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (474, 198, 196)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (475, 198, 197)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (476, 198, 198)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (477, 198, 199)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (478, 199, 200)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (479, 200, 198)
GO
INSERT [dbo].[Assessment_CLO] ([AssessmentCLOID], [AssessmentID], [CLOID]) VALUES (480, 200, 199)
GO
SET IDENTITY_INSERT [dbo].[Assessment_CLO] OFF
GO
SET IDENTITY_INSERT [dbo].[Chatbot_Query_Log] ON 
GO
INSERT [dbo].[Chatbot_Query_Log] ([QueryID], [UserID], [Question], [Answer], [SourceType], [CreatedAt]) VALUES (1, 4, N'Học kỳ 3 ngành SE học những môn gì?', N'Dạ, theo dữ liệu chương trình đào tạo của ngành Kỹ thuật phần mềm (BIT_SE_K20), học kỳ 3 bao gồm các môn học sau đây:

| Mã môn | Tên môn học | Số tín chỉ | Loại |
| :--- | :--- | :--- | :--- |
| **CSD201** | Data Structures and Algorithms | 3 | Bắt buộc |
| **DBI202** | Introduction to Databases | 3 | Bắt buộc |
| **JPD113** | Elementary Japanese 1-A1.1 | 3 | Bắt buộc |
| **LAB211** | OOP with Java Lab | 3 | Bắt buộc |
| **WED201** | Web Design | 3 | Bắt buộc |

**Tổng cộng:** 5 môn, tất cả đều là môn bắt buộc, với tổng số **15 tín chỉ**.

Bạn có muốn tìm hiểu thêm về đề cương chi tiết hoặc tài liệu học tập của môn nào trong số này không? Mình sẵn lòng hỗ trợ bạn nhé! 😊', N'Web Chatbot', CAST(N'2026-07-26T22:47:48.757' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Chatbot_Query_Log] OFF
GO
SET IDENTITY_INSERT [dbo].[CLO] ON 
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (1, 1, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (2, 1, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (3, 1, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (4, 1, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (5, 1, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (6, 2, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (7, 2, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (8, 2, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (9, 2, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (10, 2, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (11, 3, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (12, 3, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (13, 3, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (14, 3, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (15, 3, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (16, 4, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (17, 4, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (18, 4, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (19, 4, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (20, 4, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (21, 5, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (22, 5, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (23, 5, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (24, 5, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (25, 5, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (26, 6, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (27, 6, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (28, 6, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (29, 6, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (30, 6, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (31, 7, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (32, 7, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (33, 7, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (34, 7, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (35, 7, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (36, 8, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (37, 8, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (38, 8, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (39, 8, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (40, 8, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (41, 9, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (42, 9, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (43, 9, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (44, 9, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (45, 9, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (46, 10, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (47, 10, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (48, 10, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (49, 10, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (50, 10, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (51, 11, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (52, 11, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (53, 11, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (54, 11, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (55, 11, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (56, 12, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (57, 12, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (58, 12, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (59, 12, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (60, 12, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (61, 13, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (62, 13, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (63, 13, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (64, 13, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (65, 13, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (66, 14, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (67, 14, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (68, 14, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (69, 14, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (70, 14, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (71, 15, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (72, 15, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (73, 15, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (74, 15, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (75, 15, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (76, 16, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (77, 16, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (78, 16, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (79, 16, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (80, 16, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (81, 17, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (82, 17, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (83, 17, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (84, 17, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (85, 17, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (86, 18, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (87, 18, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (88, 18, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (89, 18, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (90, 18, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (91, 19, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (92, 19, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (93, 19, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (94, 19, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (95, 19, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (96, 20, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (97, 20, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (98, 20, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (99, 20, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (100, 20, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (101, 21, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (102, 21, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (103, 21, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (104, 21, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (105, 21, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (106, 22, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (107, 22, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (108, 22, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (109, 22, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (110, 22, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (111, 23, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (112, 23, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (113, 23, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (114, 23, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (115, 23, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (116, 24, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (117, 24, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (118, 24, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (119, 24, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (120, 24, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (121, 25, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (122, 25, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (123, 25, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (124, 25, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (125, 25, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (126, 26, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (127, 26, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (128, 26, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (129, 26, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (130, 26, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (131, 27, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (132, 27, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (133, 27, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (134, 27, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (135, 27, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (136, 28, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (137, 28, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (138, 28, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (139, 28, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (140, 28, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (141, 29, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (142, 29, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (143, 29, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (144, 29, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (145, 29, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (146, 30, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (147, 30, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (148, 30, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (149, 30, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (150, 30, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (151, 31, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (152, 31, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (153, 31, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (154, 31, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (155, 31, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (156, 32, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (157, 32, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (158, 32, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (159, 32, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (160, 32, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (161, 33, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (162, 33, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (163, 33, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (164, 33, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (165, 33, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (166, 34, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (167, 34, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (168, 34, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (169, 34, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (170, 34, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (171, 35, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (172, 35, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (173, 35, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (174, 35, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (175, 35, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (186, 36, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (187, 36, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (188, 36, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (189, 36, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (190, 36, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (196, 37, N'CLO1', N'CLO1', N'Apply knowledge of computing and mathematics to develop software', 1)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (197, 37, N'CLO2', N'CLO2', N'Identify and analyze software requirements from stakeholders', 2)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (198, 37, N'CLO3', N'CLO3', N'Design and implement web-based applications using Java technologies', 3)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (199, 37, N'CLO4', N'CLO4', N'Test and debug programs systematically', 4)
GO
INSERT [dbo].[CLO] ([CLOID], [SyllabusID], [CLOName], [CLODetails], [LODetails], [DisplayOrder]) VALUES (200, 37, N'CLO5', N'CLO5', N'Work effectively in teams using software project management tools', 5)
GO
SET IDENTITY_INSERT [dbo].[CLO] OFF
GO
SET IDENTITY_INSERT [dbo].[CLO_PLO] ON 
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (1, 1, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (2, 1, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (3, 2, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (4, 2, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (5, 3, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (6, 3, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (7, 4, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (8, 4, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (9, 5, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (10, 5, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (11, 6, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (12, 6, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (13, 7, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (14, 7, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (15, 8, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (16, 8, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (17, 9, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (18, 9, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (19, 10, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (20, 10, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (21, 11, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (22, 12, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (23, 13, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (24, 14, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (25, 15, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (26, 16, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (27, 16, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (28, 17, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (29, 17, 9)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (30, 17, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (31, 18, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (32, 18, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (33, 19, 9)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (34, 19, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (35, 20, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (36, 20, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (37, 21, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (38, 22, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (39, 23, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (40, 24, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (41, 25, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (42, 26, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (43, 26, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (44, 27, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (45, 27, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (46, 28, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (47, 28, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (48, 29, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (49, 29, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (50, 30, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (51, 30, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (52, 31, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (53, 31, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (54, 32, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (55, 32, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (56, 33, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (57, 33, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (58, 34, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (59, 34, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (60, 34, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (61, 35, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (62, 35, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (63, 36, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (64, 37, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (65, 38, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (66, 39, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (67, 40, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (68, 41, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (69, 42, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (70, 43, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (71, 44, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (72, 45, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (73, 46, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (74, 47, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (75, 48, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (76, 49, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (77, 50, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (78, 51, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (79, 52, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (80, 53, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (81, 54, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (82, 55, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (83, 56, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (84, 57, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (85, 58, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (86, 59, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (87, 60, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (88, 61, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (89, 62, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (90, 63, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (91, 64, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (92, 65, 1)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (93, 66, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (94, 66, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (95, 67, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (96, 67, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (97, 68, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (98, 68, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (99, 69, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (100, 69, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (101, 70, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (102, 70, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (103, 71, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (104, 71, 21)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (105, 72, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (106, 72, 21)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (107, 73, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (108, 73, 21)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (109, 74, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (110, 74, 21)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (111, 75, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (112, 75, 21)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (113, 76, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (114, 77, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (115, 78, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (116, 79, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (117, 80, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (118, 81, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (119, 81, 22)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (120, 82, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (121, 82, 22)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (122, 83, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (123, 83, 22)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (124, 84, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (125, 84, 22)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (126, 85, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (127, 85, 22)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (128, 86, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (129, 86, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (130, 87, 9)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (131, 87, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (132, 88, 9)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (133, 88, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (134, 89, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (135, 89, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (136, 90, 9)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (137, 90, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (138, 91, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (139, 92, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (140, 93, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (141, 94, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (142, 95, 11)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (143, 96, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (144, 97, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (145, 98, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (146, 99, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (147, 100, 8)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (148, 101, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (149, 101, 21)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (150, 102, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (151, 102, 21)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (152, 103, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (153, 103, 21)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (154, 104, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (155, 104, 21)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (156, 105, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (157, 105, 21)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (158, 106, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (159, 106, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (160, 107, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (161, 107, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (162, 108, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (163, 108, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (164, 109, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (165, 109, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (166, 110, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (167, 110, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (168, 111, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (169, 112, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (170, 113, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (171, 114, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (172, 115, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (173, 115, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (174, 116, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (175, 116, 22)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (176, 117, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (177, 117, 22)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (178, 118, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (179, 118, 22)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (180, 119, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (181, 119, 22)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (182, 120, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (183, 120, 22)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (184, 121, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (185, 122, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (186, 122, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (187, 123, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (188, 123, 7)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (189, 124, 7)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (190, 124, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (191, 125, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (192, 125, 4)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (193, 125, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (194, 126, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (195, 127, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (196, 128, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (197, 129, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (198, 130, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (199, 131, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (200, 132, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (201, 133, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (202, 134, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (203, 135, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (204, 136, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (205, 136, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (206, 137, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (207, 137, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (208, 138, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (209, 138, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (210, 138, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (211, 139, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (212, 139, 25)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (213, 140, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (214, 140, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (215, 141, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (216, 141, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (217, 142, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (218, 142, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (219, 143, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (220, 143, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (221, 144, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (222, 144, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (223, 145, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (224, 145, 24)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (225, 146, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (226, 147, 9)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (227, 148, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (228, 149, 9)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (229, 150, 9)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (230, 150, 10)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (231, 151, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (232, 151, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (233, 152, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (234, 152, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (235, 153, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (236, 153, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (237, 154, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (238, 154, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (239, 154, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (240, 155, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (241, 155, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (242, 155, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (243, 156, 5)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (244, 156, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (245, 157, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (246, 157, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (247, 158, 5)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (248, 158, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (249, 158, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (250, 159, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (251, 159, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (252, 160, 6)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (253, 160, 23)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (254, 161, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (255, 161, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (256, 162, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (257, 162, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (258, 163, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (259, 163, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (260, 164, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (261, 164, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (262, 165, 12)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (263, 165, 20)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (264, 166, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (265, 166, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (266, 167, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (267, 168, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (268, 169, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (269, 170, 2)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (270, 171, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (271, 172, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (272, 173, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (273, 174, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (274, 175, 3)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (281, 186, 34)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (282, 186, 35)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (283, 187, 35)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (284, 188, 34)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (285, 189, 35)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (286, 190, 34)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (293, 196, 34)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (294, 196, 35)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (295, 197, 35)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (296, 198, 34)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (297, 199, 35)
GO
INSERT [dbo].[CLO_PLO] ([CloPloID], [CLOID], [PloID]) VALUES (298, 200, 34)
GO
SET IDENTITY_INSERT [dbo].[CLO_PLO] OFF
GO
SET IDENTITY_INSERT [dbo].[Combo] ON 
GO
INSERT [dbo].[Combo] ([ComboID], [CurriculumID], [ComboName], [Description], [Status], [DisplayOrder]) VALUES (1, 1, N'JS', N'kỹ sư cầu nối Viêt-Nhật', N'Active', NULL)
GO
INSERT [dbo].[Combo] ([ComboID], [CurriculumID], [ComboName], [Description], [Status], [DisplayOrder]) VALUES (2, 5, N'JS_IT', N'Kỹ sư cầu nối Việt-Nhật', N'Active', NULL)
GO
SET IDENTITY_INSERT [dbo].[Combo] OFF
GO
SET IDENTITY_INSERT [dbo].[Combo_Subject] ON 
GO
INSERT [dbo].[Combo_Subject] ([ComboSubjectID], [ComboID], [SubjectID], [SemesterNo], [DisplayOrder]) VALUES (1, 1, 29, 3, 1)
GO
INSERT [dbo].[Combo_Subject] ([ComboSubjectID], [ComboID], [SubjectID], [SemesterNo], [DisplayOrder]) VALUES (2, 1, 36, 7, 2)
GO
INSERT [dbo].[Combo_Subject] ([ComboSubjectID], [ComboID], [SubjectID], [SemesterNo], [DisplayOrder]) VALUES (3, 1, 39, 8, 3)
GO
INSERT [dbo].[Combo_Subject] ([ComboSubjectID], [ComboID], [SubjectID], [SemesterNo], [DisplayOrder]) VALUES (4, 1, 41, 8, 4)
GO
INSERT [dbo].[Combo_Subject] ([ComboSubjectID], [ComboID], [SubjectID], [SemesterNo], [DisplayOrder]) VALUES (5, 2, 29, 5, 1)
GO
INSERT [dbo].[Combo_Subject] ([ComboSubjectID], [ComboID], [SubjectID], [SemesterNo], [DisplayOrder]) VALUES (6, 2, 36, 7, 2)
GO
SET IDENTITY_INSERT [dbo].[Combo_Subject] OFF
GO
SET IDENTITY_INSERT [dbo].[Curriculum] ON 
GO
INSERT [dbo].[Curriculum] ([CurriculumID], [ProgramID], [CreatedBy], [CurriculumName], [Description], [Status]) VALUES (1, 1, 2, N'BIT_SE_K20', N'Đào tạo cử nhân kỹ thuật phần mềm theo chính sách', N'Active')
GO
INSERT [dbo].[Curriculum] ([CurriculumID], [ProgramID], [CreatedBy], [CurriculumName], [Description], [Status]) VALUES (2, 2, 2, N'BIT_GD_K20', N'Đào tạo cử nhân thiết kế đồ họa', N'Not Active')
GO
INSERT [dbo].[Curriculum] ([CurriculumID], [ProgramID], [CreatedBy], [CurriculumName], [Description], [Status]) VALUES (3, 1, 2, N'BIT_GD_K20_B', N'Đào tạo cử nhân kỹ thuật phần mềm', N'Active')
GO
INSERT [dbo].[Curriculum] ([CurriculumID], [ProgramID], [CreatedBy], [CurriculumName], [Description], [Status]) VALUES (5, 3, 2, N'BIT_IT_K20_A', N'Đào tạo cử nhân theo nghị định', N'Active')
GO
INSERT [dbo].[Curriculum] ([CurriculumID], [ProgramID], [CreatedBy], [CurriculumName], [Description], [Status]) VALUES (6, 4, 2, N'BIT_DD_K20', N'Đào tạo cử nhân theo nghị định', N'Not active')
GO
INSERT [dbo].[Curriculum] ([CurriculumID], [ProgramID], [CreatedBy], [CurriculumName], [Description], [Status]) VALUES (7, 4, 2, N'BIT_DD_K20_A', N'Đào tạo cử nhân', N'Active')
GO
SET IDENTITY_INSERT [dbo].[Curriculum] OFF
GO
SET IDENTITY_INSERT [dbo].[Curriculum_Elective] ON 
GO
INSERT [dbo].[Curriculum_Elective] ([CurriculumElectiveID], [CurriculumID], [SubjectID], [ElectiveGroupName], [DisplayOrder], [Status]) VALUES (1, 1, 1, N'Vovinam', 1, N'Active')
GO
INSERT [dbo].[Curriculum_Elective] ([CurriculumElectiveID], [CurriculumID], [SubjectID], [ElectiveGroupName], [DisplayOrder], [Status]) VALUES (2, 1, 2, N'Voviman', 2, N'Active')
GO
INSERT [dbo].[Curriculum_Elective] ([CurriculumElectiveID], [CurriculumID], [SubjectID], [ElectiveGroupName], [DisplayOrder], [Status]) VALUES (3, 5, 1, N'Vovinam', 1, N'Active')
GO
SET IDENTITY_INSERT [dbo].[Curriculum_Elective] OFF
GO
SET IDENTITY_INSERT [dbo].[Curriculum_Subject] ON 
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (1, 1, 11, 1, NULL, 1, 1)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (2, 1, 8, 1, NULL, 1, 2)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (3, 1, 10, 1, NULL, 1, 3)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (4, 1, 9, 1, NULL, 1, 4)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (5, 1, 7, 1, NULL, 1, 5)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (6, 1, 13, 2, NULL, 1, 6)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (7, 1, 16, 2, NULL, 1, 7)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (8, 1, 14, 2, NULL, 1, 8)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (9, 1, 12, 2, NULL, 1, 9)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (10, 1, 15, 2, NULL, 1, 10)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (11, 1, 18, 3, NULL, 1, 11)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (12, 1, 19, 3, NULL, 1, 12)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (13, 1, 17, 3, NULL, 1, 13)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (14, 1, 20, 3, NULL, 1, 14)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (15, 1, 21, 3, NULL, 1, 15)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (16, 1, 25, 4, NULL, 1, 16)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (17, 1, 23, 4, NULL, 1, 17)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (18, 1, 22, 4, NULL, 1, 18)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (19, 1, 26, 4, NULL, 1, 19)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (20, 1, 24, 4, NULL, 1, 20)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (21, 1, 28, 5, NULL, 1, 21)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (22, 1, 30, 5, NULL, 1, 22)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (23, 1, 31, 5, NULL, 1, 23)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (24, 1, 27, 5, NULL, 1, 24)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (25, 1, 33, 6, NULL, 1, 25)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (26, 1, 32, 6, NULL, 1, 26)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (27, 1, 37, 7, NULL, 1, 27)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (28, 1, 35, 7, NULL, 1, 28)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (29, 1, 42, 8, NULL, 1, 29)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (30, 1, 38, 8, NULL, 1, 30)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (31, 1, 40, 8, NULL, 1, 31)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (32, 1, 43, 8, NULL, 1, 32)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (33, 1, 45, 9, NULL, 1, 33)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (34, 1, 46, 9, NULL, 1, 34)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (35, 1, 44, 9, NULL, 1, 35)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (36, 1, 47, 9, NULL, 1, 36)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (37, 2, 11, 1, NULL, 1, 1)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (38, 2, 10, 1, NULL, 1, 2)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (39, 2, 6, 2, NULL, 1, 3)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (40, 2, 13, 2, NULL, 1, 4)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (41, 2, 33, 3, NULL, 1, 5)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (42, 2, 22, 3, NULL, 1, 6)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (43, 2, 5, 4, NULL, 1, 7)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (44, 2, 17, 5, NULL, 1, 8)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (45, 2, 23, 6, NULL, 1, 9)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (46, 2, 32, 6, NULL, 1, 10)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (47, 2, 34, 7, NULL, 1, 11)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (48, 2, 38, 8, NULL, 1, 12)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (49, 2, 40, 8, NULL, 1, 13)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (50, 2, 45, 9, NULL, 1, 14)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (51, 2, 46, 9, NULL, 1, 15)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (52, 2, 44, 9, NULL, 1, 16)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (53, 2, 47, 9, NULL, 1, 17)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (54, 3, 11, 1, NULL, 1, 1)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (55, 3, 9, 1, NULL, 1, 2)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (56, 3, 12, 2, NULL, 1, 3)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (57, 3, 18, 3, NULL, 1, 4)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (58, 3, 19, 3, NULL, 1, 5)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (59, 3, 25, 4, NULL, 1, 6)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (60, 3, 26, 4, NULL, 1, 7)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (61, 3, 24, 4, NULL, 1, 8)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (62, 3, 30, 5, NULL, 1, 9)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (63, 3, 31, 5, NULL, 1, 10)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (64, 3, 32, 6, NULL, 1, 11)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (65, 3, 35, 7, NULL, 1, 12)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (66, 3, 38, 8, NULL, 1, 13)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (67, 3, 40, 8, NULL, 1, 14)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (68, 3, 45, 9, NULL, 1, 15)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (69, 3, 46, 9, NULL, 1, 16)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (70, 3, 44, 9, NULL, 1, 17)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (71, 3, 47, 9, NULL, 1, 18)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (82, 5, 11, 1, NULL, 1, 1)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (83, 5, 8, 2, NULL, 1, 2)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (84, 5, 17, 3, NULL, 1, 3)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (85, 5, 23, 4, NULL, 1, 4)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (86, 5, 24, 5, NULL, 1, 5)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (87, 5, 32, 6, NULL, 1, 6)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (88, 5, 48, 7, NULL, 1, 7)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (89, 5, 35, 8, NULL, 1, 8)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (90, 5, 44, 9, NULL, 1, 9)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (91, 6, 11, 1, NULL, 1, 1)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (92, 6, 8, 2, NULL, 1, 2)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (93, 6, 4, 3, NULL, 1, 3)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (94, 6, 5, 4, NULL, 1, 4)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (95, 6, 32, 5, NULL, 1, 5)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (96, 6, 44, 6, NULL, 1, 6)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (97, 7, 11, 1, NULL, 1, 1)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (98, 7, 8, 2, NULL, 1, 2)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (99, 7, 33, 3, NULL, 1, 3)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (100, 7, 48, 4, NULL, 1, 4)
GO
INSERT [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID], [SubjectID], [SemesterNo], [SubjectGroup], [IsRequired], [DisplayOrder]) VALUES (101, 7, 17, 5, NULL, 1, 5)
GO
SET IDENTITY_INSERT [dbo].[Curriculum_Subject] OFF
GO
SET IDENTITY_INSERT [dbo].[Curriculum_Subject_PLO] ON 
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (1, 1, 1, 11, NULL, NULL, CAST(N'2026-07-26T18:24:33.1335773' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (2, 1, 2, 6, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (3, 1, 3, 1, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (4, 1, 4, 4, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (5, 1, 5, 12, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (6, 1, 6, 1, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (7, 1, 7, 8, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (8, 1, 8, 11, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (9, 1, 9, 4, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (10, 1, 10, 10, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (11, 1, 10, 12, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (12, 1, 11, 2, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (13, 1, 11, 8, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (14, 1, 12, 8, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (15, 1, 12, 9, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (16, 1, 12, 10, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (17, 1, 13, 1, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (18, 1, 14, 4, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (19, 1, 15, 3, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (20, 1, 16, 3, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (21, 1, 17, 12, NULL, NULL, CAST(N'2026-07-26T18:24:33.1345778' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (22, 1, 18, 1, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (23, 1, 19, 3, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (24, 1, 19, 4, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (25, 1, 19, 10, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (26, 1, 20, 10, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (27, 1, 21, 9, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (28, 1, 21, 10, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (29, 1, 22, 2, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (30, 1, 22, 6, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (31, 1, 23, 5, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (32, 1, 23, 6, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (33, 1, 24, 2, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (34, 1, 24, 3, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (35, 1, 25, 6, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (36, 1, 26, 8, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (37, 1, 26, 9, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (38, 1, 27, 8, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (39, 1, 28, 2, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (40, 1, 29, 11, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (41, 1, 29, 12, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (42, 1, 30, 12, NULL, NULL, CAST(N'2026-07-26T18:24:33.1355920' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (43, 1, 31, 12, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (44, 1, 32, 3, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (45, 1, 32, 4, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (46, 1, 32, 6, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (47, 1, 32, 10, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (48, 1, 33, 12, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (49, 1, 34, 12, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (50, 1, 35, 2, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (51, 1, 35, 3, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (52, 1, 35, 4, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (53, 1, 35, 6, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (54, 1, 35, 7, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (55, 1, 35, 10, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (56, 1, 36, 12, NULL, NULL, CAST(N'2026-07-26T18:24:33.1365768' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (57, 3, 54, 20, NULL, NULL, CAST(N'2026-07-26T18:42:42.2640314' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (58, 3, 55, 21, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (59, 3, 56, 22, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (60, 3, 57, 23, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (61, 3, 57, 25, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (62, 3, 58, 24, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (63, 3, 59, 24, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (64, 3, 59, 25, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (65, 3, 60, 25, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (66, 3, 61, 24, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (67, 3, 62, 23, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (68, 3, 63, 23, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (69, 3, 64, 23, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (70, 3, 64, 25, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (71, 3, 65, 24, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (72, 3, 65, 25, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (73, 3, 66, 24, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (74, 3, 67, 21, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (75, 3, 68, 20, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (76, 3, 69, 22, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (77, 3, 70, 21, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (78, 3, 70, 22, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (79, 3, 70, 24, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (80, 3, 71, 20, NULL, NULL, CAST(N'2026-07-26T18:42:42.2650267' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (81, 5, 82, 31, NULL, NULL, CAST(N'2026-07-26T22:37:27.6519652' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (82, 5, 83, 32, NULL, NULL, CAST(N'2026-07-26T22:37:27.6529658' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (83, 5, 84, 33, NULL, NULL, CAST(N'2026-07-26T22:37:27.6534955' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (84, 5, 85, 34, NULL, NULL, CAST(N'2026-07-26T22:37:27.6534955' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (85, 5, 86, 35, NULL, NULL, CAST(N'2026-07-26T22:37:27.6534955' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (86, 5, 87, 36, NULL, NULL, CAST(N'2026-07-26T22:37:27.6534955' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (87, 5, 88, 34, NULL, NULL, CAST(N'2026-07-26T22:37:27.6534955' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (88, 5, 88, 35, NULL, NULL, CAST(N'2026-07-26T22:37:27.6534955' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (89, 5, 89, 36, NULL, NULL, CAST(N'2026-07-26T22:37:27.6534955' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (90, 5, 90, 34, NULL, NULL, CAST(N'2026-07-26T22:37:27.6534955' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (91, 5, 90, 35, NULL, NULL, CAST(N'2026-07-26T22:37:27.6534955' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (92, 5, 90, 36, NULL, NULL, CAST(N'2026-07-26T22:37:27.6534955' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (93, 6, 91, 37, NULL, NULL, CAST(N'2026-07-27T00:53:40.0202692' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (94, 6, 92, 38, NULL, NULL, CAST(N'2026-07-27T00:53:40.0207736' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (95, 6, 93, 39, NULL, NULL, CAST(N'2026-07-27T00:53:40.0207736' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (96, 6, 94, 40, NULL, NULL, CAST(N'2026-07-27T00:53:40.0217826' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (97, 6, 95, 40, NULL, NULL, CAST(N'2026-07-27T00:53:40.0217826' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (98, 6, 96, 39, NULL, NULL, CAST(N'2026-07-27T00:53:40.0217826' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (99, 6, 96, 40, NULL, NULL, CAST(N'2026-07-27T00:53:40.0217826' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (100, 7, 97, 41, NULL, NULL, CAST(N'2026-07-27T00:55:45.4274170' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (101, 7, 98, 42, NULL, NULL, CAST(N'2026-07-27T00:55:45.4274170' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (102, 7, 99, 43, NULL, NULL, CAST(N'2026-07-27T00:55:45.4284219' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (103, 7, 100, 42, NULL, NULL, CAST(N'2026-07-27T00:55:45.4284219' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (104, 7, 100, 44, NULL, NULL, CAST(N'2026-07-27T00:55:45.4284219' AS DateTime2))
GO
INSERT [dbo].[Curriculum_Subject_PLO] ([CurriculumSubjectPloID], [CurriculumID], [CurriculumSubjectID], [PloID], [ContributionLevel], [Description], [CreatedAt]) VALUES (105, 7, 101, 44, NULL, NULL, CAST(N'2026-07-27T00:55:45.4284219' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Curriculum_Subject_PLO] OFF
GO
SET IDENTITY_INSERT [dbo].[Learning_Material] ON 
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (1, 1, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785066747/flm_materials/1785066745601_1785066745499_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T18:52:27.670' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (2, 2, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785066803/flm_materials/1785066801755_1785066801705_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T18:53:22.937' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (3, 3, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785066845/flm_materials/1785066843423_1785066843379_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T18:54:04.727' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (4, 4, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785066882/flm_materials/1785066880759_1785066880705_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T18:54:41.970' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (5, 5, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785066923/flm_materials/1785066921416_1785066921371_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T18:55:22.587' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (6, 6, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785066987/flm_materials/1785066985863_1785066985820_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T18:56:27.203' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (7, 7, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067030/flm_materials/1785067029012_1785067028962_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T18:57:10.317' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (8, 8, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067070/flm_materials/1785067068610_1785067068560_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T18:57:49.887' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (9, 9, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067140/flm_materials/1785067139071_1785067139023_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T18:59:00.417' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (10, 10, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067174/flm_materials/1785067172980_1785067172914_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T18:59:34.173' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (11, 11, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067220/flm_materials/1785067218071_1785067218030_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:00:19.563' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (12, 12, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067259/flm_materials/1785067257291_1785067257234_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:00:58.723' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (13, 13, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067295/flm_materials/1785067293230_1785067293178_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:01:34.530' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (14, 14, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067353/flm_materials/1785067351775_1785067351730_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:02:32.960' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (15, 15, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067400/flm_materials/1785067398676_1785067398630_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:03:20.183' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (16, 16, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067435/flm_materials/1785067433828_1785067433780_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:03:55.023' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (17, 17, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067490/flm_materials/1785067488856_1785067488788_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:04:50.107' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (18, 18, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067542/flm_materials/1785067541076_1785067541025_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:05:42.340' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (19, 19, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067581/flm_materials/1785067579381_1785067579336_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:06:20.600' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (20, 20, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067615/flm_materials/1785067613577_1785067613531_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:06:54.787' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (21, 21, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067653/flm_materials/1785067651931_1785067651880_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:07:33.100' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (22, 22, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067700/flm_materials/1785067698773_1785067698732_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:08:19.917' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (23, 23, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067754/flm_materials/1785067752335_1785067752289_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:09:13.613' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (24, 24, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067812/flm_materials/1785067810496_1785067810450_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:10:11.763' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (25, 25, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067859/flm_materials/1785067857974_1785067857920_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:10:59.213' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (26, 26, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067897/flm_materials/1785067895332_1785067895277_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:11:36.533' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (27, 27, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067932/flm_materials/1785067930928_1785067930881_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:12:12.180' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (28, 28, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785067975/flm_materials/1785067973781_1785067973731_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:12:55.013' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (29, 29, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785068029/flm_materials/1785068028102_1785068028043_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:13:49.390' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (30, 30, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785068063/flm_materials/1785068061565_1785068061514_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:14:22.933' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (31, 31, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785068116/flm_materials/1785068114440_1785068114390_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:15:15.607' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (32, 32, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785068159/flm_materials/1785068157888_1785068157835_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:15:59.103' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (33, 33, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785068216/flm_materials/1785068214393_1785068214345_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:16:55.550' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (34, 34, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785068259/flm_materials/1785068258160_1785068258114_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:17:39.380' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (35, 35, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785068302/flm_materials/1785068300863_1785068300815_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T19:18:22.090' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (36, 36, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785080540/flm_materials/1785080537584_1785080537506_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T22:42:19.570' AS DateTime))
GO
INSERT [dbo].[Learning_Material] ([MaterialID], [SyllabusID], [UploadedBy], [MaterialName], [FilePath], [MaterialType], [Visibility], [Status], [UploadedAt]) VALUES (37, 37, 3, N'Student Material Package', N'https://res.cloudinary.com/uaeubktv/raw/upload/v1785080540/flm_materials/1785080537584_1785080537506_material.zip', N'ZIP', N'Public', N'Active', CAST(N'2026-07-26T22:46:16.403' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Learning_Material] OFF
GO
SET IDENTITY_INSERT [dbo].[PLO] ON 
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (1, 1, N'PLO01', N'Applying knowledge of mathematics, statistics, and natural sciences to solve software engineering problems.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (2, 1, N'PLO02', N'Analyzing user requirements to transform them into complete software system specifications.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (3, 1, N'PLO03', N'Designing software architecture, databases, and user interfaces (UI/UX) to meet technical standards.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (4, 1, N'PLO04', N'Programming software using modern languages ​​(Java, Python, C#, JS) according to clean source code principles.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (5, 1, N'PLO05', N'Planning and implementing software testing processes to ensure product quality.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (6, 1, N'PLO06', N'Deploying, operating, and maintaining software systems on various platforms (Cloud, Mobile, Web).')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (7, 1, N'PLO07', N'Proficiently using modern software development tools (Git, Docker, CI/CD pipelines).')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (8, 1, N'PLO08', N'Effective technical communication through documentation, solution presentations, and debates.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (9, 1, N'PLO09', N'Ability to read and understand technical documents and communicate effectively in a foreign language (usually English).')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (10, 1, N'PLO10', N'Effective teamwork and project management skills using Agile/Scrum models.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (11, 1, N'PLO11', N'Adherence to professional ethics, data security, and cybersecurity laws.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (12, 1, N'PLO12', N'Ability to assess the impact of software solutions on the global economy, society, and environment.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (13, 2, N'PLO01', N'Applying knowledge of mathematics, statistics, and natural sciences to solve software engineering problems.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (14, 2, N'PLO02', N'Analyzing user requirements to transform them into complete software system specifications.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (15, 2, N'PLO03', N'Designing software architecture, databases, and user interfaces (UI/UX) to meet technical standards.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (16, 2, N'PLO04', N'Planning and implementing software testing processes to ensure product quality.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (17, 2, N'PLO05', N'Effective technical communication through documentation, solution presentations, and debates.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (18, 2, N'PLO06', N'Ability to read and understand technical documents and communicate effectively in a foreign language (usually English).')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (19, 2, N'PLO07', N'Adherence to professional ethics, data security, and cybersecurity laws.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (20, 3, N'PLO01', N'Applying knowledge of mathematics, statistics, and natural sciences to solve software engineering problems.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (21, 3, N'PLO02', N'Analyzing user requirements to transform them into complete software system specifications.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (22, 3, N'PLO03', N'Designing software architecture, databases, and user interfaces (UI/UX) to meet technical standards.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (23, 3, N'PLO04', N'Proficiently using modern software development tools (Git, Docker, CI/CD pipelines).')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (24, 3, N'PLO05', N'Effective technical communication through documentation, solution presentations, and debates.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (25, 3, N'PLO06', N'Adherence to professional ethics, data security, and cybersecurity laws.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (31, 5, N'PLO01', N'Applying knowledge of mathematics, statistics, and natural sciences to solve software engineering problems.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (32, 5, N'PLO02', N'Analyzing user requirements to transform them into complete software system specifications.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (33, 5, N'PLO03', N'Designing software architecture, databases, and user interfaces (UI/UX) to meet technical standards.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (34, 5, N'PLO04', N'Proficiently using modern software development tools (Git, Docker, CI/CD pipelines).')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (35, 5, N'PLO05', N'Effective technical communication through documentation, solution presentations, and debates.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (36, 5, N'PLO06', N'Adherence to professional ethics, data security, and cybersecurity laws.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (37, 6, N'PLO01', N'Applying knowledge of mathematics, statistics, and natural sciences to solve software engineering problems.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (38, 6, N'PLO02', N'Analyzing user requirements to transform them into complete software system specifications.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (39, 6, N'PLO03', N'Designing software architecture, databases, and user interfaces (UI/UX) to meet technical standards.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (40, 6, N'PLO04', N'Proficiently using modern software development tools (Git, Docker, CI/CD pipelines).')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (41, 7, N'PLO01', N'Proficiently using modern software development tools (Git, Docker, CI/CD pipelines).')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (42, 7, N'PLO02', N'Applying knowledge of mathematics, statistics, and natural sciences to solve software engineering problems.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (43, 7, N'PLO03', N'Adherence to professional ethics, data security, and cybersecurity laws.')
GO
INSERT [dbo].[PLO] ([PloID], [CurriculumID], [PloCode], [PloDescription]) VALUES (44, 7, N'PLO04', N'Effective technical communication through documentation, solution presentations, and debates.')
GO
SET IDENTITY_INSERT [dbo].[PLO] OFF
GO
SET IDENTITY_INSERT [dbo].[PO] ON 
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (1, 1, N'PO01', N'Design and develop professional software solutions to address real-world problems.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (2, 1, N'PO02', N'Work in teams, organize, and manage technology projects in a global environment.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (3, 1, N'PO03', N'Continuously learn, update on new technologies, and strengthen professional ethics.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (4, 2, N'PO01', N'Design and develop professional software solutions to address real-world problems.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (5, 2, N'PO02', N'Work in teams, organize, and manage technology projects in a global environment.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (6, 2, N'PO03', N'Continuously learn, update on new technologies, and strengthen professional ethics.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (7, 3, N'PO01', N'Design and develop professional software solutions to address real-world problems.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (8, 3, N'PO02', N'Work in teams, organize, and manage technology projects in a global environment.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (9, 3, N'PO03', N'Continuously learn, update on new technologies, and strengthen professional ethics.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (10, 5, N'PO01', N'Design and develop professional software solutions to address real-world problems.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (11, 5, N'PO02', N'Work in teams, organize, and manage technology projects in a global environment.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (12, 5, N'PO03', N'Continuously learn, update on new technologies, and strengthen professional ethics.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (13, 6, N'PO01', N'Design and develop professional software solutions to address real-world problems.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (14, 6, N'PO02', N'Work in teams, organize, and manage technology projects in a global environment.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (15, 7, N'PO01', N'Work in teams, organize, and manage technology projects in a global environment.')
GO
INSERT [dbo].[PO] ([PoID], [CurriculumID], [PoCode], [PoDescription]) VALUES (16, 7, N'PO02', N'Continuously learn, update on new technologies, and strengthen professional ethics.')
GO
SET IDENTITY_INSERT [dbo].[PO] OFF
GO
SET IDENTITY_INSERT [dbo].[PO_PLO] ON 
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (1, 1, 1)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (2, 1, 2)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (9, 1, 9)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (13, 1, 12)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (3, 2, 3)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (4, 2, 4)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (7, 2, 7)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (11, 2, 11)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (14, 2, 12)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (5, 3, 5)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (6, 3, 6)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (8, 3, 8)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (10, 3, 9)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (12, 3, 11)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (15, 7, 20)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (18, 7, 23)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (16, 8, 21)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (20, 8, 24)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (17, 9, 22)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (19, 9, 23)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (21, 9, 25)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (22, 10, 31)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (24, 10, 33)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (28, 10, 36)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (23, 11, 32)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (26, 11, 34)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (29, 11, 36)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (25, 12, 33)
GO
INSERT [dbo].[PO_PLO] ([PoPloID], [PoID], [PloID]) VALUES (27, 12, 34)
GO
SET IDENTITY_INSERT [dbo].[PO_PLO] OFF
GO
SET IDENTITY_INSERT [dbo].[Role] ON 
GO
INSERT [dbo].[Role] ([RoleID], [RoleName], [Description]) VALUES (1, N'Admin', N'System administrator')
GO
INSERT [dbo].[Role] ([RoleID], [RoleName], [Description]) VALUES (2, N'Student', N'Student user')
GO
INSERT [dbo].[Role] ([RoleID], [RoleName], [Description]) VALUES (3, N'Teacher', N'Teacher user')
GO
INSERT [dbo].[Role] ([RoleID], [RoleName], [Description]) VALUES (4, N'Training Department', N'Training program management staff')
GO
INSERT [dbo].[Role] ([RoleID], [RoleName], [Description]) VALUES (5, N'Syllabus Designer', N'User responsible for syllabus design')
GO
SET IDENTITY_INSERT [dbo].[Role] OFF
GO
SET IDENTITY_INSERT [dbo].[Session_CLO] ON 
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (1, 1, 1)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (2, 2, 2)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (3, 3, 3)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (4, 4, 4)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (5, 5, 5)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (6, 6, 1)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (7, 7, 2)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (8, 8, 3)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (9, 9, 4)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (10, 10, 5)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (11, 11, 1)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (12, 12, 2)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (13, 13, 3)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (14, 14, 4)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (15, 15, 5)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (16, 16, 1)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (17, 17, 2)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (18, 18, 3)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (19, 19, 4)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (20, 20, 5)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (21, 21, 6)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (22, 22, 7)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (23, 23, 8)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (24, 24, 9)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (25, 25, 10)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (26, 26, 6)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (27, 27, 7)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (28, 28, 8)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (29, 29, 9)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (30, 30, 10)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (31, 31, 6)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (32, 32, 7)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (33, 33, 8)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (34, 34, 9)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (35, 35, 10)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (36, 36, 6)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (37, 37, 7)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (38, 38, 8)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (39, 39, 9)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (40, 40, 10)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (41, 41, 11)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (42, 42, 12)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (43, 43, 13)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (44, 44, 14)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (45, 45, 15)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (46, 46, 11)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (47, 47, 12)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (48, 48, 13)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (49, 49, 14)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (50, 50, 15)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (51, 51, 11)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (52, 52, 12)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (53, 53, 13)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (54, 54, 14)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (55, 55, 15)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (56, 56, 11)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (57, 57, 12)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (58, 58, 13)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (59, 59, 14)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (60, 60, 15)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (61, 61, 16)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (62, 62, 17)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (63, 63, 18)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (64, 64, 19)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (65, 65, 20)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (66, 66, 16)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (67, 67, 17)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (68, 68, 18)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (69, 69, 19)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (70, 70, 20)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (71, 71, 16)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (72, 72, 17)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (73, 73, 18)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (74, 74, 19)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (75, 75, 20)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (76, 76, 16)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (77, 77, 17)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (78, 78, 18)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (79, 79, 19)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (80, 80, 20)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (81, 81, 21)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (82, 82, 22)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (83, 83, 23)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (84, 84, 24)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (85, 85, 25)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (86, 86, 21)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (87, 87, 22)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (88, 88, 23)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (89, 89, 24)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (90, 90, 25)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (91, 91, 21)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (92, 92, 22)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (93, 93, 23)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (94, 94, 24)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (95, 95, 25)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (96, 96, 21)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (97, 97, 22)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (98, 98, 23)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (99, 99, 24)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (100, 100, 25)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (101, 101, 26)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (102, 102, 27)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (103, 103, 28)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (104, 104, 29)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (105, 105, 30)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (106, 106, 26)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (107, 107, 27)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (108, 108, 28)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (109, 109, 29)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (110, 110, 30)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (111, 111, 26)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (112, 112, 27)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (113, 113, 28)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (114, 114, 29)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (115, 115, 30)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (116, 116, 26)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (117, 117, 27)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (118, 118, 28)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (119, 119, 29)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (120, 120, 30)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (121, 121, 31)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (122, 122, 32)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (123, 123, 33)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (124, 124, 34)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (125, 125, 35)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (126, 126, 31)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (127, 127, 32)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (128, 128, 33)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (129, 129, 34)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (130, 130, 35)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (131, 131, 31)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (132, 132, 32)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (133, 133, 33)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (134, 134, 34)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (135, 135, 35)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (136, 136, 31)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (137, 137, 32)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (138, 138, 33)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (139, 139, 34)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (140, 140, 35)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (141, 141, 36)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (142, 142, 37)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (143, 143, 38)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (144, 144, 39)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (145, 145, 40)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (146, 146, 36)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (147, 147, 37)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (148, 148, 38)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (149, 149, 39)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (150, 150, 40)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (151, 151, 36)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (152, 152, 37)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (153, 153, 38)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (154, 154, 39)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (155, 155, 40)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (156, 156, 36)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (157, 157, 37)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (158, 158, 38)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (159, 159, 39)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (160, 160, 40)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (161, 161, 41)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (162, 162, 42)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (163, 163, 43)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (164, 164, 44)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (165, 165, 45)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (166, 166, 41)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (167, 167, 42)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (168, 168, 43)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (169, 169, 44)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (170, 170, 45)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (171, 171, 41)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (172, 172, 42)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (173, 173, 43)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (174, 174, 44)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (175, 175, 45)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (176, 176, 41)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (177, 177, 42)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (178, 178, 43)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (179, 179, 44)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (180, 180, 45)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (181, 181, 46)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (182, 182, 47)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (183, 183, 48)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (184, 184, 49)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (185, 185, 50)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (186, 186, 46)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (187, 187, 47)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (188, 188, 48)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (189, 189, 49)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (190, 190, 50)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (191, 191, 46)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (192, 192, 47)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (193, 193, 48)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (194, 194, 49)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (195, 195, 50)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (196, 196, 46)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (197, 197, 47)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (198, 198, 48)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (199, 199, 49)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (200, 200, 50)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (201, 201, 51)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (202, 202, 52)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (203, 203, 53)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (204, 204, 54)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (205, 205, 55)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (206, 206, 51)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (207, 207, 52)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (208, 208, 53)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (209, 209, 54)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (210, 210, 55)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (211, 211, 51)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (212, 212, 52)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (213, 213, 53)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (214, 214, 54)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (215, 215, 55)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (216, 216, 51)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (217, 217, 52)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (218, 218, 53)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (219, 219, 54)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (220, 220, 55)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (221, 221, 56)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (222, 222, 57)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (223, 223, 58)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (224, 224, 59)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (225, 225, 60)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (226, 226, 56)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (227, 227, 57)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (228, 228, 58)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (229, 229, 59)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (230, 230, 60)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (231, 231, 56)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (232, 232, 57)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (233, 233, 58)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (234, 234, 59)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (235, 235, 60)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (236, 236, 56)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (237, 237, 57)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (238, 238, 58)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (239, 239, 59)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (240, 240, 60)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (241, 241, 61)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (242, 242, 62)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (243, 243, 63)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (244, 244, 64)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (245, 245, 65)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (246, 246, 61)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (247, 247, 62)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (248, 248, 63)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (249, 249, 64)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (250, 250, 65)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (251, 251, 61)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (252, 252, 62)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (253, 253, 63)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (254, 254, 64)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (255, 255, 65)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (256, 256, 61)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (257, 257, 62)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (258, 258, 63)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (259, 259, 64)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (260, 260, 65)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (261, 261, 66)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (262, 262, 67)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (263, 263, 68)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (264, 264, 69)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (265, 265, 70)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (266, 266, 66)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (267, 267, 67)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (268, 268, 68)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (269, 269, 69)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (270, 270, 70)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (271, 271, 66)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (272, 272, 67)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (273, 273, 68)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (274, 274, 69)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (275, 275, 70)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (276, 276, 66)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (277, 277, 67)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (278, 278, 68)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (279, 279, 69)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (280, 280, 70)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (281, 281, 71)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (282, 282, 72)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (283, 283, 73)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (284, 284, 74)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (285, 285, 75)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (286, 286, 71)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (287, 287, 72)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (288, 288, 73)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (289, 289, 74)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (290, 290, 75)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (291, 291, 71)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (292, 292, 72)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (293, 293, 73)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (294, 294, 74)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (295, 295, 75)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (296, 296, 71)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (297, 297, 72)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (298, 298, 73)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (299, 299, 74)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (300, 300, 75)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (301, 301, 76)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (302, 302, 77)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (303, 303, 78)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (304, 304, 79)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (305, 305, 80)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (306, 306, 76)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (307, 307, 77)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (308, 308, 78)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (309, 309, 79)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (310, 310, 80)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (311, 311, 76)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (312, 312, 77)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (313, 313, 78)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (314, 314, 79)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (315, 315, 80)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (316, 316, 76)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (317, 317, 77)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (318, 318, 78)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (319, 319, 79)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (320, 320, 80)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (321, 321, 81)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (322, 322, 82)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (323, 323, 83)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (324, 324, 84)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (325, 325, 85)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (326, 326, 81)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (327, 327, 82)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (328, 328, 83)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (329, 329, 84)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (330, 330, 85)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (331, 331, 81)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (332, 332, 82)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (333, 333, 83)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (334, 334, 84)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (335, 335, 85)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (336, 336, 81)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (337, 337, 82)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (338, 338, 83)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (339, 339, 84)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (340, 340, 85)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (341, 341, 86)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (342, 342, 87)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (343, 343, 88)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (344, 344, 89)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (345, 345, 90)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (346, 346, 86)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (347, 347, 87)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (348, 348, 88)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (349, 349, 89)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (350, 350, 90)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (351, 351, 86)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (352, 352, 87)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (353, 353, 88)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (354, 354, 89)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (355, 355, 90)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (356, 356, 86)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (357, 357, 87)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (358, 358, 88)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (359, 359, 89)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (360, 360, 90)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (361, 361, 91)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (362, 362, 92)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (363, 363, 93)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (364, 364, 94)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (365, 365, 95)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (366, 366, 91)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (367, 367, 92)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (368, 368, 93)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (369, 369, 94)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (370, 370, 95)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (371, 371, 91)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (372, 372, 92)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (373, 373, 93)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (374, 374, 94)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (375, 375, 95)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (376, 376, 91)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (377, 377, 92)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (378, 378, 93)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (379, 379, 94)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (380, 380, 95)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (381, 381, 96)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (382, 382, 97)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (383, 383, 98)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (384, 384, 99)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (385, 385, 100)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (386, 386, 96)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (387, 387, 97)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (388, 388, 98)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (389, 389, 99)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (390, 390, 100)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (391, 391, 96)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (392, 392, 97)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (393, 393, 98)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (394, 394, 99)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (395, 395, 100)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (396, 396, 96)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (397, 397, 97)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (398, 398, 98)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (399, 399, 99)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (400, 400, 100)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (401, 401, 101)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (402, 402, 102)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (403, 403, 103)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (404, 404, 104)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (405, 405, 105)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (406, 406, 101)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (407, 407, 102)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (408, 408, 103)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (409, 409, 104)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (410, 410, 105)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (411, 411, 101)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (412, 412, 102)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (413, 413, 103)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (414, 414, 104)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (415, 415, 105)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (416, 416, 101)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (417, 417, 102)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (418, 418, 103)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (419, 419, 104)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (420, 420, 105)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (421, 421, 106)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (422, 422, 107)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (423, 423, 108)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (424, 424, 109)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (425, 425, 110)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (426, 426, 106)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (427, 427, 107)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (428, 428, 108)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (429, 429, 109)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (430, 430, 110)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (431, 431, 106)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (432, 432, 107)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (433, 433, 108)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (434, 434, 109)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (435, 435, 110)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (436, 436, 106)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (437, 437, 107)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (438, 438, 108)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (439, 439, 109)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (440, 440, 110)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (441, 441, 111)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (442, 442, 112)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (443, 443, 113)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (444, 444, 114)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (445, 445, 115)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (446, 446, 111)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (447, 447, 112)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (448, 448, 113)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (449, 449, 114)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (450, 450, 115)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (451, 451, 111)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (452, 452, 112)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (453, 453, 113)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (454, 454, 114)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (455, 455, 115)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (456, 456, 111)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (457, 457, 112)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (458, 458, 113)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (459, 459, 114)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (460, 460, 115)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (461, 461, 116)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (462, 462, 117)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (463, 463, 118)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (464, 464, 119)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (465, 465, 120)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (466, 466, 116)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (467, 467, 117)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (468, 468, 118)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (469, 469, 119)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (470, 470, 120)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (471, 471, 116)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (472, 472, 117)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (473, 473, 118)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (474, 474, 119)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (475, 475, 120)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (476, 476, 116)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (477, 477, 117)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (478, 478, 118)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (479, 479, 119)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (480, 480, 120)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (481, 481, 121)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (482, 482, 122)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (483, 483, 123)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (484, 484, 124)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (485, 485, 125)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (486, 486, 121)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (487, 487, 122)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (488, 488, 123)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (489, 489, 124)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (490, 490, 125)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (491, 491, 121)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (492, 492, 122)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (493, 493, 123)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (494, 494, 124)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (495, 495, 125)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (496, 496, 121)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (497, 497, 122)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (498, 498, 123)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (499, 499, 124)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (500, 500, 125)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (501, 501, 126)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (502, 502, 127)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (503, 503, 128)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (504, 504, 129)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (505, 505, 130)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (506, 506, 126)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (507, 507, 127)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (508, 508, 128)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (509, 509, 129)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (510, 510, 130)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (511, 511, 126)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (512, 512, 127)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (513, 513, 128)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (514, 514, 129)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (515, 515, 130)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (516, 516, 126)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (517, 517, 127)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (518, 518, 128)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (519, 519, 129)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (520, 520, 130)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (521, 521, 131)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (522, 522, 132)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (523, 523, 133)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (524, 524, 134)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (525, 525, 135)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (526, 526, 131)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (527, 527, 132)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (528, 528, 133)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (529, 529, 134)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (530, 530, 135)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (531, 531, 131)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (532, 532, 132)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (533, 533, 133)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (534, 534, 134)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (535, 535, 135)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (536, 536, 131)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (537, 537, 132)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (538, 538, 133)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (539, 539, 134)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (540, 540, 135)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (541, 541, 136)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (542, 542, 137)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (543, 543, 138)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (544, 544, 139)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (545, 545, 140)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (546, 546, 136)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (547, 547, 137)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (548, 548, 138)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (549, 549, 139)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (550, 550, 140)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (551, 551, 136)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (552, 552, 137)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (553, 553, 138)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (554, 554, 139)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (555, 555, 140)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (556, 556, 136)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (557, 557, 137)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (558, 558, 138)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (559, 559, 139)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (560, 560, 140)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (561, 561, 141)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (562, 562, 142)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (563, 563, 143)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (564, 564, 144)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (565, 565, 145)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (566, 566, 141)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (567, 567, 142)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (568, 568, 143)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (569, 569, 144)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (570, 570, 145)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (571, 571, 141)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (572, 572, 142)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (573, 573, 143)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (574, 574, 144)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (575, 575, 145)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (576, 576, 141)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (577, 577, 142)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (578, 578, 143)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (579, 579, 144)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (580, 580, 145)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (581, 581, 146)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (582, 582, 147)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (583, 583, 148)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (584, 584, 149)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (585, 585, 150)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (586, 586, 146)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (587, 587, 147)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (588, 588, 148)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (589, 589, 149)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (590, 590, 150)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (591, 591, 146)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (592, 592, 147)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (593, 593, 148)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (594, 594, 149)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (595, 595, 150)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (596, 596, 146)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (597, 597, 147)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (598, 598, 148)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (599, 599, 149)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (600, 600, 150)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (601, 601, 151)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (602, 602, 152)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (603, 603, 153)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (604, 604, 154)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (605, 605, 155)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (606, 606, 151)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (607, 607, 152)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (608, 608, 153)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (609, 609, 154)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (610, 610, 155)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (611, 611, 151)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (612, 612, 152)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (613, 613, 153)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (614, 614, 154)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (615, 615, 155)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (616, 616, 151)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (617, 617, 152)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (618, 618, 153)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (619, 619, 154)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (620, 620, 155)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (621, 621, 156)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (622, 622, 157)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (623, 623, 158)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (624, 624, 159)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (625, 625, 160)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (626, 626, 156)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (627, 627, 157)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (628, 628, 158)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (629, 629, 159)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (630, 630, 160)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (631, 631, 156)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (632, 632, 157)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (633, 633, 158)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (634, 634, 159)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (635, 635, 160)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (636, 636, 156)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (637, 637, 157)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (638, 638, 158)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (639, 639, 159)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (640, 640, 160)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (641, 641, 161)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (642, 642, 162)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (643, 643, 163)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (644, 644, 164)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (645, 645, 165)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (646, 646, 161)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (647, 647, 162)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (648, 648, 163)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (649, 649, 164)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (650, 650, 165)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (651, 651, 161)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (652, 652, 162)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (653, 653, 163)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (654, 654, 164)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (655, 655, 165)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (656, 656, 161)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (657, 657, 162)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (658, 658, 163)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (659, 659, 164)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (660, 660, 165)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (661, 661, 166)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (662, 662, 167)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (663, 663, 168)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (664, 664, 169)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (665, 665, 170)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (666, 666, 166)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (667, 667, 167)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (668, 668, 168)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (669, 669, 169)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (670, 670, 170)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (671, 671, 166)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (672, 672, 167)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (673, 673, 168)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (674, 674, 169)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (675, 675, 170)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (676, 676, 166)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (677, 677, 167)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (678, 678, 168)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (679, 679, 169)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (680, 680, 170)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (681, 681, 171)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (682, 682, 172)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (683, 683, 173)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (684, 684, 174)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (685, 685, 175)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (686, 686, 171)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (687, 687, 172)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (688, 688, 173)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (689, 689, 174)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (690, 690, 175)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (691, 691, 171)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (692, 692, 172)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (693, 693, 173)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (694, 694, 174)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (695, 695, 175)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (696, 696, 171)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (697, 697, 172)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (698, 698, 173)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (699, 699, 174)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (700, 700, 175)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (741, 741, 186)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (742, 742, 187)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (743, 743, 188)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (744, 744, 189)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (745, 745, 190)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (746, 746, 186)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (747, 747, 187)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (748, 748, 188)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (749, 749, 189)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (750, 750, 190)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (751, 751, 186)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (752, 752, 187)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (753, 753, 188)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (754, 754, 189)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (755, 755, 190)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (756, 756, 186)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (757, 757, 187)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (758, 758, 188)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (759, 759, 189)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (760, 760, 190)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (781, 781, 196)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (782, 782, 197)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (783, 783, 198)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (784, 784, 199)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (785, 785, 200)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (786, 786, 196)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (787, 787, 197)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (788, 788, 198)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (789, 789, 199)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (790, 790, 200)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (791, 791, 196)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (792, 792, 197)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (793, 793, 198)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (794, 794, 197)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (795, 794, 199)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (796, 795, 200)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (797, 796, 196)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (798, 797, 197)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (799, 798, 198)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (800, 799, 199)
GO
INSERT [dbo].[Session_CLO] ([SessionCLOID], [SessionID], [CLOID]) VALUES (801, 800, 200)
GO
SET IDENTITY_INSERT [dbo].[Session_CLO] OFF
GO
SET IDENTITY_INSERT [dbo].[Subject] ON 
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (1, 2, N'VOV114', N'Vovinam 1', 3, N'Nhập môn vovinam', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (2, 2, N'VOV124', N'Vovinam 2', 3, N'Vovinam trung cấp', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (3, 2, N'VOV134', N'Vovinam 3', 3, N'Vovinam nâng cao', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (4, 2, N'DNG102', N'Traditional musical instruments', 3, N'Đàn Nguyệt sơ cấp', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (5, 2, N'DTR102', N'Traditional musical instruments', 3, N'Đàn Tranh sơ cấp', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (6, 2, N'DNH102', N'Traditional musical instruments', 3, N'Đàn Nhị sơ cấp', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (7, 2, N'SSA101', N'Academic Skills for University Success', 3, N'Academic Skills for University Success', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (8, 2, N'CSI104', N'Introduction to Computer Science', 3, N'Giới thiệu về khoa học máy tính', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (9, 2, N'PRF192', N'Programming Fundamentals', 3, N'Lập trình cơ bản', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (10, 2, N'MAE101', N'Mathematics for Engineering', 3, N'Toán kỹ thuật', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (11, 2, N'CEA201', N'Computer Organization and Architecture', 3, N'Kiến trúc máy tính', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (12, 2, N'PRO192', N'Object-Oriented Programming', 3, N'Lập trình hướng đối tượng', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (13, 2, N'MAD101', N'Discrete mathematics', 3, N'Toán rời rạc', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (14, 2, N'OSG202', N'Operating Systems', 3, N'Hệ điều hành máy tính', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (15, 2, N'SSG104', N'Communication and In-Group Working Skills', 3, N'Kỹ năng làm việc nhóm', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (16, 2, N'NWC204', N'Computer Networking', 3, N'Mạng máy tính', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (17, 2, N'JPD113', N'Elementary Japanese 1-A1.1', 3, N'Tiếng nhật sơ cấp', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (18, 2, N'CSD201', N'Data Structures and Algorithms', 3, N'Cấu trúc dữ liệu', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (19, 2, N'DBI202', N'Introduction to Databases', 3, N'Giới thiệu về cơ sở dữ liệu', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (20, 2, N'LAB211', N'OOP with Java Lab', 3, N'Thực hành lập trình hướng đối tượng', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (21, 2, N'WED201', N'Web Design', 3, N'Thiết kế web', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (22, 2, N'MAS291', N'Statistics and Probability', 3, N'Toán xác suất và thống kê', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (23, 2, N'JPD123', N'Elementary Japanese 1-A1.2', 3, N'Tiếng Nhật sơ cấp A2', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (24, 2, N'SWE201', N'Introduction to Software Engineering', 3, N'Giới thiệu về kỹ thuật phần mềm', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (25, 2, N'IOT102', N'Internet of Things', 3, N'Nhập môn tự động hóa', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (26, 2, N'PRJ301', N'Java Web Application Development', 3, N'Phát triển ứng dụng web java', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (27, 2, N'WDU203C', N'UI/UX Design', 3, N'Thiết kế UI/UX', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (28, 2, N'SWP391', N'Application development project', 3, N'Dự án phát triển ứng dụng', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (29, 2, N'JPD133', N'Elementary Japanese 1-A1/A2', 3, N'Tiếng Nhật sơ cấp 1 A2', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (30, 2, N'SWR302', N'Software Requirement', 3, N'Yêu cầu phần mềm', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (31, 2, N'SWT301', N'Software Testing', 3, N'Kiểm thử phần mềm', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (32, 2, N'OJT202', N'On the job training', 10, N'Kỳ thực tập tại doanh nghiệp', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (33, 2, N'ENW493', N'Research Methods & Academic Writing Skills', 3, N'Nghiên cứu và viết báo cáo học thuật', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (34, 2, N'SYB302', N'Entrepreneurship', 3, N'Kỹ năng kinh doanh', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (35, 2, N'SWD392', N'SW Architecture and Design', 3, N'Thiết kế kiến trúc phần mềm', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (36, 2, N'JPD316', N'Intermediate Japanese 1-B1/B2', 3, N'Tiếng Nhật trung cấp B1', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (37, 2, N'PMG201', N'Project management', 3, N'Quản lý dự án', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (38, 2, N'MLN111', N'Philosophy of Marxism – Leninism', 3, N'Triết học chủ nghĩ Mác', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (39, 2, N'JFE301', N'Japanese IT Fundamentals', 3, N'Nguyên tắc trong IT Nhật Bản', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (40, 2, N'MLN122', N'Political economics of Marxism – Leninism', 2, N'Triết học kinh tế trính trị Mác', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (41, 2, N'JIT401', N'Information Technology Japanese', 3, N'Tiếng Nhật trong IT', N'WaitingForSyllabus')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (42, 2, N'ITE302', N'Ethics in IT', 3, N'Đạo đức trong nghề IT', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (43, 2, N'PRM393', N'Mobile Programming', 3, N'Lập trình di động', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (44, 2, N'SE_GRA_ELE', N'Graduation Elective - Software Engineering', 10, N'Đồ án tốt nghiệp', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (45, 2, N'HCM202', N'Ho Chi Minh Ideology', 2, N'Tư tưởng Hồ Chí Minh', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (46, 2, N'MLN131', N'Scientific socialism', 2, N'Chủ Nghĩa xã hội khoa học Mác Lenin', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (47, 2, N'VNR202', N'History of Việt Nam Communist Party', 3, N'Lịch sử Đảng Việt Nam', N'Active')
GO
INSERT [dbo].[Subject] ([SubjectID], [CreatedBy], [SubjectCode], [SubjectName], [Credits], [Description], [Status]) VALUES (48, 2, N'EXE101', N'Experiential Entrepreneurship 1', 3, N'Trải nghiệm khởi nghiệp', N'Active')
GO
SET IDENTITY_INSERT [dbo].[Subject] OFF
GO
SET IDENTITY_INSERT [dbo].[Subject_Prerequisite] ON 
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (1, 2, 1, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (2, 3, 2, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (3, 12, 9, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (4, 18, 12, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (5, 20, 12, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (6, 22, 10, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (7, 23, 17, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (8, 26, 19, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (9, 26, 12, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (10, 28, 20, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (11, 28, 24, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (12, 28, 26, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (13, 30, 24, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (14, 45, 38, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (15, 45, 40, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (16, 46, 38, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (17, 46, 40, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (18, 47, 38, N'Pass', N'Pass prerequisite subject')
GO
INSERT [dbo].[Subject_Prerequisite] ([PrerequisiteID], [SubjectID], [RequiredSubjectID], [ConditionType], [Description]) VALUES (19, 47, 40, N'Pass', N'Pass prerequisite subject')
GO
SET IDENTITY_INSERT [dbo].[Subject_Prerequisite] OFF
GO
SET IDENTITY_INSERT [dbo].[Syllabus] ON 
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (1, 11, 3, 2, N'1.0', N'Computer Organization and Architecture', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T18:52:25.553' AS DateTime), CAST(N'2026-07-26T19:20:38.453' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (2, 18, 3, 2, N'1.0', N'Data Structures and Algorithms', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T18:53:21.750' AS DateTime), CAST(N'2026-07-26T19:20:35.993' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'PRO192', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (3, 8, 3, 2, N'1.0', N'Introduction to Computer Science', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T18:54:03.420' AS DateTime), CAST(N'2026-07-26T19:20:33.737' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (4, 19, 3, 2, N'1.0', N'Introduction to Databases', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T18:54:40.753' AS DateTime), CAST(N'2026-07-26T19:20:31.243' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (5, 33, 3, 2, N'1.0', N'Research Methods & Academic Writing Skills', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T18:55:21.413' AS DateTime), CAST(N'2026-07-26T19:20:28.630' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (6, 45, 3, 2, N'1.0', N'Ho Chi Minh Ideology', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T18:56:25.863' AS DateTime), CAST(N'2026-07-26T19:20:26.210' AS DateTime), N'Tư tưởng Hồ Chí MInh', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'MLN111, MLN122', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (7, 25, 3, 2, N'1.0', N'Internet of Things', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T18:57:09.010' AS DateTime), CAST(N'2026-07-26T19:20:23.550' AS DateTime), N'IOT', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (8, 42, 3, 2, N'1.0', N'Ethics in IT', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T18:57:48.607' AS DateTime), CAST(N'2026-07-26T19:20:21.050' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (9, 17, 3, 2, N'1.0', N'Elementary Japanese 1-A1.1', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T18:58:59.070' AS DateTime), CAST(N'2026-07-26T19:20:18.650' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (10, 23, 3, 2, N'1.0', N'Elementary Japanese 1-A1.2', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T18:59:32.973' AS DateTime), CAST(N'2026-07-26T19:20:15.753' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'JPD113', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (11, 20, 3, 2, N'1.0', N'OOP with Java Lab', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:00:18.067' AS DateTime), CAST(N'2026-07-26T19:20:13.190' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'PRO192', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (12, 13, 3, 2, N'1.0', N'Discrete mathematics', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:00:57.290' AS DateTime), CAST(N'2026-07-26T19:20:10.690' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (13, 10, 3, 2, N'1.0', N'Mathematics for Engineering', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:01:33.223' AS DateTime), CAST(N'2026-07-26T19:20:08.030' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (14, 38, 3, 2, N'1.0', N'Philosophy of Marxism – Leninism', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:02:31.770' AS DateTime), CAST(N'2026-07-26T19:20:05.293' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (15, 40, 3, 2, N'1.0', N'Political economics of Marxism – Leninism', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:03:18.673' AS DateTime), CAST(N'2026-07-26T19:20:02.420' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (16, 16, 3, 2, N'1.0', N'Computer Networking', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:03:53.823' AS DateTime), CAST(N'2026-07-26T19:20:00.220' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (17, 46, 3, 2, N'1.0', N'Scientific socialism', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:04:48.853' AS DateTime), CAST(N'2026-07-26T19:19:57.993' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'MLN111, MLN122', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (18, 32, 3, 2, N'1.0', N'On the job training', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:05:41.073' AS DateTime), CAST(N'2026-07-26T19:19:55.423' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (19, 14, 3, 2, N'1.0', N'Operating Systems', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:06:19.380' AS DateTime), CAST(N'2026-07-26T19:19:52.797' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (20, 37, 3, 2, N'1.0', N'Project management', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:06:53.573' AS DateTime), CAST(N'2026-07-26T19:19:49.787' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (21, 9, 3, 2, N'1.0', N'Programming Fundamentals', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:07:31.930' AS DateTime), CAST(N'2026-07-26T19:19:36.423' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (22, 26, 3, 2, N'1.0', N'Java Web Application Development', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:08:18.770' AS DateTime), CAST(N'2026-07-26T19:19:33.327' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'DBI202, PRO192', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (23, 43, 3, 2, N'1.0', N'Mobile Programming', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:09:12.330' AS DateTime), CAST(N'2026-07-26T19:19:27.510' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (24, 12, 3, 2, N'1.0', N'Object-Oriented Programming', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:10:10.493' AS DateTime), CAST(N'2026-07-26T19:19:24.530' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'PRF192', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (25, 44, 3, 2, N'1.0', N'Graduation Elective - Software Engineering', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:10:57.970' AS DateTime), CAST(N'2026-07-26T19:19:22.060' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (26, 7, 3, 2, N'1.0', N'Academic Skills for University Success', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:11:35.327' AS DateTime), CAST(N'2026-07-26T19:19:19.300' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (27, 15, 3, 2, N'1.0', N'Communication and In-Group Working Skills', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:12:10.923' AS DateTime), CAST(N'2026-07-26T19:19:16.560' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (28, 35, 3, 2, N'1.0', N'SW Architecture and Design', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:12:53.770' AS DateTime), CAST(N'2026-07-26T19:19:13.390' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (29, 24, 3, 2, N'1.0', N'Introduction to Software Engineering', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:13:48.097' AS DateTime), CAST(N'2026-07-26T19:19:10.720' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (30, 28, 3, 2, N'1.0', N'Application development project', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:14:21.563' AS DateTime), CAST(N'2026-07-26T19:19:08.083' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'LAB211, PRJ301, SWE201', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (31, 30, 3, 2, N'1.0', N'Software Requirement', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:15:14.437' AS DateTime), CAST(N'2026-07-26T19:19:05.487' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'SWE201', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (32, 31, 3, 2, N'1.0', N'Software Testing', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:15:57.883' AS DateTime), CAST(N'2026-07-26T19:19:02.870' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (33, 47, 3, 2, N'1.0', N'History of Việt Nam Communist Party', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:16:54.390' AS DateTime), CAST(N'2026-07-26T19:18:59.820' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'MLN111, MLN122', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (34, 27, 3, 2, N'1.0', N'UI/UX Design', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:17:38.153' AS DateTime), CAST(N'2026-07-26T19:18:56.960' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (35, 21, 3, 2, N'1.0', N'Web Design', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T19:18:20.860' AS DateTime), CAST(N'2026-07-26T19:18:53.950' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (36, 48, 3, 2, N'1.0', N'Experiential Entrepreneurship 1', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T22:41:39.440' AS DateTime), CAST(N'2026-07-26T22:43:31.293' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'Chỉnh sửa lại mục 2 Materials cho chi tiết hơn', CAST(5.0 AS Decimal(3, 1)), 1)
GO
INSERT [dbo].[Syllabus] ([SyllabusID], [SubjectID], [CreatedBy], [ApprovedBy], [VersionNo], [SyllabusTitle], [Description], [LearningOutcome], [AssessmentMethod], [Status], [IsCurrentVersion], [CreatedAt], [ApprovedAt], [SyllabusName], [SyllabusEnglish], [DegreeLevel], [TimeAllocation], [PreRequisiteText], [StudentTasks], [Tools], [ScoringScale], [DecisionNo], [Note], [MinAvgMarkToPass], [IsActive]) VALUES (37, 48, 3, 2, N'1.1', N'Experiential Entrepreneurship 1', N'Mô tả tổng quan về đề cương...', NULL, NULL, N'Approved', 1, CAST(N'2026-07-26T22:46:16.210' AS DateTime), CAST(N'2026-07-26T22:46:39.397' AS DateTime), N'Phát triển ứng dụng Web với Java', N'', N'Bachelor', N'Study hour (150h) = 45h contact + 104h self-study', N'', N'Nhiệm vụ của sinh viên...', N'IntelliJ IDEA, SQL Server, Apache Tomcat', 10, N'377/QĐ-ĐHFPT dated 04/09/2026', N'', CAST(5.0 AS Decimal(3, 1)), 1)
GO
SET IDENTITY_INSERT [dbo].[Syllabus] OFF
GO
SET IDENTITY_INSERT [dbo].[Syllabus_Approval_Request] ON 
GO
INSERT [dbo].[Syllabus_Approval_Request] ([RequestID], [SyllabusID], [RequestedBy], [ReviewedBy], [RequestType], [Status], [ReviewNote], [RequestedAt], [ReviewedAt]) VALUES (1, 35, 5, NULL, N'New', N'Pending', N'Yêu cầu chỉnh sửa nội dung', CAST(N'2026-07-26T21:58:58.253' AS DateTime), NULL)
GO
INSERT [dbo].[Syllabus_Approval_Request] ([RequestID], [SyllabusID], [RequestedBy], [ReviewedBy], [RequestType], [Status], [ReviewNote], [RequestedAt], [ReviewedAt]) VALUES (2, 33, 5, 3, N'New', N'Approved', NULL, CAST(N'2026-07-26T22:06:53.810' AS DateTime), CAST(N'2026-07-26T22:08:05.860' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Syllabus_Approval_Request] OFF
GO
SET IDENTITY_INSERT [dbo].[Syllabus_Assessment] ON 
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (1, 1, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (2, 1, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (3, 1, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (4, 1, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (5, 1, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (6, 2, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (7, 2, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (8, 2, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (9, 2, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (10, 2, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (11, 3, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (12, 3, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (13, 3, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (14, 3, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (15, 3, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (16, 4, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (17, 4, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (18, 4, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (19, 4, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (20, 4, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (21, 5, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (22, 5, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (23, 5, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (24, 5, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (25, 5, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (26, 6, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (27, 6, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (28, 6, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (29, 6, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (30, 6, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (31, 7, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (32, 7, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (33, 7, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (34, 7, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (35, 7, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (36, 8, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (37, 8, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (38, 8, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (39, 8, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (40, 8, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (41, 9, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (42, 9, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (43, 9, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (44, 9, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (45, 9, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (46, 10, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (47, 10, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (48, 10, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (49, 10, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (50, 10, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (51, 11, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (52, 11, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (53, 11, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (54, 11, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (55, 11, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (56, 12, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (57, 12, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (58, 12, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (59, 12, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (60, 12, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (61, 13, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (62, 13, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (63, 13, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (64, 13, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (65, 13, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (66, 14, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (67, 14, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (68, 14, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (69, 14, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (70, 14, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (71, 15, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (72, 15, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (73, 15, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (74, 15, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (75, 15, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (76, 16, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (77, 16, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (78, 16, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (79, 16, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (80, 16, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (81, 17, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (82, 17, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (83, 17, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (84, 17, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (85, 17, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (86, 18, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (87, 18, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (88, 18, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (89, 18, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (90, 18, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (91, 19, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (92, 19, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (93, 19, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (94, 19, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (95, 19, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (96, 20, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (97, 20, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (98, 20, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (99, 20, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (100, 20, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (101, 21, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (102, 21, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (103, 21, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (104, 21, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (105, 21, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (106, 22, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (107, 22, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (108, 22, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (109, 22, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (110, 22, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (111, 23, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (112, 23, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (113, 23, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (114, 23, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (115, 23, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (116, 24, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (117, 24, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (118, 24, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (119, 24, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (120, 24, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (121, 25, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (122, 25, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (123, 25, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (124, 25, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (125, 25, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (126, 26, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (127, 26, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (128, 26, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (129, 26, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (130, 26, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (131, 27, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (132, 27, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (133, 27, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (134, 27, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (135, 27, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (136, 28, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (137, 28, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (138, 28, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (139, 28, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (140, 28, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (141, 29, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (142, 29, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (143, 29, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (144, 29, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (145, 29, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (146, 30, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (147, 30, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (148, 30, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (149, 30, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (150, 30, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (151, 31, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (152, 31, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (153, 31, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (154, 31, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (155, 31, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (156, 32, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (157, 32, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (158, 32, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (159, 32, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (160, 32, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (161, 33, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (162, 33, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (163, 33, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (164, 33, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (165, 33, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (166, 34, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (167, 34, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (168, 34, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (169, 34, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (170, 34, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (171, 35, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (172, 35, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (173, 35, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (174, 35, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (175, 35, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (186, 36, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (187, 36, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (188, 36, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (189, 36, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (190, 36, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (196, 37, N'Assignment', N'Group project', 1, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Rubric', N'', 1)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (197, 37, N'Progress Test', N'Multiple choice', 2, CAST(20.00 AS Decimal(5, 2)), N'> 0', N'60 min', N'MCQ', NULL, N'', N'Answer key', N'', 2)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (198, 37, N'Final Exam', N'Written exam', 3, CAST(40.00 AS Decimal(5, 2)), N'> 0', N'90 min', N'MCQ + Essay', NULL, N'', N'Answer key + Rubric', N'', 3)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (199, 37, N'Participation & Attitude', N'Attendance', 4, CAST(10.00 AS Decimal(5, 2)), N'> 80% attendance', N'', N'', NULL, N'', N'', N'', 4)
GO
INSERT [dbo].[Syllabus_Assessment] ([AssessmentID], [SyllabusID], [Category], [Type], [Part], [Weight], [CompletionCriteria], [Duration], [QuestionType], [NoQuestion], [KnowledgeAndSkill], [GradingGuide], [Note], [DisplayOrder]) VALUES (200, 37, N'Practice Exercises', N'Lab work', 5, CAST(10.00 AS Decimal(5, 2)), N'> 0', N'', N'Practical', NULL, N'', N'Checklist', N'', 5)
GO
SET IDENTITY_INSERT [dbo].[Syllabus_Assessment] OFF
GO
SET IDENTITY_INSERT [dbo].[Syllabus_Material] ON 
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (1, 1, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (2, 1, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (3, 2, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (4, 2, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (5, 3, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (6, 3, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (7, 4, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (8, 4, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (9, 5, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (10, 5, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (11, 6, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (12, 6, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (13, 7, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (14, 7, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (15, 8, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (16, 8, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (17, 9, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (18, 9, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (19, 10, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (20, 10, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (21, 11, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (22, 11, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (23, 12, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (24, 12, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (25, 13, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (26, 13, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (27, 14, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (28, 14, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (29, 15, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (30, 15, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (31, 16, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (32, 16, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (33, 17, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (34, 17, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (35, 18, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (36, 18, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (37, 19, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (38, 19, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (39, 20, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (40, 20, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (41, 21, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (42, 21, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (43, 22, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (44, 22, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (45, 23, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (46, 23, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (47, 24, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (48, 24, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (49, 25, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (50, 25, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (51, 26, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (52, 26, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (53, 27, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (54, 27, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (55, 28, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (56, 28, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (57, 29, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (58, 29, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (59, 30, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (60, 30, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (61, 31, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (62, 31, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (63, 32, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (64, 32, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (65, 33, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (66, 33, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (67, 34, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (68, 34, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (69, 35, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (70, 35, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (75, 36, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (76, 36, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (79, 37, N'Software Engineering: A Practitioner''s Approach', N'Roger S. Pressman', N'McGraw-Hill', N'2020', N'9th', N'978-1259872976', 1, 1, 0, N'', 1)
GO
INSERT [dbo].[Syllabus_Material] ([MaterialID], [SyllabusID], [MaterialDescription], [Author], [Publisher], [PublishedDate], [Edition], [ISBN], [IsMainMaterial], [IsHardCopy], [IsOnline], [Note], [DisplayOrder]) VALUES (80, 37, N'Head First Java', N'Kathy Sierra', N'O''Reilly', N'2022', N'3rd', N'978-1491910771', 0, 0, 1, N'https://example.com', 2)
GO
SET IDENTITY_INSERT [dbo].[Syllabus_Material] OFF
GO
SET IDENTITY_INSERT [dbo].[Syllabus_Session] ON 
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (1, 1, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (2, 1, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (3, 1, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (4, 1, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (5, 1, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (6, 1, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (7, 1, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (8, 1, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (9, 1, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (10, 1, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (11, 1, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (12, 1, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (13, 1, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (14, 1, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (15, 1, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (16, 1, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (17, 1, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (18, 1, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (19, 1, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (20, 1, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (21, 2, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (22, 2, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (23, 2, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (24, 2, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (25, 2, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (26, 2, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (27, 2, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (28, 2, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (29, 2, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (30, 2, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (31, 2, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (32, 2, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (33, 2, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (34, 2, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (35, 2, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (36, 2, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (37, 2, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (38, 2, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (39, 2, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (40, 2, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (41, 3, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (42, 3, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (43, 3, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (44, 3, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (45, 3, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (46, 3, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (47, 3, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (48, 3, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (49, 3, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (50, 3, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (51, 3, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (52, 3, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (53, 3, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (54, 3, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (55, 3, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (56, 3, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (57, 3, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (58, 3, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (59, 3, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (60, 3, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (61, 4, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (62, 4, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (63, 4, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (64, 4, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (65, 4, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (66, 4, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (67, 4, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (68, 4, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (69, 4, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (70, 4, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (71, 4, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (72, 4, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (73, 4, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (74, 4, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (75, 4, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (76, 4, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (77, 4, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (78, 4, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (79, 4, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (80, 4, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (81, 5, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (82, 5, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (83, 5, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (84, 5, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (85, 5, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (86, 5, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (87, 5, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (88, 5, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (89, 5, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (90, 5, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (91, 5, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (92, 5, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (93, 5, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (94, 5, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (95, 5, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (96, 5, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (97, 5, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (98, 5, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (99, 5, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (100, 5, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (101, 6, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (102, 6, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (103, 6, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (104, 6, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (105, 6, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (106, 6, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (107, 6, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (108, 6, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (109, 6, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (110, 6, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (111, 6, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (112, 6, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (113, 6, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (114, 6, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (115, 6, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (116, 6, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (117, 6, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (118, 6, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (119, 6, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (120, 6, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (121, 7, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (122, 7, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (123, 7, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (124, 7, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (125, 7, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (126, 7, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (127, 7, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (128, 7, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (129, 7, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (130, 7, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (131, 7, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (132, 7, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (133, 7, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (134, 7, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (135, 7, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (136, 7, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (137, 7, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (138, 7, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (139, 7, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (140, 7, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (141, 8, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (142, 8, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (143, 8, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (144, 8, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (145, 8, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (146, 8, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (147, 8, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (148, 8, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (149, 8, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (150, 8, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (151, 8, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (152, 8, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (153, 8, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (154, 8, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (155, 8, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (156, 8, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (157, 8, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (158, 8, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (159, 8, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (160, 8, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (161, 9, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (162, 9, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (163, 9, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (164, 9, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (165, 9, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (166, 9, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (167, 9, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (168, 9, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (169, 9, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (170, 9, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (171, 9, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (172, 9, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (173, 9, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (174, 9, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (175, 9, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (176, 9, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (177, 9, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (178, 9, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (179, 9, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (180, 9, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (181, 10, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (182, 10, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (183, 10, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (184, 10, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (185, 10, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (186, 10, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (187, 10, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (188, 10, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (189, 10, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (190, 10, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (191, 10, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (192, 10, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (193, 10, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (194, 10, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (195, 10, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (196, 10, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (197, 10, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (198, 10, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (199, 10, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (200, 10, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (201, 11, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (202, 11, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (203, 11, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (204, 11, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (205, 11, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (206, 11, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (207, 11, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (208, 11, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (209, 11, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (210, 11, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (211, 11, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (212, 11, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (213, 11, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (214, 11, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (215, 11, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (216, 11, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (217, 11, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (218, 11, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (219, 11, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (220, 11, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (221, 12, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (222, 12, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (223, 12, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (224, 12, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (225, 12, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (226, 12, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (227, 12, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (228, 12, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (229, 12, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (230, 12, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (231, 12, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (232, 12, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (233, 12, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (234, 12, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (235, 12, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (236, 12, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (237, 12, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (238, 12, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (239, 12, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (240, 12, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (241, 13, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (242, 13, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (243, 13, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (244, 13, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (245, 13, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (246, 13, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (247, 13, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (248, 13, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (249, 13, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (250, 13, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (251, 13, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (252, 13, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (253, 13, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (254, 13, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (255, 13, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (256, 13, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (257, 13, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (258, 13, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (259, 13, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (260, 13, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (261, 14, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (262, 14, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (263, 14, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (264, 14, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (265, 14, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (266, 14, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (267, 14, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (268, 14, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (269, 14, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (270, 14, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (271, 14, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (272, 14, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (273, 14, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (274, 14, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (275, 14, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (276, 14, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (277, 14, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (278, 14, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (279, 14, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (280, 14, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (281, 15, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (282, 15, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (283, 15, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (284, 15, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (285, 15, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (286, 15, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (287, 15, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (288, 15, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (289, 15, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (290, 15, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (291, 15, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (292, 15, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (293, 15, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (294, 15, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (295, 15, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (296, 15, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (297, 15, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (298, 15, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (299, 15, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (300, 15, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (301, 16, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (302, 16, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (303, 16, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (304, 16, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (305, 16, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (306, 16, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (307, 16, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (308, 16, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (309, 16, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (310, 16, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (311, 16, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (312, 16, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (313, 16, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (314, 16, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (315, 16, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (316, 16, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (317, 16, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (318, 16, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (319, 16, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (320, 16, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (321, 17, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (322, 17, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (323, 17, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (324, 17, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (325, 17, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (326, 17, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (327, 17, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (328, 17, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (329, 17, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (330, 17, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (331, 17, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (332, 17, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (333, 17, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (334, 17, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (335, 17, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (336, 17, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (337, 17, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (338, 17, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (339, 17, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (340, 17, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (341, 18, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (342, 18, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (343, 18, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (344, 18, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (345, 18, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (346, 18, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (347, 18, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (348, 18, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (349, 18, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (350, 18, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (351, 18, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (352, 18, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (353, 18, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (354, 18, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (355, 18, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (356, 18, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (357, 18, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (358, 18, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (359, 18, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (360, 18, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (361, 19, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (362, 19, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (363, 19, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (364, 19, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (365, 19, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (366, 19, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (367, 19, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (368, 19, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (369, 19, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (370, 19, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (371, 19, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (372, 19, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (373, 19, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (374, 19, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (375, 19, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (376, 19, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (377, 19, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (378, 19, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (379, 19, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (380, 19, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (381, 20, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (382, 20, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (383, 20, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (384, 20, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (385, 20, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (386, 20, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (387, 20, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (388, 20, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (389, 20, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (390, 20, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (391, 20, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (392, 20, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (393, 20, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (394, 20, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (395, 20, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (396, 20, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (397, 20, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (398, 20, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (399, 20, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (400, 20, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (401, 21, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (402, 21, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (403, 21, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (404, 21, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (405, 21, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (406, 21, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (407, 21, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (408, 21, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (409, 21, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (410, 21, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (411, 21, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (412, 21, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (413, 21, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (414, 21, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (415, 21, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (416, 21, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (417, 21, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (418, 21, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (419, 21, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (420, 21, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (421, 22, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (422, 22, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (423, 22, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (424, 22, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (425, 22, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (426, 22, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (427, 22, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (428, 22, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (429, 22, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (430, 22, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (431, 22, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (432, 22, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (433, 22, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (434, 22, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (435, 22, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (436, 22, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (437, 22, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (438, 22, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (439, 22, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (440, 22, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (441, 23, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (442, 23, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (443, 23, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (444, 23, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (445, 23, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (446, 23, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (447, 23, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (448, 23, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (449, 23, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (450, 23, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (451, 23, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (452, 23, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (453, 23, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (454, 23, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (455, 23, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (456, 23, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (457, 23, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (458, 23, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (459, 23, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (460, 23, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (461, 24, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (462, 24, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (463, 24, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (464, 24, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (465, 24, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (466, 24, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (467, 24, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (468, 24, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (469, 24, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (470, 24, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (471, 24, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (472, 24, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (473, 24, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (474, 24, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (475, 24, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (476, 24, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (477, 24, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (478, 24, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (479, 24, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (480, 24, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (481, 25, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (482, 25, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (483, 25, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (484, 25, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (485, 25, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (486, 25, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (487, 25, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (488, 25, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (489, 25, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (490, 25, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (491, 25, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (492, 25, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (493, 25, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (494, 25, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (495, 25, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (496, 25, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (497, 25, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (498, 25, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (499, 25, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (500, 25, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (501, 26, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (502, 26, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (503, 26, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (504, 26, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (505, 26, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (506, 26, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (507, 26, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (508, 26, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (509, 26, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (510, 26, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (511, 26, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (512, 26, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (513, 26, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (514, 26, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (515, 26, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (516, 26, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (517, 26, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (518, 26, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (519, 26, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (520, 26, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (521, 27, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (522, 27, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (523, 27, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (524, 27, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (525, 27, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (526, 27, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (527, 27, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (528, 27, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (529, 27, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (530, 27, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (531, 27, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (532, 27, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (533, 27, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (534, 27, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (535, 27, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (536, 27, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (537, 27, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (538, 27, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (539, 27, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (540, 27, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (541, 28, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (542, 28, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (543, 28, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (544, 28, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (545, 28, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (546, 28, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (547, 28, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (548, 28, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (549, 28, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (550, 28, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (551, 28, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (552, 28, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (553, 28, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (554, 28, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (555, 28, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (556, 28, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (557, 28, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (558, 28, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (559, 28, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (560, 28, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (561, 29, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (562, 29, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (563, 29, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (564, 29, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (565, 29, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (566, 29, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (567, 29, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (568, 29, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (569, 29, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (570, 29, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (571, 29, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (572, 29, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (573, 29, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (574, 29, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (575, 29, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (576, 29, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (577, 29, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (578, 29, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (579, 29, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (580, 29, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (581, 30, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (582, 30, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (583, 30, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (584, 30, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (585, 30, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (586, 30, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (587, 30, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (588, 30, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (589, 30, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (590, 30, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (591, 30, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (592, 30, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (593, 30, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (594, 30, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (595, 30, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (596, 30, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (597, 30, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (598, 30, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (599, 30, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (600, 30, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (601, 31, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (602, 31, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (603, 31, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (604, 31, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (605, 31, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (606, 31, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (607, 31, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (608, 31, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (609, 31, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (610, 31, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (611, 31, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (612, 31, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (613, 31, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (614, 31, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (615, 31, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (616, 31, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (617, 31, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (618, 31, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (619, 31, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (620, 31, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (621, 32, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (622, 32, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (623, 32, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (624, 32, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (625, 32, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (626, 32, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (627, 32, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (628, 32, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (629, 32, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (630, 32, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (631, 32, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (632, 32, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (633, 32, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (634, 32, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (635, 32, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (636, 32, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (637, 32, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (638, 32, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (639, 32, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (640, 32, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (641, 33, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (642, 33, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (643, 33, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (644, 33, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (645, 33, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (646, 33, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (647, 33, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (648, 33, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (649, 33, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (650, 33, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (651, 33, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (652, 33, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (653, 33, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (654, 33, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (655, 33, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (656, 33, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (657, 33, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (658, 33, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (659, 33, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (660, 33, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (661, 34, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (662, 34, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (663, 34, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (664, 34, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (665, 34, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (666, 34, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (667, 34, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (668, 34, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (669, 34, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (670, 34, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (671, 34, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (672, 34, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (673, 34, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (674, 34, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (675, 34, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (676, 34, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (677, 34, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (678, 34, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (679, 34, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (680, 34, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (681, 35, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (682, 35, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (683, 35, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (684, 35, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (685, 35, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (686, 35, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (687, 35, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (688, 35, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (689, 35, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (690, 35, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (691, 35, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (692, 35, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (693, 35, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (694, 35, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (695, 35, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (696, 35, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (697, 35, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (698, 35, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (699, 35, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (700, 35, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (741, 36, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (742, 36, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (743, 36, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (744, 36, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (745, 36, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (746, 36, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (747, 36, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (748, 36, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (749, 36, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (750, 36, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (751, 36, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (752, 36, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (753, 36, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (754, 36, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (755, 36, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (756, 36, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (757, 36, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (758, 36, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (759, 36, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (760, 36, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (781, 37, 1, N'Topic 1: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 1', N'Yes', N'Read chapter 1', N'', 1)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (782, 37, 2, N'Topic 2: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 2', N'Yes', N'Read chapter 2', N'', 2)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (783, 37, 3, N'Topic 3: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 3', N'Yes', N'Read chapter 3', N'', 3)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (784, 37, 4, N'Topic 4: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 4', N'Yes', N'Read chapter 4', N'', 4)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (785, 37, 5, N'Topic 5: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 5', N'Yes', N'Read chapter 5', N'', 5)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (786, 37, 6, N'Topic 6: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 6', N'Yes', N'Read chapter 6', N'', 6)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (787, 37, 7, N'Topic 7: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 7', N'Yes', N'Read chapter 7', N'', 7)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (788, 37, 8, N'Topic 8: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 8', N'Yes', N'Read chapter 8', N'', 8)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (789, 37, 9, N'Topic 9: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 9', N'Yes', N'Read chapter 9', N'', 9)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (790, 37, 10, N'Topic 10: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 10', N'Yes', N'Read chapter 10', N'', 10)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (791, 37, 11, N'Topic 11: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 11', N'Yes', N'Read chapter 11', N'', 11)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (792, 37, 12, N'Topic 12: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 12', N'Yes', N'Read chapter 12', N'', 12)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (793, 37, 13, N'Topic 13: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 13', N'Yes', N'Read chapter 13', N'', 13)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (794, 37, 14, N'Topic 14: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 14', N'Yes', N'Read chapter 14', N'', 14)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (795, 37, 15, N'Topic 15: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 15', N'Yes', N'Read chapter 15', N'', 15)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (796, 37, 16, N'Topic 16: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 16', N'Yes', N'Read chapter 16', N'', 16)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (797, 37, 17, N'Topic 17: Web Development Concepts', N'Lecture, Lab', N'AI literacy', N'Slide 17', N'Yes', N'Read chapter 17', N'', 17)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (798, 37, 18, N'Topic 18: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 18', N'Yes', N'Read chapter 18', N'', 18)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (799, 37, 19, N'Topic 19: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 19', N'Yes', N'Read chapter 19', N'', 19)
GO
INSERT [dbo].[Syllabus_Session] ([SessionID], [SyllabusID], [SessionNumber], [Topic], [LearningTeachingType], [ITU], [StudentMaterials], [SDownload], [StudentTasks], [URLs], [DisplayOrder]) VALUES (800, 37, 20, N'Topic 20: Web Development Concepts', N'Lecture, Lab', N'', N'Slide 20', N'Yes', N'Read chapter 20', N'', 20)
GO
SET IDENTITY_INSERT [dbo].[Syllabus_Session] OFF
GO
SET IDENTITY_INSERT [dbo].[Training_Program] ON 
GO
INSERT [dbo].[Training_Program] ([ProgramID], [CreatedBy], [ProgramCode], [ProgramName], [MajorName], [Description], [Status]) VALUES (1, 2, N'SE', N'Kỹ thuật phần mềm', N'Software Engineering', N'Đào tạo cử nhân ngành kỹ thuật phần mềm', N'Active')
GO
INSERT [dbo].[Training_Program] ([ProgramID], [CreatedBy], [ProgramCode], [ProgramName], [MajorName], [Description], [Status]) VALUES (2, 2, N'GD', N'Thiết kế đồ họa', N'Graphic design', N'Đào tạo cử nhân thiết kế đồ họa', N'Active')
GO
INSERT [dbo].[Training_Program] ([ProgramID], [CreatedBy], [ProgramCode], [ProgramName], [MajorName], [Description], [Status]) VALUES (3, 2, N'IT', N'Công nghệ thông tin', N'Information technology', N'Đào tạo cử nhân ngành công nghệ thông tin', N'Active')
GO
INSERT [dbo].[Training_Program] ([ProgramID], [CreatedBy], [ProgramCode], [ProgramName], [MajorName], [Description], [Status]) VALUES (4, 2, N'DD', N'Thiết kế đồ họa số', N'Digital Design', N'Đào tạo cử nhân ngành thiết kế mĩ thuật số', N'Active')
GO
SET IDENTITY_INSERT [dbo].[Training_Program] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 
GO
INSERT [dbo].[User] ([UserID], [RoleID], [Email], [PasswordHash], [FullName], [Status], [CreatedAt]) VALUES (1, 1, N'admin@gmail.com', N'$2a$10$2m5/078LK.UYjWHIHmeZK.tvZyJqJm87v15.an3ezJ11Ur6w9lhLy', N'admin', N'Active', CAST(N'2026-06-10T14:08:34.530' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [RoleID], [Email], [PasswordHash], [FullName], [Status], [CreatedAt]) VALUES (2, 4, N'trainingdepart@gmail.com', N'$2a$10$ukXlaqfMWQaRGLU3w6R/veVpGC38PhALtwhDynuCr69GBWO5EklGO', N'trainingdepart', N'Active', CAST(N'2026-06-15T09:08:20.180' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [RoleID], [Email], [PasswordHash], [FullName], [Status], [CreatedAt]) VALUES (3, 5, N'syllabusds@gmail.com', N'$2a$10$YkPKAwNN6FfmQWpLIGq/4.8lExIAVlPwRVbGZ87qtGtIAXNtsX6/u', N'syllabusds', N'Active', CAST(N'2026-06-17T15:51:17.990' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [RoleID], [Email], [PasswordHash], [FullName], [Status], [CreatedAt]) VALUES (4, 2, N'nguyenbao220824@gmail.com', N'$2a$10$h842DycklcokR2fQyqnFo.6HBp4Be8jTZtWdN1uBLIWOedKzC1Vfu', N'Nguyễn Văn Bảo', N'Active', CAST(N'2026-06-24T11:16:15.963' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [RoleID], [Email], [PasswordHash], [FullName], [Status], [CreatedAt]) VALUES (5, 3, N'teacher@gmail.com', N'$2a$10$cxBKsaIlilMcdoXISCxU6eDxHm9/MduEwFKLvr1LZU.BsABDUZb2S', N'teacher', N'Active', CAST(N'2026-06-24T12:11:53.717' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [RoleID], [Email], [PasswordHash], [FullName], [Status], [CreatedAt]) VALUES (6, 2, N'nguyenbao2208204@gmail.com', N'$2a$10$uxboKcJIcNec68qWV5Yk0.ijSnvoP9xcMzuRAAav7TdmCbKpZJYJW', N'Hh Hh', N'Active', CAST(N'2026-07-17T08:53:16.200' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [RoleID], [Email], [PasswordHash], [FullName], [Status], [CreatedAt]) VALUES (7, 2, N'teacher2@gmail.com', N'$2a$10$BYCWvLeTGxLeNuHJv1GV7u88Ervwg.t3lUlgZc6se7otRDiLPVSuy', N'Nguyễn Văn Bảo', N'Deactive', CAST(N'2026-07-22T18:19:40.167' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[User] OFF
GO
/****** Object:  Index [UQ_Assessment_CLO]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Assessment_CLO] ADD  CONSTRAINT [UQ_Assessment_CLO] UNIQUE NONCLUSTERED 
(
	[AssessmentID] ASC,
	[CLOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_CLO_PLO]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[CLO_PLO] ADD  CONSTRAINT [UQ_CLO_PLO] UNIQUE NONCLUSTERED 
(
	[CLOID] ASC,
	[PloID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CLO_PLO_CLOID]    Script Date: 7/27/2026 12:56:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_CLO_PLO_CLOID] ON [dbo].[CLO_PLO]
(
	[CLOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CLO_PLO_PloID]    Script Date: 7/27/2026 12:56:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_CLO_PLO_PloID] ON [dbo].[CLO_PLO]
(
	[PloID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_ComboSubject]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Combo_Subject] ADD  CONSTRAINT [UQ_ComboSubject] UNIQUE NONCLUSTERED 
(
	[ComboID] ASC,
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_CurriculumElective]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Curriculum_Elective] ADD  CONSTRAINT [UQ_CurriculumElective] UNIQUE NONCLUSTERED 
(
	[CurriculumID] ASC,
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_CurriculumSubject]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Curriculum_Subject] ADD  CONSTRAINT [UQ_CurriculumSubject] UNIQUE NONCLUSTERED 
(
	[CurriculumID] ASC,
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_CurriculumSubject_ID_Curriculum]    Script Date: 7/27/2026 12:56:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_CurriculumSubject_ID_Curriculum] ON [dbo].[Curriculum_Subject]
(
	[CurriculumSubjectID] ASC,
	[CurriculumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_CurriculumSubject_PLO]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Curriculum_Subject_PLO] ADD  CONSTRAINT [UQ_CurriculumSubject_PLO] UNIQUE NONCLUSTERED 
(
	[CurriculumSubjectID] ASC,
	[PloID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_PLO_Curriculum_Code]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[PLO] ADD  CONSTRAINT [UQ_PLO_Curriculum_Code] UNIQUE NONCLUSTERED 
(
	[CurriculumID] ASC,
	[PloCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_PLO_ID_Curriculum]    Script Date: 7/27/2026 12:56:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_PLO_ID_Curriculum] ON [dbo].[PLO]
(
	[PloID] ASC,
	[CurriculumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_PO_Curriculum_Code]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[PO] ADD  CONSTRAINT [UQ_PO_Curriculum_Code] UNIQUE NONCLUSTERED 
(
	[CurriculumID] ASC,
	[PoCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_PO_PLO]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[PO_PLO] ADD  CONSTRAINT [UQ_PO_PLO] UNIQUE NONCLUSTERED 
(
	[PoID] ASC,
	[PloID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PO_PLO_PloID]    Script Date: 7/27/2026 12:56:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_PO_PLO_PloID] ON [dbo].[PO_PLO]
(
	[PloID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PO_PLO_PoID]    Script Date: 7/27/2026 12:56:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_PO_PLO_PoID] ON [dbo].[PO_PLO]
(
	[PoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Role__8A2B6160EB61591C]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Role] ADD UNIQUE NONCLUSTERED 
(
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_Session_CLO]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Session_CLO] ADD  CONSTRAINT [UQ_Session_CLO] UNIQUE NONCLUSTERED 
(
	[SessionID] ASC,
	[CLOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Subject__9F7CE1A907CEB6D6]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Subject] ADD UNIQUE NONCLUSTERED 
(
	[SubjectCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_SubjectPrerequisite]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Subject_Prerequisite] ADD  CONSTRAINT [UQ_SubjectPrerequisite] UNIQUE NONCLUSTERED 
(
	[SubjectID] ASC,
	[RequiredSubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Syllabus_Version]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Syllabus] ADD  CONSTRAINT [UQ_Syllabus_Version] UNIQUE NONCLUSTERED 
(
	[SubjectID] ASC,
	[VersionNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_Session_Number]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Syllabus_Session] ADD  CONSTRAINT [UQ_Session_Number] UNIQUE NONCLUSTERED 
(
	[SyllabusID] ASC,
	[SessionNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Training__7658A9872D0F5A25]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[Training_Program] ADD UNIQUE NONCLUSTERED 
(
	[ProgramCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__User__A9D105342951F4DA]    Script Date: 7/27/2026 12:56:38 AM ******/
ALTER TABLE [dbo].[User] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
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
ALTER TABLE [dbo].[Curriculum_Subject_PLO] ADD  CONSTRAINT [DF_CurriculumSubjectPLO_CreatedAt]  DEFAULT (sysdatetime()) FOR [CreatedAt]
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
ALTER TABLE [dbo].[CLO_PLO]  WITH CHECK ADD  CONSTRAINT [FK_CLOPLO_CLO] FOREIGN KEY([CLOID])
REFERENCES [dbo].[CLO] ([CLOID])
GO
ALTER TABLE [dbo].[CLO_PLO] CHECK CONSTRAINT [FK_CLOPLO_CLO]
GO
ALTER TABLE [dbo].[CLO_PLO]  WITH CHECK ADD  CONSTRAINT [FK_CLOPLO_PLO] FOREIGN KEY([PloID])
REFERENCES [dbo].[PLO] ([PloID])
GO
ALTER TABLE [dbo].[CLO_PLO] CHECK CONSTRAINT [FK_CLOPLO_PLO]
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
ALTER TABLE [dbo].[Curriculum_Subject_PLO]  WITH CHECK ADD  CONSTRAINT [FK_CurriculumSubjectPLO_Curriculum] FOREIGN KEY([CurriculumID])
REFERENCES [dbo].[Curriculum] ([CurriculumID])
GO
ALTER TABLE [dbo].[Curriculum_Subject_PLO] CHECK CONSTRAINT [FK_CurriculumSubjectPLO_Curriculum]
GO
ALTER TABLE [dbo].[Curriculum_Subject_PLO]  WITH CHECK ADD  CONSTRAINT [FK_CurriculumSubjectPLO_CurriculumSubject] FOREIGN KEY([CurriculumSubjectID], [CurriculumID])
REFERENCES [dbo].[Curriculum_Subject] ([CurriculumSubjectID], [CurriculumID])
GO
ALTER TABLE [dbo].[Curriculum_Subject_PLO] CHECK CONSTRAINT [FK_CurriculumSubjectPLO_CurriculumSubject]
GO
ALTER TABLE [dbo].[Curriculum_Subject_PLO]  WITH CHECK ADD  CONSTRAINT [FK_CurriculumSubjectPLO_PLO] FOREIGN KEY([PloID], [CurriculumID])
REFERENCES [dbo].[PLO] ([PloID], [CurriculumID])
GO
ALTER TABLE [dbo].[Curriculum_Subject_PLO] CHECK CONSTRAINT [FK_CurriculumSubjectPLO_PLO]
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
ALTER TABLE [dbo].[PLO]  WITH CHECK ADD  CONSTRAINT [FK_PLO_Curriculum] FOREIGN KEY([CurriculumID])
REFERENCES [dbo].[Curriculum] ([CurriculumID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PLO] CHECK CONSTRAINT [FK_PLO_Curriculum]
GO
ALTER TABLE [dbo].[PO]  WITH CHECK ADD  CONSTRAINT [FK_PO_Curriculum] FOREIGN KEY([CurriculumID])
REFERENCES [dbo].[Curriculum] ([CurriculumID])
GO
ALTER TABLE [dbo].[PO] CHECK CONSTRAINT [FK_PO_Curriculum]
GO
ALTER TABLE [dbo].[PO_PLO]  WITH CHECK ADD  CONSTRAINT [FK_PO_PLO_PLO] FOREIGN KEY([PloID])
REFERENCES [dbo].[PLO] ([PloID])
GO
ALTER TABLE [dbo].[PO_PLO] CHECK CONSTRAINT [FK_PO_PLO_PLO]
GO
ALTER TABLE [dbo].[PO_PLO]  WITH CHECK ADD  CONSTRAINT [FK_PO_PLO_PO] FOREIGN KEY([PoID])
REFERENCES [dbo].[PO] ([PoID])
GO
ALTER TABLE [dbo].[PO_PLO] CHECK CONSTRAINT [FK_PO_PLO_PO]
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
ALTER TABLE [dbo].[Curriculum_Subject_PLO]  WITH CHECK ADD  CONSTRAINT [CK_CurriculumSubjectPLO_Level] CHECK  (([ContributionLevel] IS NULL OR ([ContributionLevel]='M' OR [ContributionLevel]='R' OR [ContributionLevel]='I')))
GO
ALTER TABLE [dbo].[Curriculum_Subject_PLO] CHECK CONSTRAINT [CK_CurriculumSubjectPLO_Level]
GO
ALTER TABLE [dbo].[Subject_Prerequisite]  WITH CHECK ADD  CONSTRAINT [CK_SubjectPrerequisite_NotSelf] CHECK  (([SubjectID]<>[RequiredSubjectID]))
GO
ALTER TABLE [dbo].[Subject_Prerequisite] CHECK CONSTRAINT [CK_SubjectPrerequisite_NotSelf]
GO
USE [master]
GO
ALTER DATABASE [TPMS_DB] SET  READ_WRITE 
GO
