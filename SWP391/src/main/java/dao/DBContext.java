package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    // Cau hinh ket noi MySQL. Sua lai user/password cho dung may cua ban.
    private static final String URL =
            "jdbc:mysql://localhost:3306/tpms_db"
            + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh"
            + "&useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root";       // username MySQL cua ban
    private static final String PASSWORD = "123";     // mat khau MySQL cua ban

    // Ket noi co so du lieu
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
    }

    // Phuong thuc test ket noi
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("Ket noi MySQL thanh cong!");
                System.out.println("Trang thai: " + (conn.isClosed() ? "Da dong" : "Dang mo"));
            }
        } catch (Exception e) {
            System.err.println("Loi khi ket noi co so du lieu: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
