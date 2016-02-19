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

    When I click on the auction
    Then I expect to see the winning bid for the auction
    And I expect to see the description for the auction

  Scenario: Adding a multi-bid auction
    Given I am an administrator
    When I sign in
    And I visit the auctions admin page
    And I click to create a new auction
    Then I should be able to fill out a form for the auction

    When I click on create
    Then I expect to see the auction
    Then I expect to see the auction deadline

  Scenario: Updating an auction
    Given I am an administrator
    And there is an open auction
    When I sign in
    And I visit the auctions admin page

    When I click on edit
    Then I should be able to fill out a form for the auction

    When I click on update
    Then I expect to see the auction with the new title

    When I click on the auction
    Then I expect to see the changes
