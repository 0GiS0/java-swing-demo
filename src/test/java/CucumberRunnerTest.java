import org.junit.runner.RunWith;
import cucumber.api.junit.Cucumber;
import cucumber.api.CucumberOptions;

@RunWith(Cucumber.class)
@CucumberOptions(
    features = "src/test/resources/features",
    glue = {""},
    monochrome = false,
    plugin = {"pretty", "json:target/cucumber-json-reports/cucumber.json"}
)
public class CucumberRunnerTest {
    // Este archivo ejecuta todos los tests de Cucumber
}
