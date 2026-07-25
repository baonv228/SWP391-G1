package dao;

import dto.SyllabusRequestDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Syllabus_Approval_Request table.
 *
 * Used by Teacher to submit new design/modification requests,
 * and by Training Department to review them.
 */
public class SyllabusRequestDAO {

    // ----------------------------------------------------------------
    //  Read: My requests (teacher's own)
    // ----------------------------------------------------------------

    public List<SyllabusRequestDTO> getRequestsByUser(int userId, int page, int pageSize)
            throws SQLException {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT r.RequestID, r.SyllabusID, r.RequestedBy, r.ReviewedBy, " +
                "r.RequestType, r.Status, r.ReviewNote, r.RequestedAt, r.ReviewedAt, " +
                "sy.SyllabusTitle, su.SubjectCode, su.SubjectName, " +
                "u.FullName AS RequestedByName " +
                "FROM Syllabus_Approval_Request r " +
                "JOIN Syllabus sy ON r.SyllabusID = sy.SyllabusID " +
                "JOIN Subject su ON sy.SubjectID = su.SubjectID " +
                "JOIN [User] u ON r.RequestedBy = u.UserID " +
                "WHERE r.RequestedBy = ? " +
                "ORDER BY r.RequestedAt DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<SyllabusRequestDTO> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public int countRequestsByUser(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Syllabus_Approval_Request WHERE RequestedBy = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // ----------------------------------------------------------------
    //  Read: All requests (admin/training dept)
    // ----------------------------------------------------------------

    public List<SyllabusRequestDTO> getAllRequests(String statusFilter, int page, int pageSize)
            throws SQLException {
        int offset = (page - 1) * pageSize;
        boolean hasFilter = statusFilter != null && !statusFilter.trim().isEmpty()
                && !"all".equalsIgnoreCase(statusFilter);
        String whereClause = hasFilter ? "WHERE r.Status = ? " : "";
        String sql = "SELECT r.RequestID, r.SyllabusID, r.RequestedBy, r.ReviewedBy, " +
                "r.RequestType, r.Status, r.ReviewNote, r.RequestedAt, r.ReviewedAt, " +
                "sy.SyllabusTitle, su.SubjectCode, su.SubjectName, " +
                "u.FullName AS RequestedByName " +
                "FROM Syllabus_Approval_Request r " +
                "JOIN Syllabus sy ON r.SyllabusID = sy.SyllabusID " +
                "JOIN Subject su ON sy.SubjectID = su.SubjectID " +
                "JOIN [User] u ON r.RequestedBy = u.UserID " +
                whereClause +
                "ORDER BY r.RequestedAt DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<SyllabusRequestDTO> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (hasFilter) ps.setString(idx++, statusFilter.trim());
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    // ----------------------------------------------------------------
    //  Write: Insert new request
    // ----------------------------------------------------------------

    /**
     * Inserts a new Syllabus_Approval_Request.
     * Returns the generated RequestID, or -1 if failed.
     */
    public int insertRequest(int syllabusId, int requestedBy,
                             String requestType, String reviewNote) throws SQLException {
        String sql = "INSERT INTO Syllabus_Approval_Request " +
                "(SyllabusID, RequestedBy, RequestType, Status, ReviewNote, RequestedAt) " +
                "VALUES (?, ?, ?, 'Pending', ?, GETDATE())";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, syllabusId);
            ps.setInt(2, requestedBy);
            ps.setString(3, requestType);
            ps.setString(4, reviewNote != null ? reviewNote.trim() : null);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    /**
     * Updates the status and review details of a Syllabus_Approval_Request.
     */
    public boolean updateRequestStatus(int requestId, String status, String reviewNote, int reviewedBy) throws SQLException {
        String sql = "UPDATE Syllabus_Approval_Request " +
                "SET Status = ?, ReviewNote = ?, ReviewedBy = ?, ReviewedAt = GETDATE() " +
                "WHERE RequestID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            if (reviewNote != null && !reviewNote.trim().isEmpty()) {
                ps.setString(2, reviewNote.trim());
            } else {
                ps.setNull(2, Types.NVARCHAR);
            }
            ps.setInt(3, reviewedBy);
            ps.setInt(4, requestId);
            return ps.executeUpdate() > 0;
        }
    }

    // ----------------------------------------------------------------
    //  Helper: map ResultSet row to DTO
    // ----------------------------------------------------------------

    private SyllabusRequestDTO mapRow(ResultSet rs) throws SQLException {
        SyllabusRequestDTO dto = new SyllabusRequestDTO();
        dto.setRequestId(rs.getInt("RequestID"));
        dto.setSyllabusId(rs.getInt("SyllabusID"));
        dto.setRequestedBy(rs.getInt("RequestedBy"));
        dto.setRequestType(rs.getString("RequestType"));
        dto.setStatus(rs.getString("Status"));
        dto.setReviewNote(rs.getString("ReviewNote"));
        dto.setRequestedAt(rs.getTimestamp("RequestedAt"));
        dto.setReviewedAt(rs.getTimestamp("ReviewedAt"));
        dto.setSyllabusTitle(rs.getString("SyllabusTitle"));
        dto.setSubjectCode(rs.getString("SubjectCode"));
        dto.setSubjectName(rs.getString("SubjectName"));
        dto.setRequestedByName(rs.getString("RequestedByName"));
        int reviewedBy = rs.getInt("ReviewedBy");
        if (!rs.wasNull()) dto.setReviewedBy(reviewedBy);
        return dto;
    }
}
