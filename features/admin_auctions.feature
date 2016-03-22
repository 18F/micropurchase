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
    And I should see the auction

    When I click on the auction's title
    Then I should see the winning bid for the auction
    And I should see the auction's description

  Scenario: Adding a multi-bid auction
    Given I am an administrator
    When I sign in
    And I visit the auctions admin page
    And I click on the "Create a new auction" link
    Then I should be able to edit the new auction form

    When I click to create an auction
    Then I should see the auction's title
    Then I should see the auction's deadline

  Scenario: Updating an auction
    Given I am an administrator
    And there is an open auction
    When I sign in
    And I visit the auctions admin page

    When I click to edit the auction
    Then I should be able to edit the existing auction form

    When I click on the "Update" button
    Then I expect my auction changes to have been saved

    When I click on the auction's title
    Then I should see new content on the page
