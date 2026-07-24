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
    private static final String CLOUD_NAME = "uaeubktv";
    private static final String API_KEY = "424233371132972";
    private static final String API_SECRET = "GGBtJp3BvW67f6Lzn_lN9DUeo4c";

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
     * Uploads file to Cloudinary securely.
     *
     * @param fileStream InputStream of the file part.
     * @param fileName Original file name.
     * @return Uploaded URL (Cloudinary secure_url).
     * @throws Exception if saving or uploading fails.
     */
    public static String uploadFile(InputStream fileStream, String fileName) throws Exception {
        if (cloudinary == null) {
            throw new Exception("Cloudinary credentials are not configured.");
        }

        File tempDirectory = new File(
                System.getProperty("user.home") + File.separator + "tpms-uploads"
                        + File.separator + "temp" + File.separator + "cloudinary");
        if (!tempDirectory.exists() && !tempDirectory.mkdirs()) {
            throw new Exception("Cannot create Cloudinary temporary directory: " + tempDirectory);
        }

        File localFile = File.createTempFile("upload_", ".tmp", tempDirectory);
        try {
            try (OutputStream out = new FileOutputStream(localFile)) {
                byte[] buf = new byte[8192];
                int length;
                while ((length = fileStream.read(buf)) > 0) {
                    out.write(buf, 0, length);
                }
            }
            return uploadFile(localFile, fileName);
        } finally {
            // Always delete temp file to prevent disk leak
            if (localFile.exists()) {
                localFile.delete();
            }
        }
    }

    /**
     * Uploads an existing local file without copying it through java.io.tmpdir.
     */
    public static String uploadFile(File localFile, String fileName) throws Exception {
        if (cloudinary == null) {
            throw new Exception("Cloudinary credentials are not configured.");
        }
        if (localFile == null || !localFile.isFile()) {
            throw new Exception("Upload file does not exist: " + localFile);
        }

        String safeFileName = System.currentTimeMillis() + "_"
                + fileName.replaceAll("[^a-zA-Z0-9._\\-]", "_");
        String ext = getExtension(fileName).toLowerCase();
        String resourceType = "raw";
        if (ext.equals("mp4") || ext.equals("avi") || ext.equals("mov") || ext.equals("webm")) {
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
        String secureUrl = (String) uploadResult.get("secure_url");
        if (secureUrl == null || secureUrl.isBlank()) {
            throw new Exception("Cloudinary did not return secure_url.");
        }
        return secureUrl;
    }

    private static String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return (dot >= 0) ? fileName.substring(dot + 1) : "";
    }
}
    
