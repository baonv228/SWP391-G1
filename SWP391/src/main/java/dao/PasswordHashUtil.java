package dao;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility to generate BCrypt hash for test accounts.
 * Run: mvn compile exec:java -Dexec.mainClass=dao.PasswordHashUtil
 */
public class PasswordHashUtil {
    public static void main(String[] args) {
        String password = "123456";
        String hash = BCrypt.hashpw(password, BCrypt.gensalt(10));
        System.out.println("Password: " + password);
        System.out.println("BCrypt Hash: " + hash);
    }
}
