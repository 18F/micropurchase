Feature: Admin views auctions in the admin panel
  As an admin of the Micropurchase system
  I want to be able to modify existing auctions in an admin
  So that I will be able to more efficiently work with the system

  Scenario: Visiting the auctions index
    Given I am an administrator
    And there is an open auction
    When I sign in
    And I visit the auctions admin page
    Then I will not see a warning I must be an admin
    And I should see the auction

    When I click on the auction's title
    Then I should see the winning bid for the auction
    And I should see the auction's description

  Scenario: Previewing an unpublished auction
    Given I am an administrator
    And I sign in
    And there is also an unpublished auction
    When I visit the preview page for the unpublished auction
    Then I should see a preview of the auction
