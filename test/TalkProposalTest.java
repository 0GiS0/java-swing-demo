import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class TalkProposalTest {

    private TalkProposal proposal;

    @Before
    public void setUp() {
        proposal = new TalkProposal(
                1,
                "John Doe",
                "Introduction to Java",
                "Learn the basics of Java programming",
                "60 minutes",
                "Backend",
                "Beginner",
                "john@example.com",
                "pending"
        );
    }

    @Test
    public void testProposalCreation() {
        assertNotNull("Proposal should not be null", proposal);
        assertEquals("ID should be 1", 1, proposal.getId());
        assertEquals("Speaker name should be John Doe", "John Doe", proposal.getSpeakerName());
    }

    @Test
    public void testProposalGettersSetters() {
        proposal.setId(2);
        proposal.setSpeakerName("Jane Smith");
        proposal.setTalkTitle("Advanced Java");
        proposal.setAbstractText("Advanced Java concepts");
        proposal.setDuration("45 minutes");
        proposal.setCategory("Backend");
        proposal.setExperienceLevel("Advanced");
        proposal.setEmail("jane@example.com");
        proposal.setStatus("approved");

        assertEquals("ID should be 2", 2, proposal.getId());
        assertEquals("Speaker name should be Jane Smith", "Jane Smith", proposal.getSpeakerName());
        assertEquals("Talk title should be Advanced Java", "Advanced Java", proposal.getTalkTitle());
        assertEquals("Abstract should match", "Advanced Java concepts", proposal.getAbstractText());
        assertEquals("Duration should be 45 minutes", "45 minutes", proposal.getDuration());
        assertEquals("Category should be Backend", "Backend", proposal.getCategory());
        assertEquals("Experience level should be Advanced", "Advanced", proposal.getExperienceLevel());
        assertEquals("Email should be jane@example.com", "jane@example.com", proposal.getEmail());
        assertEquals("Status should be approved", "approved", proposal.getStatus());
    }

    @Test
    public void testProposalStatus() {
        proposal.setStatus("approved");
        assertEquals("Status should be approved", "approved", proposal.getStatus());

        proposal.setStatus("rejected");
        assertEquals("Status should be rejected", "rejected", proposal.getStatus());

        proposal.setStatus("pending");
        assertEquals("Status should be pending", "pending", proposal.getStatus());
    }

    @Test
    public void testProposalToString() {
        String str = proposal.toString();
        assertNotNull("toString should not be null", str);
        assertTrue("toString should contain ID", str.contains("id=1"));
        assertTrue("toString should contain speaker name", str.contains("John Doe"));
        assertTrue("toString should contain status", str.contains("pending"));
    }

    @Test
    public void testProposalWithNullValues() {
        TalkProposal emptyProposal = new TalkProposal(
                0,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null
        );

        assertEquals("ID should be 0", 0, emptyProposal.getId());
        assertNull("Speaker name should be null", emptyProposal.getSpeakerName());
        assertNull("Talk title should be null", emptyProposal.getTalkTitle());
        assertNull("Status should be null", emptyProposal.getStatus());
    }

    @Test
    public void testProposalCategoryValues() {
        String[] validCategories = {"Backend", "Frontend", "DevOps", "AI/ML", "Mobile", "Other"};
        
        for (String category : validCategories) {
            proposal.setCategory(category);
            assertEquals("Category should be " + category, category, proposal.getCategory());
        }
    }

    @Test
    public void testProposalDurationValues() {
        String[] validDurations = {"15 minutes", "30 minutes", "45 minutes", "60 minutes"};
        
        for (String duration : validDurations) {
            proposal.setDuration(duration);
            assertEquals("Duration should be " + duration, duration, proposal.getDuration());
        }
    }

    @Test
    public void testProposalExperienceLevelValues() {
        String[] validLevels = {"Beginner", "Intermediate", "Advanced"};
        
        for (String level : validLevels) {
            proposal.setExperienceLevel(level);
            assertEquals("Level should be " + level, level, proposal.getExperienceLevel());
        }
    }
}
