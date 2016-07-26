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

  @javascript
  Scenario: Adding an auction with a non-default delivery timeline
    Given I am an administrator
    And there is a client account to bill to
    And there is a skill in the system
    When I sign in
    And I visit the auctions admin page
    When I click on the "Create New Auction" link
    Then I should see an estimated delivery deadline of 12 business days from now
    And I change the auction end date
    Then I should see "Save your changes to see updated delivery date and time"

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
