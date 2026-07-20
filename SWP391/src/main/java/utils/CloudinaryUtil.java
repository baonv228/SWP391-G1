package utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;

public class CloudinaryUtil {

    // Cloudinary Credentials (fill keys when provided)
    private static final String CLOUD_NAME = "utnlrrp5";
    private static final String API_KEY = "888491846349974";
    private static final String API_SECRET = "rexoJ8l8BIrMNpUmcG2vJdb2ATw";

    private static Cloudinary cloudinary = null;

    static {
        if (CLOUD_NAME != null && !CLOUD_NAME.isEmpty()
                && API_KEY != null && !API_KEY.isEmpty()
                && API_SECRET != null && !API_SECRET.isEmpty()) {
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", CLOUD_NAME,
                "api_key", API_KEY,
                "api_secret", API_SECRET,
                "secure", true
            ));
        }
    }

    /**
     * Uploads file to Cloudinary. Falls back to local directory saving if credentials are not configured.
     *
     * @param fileStream InputStream of the file part.
     * @param fileName Original file name.
     * @param destinationDir Local directory file object to write to as fallback.
     * @param webAppRelativeFallbackPrefix Web app URL path prefix for fallback (e.g. "/materials/1/").
     * @return Uploaded URL (Cloudinary secure_url or local relative fallback path).
     * @throws Exception if saving or uploading fails.
     */
    public static String uploadFile(InputStream fileStream, String fileName, File destinationDir, String webAppRelativeFallbackPrefix) throws Exception {
        // Collisions prevention suffix
        String safeFileName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9._\\-]", "_");
        
        // Always write to local folder first (as a local backup / fallback)
        if (!destinationDir.exists()) {
            destinationDir.mkdirs();
        }
        File localFile = new File(destinationDir, safeFileName);
        try (OutputStream out = new FileOutputStream(localFile)) {
            byte[] buf = new byte[8192];
            int length;
            while ((length = fileStream.read(buf)) > 0) {
                out.write(buf, 0, length);
            }
        }

        // If Cloudinary is configured, upload to Cloudinary
        if (cloudinary != null) {
            try {
                // Determine resource type: raw (for zip/docs), image, or video
                String ext = getExtension(fileName).toLowerCase();
                String resourceType = "raw";
                if (ext.equals("pdf") || ext.equals("docx") || ext.equals("zip") || ext.equals("xlsx") || ext.equals("pptx")) {
                    resourceType = "raw";
                } else if (ext.equals("mp4") || ext.equals("avi") || ext.equals("mov") || ext.equals("webm")) {
                    resourceType = "video";
                } else if (ext.equals("png") || ext.equals("jpg") || ext.equals("jpeg") || ext.equals("gif")) {
                    resourceType = "image";
                }

                Map params = ObjectUtils.asMap(
                    "folder", "flm_materials",
                    "resource_type", resourceType,
                    "public_id", safeFileName
                );

                Map uploadResult = cloudinary.uploader().upload(localFile, params);
                String cloudinaryUrl = (String) uploadResult.get("secure_url");
                
                // Optionally delete local temp file after uploading to Cloudinary
                localFile.delete();
                
                return cloudinaryUrl;
            } catch (Exception e) {
                System.err.println("Cloudinary upload failed: " + e.getMessage() + ". Falling back to local storage.");
            }
        }

        // Fallback: return local relative path
        return webAppRelativeFallbackPrefix + safeFileName;
    }

    private static String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return (dot >= 0) ? fileName.substring(dot + 1) : "";
    }
}
