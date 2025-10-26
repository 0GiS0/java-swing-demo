Feature: Data Validation
  As a system user
  I want data to be validated correctly
  So I can prevent inconsistent data in the database

  Scenario: Validate correct email
    When I validate the email "john@example.com"
    Then the validation should be successful

  Scenario: Reject invalid email
    When I validate the email "invalid-email"
    Then the validation should fail

  Scenario: Validate allowed durations
    When I validate that duration "45 minutes" is one of: "15 minutes", "30 minutes", "45 minutes", "60 minutes"
    Then the validation should be successful

  Scenario: Validate allowed categories
    When I validate that category "Backend" is one of: "Backend", "Frontend", "DevOps", "AI/ML", "Mobile", "Other"
    Then the validation should be successful

  Scenario: Validate allowed experience levels
    When I validate that level "Intermediate" is one of: "Beginner", "Intermediate", "Advanced"
    Then the validation should be successful
