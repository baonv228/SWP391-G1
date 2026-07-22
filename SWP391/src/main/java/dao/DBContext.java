package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {


    // Cau hinh ket noi SQL Server. Sua lai cho dung may cua ban.
    private static final String serverName = getConfig("DB_SERVER", "db.server", "localhost");
    private static final String portNumber = getConfig("DB_PORT", "db.port", "1433");
    private static final String instance = getConfig("DB_INSTANCE", "db.instance", ""); // Bo trong neu khong dung instance dac biet
    private static final String dbName = getConfig("DB_NAME", "db.name", "TPMS_DB");
    private static final String userID = getConfig("DB_USER", "db.user", "sa");       // username SQL Server cua ban
    private static final String password = getConfig("DB_PASSWORD", "db.password", "123");   // mat khau SQL Server cua ban

    // Ket noi co so du lieu
    public static Connection getConnection() throws SQLException {
        try {
            String configuredUrl = getConfig("DB_URL", "db.url", "");
            String url = configuredUrl.isEmpty() ? buildJdbcUrl() : configuredUrl;
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

    private static String buildJdbcUrl() {
        StringBuilder url = new StringBuilder("jdbc:sqlserver://").append(serverName);
        if (instance != null && !instance.trim().isEmpty()) {
            url.append("\\").append(instance.trim());
        }
        if (portNumber != null && !portNumber.trim().isEmpty()) {
            url.append(":").append(portNumber.trim());
        }
        url.append(";databaseName=").append(dbName)
                .append(";encrypt=true;trustServerCertificate=true");
        return url.toString();
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
