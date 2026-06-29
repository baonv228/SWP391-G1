package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {


    // Cau hinh ket noi SQL Server. Sua lai cho dung may cua ban.
    private static final String serverName = "localhost";
    private static final String portNumber = "1433";
    private static final String instance = ""; // Bo trong neu khong dung instance dac biet
    private static final String dbName = "TPMS_DB";
    private static final String userID = "sa";       // username SQL Server cua ban
    private static final String password = "123";   // mat khau SQL Server cua ban

    // Ket noi co so du lieu
    public static Connection getConnection() throws SQLException {
        try {
            String url = "jdbc:sqlserver://" + serverName + ":" + portNumber + "\\" + instance + ";databaseName=" + dbName + ";encrypt=true;trustServerCertificate=true";
            if (instance == null || instance.trim().isEmpty()) {
                url = "jdbc:sqlserver://" + serverName + ":" + portNumber + ";databaseName=" + dbName + ";encrypt=true;trustServerCertificate=true";
            }
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(url, userID, password);
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC Driver not found", e);
        }
    }

    // Phuong thuc test ket noi (Click chuot phai -> Run DBContext.main() trong IntelliJ)
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
