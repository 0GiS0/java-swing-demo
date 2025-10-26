import org.junit.Test;
import static org.junit.Assert.*;

import java.sql.Connection;
import java.sql.SQLException;

public class DatabaseConnectionTest {

    @Test
    public void testGetConnection() {
        try {
            Connection conn = DatabaseConnection.getConnection();
            assertNotNull("Connection should not be null", conn);
            assertFalse("Connection should not be closed", conn.isClosed());
            conn.close();
        } catch (SQLException e) {
            fail("Should not throw SQLException: " + e.getMessage());
        }
    }

    @Test
    public void testConnectionIsNotClosed() {
        try {
            Connection conn = DatabaseConnection.getConnection();
            assertNotNull("Connection should not be null", conn);
            assertFalse("Connection should be open", conn.isClosed());
            conn.close();
            assertTrue("Connection should be closed after close()", conn.isClosed());
        } catch (SQLException e) {
            fail("Should not throw SQLException: " + e.getMessage());
        }
    }

    @Test
    public void testTestConnection() {
        boolean isConnected = DatabaseConnection.testConnection();
        assertTrue("Should successfully connect to database", isConnected);
    }

    @Test
    public void testMultipleConnections() {
        try {
            Connection conn1 = DatabaseConnection.getConnection();
            Connection conn2 = DatabaseConnection.getConnection();
            
            assertNotNull("First connection should not be null", conn1);
            assertNotNull("Second connection should not be null", conn2);
            assertFalse("First connection should be open", conn1.isClosed());
            assertFalse("Second connection should be open", conn2.isClosed());
            
            conn1.close();
            conn2.close();
        } catch (SQLException e) {
            fail("Should not throw SQLException: " + e.getMessage());
        }
    }
}
