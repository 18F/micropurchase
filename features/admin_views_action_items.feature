Feature: Admin view needs attention auctions
  As an admin
  I want to see the needs attention auctions dashboard
  So I can tell what actions I might need to take

  Background:
    Given I am an administrator
    And I sign in

  Scenario: Viewing the needs attention auctions dashboard
    Given there is a complete and successful auction
    And there is also an unpublished auction
    When I visit the admin needs attention auctions page
    Then I should see the name of the auction
    And I should see the edit link for the auction

  Scenario: Viewing the drafts dashboard
    Given there is an unpublished auction
    When I visit the admin drafts page
    Then I should see the auction's title

  Scenario: Viewing rejected auction
    Given there is a rejected auction
    When I visit the admin needs attention auctions page
    Then I should see the rejected auction as a needs attention auction

  Scenario: Viewing rejected auction with no bids
    Given there is a rejected auction with no bids
    When I visit the admin needs attention auctions page
    Then I should see the rejected auction as a needs attention auction
