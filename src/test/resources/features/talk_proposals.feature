Feature: Talk Proposal Management
  As a conference organizer
  I want to manage talk proposals
  So I can organize the event correctly

  Background:
    Given I have a database connection

  Scenario: Create a new talk proposal
    When I create a proposal with speaker Gisela Torres
    Then the proposal should be saved successfully to the database

  Scenario: Retrieve a proposal by ID
    Given a proposal exists with ID 1
    When I retrieve the proposal with ID 1
    Then I should get a valid proposal
    And the proposal should have speaker name "Gisela Torres"

  Scenario: Get all proposals
    Given proposals exist in the database
    When I get all proposals
    Then I should receive a list of proposals
    And the list should not be empty

  Scenario: Validate required fields of a proposal
    When I create a proposal with speaker Gisela Torres
    Then the proposal should have all required fields
