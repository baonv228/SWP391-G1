<%@page import="model.CourseReportItem"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
    private String e(String value) {
        return value == null
                ? "-"
                : value.replace("&", "&amp;")
                        .replace("<", "&lt;")
                        .replace(">", "&gt;")
                        .replace("\"", "&quot;")
                        .replace("'", "&#39;");
    }

    private String date(java.sql.Timestamp value) {
        return value == null
                ? "-"
                : value.toLocalDateTime().format(
                        java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
%>
<%
    CourseReportItem report = (CourseReportItem) request.getAttribute("report");
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Report #<%=report.getReportId()%> | TPMS</title>
    <link
      rel="stylesheet"
      href="<%=request.getContextPath()%>/css/TraningDepartment.css"
    />
    <link
      rel="stylesheet"
      href="<%=request.getContextPath()%>/css/theme-orange.css"
    />
    <style>
      .detail {
        background: #fff;
        border: 1px solid var(--line);
        border-radius: 8px;
        padding: 24px;
        box-shadow: 0 6px 20px rgba(199, 107, 18, 0.08);
      }
      .detail-head {
        display: flex;
        justify-content: space-between;
        gap: 14px;
        align-items: center;
        margin-bottom: 22px;
      }
      .grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 16px;
      }
      .field {
        padding: 12px;
        border: 1px solid var(--line);
        border-radius: 6px;
        background: #fffaf3;
      }
      .field.wide {
        grid-column: span 3;
      }
      .label {
        display: block;
        color: var(--muted);
        font-size: 12px;
        font-weight: 700;
        text-transform: uppercase;
        margin-bottom: 5px;
      }
      .button {
        display: inline-flex;
        padding: 9px 13px;
        border-radius: 5px;
        background: var(--orange);
        color: #fff;
        text-decoration: none;
        font-weight: 700;
      }
      @media (max-width: 700px) {
        .grid {
          grid-template-columns: 1fr;
        }
        .field.wide {
          grid-column: auto;
        }
        .detail-head {
          align-items: flex-start;
          flex-direction: column;
        }
      }
    </style>
  </head>
  <body>
    <main class="page">
      <header class="topbar">
        <div class="brand">Training Program Management System</div>
        <div class="profile">
          <span class="avatar">TD</span><span>Training Department</span>
        </div>
      </header>
      <section class="content">
        <div class="detail">
          <div class="detail-head">
            <div>
              <h1 style="margin: 0">Report #<%=report.getReportId()%></h1>
              <p style="color: var(--muted)">
                <%=e(report.getCourseId())%> - <%=e(report.getSubjectName())%>
              </p>
            </div>
            <a class="button" href="<%=request.getContextPath()%>/report"
              >Back to reports</a
            >
          </div>
          <div class="grid">
            <div class="field">
              <span class="label">Course ID</span><%=e(report.getCourseId())%>
            </div>
            <div class="field">
              <span class="label">Course name</span
              ><%=e(report.getSubjectName())%>
            </div>
            <div class="field">
              <span class="label">Report type</span
              ><%=e(report.getReportType())%> (Version
              <%=e(report.getVersionNo())%>)
            </div>
            <div class="field">
              <span class="label">Status</span
              ><%=e(report.getSyllabusStatus())%>
            </div>
            <div class="field">
              <span class="label">Number of changes</span
              ><%=report.getNumberOfChanges()%>
            </div>
            <div class="field">
              <span class="label">Created by</span
              ><%=e(report.getCreatedBy())%><br /><small
                ><%=date(report.getCreatedDate())%></small
              >
            </div>
            <div class="field">
              <span class="label">Last modified by</span
              ><%=e(report.getModifiedBy())%><br /><small
                ><%=date(report.getLastModifiedDate())%></small
              >
            </div>
            <div class="field">
              <span class="label">Reviewer</span
              ><%=e(report.getReviewer())%><br /><small
                ><%=date(report.getReviewDate())%></small
              >
            </div>
            <div class="field wide">
              <span class="label">Curriculum name</span
              ><%=e(report.getAssociatedCurriculums())%>
            </div>
            <div class="field wide">
              <span class="label">Associated programs</span
              ><%=e(report.getAssociatedPrograms())%>
            </div>
            <div class="field wide">
              <span class="label">Course description</span
              ><%=e(report.getCourseDescription())%>
            </div>
            <div class="field wide">
              <span class="label">Change details</span
              ><%=e(report.getChangeDetails())%>
            </div>
          </div>
        </div>
      </section>
    </main>
  </body>
</html>
