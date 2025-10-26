import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import cucumber.api.java.en.Then;

public class ProposalApprovalSteps {
    private TalkProposal currentProposal;
    private boolean operationSuccess;
    private String lastError;

    @Given("a proposal exists with ID {int} in status {string}")
    public void aProposalExistsWithIdInStatus(int id, String status) {
        try {
            currentProposal = ProposalDAO.getProposalById(id);
            assert currentProposal != null : "No proposal exists with ID " + id;
            assert currentProposal.getStatus().equals(status) 
                : "The proposal is not in status " + status + ", it is in " + currentProposal.getStatus();
        } catch (Exception e) {
            throw new AssertionError("Error retrieving proposal: " + e.getMessage());
        }
    }

    @When("I approve the proposal with ID {int}")
    public void iApproveTheProposalWithId(int id) {
        try {
            operationSuccess = ProposalDAO.updateProposalStatus(id, "approved");
            if (operationSuccess) {
                currentProposal = ProposalDAO.getProposalById(id);
            }
        } catch (Exception e) {
            operationSuccess = false;
            lastError = e.getMessage();
        }
    }

    @Then("the status of the proposal should change to {string}")
    public void theStatusOfTheProposalShouldChangeTo(String expectedStatus) {
        assert operationSuccess : "The operation was not successful: " + lastError;
        assert currentProposal.getStatus().equals(expectedStatus) 
            : "The status did not change to " + expectedStatus + ", it is in " + currentProposal.getStatus();
    }

    @Then("the update should be successful in the database")
    public void theUpdateShouldBeSuccessfulInTheDatabase() {
        assert operationSuccess : "The update failed: " + lastError;
    }

    @When("I reject the proposal with ID {int}")
    public void iRejectTheProposalWithId(int id) {
        try {
            operationSuccess = ProposalDAO.updateProposalStatus(id, "rejected");
            if (operationSuccess) {
                currentProposal = ProposalDAO.getProposalById(id);
            }
        } catch (Exception e) {
            operationSuccess = false;
            lastError = e.getMessage();
        }
    }

    @When("I try to change the status of the proposal with ID {int}")
    public void iTryToChangeTheStatusOfTheProposalWithId(int id) {
        try {
            currentProposal = ProposalDAO.getProposalById(id);
            // Try to change status even if it's already approved
            String currentStatus = currentProposal.getStatus();
            String newStatus = currentStatus.equals("approved") ? "rejected" : "approved";
            operationSuccess = ProposalDAO.updateProposalStatus(id, newStatus);
        } catch (Exception e) {
            operationSuccess = false;
            lastError = e.getMessage();
        }
    }

    @When("I retrieve the status of the proposal with ID {int}")
    public void iRetrieveTheStatusOfTheProposalWithId(int id) {
        try {
            currentProposal = ProposalDAO.getProposalById(id);
            operationSuccess = currentProposal != null;
        } catch (Exception e) {
            operationSuccess = false;
            lastError = e.getMessage();
        }
    }

    @Then("I should receive the current status of the proposal")
    public void iShouldReceiveTheCurrentStatusOfTheProposal() {
        assert operationSuccess : "Could not retrieve the status: " + lastError;
        assert currentProposal != null : "The proposal is null";
        assert currentProposal.getStatus() != null && !currentProposal.getStatus().isEmpty() 
            : "The proposal status is empty";
    }
}
