Feature: Admin views auctions in the admin panel
  As an admin of the Micro-purchase system
  I want to be able to modify existing auctions in an admin
  So that I will be able to more efficiently work with the system

  Scenario: Visiting the auctions index
    Given I am an administrator
    And there is an open auction
    And there is a future auction
    When I sign in
    And I visit the auctions page
    Then I will not see a warning I must be an admin
    And I should see the auctions in reverse start date order
    And I should see an "Edit" button

    When I click on the auction's title
    Then I should see the winning bid for the auction
    And I should see the auction's description

  Scenario: Viewing a paid auction
    Given I am an administrator
    And there is a paid auction
    When I sign in
    And I visit the auctions page
    And I click on the auction's title
    Then I should see when the winning vendor was paid in ET
