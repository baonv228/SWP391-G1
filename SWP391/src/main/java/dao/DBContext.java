package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    private static final String url = "jdbc:sqlserver://localhost:1433;databaseName=TPMS_DB;encrypt=false";
    private static final String user = "duy"; // Thay bằng username SQL Server của bạn
    private static final String password = "12345"; // Thay bằng mật khẩu

    // Kết nối cơ sở dữ liệu
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC Driver not found", e);
        }
    }

    // Phương thức test kết nối
    public static void main(String[] args) {
        DBContext dbContext = new DBContext();
        try {
            Connection conn = dbContext.getConnection();
            if (conn != null) {
                System.out.println("Kết nối cơ sở dữ liệu thành công!");
                System.out.println("Trạng thái kết nối: " + (conn.isClosed() ? "Đã đóng" : "Đang mở"));
                conn.close();
                System.out.println("Kết nối đã được đóng.");
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi kết nối cơ sở dữ liệu: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
