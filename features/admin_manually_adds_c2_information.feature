Feature: Admin manually adds C2 information for default P-card auctions
  As an administrator
  I want to be able to move an auction through the approval flow manually if C2 integration is broken
  so that I can publish it

  @background_jobs_off
  Scenario: Admin sees option to manually enter C2 information for pending approval
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
    And I should see a text input for the C2 URL
    And I should see a "Set C2 URL" button

  @background_jobs_off
  Scenario: Admin manually enters C2 URL for pending approval
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction does not have a c2 proposal url
    And the C2 proposal was sent for the auction

    When I visit the admin auction page for that auction
    Then I should see the auction was sent to C2 for approval

    When I enter a C2 URL in the C2 URL input
    And I click on the "Set C2 URL" button
    Then I should see that the auction has a C2 Proposal URL
    And I should see that the C2 status for an auction pending C2 approval

  Scenario: Admin sees "Mark Auction as Paid" button for C2 auctions
    Given I am an administrator
    And I sign in
    And there is an accepted auction
    And the auction has a c2 proposal url

    When I visit the admin auction page for that auction
    Then I should see the admin status for an auction pending payment from the default P-Card
    And I should see a "Mark as paid" button

    When I mark the auction as paid
    Then I should see the C2 status for an auction pending payment confirmation
