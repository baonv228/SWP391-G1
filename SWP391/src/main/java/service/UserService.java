package service;

import dao.PasswordResetTokenDao;
import dao.UserDao;
import java.sql.Timestamp;
import java.util.UUID;
import model.PasswordResetToken;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Tang xu ly logic cho module User Authentication (in charge: Linhnn).
 * Controller goi service, service goi DAO. (Theo SDS muc 1.2)
 */
public class UserService {

    // Thoi gian song cua token reset mat khau: 30 phut
    private static final long RESET_TOKEN_TTL_MS = 30L * 60L * 1000L;

    private final UserDao userDao = new UserDao();
    private final PasswordResetTokenDao tokenDao = new PasswordResetTokenDao();

    // ----- Login -----
    public User authenticate(String email, String rawPassword) {
        return userDao.loginByEmailPassword(email, rawPassword);
    }

    // ----- Login with Google -----
    // Tim user theo email Google tra ve. Neu chua co thi tu tao tai khoan Student.
    public User loginWithGoogle(String email, String fullName) {
        User user = userDao.findByEmail(email);
        if (user != null) {
            if (user.getStatus() == null || !user.getStatus().equalsIgnoreCase("Active")) {
                return null;
            }
            return user;
        }
        // Tai khoan dang nhap bang Google chua ton tai -> tao moi voi mat khau ngau nhien
        String randomPassword = UUID.randomUUID().toString();
        String safeName = (fullName == null || fullName.isBlank())
                ? email.substring(0, email.indexOf("@")) : fullName;
        boolean ok = userDao.register(safeName, email, null, randomPassword, "Student");
        return ok ? userDao.findByEmail(email) : null;
    }

    // ----- Register -----
    public ServiceResult register(String fullName, String email, String phone, String rawPassword) {
        if (userDao.existsEmail(email)) {
            return ServiceResult.fail("Gmail da ton tai. Vui long dung Gmail khac.");
        }
        boolean ok = userDao.register(fullName, email, phone, rawPassword, "Student");
        if (!ok) {
            return ServiceResult.fail("Dang ky that bai. Kiem tra database da co role Student chua.");
        }
        return ServiceResult.ok("Dang ky thanh cong.");
    }

    // ----- Profile -----
    public User getById(int userId) {
        return userDao.findById(userId);
    }

    public ServiceResult updateProfile(int userId, String fullName, String phone) {
        boolean ok = userDao.updateProfile(userId, fullName, phone);
        return ok ? ServiceResult.ok("Cap nhat ho so thanh cong.")
                  : ServiceResult.fail("Cap nhat ho so that bai.");
    }

    // ----- Change Password -----
    public ServiceResult changePassword(int userId, String oldPassword, String newPassword) {
        User user = userDao.findById(userId);
        if (user == null) {
            return ServiceResult.fail("Khong tim thay tai khoan.");
        }
        if (!BCrypt.checkpw(oldPassword, user.getPasswordHash())) {
            return ServiceResult.fail("Mat khau hien tai khong dung.");
        }
        if (BCrypt.checkpw(newPassword, user.getPasswordHash())) {
            return ServiceResult.fail("Mat khau moi phai khac mat khau cu.");
        }
        boolean ok = userDao.updatePassword(userId, newPassword);
        return ok ? ServiceResult.ok("Doi mat khau thanh cong.")
                  : ServiceResult.fail("Doi mat khau that bai.");
    }

    // ----- Password Reset -----
    // Tao token reset cho email. Tra ve token neu email ton tai, nguoc lai tra ve null.
    public String createResetToken(String email) {
        User user = userDao.findByEmail(email);
        if (user == null) {
            return null;
        }
        String token = UUID.randomUUID().toString().replace("-", "");
        Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + RESET_TOKEN_TTL_MS);
        boolean ok = tokenDao.create(user.getUserId(), token, expiresAt);
        return ok ? token : null;
    }

    public boolean isResetTokenValid(String token) {
        return tokenDao.findValidToken(token) != null;
    }

    public ServiceResult resetPassword(String token, String newPassword) {
        PasswordResetToken prt = tokenDao.findValidToken(token);
        if (prt == null) {
            return ServiceResult.fail("Lien ket dat lai mat khau khong hop le hoac da het han.");
        }
        boolean ok = userDao.updatePassword(prt.getUserId(), newPassword);
        if (!ok) {
            return ServiceResult.fail("Dat lai mat khau that bai.");
        }
        tokenDao.markUsed(prt.getTokenId());
        return ServiceResult.ok("Dat lai mat khau thanh cong. Vui long dang nhap.");
    }
}
