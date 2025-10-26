import cucumber.api.java.en.When;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.Given;
import java.sql.Connection;

public class DatabaseConnectionSteps {
    private Connection connection;
    private boolean connectionSuccess;
    private String lastError;

    @When("I establish a connection to the database")
    public void iEstablishAConnectionToTheDatabase() {
        try {
            connection = DatabaseConnection.getConnection();
            connectionSuccess = connection != null && !connection.isClosed();
        } catch (Exception e) {
            connectionSuccess = false;
            lastError = e.getMessage();
        }
    }

    @Then("the connection should be successful")
    public void theConnectionShouldBeSuccessful() {
        assert connectionSuccess : "The connection failed: " + lastError;
    }

    @Then("the connection should be active")
    public void theConnectionShouldBeActive() {
        try {
            assert connection != null : "The connection is null";
            assert !connection.isClosed() : "The connection is closed";
        } catch (Exception e) {
            throw new AssertionError("Error verifying the connection: " + e.getMessage());
        }
    }

    @Given("I have an active connection to the database")
    public void iHaveAnActiveConnectionToTheDatabase() {
        try {
            connection = DatabaseConnection.getConnection();
            assert connection != null && !connection.isClosed() 
                : "Could not establish an active connection";
        } catch (Exception e) {
            throw new AssertionError("Error establishing connection: " + e.getMessage());
        }
    }

    @When("I close the connection")
    public void iCloseTheConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                connectionSuccess = connection.isClosed();
            }
        } catch (Exception e) {
            connectionSuccess = false;
            lastError = e.getMessage();
        }
    }

    @Then("the connection should close correctly")
    public void theConnectionShouldCloseCorrectly() {
        try {
            assert connectionSuccess : "Could not close the connection: " + lastError;
            assert connection.isClosed() : "The connection is still open";
        } catch (Exception e) {
            throw new AssertionError("Error verifying the connection closure: " + e.getMessage());
        }
    }
}
