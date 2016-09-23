Feature: Admin creates auctions in the admins panel
  As an admin
  I should be able to create auctions

  Scenario: Adding an auction
    Given I am an administrator
    And there is a client account to bill to
    And there is a skill in the system
    When I sign in
    And I visit the auctions admin page
    When I click on the add auction link
    And I edit the new auction form
    Then I should see that the auction type is sealed bid
    And I click to create an auction
    Then I should see the auction's title

    When I click on the auction's title
    Then I should see the start time I set for the auction
    And I should see the end time I set for the auction

  @javascript
  Scenario: Adding an auction with a non-default delivery timeline
    Given I am an administrator
    And there is a client account to bill to
    And there is a skill in the system
    When I sign in
    And I visit the auctions admin page
    When I click on the add auction link
    Then I should see an estimated delivery deadline of 12 business days from now
    When I change the auction end date on the form
    Then I should see the updated estimate for the delivery deadline

  Scenario: Creating an invalid auction
    Given I am an administrator
    And there is a client account to bill to
    And there is a skill in the system
    And I sign in
    And I visit the auctions admin page
    When I click on the add auction link
    And I edit the new auction form
    And I set the auction start price to $24000
    And I click to create an auction
    Then I should see that the form preserves the previously entered values
    And I should see an alert that the start price is invalid

  Scenario: Admin can only assign active Tock projects to new auction
    Given I am an administrator
    And there is a client account to bill to
    And there is a non-active client account
    And I sign in
    And I visit the auctions admin page
    When I click on the add auction link
    Then I should not see the non-active client account
    And I should see the the active client account
