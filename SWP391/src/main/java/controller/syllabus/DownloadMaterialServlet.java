package controller.syllabus;

import dao.MaterialDAO;
import dto.MaterialDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utils.AuthUtil;
import utils.CloudinaryUtil;
import utils.ValidationUtil;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

/**
 * DownloadMaterialServlet
 *
 * URL pattern : /download-material?materialId=123
 *
 * Rules:
 *   1. User MUST be logged in (session attribute "user" is set).
 *      If not → redirect to /login?returnUrl=<current URL>
 *   2. materialId must be a valid integer.
 *   3. Material must exist and be Active.
 *   4. Files are read from the server file system using a base upload directory
 *      configured as a context init-param "upload.dir" (default: /materials under webapp).
 *   5. Streams the file with appropriate Content-Type and Content-Disposition headers
 *      so the browser triggers a download.
 */
@WebServlet(name = "DownloadMaterialServlet", urlPatterns = {"/download-material"})
public class DownloadMaterialServlet extends HttpServlet {

    /**
     * Context init-param name in web.xml.
     * Set to an absolute OS path.
     * Windows example: D:/uploads/materials
     * Linux example:   /var/uploads/materials
     * Falls back to {webapp root}/materials if not configured.
     */
    private static final String UPLOAD_DIR_PARAM = "upload.dir";


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
            getServletContext().log("DownloadMaterialServlet invoked by user: " + request.getRemoteAddr());
        
        // ── 1. Authentication check ────────────────────────────────────────
        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedInUser == null) {
            // Build returnUrl so user comes back after login
            String returnUrl = request.getRequestURI();
            String query     = request.getQueryString();
            if (query != null) returnUrl += "?" + query;

            String encodedReturn = URLEncoder.encode(returnUrl, StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" + encodedReturn);
            return;
        }

        // ── 2. Validate materialId parameter ──────────────────────────────
        String materialIdParam = request.getParameter("materialId");
        if (!ValidationUtil.isValidId(materialIdParam)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing materialId.");
            return;
        }

        int materialId = Integer.parseInt(materialIdParam.trim());
        MaterialDAO dao = new MaterialDAO();

        // ── 3. Load material metadata from DB ─────────────────────────────
        MaterialDTO material;
        try {
            material = dao.getMaterialById(materialId);
        } catch (SQLException e) {
            getServletContext().log("DB error in DownloadMaterialServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Database error while retrieving material.");
            return;
        }

        if (material == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Material not found or no longer available.");
            return;
        }

        if (!canAccessMaterial(loggedInUser, material)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
            return;
        }

        String filePath = material.getFilePath();
        if (filePath != null && (filePath.startsWith("http://") || filePath.startsWith("https://"))) {
            boolean streamed = streamRemoteFile(CloudinaryUtil.toRawDeliveryUrl(filePath), material, response);
            if (!streamed) {
                return;
            }
            recordDownload(dao, materialId);
            return;
        }

        // ── 4. Resolve the physical file path ─────────────────────────────
        File file = resolveFile(material.getFilePath());

        if (!file.exists() || !file.isFile()) {
            getServletContext().log("File not found on disk: " + file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "The file '" + material.getMaterialName() + "' is not available on the server.");
            return;
        }

        // Security: prevent path traversal
        String canonicalPath = file.getCanonicalPath();
        String uploadsCanonical = getUploadsRoot().getCanonicalPath();
        if (!canonicalPath.startsWith(uploadsCanonical)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
            return;
        }

        recordDownload(dao, materialId);

        // ── 5. Stream the file ────────────────────────────────────────────
        String contentType = resolveContentType(material.getMaterialType(), file.getName());
        response.setContentType(contentType);
        response.setContentLengthLong(file.length());

        setDownloadHeaders(response, file.getName());

        try (InputStream in = new BufferedInputStream(new FileInputStream(file));
             OutputStream out = new BufferedOutputStream(response.getOutputStream())) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────

    private boolean canAccessMaterial(User user, MaterialDTO material) {
        if (user == null || material == null) {
            return false;
        }
        if (user.getRoleId() == AuthUtil.ROLE_ADMIN) {
            return true;
        }
        return user.getRoleId() == AuthUtil.ROLE_TEACHER
                && material.getUploadedBy() == user.getUserId();
    }

    private void recordDownload(MaterialDAO dao, int materialId) {
        try {
            dao.incrementDownloadCount(materialId);
        } catch (SQLException e) {
            getServletContext().log("Unable to update material download count for materialId=" + materialId, e);
        }
    }

    private boolean streamRemoteFile(String fileUrl, MaterialDTO material, HttpServletResponse response)
            throws IOException {
        HttpURLConnection connection = null;
        try {
            connection = (HttpURLConnection) new URL(fileUrl).openConnection();
            connection.setInstanceFollowRedirects(true);
            connection.setConnectTimeout(15000);
            connection.setReadTimeout(30000);
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");

            int status = connection.getResponseCode();
            if (status < 200 || status >= 300) {
                getServletContext().log("Remote material download failed: " + status + " - " + fileUrl);
                response.sendError(HttpServletResponse.SC_BAD_GATEWAY,
                        "Unable to download material from remote storage.");
                return false;
            }

            String fileName = resolveDownloadFileName(material);
            String contentType = connection.getContentType();
            if (contentType == null || contentType.isBlank()) {
                contentType = resolveContentType(material.getMaterialType(), fileName);
            }

            response.setContentType(contentType);
            long contentLength = connection.getContentLengthLong();
            if (contentLength > 0) {
                response.setContentLengthLong(contentLength);
            }
            setDownloadHeaders(response, fileName);

            try (InputStream in = new BufferedInputStream(connection.getInputStream());
                 OutputStream out = new BufferedOutputStream(response.getOutputStream())) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
            return true;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    /**
     * Resolves the DB filePath (e.g. "/materials/lab211/lab01.zip") to a
     * physical File object under the configured uploads root directory.
     */
    private File resolveFile(String dbFilePath) throws IOException {
        File uploadsRoot = getUploadsRoot();
        // Strip leading slash and OS-normalise
        String relativePath = dbFilePath.replace("/", File.separator);
        if (relativePath.startsWith(File.separator)) {
            relativePath = relativePath.substring(1);
        }
        // Strip the duplicate "materials" folder prefix if it's prepended
        if (relativePath.toLowerCase().startsWith("materials" + File.separator)) {
            relativePath = relativePath.substring("materials".length() + 1);
        }
        return new File(uploadsRoot, relativePath);
    }

    /**
     * Returns the uploads root directory.
     * Priority: context-param "upload.dir" → {tomcat_webapps}/SWP391/materials
     */
    private File getUploadsRoot() {
        String configuredDir = getServletContext().getInitParameter(UPLOAD_DIR_PARAM);
        if (configuredDir != null && !configuredDir.trim().isEmpty()) {
            return new File(configuredDir.trim());
        }
        // Default: materials/ directory inside the deployed webapp
        String webappRoot = getServletContext().getRealPath("/");
        return new File(webappRoot, "materials");
    }

    private String resolveDownloadFileName(MaterialDTO material) {
        String materialName = material.getMaterialName();
        if (materialName != null && !materialName.trim().isEmpty()) {
            return materialName.trim().replaceAll("[\\\\/:*?\"<>|]", "_");
        }

        String filePath = material.getFilePath();
        if (filePath != null && !filePath.trim().isEmpty()) {
            String normalized = filePath.replace('\\', '/');
            int slash = normalized.lastIndexOf('/');
            return slash >= 0 ? normalized.substring(slash + 1) : normalized;
        }

        return "material-" + material.getMaterialId();
    }

    private void setDownloadHeaders(HttpServletResponse response, String fileName) {
        String encodedName = URLEncoder.encode(fileName, StandardCharsets.UTF_8)
                .replace("+", "%20");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + encodedName);
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");
    }

    /**
     * Maps material type string or file extension to a MIME content-type.
     */
    private String resolveContentType(String materialType, String fileName) {
        if (materialType != null) {
            switch (materialType.toUpperCase()) {
                case "ZIP":  return "application/zip";
                case "PDF":  return "application/pdf";
                case "PPTX": return "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                case "PPT":  return "application/vnd.ms-powerpoint";
                case "DOCX": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                case "DOC":  return "application/msword";
                case "MP4":  return "video/mp4";
                case "AVI":  return "video/x-msvideo";
            }
        }
        // Fallback: use servlet context mime type detection
        String mime = getServletContext().getMimeType(fileName);
        return (mime != null) ? mime : "application/octet-stream";
    }
}
