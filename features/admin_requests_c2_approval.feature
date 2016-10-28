Feature: Admin requests C2 approval for an auction
  As an admin
  I should be able to request C2 approvalf for an auction

  @background_jobs_off
  Scenario: Admin requests C2 approval, C2 proposal pending
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction does not have a c2 proposal url
    When I visit the admin auction page for that auction
    Then I should see that approval has not been requested for the auction

    When I click on the "Request approval" button
    Then I should see the auction was sent to C2 for approval
    And I should see that the auction does not have a C2 Proposal URL
    And I should not see a "Request approval" button

  Scenario: Admin requests C2 approval, C2 proposal created
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction does not have a c2 proposal url
    When I visit the admin auction page for that auction
    Then I should see that the auction does not have a C2 Proposal URL
    When I click on the "Request approval" button
    Then I should see that the C2 status for an auction pending C2 approval
    And I should see that the auction has a C2 Proposal URL
    And I should not see a "Request approval" button

  Scenario: Auction has a C2 proposal
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction has a c2 proposal url
    When I visit the admin auction page for that auction
    Then I should see that the auction has a C2 Proposal URL
    And I should not see a "Create C2 Proposal" button
