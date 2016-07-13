Feature: Admin requests C2 approval for an auction
  As an admin
  I should be able to request C2 approvalf for an auction

  Scenario: Auction does not have a C2 proposal
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction does not have a c2 proposal url
    When I visit the admin auction page for that auction
    Then I should see that the auction does not have a C2 Proposal URL
    When I click on the "Create C2 Proposal" button
    Then I should see that the auction has a C2 Proposal URL
    And I should not see a "Create C2 Proposal" button

  Scenario: Auction has a C2 proposal
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction has a c2 proposal url
    When I visit the admin auction page for that auction
    Then I should see that the auction has a C2 Proposal URL
    And I should not see a "Create C2 Proposal" button
