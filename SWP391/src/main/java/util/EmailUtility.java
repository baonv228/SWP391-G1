package util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.InputStream;
import java.util.Properties;

/**
 * Gửi email thật qua SMTP (Jakarta Mail). Không dùng mock/console fallback.
 * Cấu hình: src/main/resources/mail.properties
 * Có thể ghi đè bằng env: TPMS_MAIL_EMAIL, TPMS_MAIL_APP_PASSWORD
 */
public class EmailUtility {

    private static final Properties MAIL_CONFIG = loadConfig();

    private EmailUtility() {
    }

    private static Properties loadConfig() {
        Properties props = new Properties();
        try (InputStream in = EmailUtility.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (in != null) {
                props.load(in);
            } else {
                System.err.println("[SMTP] Không tìm thấy mail.properties trên classpath.");
            }
        } catch (Exception e) {
            System.err.println("[SMTP] Lỗi đọc mail.properties: " + e.getMessage());
        }
        return props;
    }

    private static String cfg(String key, String defaultValue) {
        String envKey = switch (key) {
            case "mail.sender.email" -> firstNonBlank(System.getenv("TPMS_MAIL_EMAIL"), System.getProperty("tpms.mail.email"));
            case "mail.sender.app-password" -> firstNonBlank(System.getenv("TPMS_MAIL_APP_PASSWORD"), System.getProperty("tpms.mail.appPassword"));
            default -> null;
        };
        if (envKey != null && !envKey.isBlank()) {
            return envKey.trim();
        }
        String value = MAIL_CONFIG.getProperty(key, defaultValue);
        return value == null ? defaultValue : value.trim();
    }

    private static String firstNonBlank(String a, String b) {
        if (a != null && !a.isBlank()) {
            return a;
        }
        if (b != null && !b.isBlank()) {
            return b;
        }
        return null;
    }

    private static boolean isConfigured(String email, String appPassword) {
        if (email == null || email.isBlank() || appPassword == null || appPassword.isBlank()) {
            return false;
        }
        String lower = email.toLowerCase();
        if (lower.contains("your-email") || lower.contains("example.com")) {
            return false;
        }
        String pwd = appPassword.replace(" ", "");
        return !pwd.equalsIgnoreCase("REPLACE_WITH_NEW_APP_PASSWORD")
                && !pwd.equalsIgnoreCase("your-app-password")
                && pwd.length() >= 16;
    }

    /**
     * Gửi email HTML UTF-8 qua SMTP thật.
     *
     * @return true chỉ khi SMTP gửi thành công; false nếu thiếu cấu hình hoặc gửi lỗi
     */
    public static boolean sendEmail(String recipientEmail, String subject, String content) {
        String senderEmail = cfg("mail.sender.email", "");
        String senderName = cfg("mail.sender.name", "TPMS System");
        String appPassword = cfg("mail.sender.app-password", "").replace(" ", "");

        if (!isConfigured(senderEmail, appPassword)) {
            System.err.println("[SMTP] Chưa cấu hình mail.sender.email / mail.sender.app-password trong mail.properties");
            System.err.println("[SMTP] Tạo Gmail App Password rồi điền vào mail.properties (không dùng mock).");
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", cfg("mail.smtp.auth", "true"));
        props.put("mail.smtp.starttls.enable", cfg("mail.smtp.starttls.enable", "true"));
        props.put("mail.smtp.host", cfg("mail.smtp.host", "smtp.gmail.com"));
        props.put("mail.smtp.port", cfg("mail.smtp.port", "587"));
        props.put("mail.smtp.ssl.protocols", cfg("mail.smtp.ssl.protocols", "TLSv1.2"));

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, appPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail, senderName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setContent(content, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("[SMTP EMAIL] Đã gửi mail thật thành công tới: " + recipientEmail);
            return true;
        } catch (Exception e) {
            System.err.println("[SMTP EMAIL] Gửi mail tới " + recipientEmail + " thất bại: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
