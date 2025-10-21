import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProposalDAO {

    public static List<TalkProposal> getAllProposals() {
        List<TalkProposal> proposals = new ArrayList<>();
        String query = "SELECT id, speaker_name, talk_title, abstract, duration, category, experience_level, email, status FROM talk_proposals";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                TalkProposal proposal = new TalkProposal(
                        rs.getInt("id"),
                        rs.getString("speaker_name"),
                        rs.getString("talk_title"),
                        rs.getString("abstract"),
                        rs.getString("duration"),
                        rs.getString("category"),
                        rs.getString("experience_level"),
                        rs.getString("email"),
                        rs.getString("status")
                );
                proposals.add(proposal);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching proposals: " + e.getMessage());
            e.printStackTrace();
        }

        return proposals;
    }

    public static boolean updateProposalStatus(int proposalId, String newStatus) {
        String query = "UPDATE talk_proposals SET status = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, newStatus);
            pstmt.setInt(2, proposalId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating proposal status: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public static TalkProposal getProposalById(int proposalId) {
        String query = "SELECT id, speaker_name, talk_title, abstract, duration, category, experience_level, email, status FROM talk_proposals WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, proposalId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new TalkProposal(
                            rs.getInt("id"),
                            rs.getString("speaker_name"),
                            rs.getString("talk_title"),
                            rs.getString("abstract"),
                            rs.getString("duration"),
                            rs.getString("category"),
                            rs.getString("experience_level"),
                            rs.getString("email"),
                            rs.getString("status")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching proposal: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public static boolean insertProposal(TalkProposal proposal) {
        String query = "INSERT INTO talk_proposals (speaker_name, talk_title, abstract, duration, category, experience_level, email, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, proposal.getSpeakerName());
            pstmt.setString(2, proposal.getTalkTitle());
            pstmt.setString(3, proposal.getAbstractText());
            pstmt.setString(4, proposal.getDuration());
            pstmt.setString(5, proposal.getCategory());
            pstmt.setString(6, proposal.getExperienceLevel());
            pstmt.setString(7, proposal.getEmail());
            pstmt.setString(8, proposal.getStatus());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error inserting proposal: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}
