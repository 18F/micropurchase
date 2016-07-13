Feature: Admin creates auctions in the admins panel
  As an admin
  I should be able to create auctions

  Scenario: Adding an auction
    Given I am an administrator
    And there is a client account to bill to
    And there is a skill in the system
    When I sign in
    And I visit the auctions admin page
    When I click on the "Create New Auction" link
    And I edit the new auction form
    And I click to create an auction
    Then I should see the auction's title
    And I should see the start time I set for the auction
    And I should see the end time I set for the auction

  Scenario: Creating an invalid auction
    Given I am an administrator
    And there is a client account to bill to
    And there is a skill in the system
    And I sign in
    And I visit the auctions admin page
    When I click on the "Create New Auction" link
    And I edit the new auction form
    And I set the auction start price to $24000
    And I click to create an auction
    Then I should see that the form preserves the previously entered values
    And I should see an alert that
    """
    You do not have permission to publish auctions with a start price over $3500
    """
