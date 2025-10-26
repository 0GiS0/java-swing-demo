import java.sql.*;

public class DatabaseConnection {
    // ============================================
    // 📝 VALORES POR DEFECTO EMBEBIDOS
    // ============================================
    private static final String DEFAULT_HOST = "mysql";
    private static final int DEFAULT_PORT = 3306;
    private static final String DEFAULT_NAME = "callforpaper";
    private static final String DEFAULT_USER = "developer";
    private static final String DEFAULT_PASSWORD = "developer123";
    
    // Lee del entorno si existe, si no usa los valores por defecto
    private static final String DB_HOST = getEnvOrDefault("DB_HOST", DEFAULT_HOST);
    private static final String DB_PORT = getEnvOrDefault("DB_PORT", String.valueOf(DEFAULT_PORT));
    private static final String DB_NAME = getEnvOrDefault("DB_NAME", DEFAULT_NAME);
    private static final String DB_USER = getEnvOrDefault("DB_USER", DEFAULT_USER);
    private static final String DB_PASSWORD = getEnvOrDefault("DB_PASSWORD", DEFAULT_PASSWORD);
    
    // Build URL
    private static final String URL = String.format(
        "jdbc:mysql://%s:%s/%s",
        DB_HOST, DB_PORT, DB_NAME
    );
    private static final String USER = DB_USER;
    private static final String PASSWORD = DB_PASSWORD;

    static {
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Failed to load MySQL JDBC Driver!");
            e.printStackTrace();
        }
    }

    /**
     * Get environment variable or return default value
     */
    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value != null && !value.isEmpty()) {
            System.out.println("✓ Usando variable de entorno: " + key + "=" + value);
            return value;
        }
        System.out.println("✓ Usando valor por defecto para: " + key + "=" + defaultValue);
        return defaultValue;
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Test the connection
    public static boolean testConnection() {
        System.out.println("\n📊 Database Configuration:");
        System.out.println("   URL: " + URL);
        System.out.println("   User: " + USER);
        
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
