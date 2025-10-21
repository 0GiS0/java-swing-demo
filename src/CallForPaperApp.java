import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;

public class CallForPaperApp {
    private static Controller controller;

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            controller = new Controller();
            controller.openMainWindow();
        });
    }
}

class Controller {
    private MainWindow mainWindow;

    public void openMainWindow() {
        mainWindow = new MainWindow(this);
        mainWindow.setVisible(true);
    }

    public void openCallForPaperForm() {
        CallForPaperWindow callForPaperWindow = new CallForPaperWindow(this);
        callForPaperWindow.setVisible(true);
    }

    public void openSecondaryWindow() {
        SecondaryWindow secondaryWindow = new SecondaryWindow(this);
        secondaryWindow.setVisible(true);
    }
}

class MainWindow extends JFrame {
    public MainWindow(Controller controller) {
        setTitle("☕ Main Window - Java Swing");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(500, 300);
        setLocationRelativeTo(null);

        JPanel panel = new JPanel();
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
        panel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));

        JLabel label = new JLabel("Welcome to Swing! 🎉");
        label.setFont(new Font("SansSerif", Font.BOLD, 24));
        label.setAlignmentX(Component.CENTER_ALIGNMENT);

        JButton callForPaperButton = new JButton("Create Talk Proposal 📝");
        callForPaperButton.setAlignmentX(Component.CENTER_ALIGNMENT);
        callForPaperButton.addActionListener(e -> controller.openCallForPaperForm());

        JButton talkListButton = new JButton("Talk List 📋");
        talkListButton.setAlignmentX(Component.CENTER_ALIGNMENT);
        talkListButton.addActionListener(e -> controller.openSecondaryWindow());

        panel.add(Box.createVerticalGlue());
        panel.add(label);
        panel.add(Box.createVerticalStrut(20));
        panel.add(callForPaperButton);
        panel.add(Box.createVerticalStrut(10));
        panel.add(talkListButton);
        panel.add(Box.createVerticalGlue());

        add(panel);
    }
}

class SecondaryWindow extends JFrame {
    private DefaultTableModel tableModel;
    private JTable table;

    public SecondaryWindow(Controller controller) {
        setTitle("📋 Talk Proposals Management");
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setSize(900, 650);
        setLocationRelativeTo(null);

        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new BorderLayout());
        mainPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Title
        JLabel titleLabel = new JLabel("📝 Review and Approve Talk Proposals");
        titleLabel.setFont(new Font("SansSerif", Font.BOLD, 20));
        titleLabel.setHorizontalAlignment(SwingConstants.CENTER);
        mainPanel.add(titleLabel, BorderLayout.NORTH);

        // Table with proposals
        String[] columnNames = {"ID", "Speaker", "Talk Title", "Duration", "Category", "Level", "Email", "Status"};
        
        tableModel = new DefaultTableModel(columnNames, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        // Load data from database
        loadProposalsFromDatabase();

        table = new JTable(tableModel);
        table.setFont(new Font("SansSerif", Font.PLAIN, 11));
        table.setRowHeight(25);
        table.getTableHeader().setFont(new Font("SansSerif", Font.BOLD, 12));
        table.getTableHeader().setBackground(new Color(70, 130, 180));
        table.getTableHeader().setForeground(Color.WHITE);
        table.setSelectionBackground(new Color(100, 150, 200));
        table.setGridColor(new Color(200, 200, 200));

        // Set column widths
        table.getColumnModel().getColumn(0).setPreferredWidth(40);
        table.getColumnModel().getColumn(7).setPreferredWidth(80);

        JScrollPane scrollPane = new JScrollPane(table);
        mainPanel.add(scrollPane, BorderLayout.CENTER);

        // Bottom panel with buttons
        JPanel buttonPanel = new JPanel();
        buttonPanel.setLayout(new BoxLayout(buttonPanel, BoxLayout.X_AXIS));
        buttonPanel.setBorder(BorderFactory.createEmptyBorder(10, 0, 0, 0));

        JLabel infoLabel = new JLabel("Total proposals: " + tableModel.getRowCount());
        infoLabel.setFont(new Font("SansSerif", Font.PLAIN, 12));

        JButton approveButton = new JButton("Approve ✓");
        approveButton.setBackground(new Color(76, 175, 80));
        approveButton.setForeground(Color.WHITE);
        approveButton.setOpaque(true);
        approveButton.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow != -1) {
                int proposalId = (int) table.getValueAt(selectedRow, 0);
                String speaker = (String) table.getValueAt(selectedRow, 1);
                String title = (String) table.getValueAt(selectedRow, 2);
                
                if (ProposalDAO.updateProposalStatus(proposalId, "approved")) {
                    tableModel.setValueAt("approved", selectedRow, 7);
                    table.repaint();
                    JOptionPane.showMessageDialog(this, 
                        "Approved!\n\nSpeaker: " + speaker + "\nTalk: " + title, 
                        "Proposal Approved", 
                        JOptionPane.INFORMATION_MESSAGE);
                } else {
                    JOptionPane.showMessageDialog(this, "Error updating database", "Error", JOptionPane.ERROR_MESSAGE);
                }
            } else {
                JOptionPane.showMessageDialog(this, "Please select a proposal first", "No Selection", JOptionPane.WARNING_MESSAGE);
            }
        });

        JButton rejectButton = new JButton("Reject ✕");
        rejectButton.setBackground(new Color(244, 67, 54));
        rejectButton.setForeground(Color.WHITE);
        rejectButton.setOpaque(true);
        rejectButton.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow != -1) {
                int proposalId = (int) table.getValueAt(selectedRow, 0);
                String speaker = (String) table.getValueAt(selectedRow, 1);
                String title = (String) table.getValueAt(selectedRow, 2);
                
                if (ProposalDAO.updateProposalStatus(proposalId, "rejected")) {
                    tableModel.setValueAt("rejected", selectedRow, 7);
                    table.repaint();
                    JOptionPane.showMessageDialog(this, 
                        "Rejected!\n\nSpeaker: " + speaker + "\nTalk: " + title, 
                        "Proposal Rejected", 
                        JOptionPane.INFORMATION_MESSAGE);
                } else {
                    JOptionPane.showMessageDialog(this, "Error updating database", "Error", JOptionPane.ERROR_MESSAGE);
                }
            } else {
                JOptionPane.showMessageDialog(this, "Please select a proposal first", "No Selection", JOptionPane.WARNING_MESSAGE);
            }
        });

        JButton detailsButton = new JButton("View Details 👁️");
        detailsButton.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow != -1) {
                int proposalId = (int) table.getValueAt(selectedRow, 0);
                TalkProposal proposal = ProposalDAO.getProposalById(proposalId);
                
                if (proposal != null) {
                    JOptionPane.showMessageDialog(this, 
                        "Speaker: " + proposal.getSpeakerName() + "\n" +
                        "Email: " + proposal.getEmail() + "\n" +
                        "Talk: " + proposal.getTalkTitle() + "\n" +
                        "Duration: " + proposal.getDuration() + "\n" +
                        "Category: " + proposal.getCategory() + "\n" +
                        "Level: " + proposal.getExperienceLevel() + "\n" +
                        "Status: " + proposal.getStatus() + "\n\n" +
                        "Abstract:\n" + proposal.getAbstractText(), 
                        "Proposal Details", 
                        JOptionPane.INFORMATION_MESSAGE);
                }
            } else {
                JOptionPane.showMessageDialog(this, "Please select a proposal first", "No Selection", JOptionPane.WARNING_MESSAGE);
            }
        });

        JButton refreshButton = new JButton("Refresh 🔄");
        refreshButton.addActionListener(e -> {
            tableModel.setRowCount(0);
            loadProposalsFromDatabase();
            infoLabel.setText("Total proposals: " + tableModel.getRowCount());
        });

        JButton closeButton = new JButton("Close ✕");
        closeButton.addActionListener(e -> dispose());

        buttonPanel.add(infoLabel);
        buttonPanel.add(Box.createHorizontalGlue());
        buttonPanel.add(refreshButton);
        buttonPanel.add(Box.createHorizontalStrut(8));
        buttonPanel.add(detailsButton);
        buttonPanel.add(Box.createHorizontalStrut(8));
        buttonPanel.add(approveButton);
        buttonPanel.add(Box.createHorizontalStrut(8));
        buttonPanel.add(rejectButton);
        buttonPanel.add(Box.createHorizontalStrut(8));
        buttonPanel.add(closeButton);

        mainPanel.add(buttonPanel, BorderLayout.SOUTH);

        add(mainPanel);
    }

    private void loadProposalsFromDatabase() {
        java.util.List<TalkProposal> proposals = ProposalDAO.getAllProposals();
        
        for (TalkProposal proposal : proposals) {
            Object[] row = {
                proposal.getId(),
                proposal.getSpeakerName(),
                proposal.getTalkTitle(),
                proposal.getDuration(),
                proposal.getCategory(),
                proposal.getExperienceLevel(),
                proposal.getEmail(),
                proposal.getStatus()
            };
            tableModel.addRow(row);
        }
        
        if (proposals.isEmpty()) {
            JOptionPane.showMessageDialog(this, 
                "No proposals found in database.\nMake sure MySQL is running and the database is initialized.", 
                "Database Connection Info", 
                JOptionPane.WARNING_MESSAGE);
        }
    }
}

class CallForPaperWindow extends JFrame {
    public CallForPaperWindow(Controller controller) {
        setTitle("📝 Call for Paper - Talk Proposal Form");
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setSize(600, 700);
        setLocationRelativeTo(null);

        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new BoxLayout(mainPanel, BoxLayout.Y_AXIS));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(15, 15, 15, 15));
        mainPanel.setBackground(new Color(245, 245, 245));

        // Title
        JLabel titleLabel = new JLabel("Submit Your Talk Proposal 🎤");
        titleLabel.setFont(new Font("SansSerif", Font.BOLD, 20));
        titleLabel.setAlignmentX(Component.CENTER_ALIGNMENT);

        mainPanel.add(titleLabel);
        mainPanel.add(Box.createVerticalStrut(15));

        // Scroll pane for form fields
        JPanel formPanel = new JPanel();
        formPanel.setLayout(new BoxLayout(formPanel, BoxLayout.Y_AXIS));
        formPanel.setOpaque(false);

        // Speaker Name
        formPanel.add(createLabeledField("Speaker Name:"));
        formPanel.add(Box.createVerticalStrut(8));

        // Talk Title
        formPanel.add(createLabeledField("Talk Title:"));
        formPanel.add(Box.createVerticalStrut(8));

        // Abstract
        JLabel abstractLabel = new JLabel("Abstract:");
        abstractLabel.setFont(new Font("SansSerif", Font.PLAIN, 12));
        abstractLabel.setAlignmentX(Component.LEFT_ALIGNMENT);
        formPanel.add(abstractLabel);
        JTextArea abstractArea = new JTextArea(5, 40);
        abstractArea.setLineWrap(true);
        abstractArea.setWrapStyleWord(true);
        abstractArea.setFont(new Font("SansSerif", Font.PLAIN, 12));
        JScrollPane abstractScroll = new JScrollPane(abstractArea);
        abstractScroll.setMaximumSize(new Dimension(500, 120));
        abstractScroll.setAlignmentX(Component.LEFT_ALIGNMENT);
        formPanel.add(abstractScroll);
        formPanel.add(Box.createVerticalStrut(8));

        // Talk Duration
        formPanel.add(createComboField("Talk Duration:", new String[]{"15 minutes", "30 minutes", "45 minutes", "60 minutes"}));
        formPanel.add(Box.createVerticalStrut(8));

        // Track/Category
        formPanel.add(createComboField("Track/Category:", new String[]{"Backend", "Frontend", "DevOps", "AI/ML", "Mobile", "Other"}));
        formPanel.add(Box.createVerticalStrut(8));

        // Experience Level
        formPanel.add(createComboField("Experience Level:", new String[]{"Beginner", "Intermediate", "Advanced"}));
        formPanel.add(Box.createVerticalStrut(8));

        // Contact Email
        formPanel.add(createLabeledField("Contact Email:"));
        formPanel.add(Box.createVerticalStrut(8));

        // Additional Notes
        JLabel notesLabel = new JLabel("Additional Notes:");
        notesLabel.setFont(new Font("SansSerif", Font.PLAIN, 12));
        notesLabel.setAlignmentX(Component.LEFT_ALIGNMENT);
        formPanel.add(notesLabel);
        JTextArea notesArea = new JTextArea(3, 40);
        notesArea.setLineWrap(true);
        notesArea.setWrapStyleWord(true);
        notesArea.setFont(new Font("SansSerif", Font.PLAIN, 12));
        JScrollPane notesScroll = new JScrollPane(notesArea);
        notesScroll.setMaximumSize(new Dimension(500, 80));
        notesScroll.setAlignmentX(Component.LEFT_ALIGNMENT);
        formPanel.add(notesScroll);

        // Checkbox for terms
        formPanel.add(Box.createVerticalStrut(10));
        JCheckBox termsCheckBox = new JCheckBox("I agree to the conference terms and conditions");
        termsCheckBox.setOpaque(false);
        termsCheckBox.setAlignmentX(Component.LEFT_ALIGNMENT);
        formPanel.add(termsCheckBox);

        JScrollPane scrollPane = new JScrollPane(formPanel);
        scrollPane.setOpaque(false);
        scrollPane.getViewport().setOpaque(false);
        mainPanel.add(scrollPane);

        // Buttons Panel
        mainPanel.add(Box.createVerticalStrut(10));
        JPanel buttonsPanel = new JPanel();
        buttonsPanel.setLayout(new BoxLayout(buttonsPanel, BoxLayout.X_AXIS));
        buttonsPanel.setOpaque(false);
        buttonsPanel.setAlignmentX(Component.CENTER_ALIGNMENT);

        JButton submitButton = new JButton("Submit Proposal ✓");
        submitButton.setFont(new Font("SansSerif", Font.PLAIN, 12));
        submitButton.addActionListener(e -> {
            JOptionPane.showMessageDialog(this, 
                "Thank you! Your talk proposal has been submitted successfully! 🎉", 
                "Success", 
                JOptionPane.INFORMATION_MESSAGE);
        });

        JButton clearButton = new JButton("Clear Form 🔄");
        clearButton.setFont(new Font("SansSerif", Font.PLAIN, 12));
        clearButton.addActionListener(e -> {
            // Clear all fields
            int result = JOptionPane.showConfirmDialog(this, 
                "Are you sure you want to clear all fields?", 
                "Confirm Clear", 
                JOptionPane.YES_NO_OPTION);
            if (result == JOptionPane.YES_OPTION) {
                formPanel.repaint();
            }
        });

        JButton closeButton = new JButton("Close ✕");
        closeButton.setFont(new Font("SansSerif", Font.PLAIN, 12));
        closeButton.addActionListener(e -> dispose());

        buttonsPanel.add(submitButton);
        buttonsPanel.add(Box.createHorizontalStrut(10));
        buttonsPanel.add(clearButton);
        buttonsPanel.add(Box.createHorizontalStrut(10));
        buttonsPanel.add(closeButton);

        mainPanel.add(buttonsPanel);

        add(mainPanel);
    }

    private JPanel createLabeledField(String labelText) {
        JPanel panel = new JPanel();
        panel.setLayout(new BoxLayout(panel, BoxLayout.X_AXIS));
        panel.setOpaque(false);
        panel.setMaximumSize(new Dimension(500, 25));

        JLabel label = new JLabel(labelText);
        label.setFont(new Font("SansSerif", Font.PLAIN, 12));
        label.setPreferredSize(new Dimension(150, 25));

        JTextField textField = new JTextField(30);
        textField.setFont(new Font("SansSerif", Font.PLAIN, 12));

        panel.add(label);
        panel.add(Box.createHorizontalStrut(5));
        panel.add(textField);

        return panel;
    }

    private JPanel createComboField(String labelText, String[] options) {
        JPanel panel = new JPanel();
        panel.setLayout(new BoxLayout(panel, BoxLayout.X_AXIS));
        panel.setOpaque(false);
        panel.setMaximumSize(new Dimension(500, 25));

        JLabel label = new JLabel(labelText);
        label.setFont(new Font("SansSerif", Font.PLAIN, 12));
        label.setPreferredSize(new Dimension(150, 25));

        JComboBox<String> comboBox = new JComboBox<>(options);
        comboBox.setFont(new Font("SansSerif", Font.PLAIN, 12));

        panel.add(label);
        panel.add(Box.createHorizontalStrut(5));
        panel.add(comboBox);

        return panel;
    }
}
