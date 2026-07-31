package controller.teacher;

import dao.MaterialDAO;
import dao.SyllabusDAO;
import dao.TeacherProgramDAO;
import dto.MaterialDTO;
import dto.SyllabusDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.TrainingProgram;
import model.User;
import utils.AuthUtil;
import utils.ValidationUtil;

import java.io.*;
import java.nio.file.*;
import java.sql.SQLException;
import java.util.List;

/**
 * UploadMaterialServlet — Teacher uploads a ZIP/PDF file as teacher material
 * (only teacher-uploaded materials can be downloaded/viewed).
 *
 * GET  /teacher/upload-material?syllabusId=N  → Show upload form for that syllabus
 * POST /teacher/upload-material               → Process file upload
 *
 * === CHỈNH SỬA (Teacher Program Assignment) ===
 * - Dropdown syllabus chỉ còn các syllabus thuộc ngành (Training_Program)
 *   đã được Training Department gán cho teacher (bảng Teacher_Program).
 * - POST từ chối upload nếu syllabus không thuộc ngành đã gán.
 * - Course List KHÔNG bị ảnh hưởng (vẫn xem full tất cả ngành).
 *
 * @MultipartConfig enables multipart/form-data handling built into Jakarta Servlet 6.
 * Max file size: 100 MB per file, 110 MB total request.
 */
@WebServlet(name = "UploadMaterialServlet", urlPatterns = {"/teacher/upload-material"})
@MultipartConfig(
        fileSizeThreshold = 2 * 1024 * 1024,   // 2 MB — write to disk after this
        maxFileSize       = 100 * 1024 * 1024,  // 100 MB max per file
        maxRequestSize    = 110 * 1024 * 1024   // 110 MB max total request
)
public class UploadMaterialServlet extends HttpServlet {

    private static final String UPLOAD_DIR_PARAM = "upload.dir";

    // ----------------------------------------------------------------
    //  GET — Show upload form
    // ----------------------------------------------------------------

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        User teacher = AuthUtil.getLoggedInUser(request);

        try {
            // CHANGED: load syllabi by assigned majors instead of all syllabi
            TeacherProgramDAO teacherProgramDAO = new TeacherProgramDAO();
            List<Integer> programIds = teacherProgramDAO.getProgramIdsByTeacherId(teacher.getUserId());
            List<TrainingProgram> assignedPrograms = teacherProgramDAO.getProgramsByTeacherId(teacher.getUserId());
            request.setAttribute("assignedPrograms", assignedPrograms);

            SyllabusDAO syllabusDAO = new SyllabusDAO();
            List<SyllabusDTO> syllabi = syllabusDAO.searchSyllabiByProgramIds(programIds);
            request.setAttribute("syllabi", syllabi);

            if (programIds.isEmpty()) {
                request.setAttribute("error",
                        "Bạn chưa được gán ngành nào. Liên hệ Training Department để được gán (SE, KTE, …).");
            }

            // If syllabusId param given, pre-select only if allowed for this teacher
            String syllabusIdParam = request.getParameter("syllabusId");
            if (ValidationUtil.isValidId(syllabusIdParam)) {
                int syllabusId = Integer.parseInt(syllabusIdParam);
                if (syllabusDAO.isSyllabusInProgramIds(syllabusId, programIds)) {
                    request.setAttribute("selectedSyllabusId", syllabusId);
                } else {
                    request.setAttribute("error",
                            "Syllabus này không thuộc ngành bạn được gán. Chỉ được upload trong ngành đã gán.");
                }
            }

            // Show existing materials only for an allowed selected syllabus
            Object selectedObj = request.getAttribute("selectedSyllabusId");
            if (selectedObj instanceof Integer selectedSyllabusId) {
                MaterialDAO materialDAO = new MaterialDAO();
                List<MaterialDTO> existing = materialDAO.getMaterialsBySyllabusId(selectedSyllabusId);
                request.setAttribute("existingMaterials", existing);
            }

            request.getRequestDispatcher("/views/teacher/uploadMaterial.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("DB error in UploadMaterialServlet GET", e);
            request.getRequestDispatcher("/views/error/dbError.jsp").forward(request, response);
        }
    }

    // ----------------------------------------------------------------
    //  POST — Process upload
    // ----------------------------------------------------------------

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        User teacher = AuthUtil.getLoggedInUser(request);
        request.setCharacterEncoding("UTF-8");

        // ── Validate form fields ──────────────────────────────────────
        String syllabusIdParam = request.getParameter("syllabusId");
        String materialName    = request.getParameter("materialName");
        String visibility      = request.getParameter("visibility");

        if (!ValidationUtil.isValidId(syllabusIdParam)
                || materialName == null || materialName.trim().isEmpty()) {
            request.setAttribute("error", "Syllabus and Material Name are required.");
            doGet(request, response);
            return;
        }

        int syllabusId = Integer.parseInt(syllabusIdParam.trim());
        materialName = ValidationUtil.sanitize(materialName);

        // CHANGED: block upload outside assigned majors
        try {
            TeacherProgramDAO teacherProgramDAO = new TeacherProgramDAO();
            List<Integer> programIds = teacherProgramDAO.getProgramIdsByTeacherId(teacher.getUserId());
            SyllabusDAO syllabusDAO = new SyllabusDAO();
            if (!syllabusDAO.isSyllabusInProgramIds(syllabusId, programIds)) {
                request.setAttribute("error",
                        "Không được upload ngoài ngành đã gán. Liên hệ Training Department nếu cần thêm ngành.");
                doGet(request, response);
                return;
            }
        } catch (SQLException e) {
            getServletContext().log("DB error checking teacher program scope", e);
            request.setAttribute("error", "Database error while checking major assignment.");
            doGet(request, response);
            return;
        }

        // ── Get uploaded file ─────────────────────────────────────────
        Part filePart = request.getPart("materialFile");
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Please select a file to upload.");
            request.setAttribute("selectedSyllabusId", syllabusId);
            doGet(request, response);
            return;
        }

        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        if (originalFileName.isEmpty()) {
            request.setAttribute("error", "Invalid file name.");
            doGet(request, response);
            return;
        }

        // Derive material type from extension
        String extension = getExtension(originalFileName).toUpperCase();
        if (!isAllowedExtension(extension)) {
            request.setAttribute("error", "File type not allowed. Allowed: ZIP, PDF, PPTX, DOCX, MP4.");
            request.setAttribute("selectedSyllabusId", syllabusId);
            doGet(request, response);
            return;
        }

        // ── Save file to disk ─────────────────────────────────────────
        // Directory structure: {uploadRoot}/syllabusId/filename
        File uploadsRoot = getUploadsRoot();
        File syllabusDir = new File(uploadsRoot, String.valueOf(syllabusId));
        if (!syllabusDir.exists()) syllabusDir.mkdirs();

        // Prevent filename collisions: prefix with timestamp
        String safeFileName = System.currentTimeMillis() + "_" +
                originalFileName.replaceAll("[^a-zA-Z0-9._\\-]", "_");
        File destFile = new File(syllabusDir, safeFileName);

        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        // DB relative path (forward slashes for URL compatibility)
        String relPath = "/materials/" + syllabusId + "/" + safeFileName;

        // ── Insert DB record ─────────────────────────────────────────
        try {
            MaterialDAO materialDAO = new MaterialDAO();
            int newId = materialDAO.insertMaterial(
                    syllabusId,
                    teacher.getUserId(),
                    materialName,
                    relPath,
                    extension,
                    visibility != null ? visibility : "Public"
            );

            if (newId > 0) {
                response.sendRedirect(request.getContextPath()
                        + "/teacher/upload-material?syllabusId=" + syllabusId
                        + "&success=Material+uploaded+successfully");
            } else {
                request.setAttribute("error", "Failed to save material record. Please try again.");
                doGet(request, response);
            }
        } catch (SQLException e) {
            getServletContext().log("DB error inserting material", e);
            // Remove file if DB insert failed
            destFile.delete();
            request.setAttribute("error", "Database error while saving material.");
            request.setAttribute("selectedSyllabusId", syllabusId);
            doGet(request, response);
        }
    }

    // ----------------------------------------------------------------
    //  Helpers
    // ----------------------------------------------------------------

    private File getUploadsRoot() {
        String configured = getServletContext().getInitParameter(UPLOAD_DIR_PARAM);
        if (configured != null && !configured.trim().isEmpty()) {
            return new File(configured.trim());
        }
        return new File(getServletContext().getRealPath("/"), "materials");
    }

    private String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return (dot >= 0) ? fileName.substring(dot + 1) : "";
    }

    private boolean isAllowedExtension(String ext) {
        switch (ext) {
            case "ZIP": case "PDF": case "PPTX": case "PPT":
            case "DOCX": case "DOC": case "MP4": case "AVI":
                return true;
            default: return false;
        }
    }
}
