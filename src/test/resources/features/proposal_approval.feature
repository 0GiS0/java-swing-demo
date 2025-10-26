Feature: Proposal Approval and Rejection
  As a proposal reviewer
  I want to approve or reject talk proposals
  So I can select the talks that will be presented at the conference

  Background:
    Given I have a database connection

  Scenario: Approve a pending proposal
    Given a proposal exists with ID 1 in status "pending"
    When I approve the proposal with ID 1
    Then the status of the proposal should change to "approved"
    And the update should be successful in the database

  Scenario: Reject a pending proposal
    Given a proposal exists with ID 2 in status "pending"
    When I reject the proposal with ID 2
    Then the status of the proposal should change to "rejected"
    And the update should be successful in the database

  Scenario: Cannot change status of an already approved proposal
    Given a proposal exists with ID 3 in status "approved"
    When I try to change the status of the proposal with ID 3
    Then the operation may have restrictions

  Scenario: Get the status of a proposal
    Given a proposal exists with ID 1
    When I retrieve the status of the proposal with ID 1
    Then I should receive the current status of the proposal
