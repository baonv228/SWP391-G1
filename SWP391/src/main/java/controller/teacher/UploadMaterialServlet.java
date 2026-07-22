package controller.teacher;

import dao.MaterialDAO;
import dao.SyllabusDAO;
import dto.MaterialDTO;
import dto.PaginationDTO;
import dto.SyllabusDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.User;
import utils.AuthUtil;
import utils.PaginationUtil;
import utils.ValidationUtil;

import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.sql.SQLException;
import java.util.List;

/**
 * UploadMaterialServlet — Teacher uploads a ZIP/PDF file as a learning material.
 *
 * GET  /teacher/upload-material?syllabusId=N  → Show upload form for that syllabus
 * POST /teacher/upload-material               → Process file upload
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
    private static final int PAGE_SIZE = PaginationUtil.TEACHER_PAGE_SIZE;

    // ----------------------------------------------------------------
    //  GET — Show upload form
    // ----------------------------------------------------------------

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        User teacher = AuthUtil.getLoggedInUser(request);

        try {
            // Pre-load all active syllabi for the dropdown
            SyllabusDAO syllabusDAO = new SyllabusDAO();
            List<SyllabusDTO> syllabi = syllabusDAO.searchSyllabi("", "", 1, 1000);
            request.setAttribute("syllabi", syllabi);

            // If syllabusId param given, pre-select it
            String syllabusIdParam = request.getParameter("syllabusId");
            Integer selectedSyllabusId = null;
            if (ValidationUtil.isValidId(syllabusIdParam)) {
                selectedSyllabusId = Integer.parseInt(syllabusIdParam);
                request.setAttribute("selectedSyllabusId", selectedSyllabusId);
            }

            // Private cloud: only show files uploaded by the current teacher.
            int page = ValidationUtil.parsePageNumber(request.getParameter("page"));
            MaterialDAO materialDAO = new MaterialDAO();
            int total = materialDAO.countMaterialsByUploader(teacher.getUserId(), selectedSyllabusId);
            PaginationDTO pagination = PaginationUtil.buildPagination(total, page, PAGE_SIZE);
            List<MaterialDTO> existing = materialDAO.getMaterialsByUploader(
                    teacher.getUserId(), selectedSyllabusId, pagination.getCurrentPage(), PAGE_SIZE);
            request.setAttribute("existingMaterials", existing);
            request.setAttribute("materialPagination", pagination);
            request.setAttribute("totalMaterials", total);

            request.getRequestDispatcher("/view/teacher/uploadMaterial.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("DB error in UploadMaterialServlet GET", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
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

        String action = request.getParameter("action");
        if ("update".equalsIgnoreCase(action)) {
            updateMaterialMetadata(request, response, teacher);
            return;
        }
        if ("delete".equalsIgnoreCase(action)) {
            deleteMaterial(request, response, teacher);
            return;
        }

        // ── Validate form fields ──────────────────────────────────────
        String syllabusIdParam = request.getParameter("syllabusId");
        String materialName    = request.getParameter("materialName");

        if (!ValidationUtil.isValidId(syllabusIdParam)
                || materialName == null || materialName.trim().isEmpty()) {
            request.setAttribute("error", "Syllabus and Material Name are required.");
            doGet(request, response);
            return;
        }

        int syllabusId = Integer.parseInt(syllabusIdParam.trim());
        materialName = ValidationUtil.sanitize(materialName);

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

        // ── Save/Upload file ─────────────────────────────────────────
        File uploadsRoot = getUploadsRoot();
        File syllabusDir = new File(uploadsRoot, String.valueOf(syllabusId));
        String relativeFallbackPrefix = "/materials/" + syllabusId + "/";

        String finalFileUrl;
        try (InputStream in = filePart.getInputStream()) {
            finalFileUrl = utils.CloudinaryUtil.uploadFile(in, originalFileName, syllabusDir, relativeFallbackPrefix);
        } catch (Exception e) {
            getServletContext().log("File save/upload error", e);
            request.setAttribute("error", "Error uploading file: " + e.getMessage());
            request.setAttribute("selectedSyllabusId", syllabusId);
            doGet(request, response);
            return;
        }

        // ── Insert DB record ─────────────────────────────────────────
        try {
            MaterialDAO materialDAO = new MaterialDAO();
            int newId = materialDAO.insertMaterial(
                    syllabusId,
                    teacher.getUserId(),
                    materialName,
                    finalFileUrl,
                    extension,
                    "Private"
            );

            if (newId > 0) {
                redirectToCloud(request, response, syllabusIdParam,
                        "success", "Material uploaded to your private cloud");
            } else {
                request.setAttribute("error", "Failed to save material record. Please try again.");
                doGet(request, response);
            }
        } catch (SQLException e) {
            getServletContext().log("DB error inserting material", e);
            // Remove local file if DB insert failed and it was stored locally
            if (finalFileUrl.startsWith("/materials/")) {
                String localFilename = finalFileUrl.substring(finalFileUrl.lastIndexOf('/') + 1);
                File stored = new File(syllabusDir, localFilename);
                if (stored.exists()) stored.delete();
            }
            request.setAttribute("error", "Database error while saving material.");
            request.setAttribute("selectedSyllabusId", syllabusId);
            doGet(request, response);
        }
    }

    // ----------------------------------------------------------------
    //  Helpers
    // ----------------------------------------------------------------

    private void updateMaterialMetadata(HttpServletRequest request, HttpServletResponse response, User teacher)
            throws IOException, ServletException {
        String materialIdParam = request.getParameter("materialId");
        String syllabusIdParam = request.getParameter("syllabusId");
        String materialName = request.getParameter("materialName");

        if (!ValidationUtil.isValidId(materialIdParam)
                || materialName == null || materialName.trim().isEmpty()) {
            redirectToCloud(request, response, syllabusIdParam,
                    "error", "Material name is required");
            return;
        }

        materialName = ValidationUtil.sanitize(materialName);
        try {
            MaterialDAO materialDAO = new MaterialDAO();
            boolean updated = materialDAO.updateMaterialName(
                    Integer.parseInt(materialIdParam.trim()),
                    teacher.getUserId(),
                    materialName
            );
            redirectToCloud(request, response, syllabusIdParam,
                    updated ? "success" : "error",
                    updated ? "Material updated successfully" : "Material not found or access denied");
        } catch (SQLException e) {
            getServletContext().log("DB error updating material", e);
            request.setAttribute("error", "Database error while updating material.");
            doGet(request, response);
        }
    }

    private void deleteMaterial(HttpServletRequest request, HttpServletResponse response, User teacher)
            throws IOException, ServletException {
        String materialIdParam = request.getParameter("materialId");
        String syllabusIdParam = request.getParameter("syllabusId");

        if (!ValidationUtil.isValidId(materialIdParam)) {
            redirectToCloud(request, response, syllabusIdParam,
                    "error", "Invalid material");
            return;
        }

        try {
            MaterialDAO materialDAO = new MaterialDAO();
            boolean deleted = materialDAO.deleteMaterial(
                    Integer.parseInt(materialIdParam.trim()),
                    teacher.getUserId()
            );
            redirectToCloud(request, response, syllabusIdParam,
                    deleted ? "success" : "error",
                    deleted ? "Material deleted successfully" : "Material not found or access denied");
        } catch (SQLException e) {
            getServletContext().log("DB error deleting material", e);
            request.setAttribute("error", "Database error while deleting material.");
            doGet(request, response);
        }
    }

    private void redirectToCloud(HttpServletRequest request, HttpServletResponse response,
                                 String syllabusIdParam, String messageType, String message)
            throws IOException {
        StringBuilder url = new StringBuilder(request.getContextPath()).append("/teacher/upload-material");
        String separator = "?";
        if (ValidationUtil.isValidId(syllabusIdParam)) {
            url.append(separator).append("syllabusId=").append(syllabusIdParam.trim());
            separator = "&";
        }
        url.append(separator)
                .append(messageType)
                .append("=")
                .append(URLEncoder.encode(message, StandardCharsets.UTF_8));
        response.sendRedirect(url.toString());
    }

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
