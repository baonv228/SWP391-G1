package utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;

public class CloudinaryUtil {

    private static final String CLOUD_NAME = getConfig("CLOUDINARY_CLOUD_NAME", "cloudinary.cloud_name", "utnlrrp5");
    private static final String API_KEY = getConfig("CLOUDINARY_API_KEY", "cloudinary.api_key", "888491846349974");
    private static final String API_SECRET = getConfig("CLOUDINARY_API_SECRET", "cloudinary.api_secret", "rexoJ8l8BIrMNpUmcG2vJdb2ATw");

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

    public static String uploadFile(InputStream fileStream, String fileName) throws Exception {
        if (cloudinary == null) {
            throw new Exception("Cloudinary credentials are not configured.");
        }

        String safeFileName = buildSafeFileName(fileName);
        File localFile = File.createTempFile("upload_", "_" + safeFileName);
        try {
            writeToFile(fileStream, localFile);
            return uploadToCloudinary(localFile, safeFileName, fileName);
        } finally {
            if (localFile.exists()) {
                localFile.delete();
            }
        }
    }

    public static String uploadFile(InputStream fileStream, String fileName,
                                    File destinationDir, String webAppRelativeFallbackPrefix) throws Exception {
        String safeFileName = buildSafeFileName(fileName);
        if (!destinationDir.exists() && !destinationDir.mkdirs()) {
            throw new Exception("Unable to create upload directory: " + destinationDir.getAbsolutePath());
        }

        File localFile = new File(destinationDir, safeFileName);
        writeToFile(fileStream, localFile);

        String resourceType = resolveResourceType(fileName);
        if ("raw".equals(resourceType)) {
            return webAppRelativeFallbackPrefix + safeFileName;
        }

        if (cloudinary != null) {
            try {
                String cloudinaryUrl = uploadToCloudinary(localFile, safeFileName, fileName);
                if (localFile.exists()) {
                    localFile.delete();
                }
                return cloudinaryUrl;
            } catch (Exception e) {
                System.err.println("Cloudinary upload failed: " + e.getMessage() + ". Falling back to local storage.");
            }
        }

        return webAppRelativeFallbackPrefix + safeFileName;
    }

    public static String toRawDeliveryUrl(String fileUrl) {
        if (fileUrl == null || !fileUrl.contains("res.cloudinary.com") || !fileUrl.contains("/upload/")) {
            return fileUrl;
        }

        int uploadIndex = fileUrl.indexOf("/upload/");
        String prefix = fileUrl.substring(0, uploadIndex + "/upload/".length());
        String deliveryPath = fileUrl.substring(uploadIndex + "/upload/".length());

        if (deliveryPath.startsWith("fl_attachment/")) {
            return prefix + deliveryPath.substring("fl_attachment/".length());
        }
        if (deliveryPath.startsWith("fl_attachment,")) {
            return prefix + deliveryPath.substring("fl_attachment,".length());
        }
        if (deliveryPath.startsWith("fl_attachment:")) {
            int nextSlash = deliveryPath.indexOf('/');
            if (nextSlash >= 0 && nextSlash < deliveryPath.length() - 1) {
                return prefix + deliveryPath.substring(nextSlash + 1);
            }
        }

        return fileUrl;
    }

    private static String uploadToCloudinary(File localFile, String safeFileName, String originalFileName) throws Exception {
        Map params = ObjectUtils.asMap(
                "folder", "flm_materials",
                "resource_type", resolveResourceType(originalFileName),
                "public_id", safeFileName
        );

        Map uploadResult = cloudinary.uploader().upload(localFile, params);
        return (String) uploadResult.get("secure_url");
    }

    private static void writeToFile(InputStream fileStream, File localFile) throws Exception {
        try (OutputStream out = new FileOutputStream(localFile)) {
            byte[] buffer = new byte[8192];
            int length;
            while ((length = fileStream.read(buffer)) > 0) {
                out.write(buffer, 0, length);
            }
        }
    }

    private static String buildSafeFileName(String fileName) {
        return System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9._\\-]", "_");
    }

    private static String resolveResourceType(String fileName) {
        String extension = getExtension(fileName).toLowerCase();
        switch (extension) {
            case "mp4":
            case "avi":
            case "mov":
            case "webm":
                return "video";
            case "png":
            case "jpg":
            case "jpeg":
            case "gif":
                return "image";
            default:
                return "raw";
        }
    }

    private static String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return (dot >= 0) ? fileName.substring(dot + 1) : "";
    }

    private static String getConfig(String envName, String propertyName, String defaultValue) {
        String propertyValue = System.getProperty(propertyName);
        if (propertyValue != null && !propertyValue.trim().isEmpty()) {
            return propertyValue.trim();
        }
        String envValue = System.getenv(envName);
        if (envValue != null && !envValue.trim().isEmpty()) {
            return envValue.trim();
        }
        return defaultValue;
    }
}
