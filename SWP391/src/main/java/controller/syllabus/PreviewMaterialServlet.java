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
 * PreviewMaterialServlet
 *
 * URL pattern : /preview-material?materialId=123
 *
 * Serves a material INLINE (Content-Disposition: inline) so the browser can
 * render it in place (PDF viewer / image). Unlike DownloadMaterialServlet it
 * does NOT force an attachment and does NOT send no-store headers, so the
 * browser's built-in viewer works.
 *
 * Restrictions:
 *   1. User MUST be logged in.
 *   2. Only owner or admin may preview (same rule as download).
 *   3. Only inline-safe types are allowed (PDF and images). Other types are
 *      rejected with 400 — the UI should link them to /download-material instead.
 */
@WebServlet(name = "PreviewMaterialServlet", urlPatterns = {"/preview-material"})
public class PreviewMaterialServlet extends HttpServlet {

    private static final String UPLOAD_DIR_PARAM = "upload.dir";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Authentication check ────────────────────────────────────────
        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedInUser == null) {
            String returnUrl = request.getRequestURI();
            String query = request.getQueryString();
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
            getServletContext().log("DB error in PreviewMaterialServlet", e);
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

        // ── 4. Only allow inline-safe types (PDF and images) ──────────────
        if (!isPreviewable(material.getMaterialType())) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "This material type cannot be previewed. Use download instead.");
            return;
        }

        // ── 5. Serve inline ────────────────────────────────────────────────
        String filePath = material.getFilePath();
        if (filePath != null && (filePath.startsWith("http://") || filePath.startsWith("https://"))) {
            streamRemoteFile(CloudinaryUtil.toRawDeliveryUrl(filePath), material, response);
            return;
        }

        File file = resolveFile(filePath);
        if (!file.exists() || !file.isFile()) {
            getServletContext().log("Preview file not found on disk: " + file.getAbsolutePath());
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

        String contentType = resolveContentType(material.getMaterialType(), file.getName());
        response.setContentType(contentType);
        response.setContentLengthLong(file.length());
        setInlineHeaders(response, resolveFileName(material));

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

    /** Only PDF and common image types are safe to render inline. */
    private boolean isPreviewable(String materialType) {
        if (materialType == null) return false;
        switch (materialType.toUpperCase()) {
            case "PDF":
            case "PNG":
            case "JPG":
            case "JPEG":
            case "GIF":
            case "WEBP":
                return true;
            default:
                return false;
        }
    }

    private void streamRemoteFile(String fileUrl, MaterialDTO material, HttpServletResponse response)
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
                getServletContext().log("Remote material preview failed: " + status + " - " + fileUrl);
                response.sendError(HttpServletResponse.SC_BAD_GATEWAY,
                        "Unable to load material from remote storage.");
                return;
            }

            String fileName = resolveFileName(material);
            String contentType = connection.getContentType();
            if (contentType == null || contentType.isBlank()) {
                contentType = resolveContentType(material.getMaterialType(), fileName);
            }

            response.setContentType(contentType);
            long contentLength = connection.getContentLengthLong();
            if (contentLength > 0) {
                response.setContentLengthLong(contentLength);
            }
            setInlineHeaders(response, fileName);

            try (InputStream in = new BufferedInputStream(connection.getInputStream());
                 OutputStream out = new BufferedOutputStream(response.getOutputStream())) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    private File resolveFile(String dbFilePath) throws IOException {
        File uploadsRoot = getUploadsRoot();
        String relativePath = dbFilePath.replace("/", File.separator);
        if (relativePath.startsWith(File.separator)) {
            relativePath = relativePath.substring(1);
        }
        if (relativePath.toLowerCase().startsWith("materials" + File.separator)) {
            relativePath = relativePath.substring("materials".length() + 1);
        }
        return new File(uploadsRoot, relativePath);
    }

    private File getUploadsRoot() {
        String configuredDir = getServletContext().getInitParameter(UPLOAD_DIR_PARAM);
        if (configuredDir != null && !configuredDir.trim().isEmpty()) {
            return new File(configuredDir.trim());
        }
        String webappRoot = getServletContext().getRealPath("/");
        return new File(webappRoot, "materials");
    }

    private String resolveFileName(MaterialDTO material) {
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

    /** Inline disposition so the browser renders in place; no no-store headers. */
    private void setInlineHeaders(HttpServletResponse response, String fileName) {
        String encodedName = URLEncoder.encode(fileName, StandardCharsets.UTF_8)
                .replace("+", "%20");
        response.setHeader("Content-Disposition",
                "inline; filename=\"" + fileName + "\"; filename*=UTF-8''" + encodedName);
    }

    private String resolveContentType(String materialType, String fileName) {
        if (materialType != null) {
            switch (materialType.toUpperCase()) {
                case "PDF":  return "application/pdf";
                case "PNG":  return "image/png";
                case "JPG":
                case "JPEG": return "image/jpeg";
                case "GIF":  return "image/gif";
                case "WEBP": return "image/webp";
            }
        }
        String mime = getServletContext().getMimeType(fileName);
        return (mime != null) ? mime : "application/octet-stream";
    }
}
