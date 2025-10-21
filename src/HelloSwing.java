import javax.swing.*;
import java.awt.*;

public class HelloSwing {
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

        JButton secondaryButton = new JButton("Open another window 🪟");
        secondaryButton.setAlignmentX(Component.CENTER_ALIGNMENT);
        secondaryButton.addActionListener(e -> controller.openSecondaryWindow());

        panel.add(Box.createVerticalGlue());
        panel.add(label);
        panel.add(Box.createVerticalStrut(20));
        panel.add(callForPaperButton);
        panel.add(Box.createVerticalStrut(10));
        panel.add(secondaryButton);
        panel.add(Box.createVerticalGlue());

        add(panel);
    }
}

class SecondaryWindow extends JFrame {
    public SecondaryWindow(Controller controller) {
        setTitle("🪟 Secondary Window");
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setSize(400, 200);
        setLocationRelativeTo(null);

        JPanel panel = new JPanel();
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
        panel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        panel.setBackground(new Color(230, 240, 250));

        JLabel label = new JLabel("This is a secondary window 👋🏻");
        label.setFont(new Font("SansSerif", Font.BOLD, 18));
        label.setAlignmentX(Component.CENTER_ALIGNMENT);

        JButton button = new JButton("Open another one 🪟");
        button.setAlignmentX(Component.CENTER_ALIGNMENT);
        button.addActionListener(e -> controller.openSecondaryWindow());

        panel.add(Box.createVerticalGlue());
        panel.add(label);
        panel.add(Box.createVerticalStrut(15));
        panel.add(button);
        panel.add(Box.createVerticalGlue());

        add(panel);
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
