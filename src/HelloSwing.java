import javax.swing.*;
import java.awt.*;

public class HelloSwing {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame frame = new JFrame("Hola desde Swing en Dev Container");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

            var label = new JLabel("¡Funciona! 🎉", SwingConstants.CENTER);
            label.setFont(new Font("SansSerif", Font.BOLD, 24));
            frame.add(label);

            frame.setSize(420, 240);
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
        });
    }
}
