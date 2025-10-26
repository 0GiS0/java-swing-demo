import org.junit.Before;
import org.junit.Test;
import org.junit.After;
import static org.junit.Assert.*;

import java.util.List;

public class ProposalDAOTest {

    @Before
    public void setUp() {
        // Setup before each test
    }

    @After
    public void tearDown() {
        // Cleanup after each test
    }

    @Test
    public void testGetAllProposals() {
        List<TalkProposal> proposals = ProposalDAO.getAllProposals();
        assertNotNull("Proposals list should not be null", proposals);
        assertTrue("Proposals list should not be empty", proposals.size() > 0);
    }

    @Test
    public void testGetAllProposalsContainsValidData() {
        List<TalkProposal> proposals = ProposalDAO.getAllProposals();
        
        for (TalkProposal proposal : proposals) {
            assertNotNull("Speaker name should not be null", proposal.getSpeakerName());
            assertNotNull("Talk title should not be null", proposal.getTalkTitle());
            assertNotNull("Email should not be null", proposal.getEmail());
            assertNotNull("Status should not be null", proposal.getStatus());
            assertTrue("ID should be positive", proposal.getId() > 0);
        }
    }

    @Test
    public void testGetProposalById() {
        // First get all proposals to get a valid ID
        List<TalkProposal> allProposals = ProposalDAO.getAllProposals();
        
        if (allProposals.size() > 0) {
            int proposalId = allProposals.get(0).getId();
            TalkProposal proposal = ProposalDAO.getProposalById(proposalId);
            
            assertNotNull("Proposal should not be null", proposal);
            assertEquals("Proposal ID should match", proposalId, proposal.getId());
            assertNotNull("Speaker name should not be null", proposal.getSpeakerName());
        }
    }

    @Test
    public void testGetNonexistentProposal() {
        TalkProposal proposal = ProposalDAO.getProposalById(99999);
        assertNull("Non-existent proposal should return null", proposal);
    }

    @Test
    public void testUpdateProposalStatus() {
        List<TalkProposal> proposals = ProposalDAO.getAllProposals();
        
        if (proposals.size() > 0) {
            int proposalId = proposals.get(0).getId();
            String originalStatus = proposals.get(0).getStatus();
            
            // Update to approved
            boolean result = ProposalDAO.updateProposalStatus(proposalId, "approved");
            assertTrue("Update should return true", result);
            
            // Verify the update
            TalkProposal updated = ProposalDAO.getProposalById(proposalId);
            assertEquals("Status should be updated to approved", "approved", updated.getStatus());
            
            // Restore original status
            ProposalDAO.updateProposalStatus(proposalId, originalStatus);
        }
    }

    @Test
    public void testInsertProposal() {
        TalkProposal newProposal = new TalkProposal(
                0,
                "Test Speaker",
                "Test Talk",
                "This is a test abstract",
                "30 minutes",
                "Backend",
                "Intermediate",
                "test@example.com",
                "pending"
        );
        
        boolean result = ProposalDAO.insertProposal(newProposal);
        assertTrue("Insert should return true", result);
    }

    @Test
    public void testProposalStatusValues() {
        List<TalkProposal> proposals = ProposalDAO.getAllProposals();
        
        for (TalkProposal proposal : proposals) {
            String status = proposal.getStatus();
            assertTrue(
                "Status should be pending, approved, or rejected",
                status.equals("pending") || status.equals("approved") || status.equals("rejected")
            );
        }
    }

    @Test
    public void testProposalDurationValues() {
        List<TalkProposal> proposals = ProposalDAO.getAllProposals();
        
        for (TalkProposal proposal : proposals) {
            String duration = proposal.getDuration();
            assertNotNull("Duration should not be null", duration);
            assertTrue("Duration should not be empty", duration.length() > 0);
        }
    }
}
