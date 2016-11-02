Feature: Admin view needs attention auctions
  As an admin
  I want to see the needs attention auctions dashboard
  So I can tell which auctions need my attention

  Background:
    Given I am an administrator
    And I sign in

  Scenario: The needs attention tab should have a count
    Given there is each type of auction that needs attention
    When I visit the admin page
    Then I should see the total number of auctions needing my attention next to the needs attention link

  Scenario: There are no auctions that need attention
    When I visit the admin page
    Then I should see the no number next to the needs attention link

    When I visit the admin needs attention auctions page
    Then I should see "There are no auctions that are coming soon"
    And I should see "There are no open auctions"
    And I should see "There are no auctions needing delivery"
    And I should see "There are no draft auctions"
    And I should see "There are no auctions needing evaluation"
    And I should see "There are no auctions needing payment"

  Scenario: Admin sees data for draft auctions on the Needs Attention page
    Given there is an unpublished auction
    When I visit the admin needs attention auctions page
    Then I should see a table listing all draft auctions
    And I should see the auction as a draft auction

  Scenario: Admin sees data for coming soon auctions on the Needs Attention page
    Given there is a future auction
    When I visit the admin needs attention auctions page
    Then I should see a table listing all future auctions
    And I should see the auction as a future auction

  Scenario: Admin sees data for open auctions on the Needs Attention page
    Given there is an open auction
    When I visit the admin needs attention auctions page
    Then I should see a table listing all open auctions
    And I should see the auction as an open auction

  Scenario: Admin sees data for needs evaluation auctions
    Given there is an auction that needs evaluation
    When I visit the admin needs attention auctions page
    Then I should see the name of the auction
    And I should see the edit link for the auction

  Scenario: Admin sees data for needs payment auctions
    Given there is an accepted auction that needs payment
    When I visit the admin needs attention auctions page
    Then I should see the name of the auction
    And I should see the edit link for the auction

  Scenario: Admin sees data for auction that needs delivery
    Given there is an auction pending delivery
    When I visit the admin needs attention auctions page
    Then I should see the name of the auction
    And I should see the edit link for the auction
