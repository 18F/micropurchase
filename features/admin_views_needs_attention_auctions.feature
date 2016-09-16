Feature: Admin view needs attention auctions
  As an admin
  I want to see the needs attention auctions dashboard
  So I can tell which auctions need my attention

  Background:
    Given I am an administrator
    And I sign in

  Scenario: The needs attention tab should have a count
    Given there is each type of auction that needs attention
    When I visit the auctions admin page
    Then I should see the total number of auctions needing my attention next to the needs attention link

  Scenario: There are no auctions that need attention
    When I visit the auctions admin page
    Then I should see the no number next to the needs attention link

  Scenario: Navigating to the needs attention auctions dashboard
    Given I visit the auctions admin page
    When I click on the needs attention link
    Then I should be on the Needs Attention page

  Scenario: Admin sees data for draft auctions on the Needs Attention page
    Given there is an unpublished auction
    When I visit the admin needs attention auctions page
    Then I should see a table listing all draft auctions
    And I should see the auction as a draft auction

  Scenario: Admin sees data for needs evaluation auctions
    Given there is an auction that needs evaluation
    When I visit the admin needs attention auctions page
    Then I should see the name of the auction
    And I should see the edit link for the auction
