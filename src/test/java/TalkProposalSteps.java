import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import cucumber.api.java.en.Then;
import java.util.Map;
import java.util.List;

public class TalkProposalSteps {
    private TalkProposal currentProposal;
    private List<TalkProposal> proposalsList;
    private boolean operationSuccess;
    private String lastError;

    @Given("I have a database connection")
    public void iHaveADatabaseConnection() {
        try {
            DatabaseConnection.getConnection();
            operationSuccess = true;
        } catch (Exception e) {
            operationSuccess = false;
            lastError = e.getMessage();
        }
    }

    @When("I create a proposal with the following data:")
    public void iCreateAProposalWithData() {
        // For now, we'll create a simple proposal
        // In a real scenario, you'd use DataTable
        try {
            currentProposal = new TalkProposal(
                0,
                "John Doe",
                "Sample Talk",
                "This is a sample abstract",
                "45 minutes",
                "Frontend",
                "Intermediate",
                "john@example.com",
                "pending"
            );
            operationSuccess = ProposalDAO.insertProposal(currentProposal);
        } catch (Exception e) {
            operationSuccess = false;
            lastError = e.getMessage();
        }
    }

    @Then("the proposal should be saved successfully to the database")
    public void theProposalShouldBeSavedSuccessfully() {
        assert operationSuccess : "The proposal was not saved correctly: " + lastError;
        assert currentProposal != null : "The proposal was not created";
    }

    @Given("a proposal exists with ID {int}")
    public void aProposalExistsWithId(int id) {
        currentProposal = ProposalDAO.getProposalById(id);
        assert currentProposal != null : "No proposal exists with ID " + id;
    }

    @When("I retrieve the proposal with ID {int}")
    public void iRetrieveTheProposalWithId(int id) {
        try {
            currentProposal = ProposalDAO.getProposalById(id);
            operationSuccess = currentProposal != null;
        } catch (Exception e) {
            operationSuccess = false;
            lastError = e.getMessage();
        }
    }

    @Then("I should get a valid proposal")
    public void iShouldGetAValidProposal() {
        assert operationSuccess : "Could not retrieve the proposal: " + lastError;
        assert currentProposal != null : "The proposal is null";
    }

    @Then("the proposal should have speaker name {string}")
    public void theProposalShouldHaveSpeakerName(String speakerName) {
        assert currentProposal.getSpeakerName().equals(speakerName) 
            : "Speaker name does not match. Expected: " + speakerName + 
              ", Got: " + currentProposal.getSpeakerName();
    }

    @Given("proposals exist in the database")
    public void proposalsExistInTheDatabase() {
        proposalsList = ProposalDAO.getAllProposals();
        assert proposalsList != null : "Could not retrieve the list of proposals";
    }

    @When("I get all proposals")
    public void iGetAllProposals() {
        try {
            proposalsList = ProposalDAO.getAllProposals();
            operationSuccess = proposalsList != null;
        } catch (Exception e) {
            operationSuccess = false;
            lastError = e.getMessage();
        }
    }

    @Then("I should receive a list of proposals")
    public void iShouldReceiveAListOfProposals() {
        assert operationSuccess : "Could not retrieve the list: " + lastError;
        assert proposalsList != null : "The proposals list is null";
    }

    @Then("the list should not be empty")
    public void theListShouldNotBeEmpty() {
        assert !proposalsList.isEmpty() : "The proposals list is empty";
    }

    @Then("the proposal should have all required fields")
    public void theProposalShouldHaveAllRequiredFields() {
        assert currentProposal.getSpeakerName() != null && !currentProposal.getSpeakerName().isEmpty() 
            : "Speaker name is empty";
        assert currentProposal.getTalkTitle() != null && !currentProposal.getTalkTitle().isEmpty() 
            : "Talk title is empty";
        assert currentProposal.getEmail() != null && !currentProposal.getEmail().isEmpty() 
            : "Email is empty";
        assert currentProposal.getCategory() != null && !currentProposal.getCategory().isEmpty() 
            : "Category is empty";
        assert currentProposal.getExperienceLevel() != null && !currentProposal.getExperienceLevel().isEmpty() 
            : "Experience level is empty";
    }
}
