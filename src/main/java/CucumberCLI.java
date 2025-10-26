import cucumber.api.cli.Main;

public class CucumberCLI {
    public static void main(String[] args) {
        String[] options = new String[] {
            "--plugin", "pretty",
            "--plugin", "html:target/cucumber-report.html",
            "src/test/resources/features"
        };
        
        System.out.println("🧪 Running Cucumber BDD Tests...\n");
        
        int exitCode = Main.run(options, Thread.currentThread().getContextClassLoader());
        
        System.out.println("\n✓ Cucumber tests completed!");
        System.exit(exitCode);
    }
}
