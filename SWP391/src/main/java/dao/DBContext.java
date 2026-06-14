package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    // Cau hinh ket noi SQL Server. Sua lai databaseName/user/password cho dung may cua ban.
    private static final String URL =
            "jdbc:sqlserver://localhost:1433;databaseName=TPMS_DB;encrypt=false";
    private static final String USER = "sa";       // username SQL Server cua ban
    private static final String PASSWORD = "123";   // mat khau SQL Server cua ban

    // Ket noi co so du lieu
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC Driver not found", e);
        }
    }

    // Phuong thuc test ket noi
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("Ket noi SQL Server thanh cong!");
                System.out.println("Trang thai: " + (conn.isClosed() ? "Da dong" : "Dang mo"));
            }
        } catch (Exception e) {
            System.err.println("Loi khi ket noi co so du lieu: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
