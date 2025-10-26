Feature: Database Connection
  As a developer
  I want to verify that the MySQL database connection works correctly
  So I can ensure that the application can access the data

  Scenario: Connect to MySQL database
    When I establish a connection to the database
    Then the connection should be successful
    And the connection should be active

  Scenario: Disconnect from the database
    Given I have an active connection to the database
    When I close the connection
    Then the connection should close correctly
