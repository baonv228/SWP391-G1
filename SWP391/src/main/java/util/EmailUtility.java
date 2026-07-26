package util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

/**
 * Tiện ích hỗ trợ gửi email sử dụng Jakarta Mail API.
 * Hỗ trợ chế độ Mock Console Fallback khi chạy local/dev nếu chưa cấu hình tài khoản thực tế.
 */
public class EmailUtility {

    // Cấu hình SMTP
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587"; // Cổng TLS cho Gmail
    
    // ĐIỀN THÔNG TIN EMAIL CỦA BẠN TẠI ĐÂY ĐỂ GỬI MAIL THẬT
    private static final String SENDER_EMAIL = "nguyenngoclinh07032003@gmail.com"; 
    private static final String SENDER_APP_PASSWORD = "lzfc uemg wrfg cpvt"; // Mật khẩu ứng dụng Gmail (App Password)

    /**
     * Gửi email dạng HTML UTF-8.
     *
     * @param recipientEmail Địa chỉ email người nhận
     * @param subject        Tiêu đề email
     * @param content        Nội dung email (hỗ trợ mã HTML)
     * @return true nếu gửi thành công (hoặc in ra console thành công ở chế độ Dev)
     */
    public static boolean sendEmail(String recipientEmail, String subject, String content) {
        // Kiểm tra xem đã cấu hình email thật hay chưa.
        // Nếu vẫn dùng giá trị mặc định, hệ thống sẽ chạy chế độ Mock và in ra console.
        if (SENDER_EMAIL.equals("your-email@gmail.com") 
                || SENDER_APP_PASSWORD.equals("your-app-password") 
                || SENDER_APP_PASSWORD.isBlank()) {
            
            System.out.println("==========================================================================");
            System.out.println("[DEV MOCK EMAIL] Gửi mail tới: " + recipientEmail);
            System.out.println("[DEV MOCK EMAIL] Tiêu đề: " + subject);
            System.out.println("[DEV MOCK EMAIL] Nội dung: \n" + content);
            System.out.println("==========================================================================");
            return true;
        }

        // Cấu hình các thuộc tính kết nối SMTP
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // Khởi tạo Mail Session
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            // Thiết lập thông tin người gửi
            message.setFrom(new InternetAddress(SENDER_EMAIL, "TPMS System"));
            // Thiết lập thông tin người nhận
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            // Thiết lập tiêu đề
            message.setSubject(subject);
            // Thiết lập nội dung dạng HTML UTF-8
            message.setContent(content, "text/html; charset=UTF-8");

            // Tiến hành gửi email
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
