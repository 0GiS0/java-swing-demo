import java.sql.*;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://mysql:3306/callforpaper";
    private static final String USER = "developer";
    private static final String PASSWORD = "developer123";

    static {
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Failed to load MySQL JDBC Driver!");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Test the connection
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("✓ Successfully connected to MySQL!");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("✗ Failed to connect to MySQL: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
