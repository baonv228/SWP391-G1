package controller.syllabus;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Serves learning material files under /materials/* with Content-Disposition: attachment
 * so the browser triggers a download instead of navigating to a 404 page.
 */
@WebServlet(name = "MaterialFileServlet", urlPatterns = {"/materials/*"})
public class MaterialFileServlet extends HttpServlet {

    private static final String UPLOAD_DIR_PARAM = "upload.dir";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (loggedInUser == null) {
            String returnUrl = request.getRequestURI();
            String query = request.getQueryString();
            if (query != null) {
                returnUrl += "?" + query;
            }
            String encodedReturn = URLEncoder.encode(returnUrl, StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" + encodedReturn);
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.isBlank() || "/".equals(pathInfo)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not specified.");
            return;
        }

        String dbFilePath = "/materials" + pathInfo;
        File file = resolveFile(dbFilePath);

        if (!file.exists() || !file.isFile()) {
            getServletContext().log("Material file not found: " + file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "The requested file is not available on the server.");
            return;
        }

        String canonicalPath = file.getCanonicalPath();
        String uploadsCanonical = getUploadsRoot().getCanonicalPath();
        if (!canonicalPath.startsWith(uploadsCanonical)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
            return;
        }

        String contentType = resolveContentType(file.getName());
        response.setContentType(contentType);
        response.setContentLengthLong(file.length());

        String encodedName = URLEncoder.encode(file.getName(), StandardCharsets.UTF_8).replace("+", "%20");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + file.getName() + "\"; filename*=UTF-8''" + encodedName);
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");

        try (InputStream in = new BufferedInputStream(new FileInputStream(file));
             OutputStream out = new BufferedOutputStream(response.getOutputStream())) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
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

    private String resolveContentType(String fileName) {
        String mime = getServletContext().getMimeType(fileName);
        if (mime != null) {
            return mime;
        }
        String lower = fileName.toLowerCase();
        if (lower.endsWith(".zip")) {
            return "application/zip";
        }
        if (lower.endsWith(".pdf")) {
            return "application/pdf";
        }
        return "application/octet-stream";
    }
}
