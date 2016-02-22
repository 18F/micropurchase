Feature: Using the Admin Auctions panel
  As an admin of the Micropurchase system
  I want to be able to modify existing auctions in an admin
  So that I will be able to more efficiently work with the system

  Scenario: Visiting the auctions index and a single auction
    Given I am an administrator
    And there is an open auction
    When I sign in
    And I visit the auctions admin page
    Then I will not see a warning I must be an admin
    And I expect to see the auction

    When I click on the auction title
    Then I expect to see the winning bid for the auction
    And I expect to see the auction description

  Scenario: Adding a multi-bid auction
    Given I am an administrator
    When I sign in
    And I visit the auctions admin page
    And I click on the "Create a new auction" link
    Then I should be able to fill out a form for the auction

    When I click to create an auction
    Then I expect to see the auction title
    Then I expect to see the auction deadline

  Scenario: Updating an auction
    Given I am an administrator
    And there is an open auction
    When I sign in
    And I visit the auctions admin page

    When I click to edit the auction
    Then I should be able to fill out a form for the auction

    When I click on the Update button
    Then I expect to see the new title for the auction

    When I click on the auction title
    Then I expect to see the changes
