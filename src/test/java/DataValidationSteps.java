import cucumber.api.java.en.When;
import cucumber.api.java.en.Then;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

public class DataValidationSteps {
    private boolean validationResult;
    private String lastError;

    @When("I validate the email {string}")
    public void iValidateTheEmail(String email) {
        try {
            // Basic email validation pattern
            String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";
            validationResult = Pattern.matches(emailPattern, email);
        } catch (Exception e) {
            validationResult = false;
            lastError = e.getMessage();
        }
    }

    @Then("the validation should be successful")
    public void theValidationShouldBeSuccessful() {
        assert validationResult : "The validation failed: " + lastError;
    }

    @Then("the validation should fail")
    public void theValidationShouldFail() {
        assert !validationResult : "The validation should have failed but was successful";
    }

    @When("I validate that duration {string} is one of: {string}")
    public void iValidateThatDurationIsOneOf(String duration, String optionsStr) {
        try {
            List<String> options = Arrays.asList(optionsStr.split(", "));
            validationResult = options.contains(duration);
        } catch (Exception e) {
            validationResult = false;
            lastError = e.getMessage();
        }
    }

    @When("I validate that category {string} is one of: {string}")
    public void iValidateThatCategoryIsOneOf(String category, String optionsStr) {
        try {
            List<String> options = Arrays.asList(optionsStr.split(", "));
            validationResult = options.contains(category);
        } catch (Exception e) {
            validationResult = false;
            lastError = e.getMessage();
        }
    }

    @When("I validate that level {string} is one of: {string}")
    public void iValidateThatLevelIsOneOf(String level, String optionsStr) {
        try {
            List<String> options = Arrays.asList(optionsStr.split(", "));
            validationResult = options.contains(level);
        } catch (Exception e) {
            validationResult = false;
            lastError = e.getMessage();
        }
    }
}
