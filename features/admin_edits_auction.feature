Feature: Admin edits auctions in the admins panel
  As an admin of the Micropurchase system
  I want to be able to modify existing auctions in an admin
  So that I will be able to more efficiently work with the system

  Scenario: Adding an auction
    Given I am an administrator
    When I sign in
    And I visit the auctions admin page
    And I click on the "Create a new auction" link
    And I edit the new auction form
    And I click to create an auction
    Then I should see the auction's title
    And I should see the auction's deadline

  Scenario: Creating an invalid auction
    Given I am an administrator
    And I sign in
    And I visit the auctions admin page
    When I click on the "Create a new auction" link
    And I edit the new auction form
    And I set the auction start price to $24000
    And I click to create an auction
    Then I should see an alert that
      """
      You do not have permission to publish auctions with a start price over $3500
      """

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
