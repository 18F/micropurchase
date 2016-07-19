Feature: Admin views user
  As an administrator
  I want to be able to click to see a user's information
  So that I do not need to ssh in order to do so

  Background:
    Given I am an administrator
    And I sign in

  Scenario: Admin navigates to show page from list of all users
    And there are users in the system
    When I visit the admin users page
    And I click on the name of the first user
    Then I should see that user's information

  Scenario: I see a user's bid history on the user show page
    Given there is a user in the system who has bid on an auction
    When I visit the admin users page
    And I click on the name of the first user
    Then I should see a section labeled "Bid History"
    And in that section I should see a table of the user's bids

  Scenario: I see a user who has not bid
    Given there are users in the system
    When I visit the admin users page
    And I click on the name of the first user
    Then I should not see a section labeled "Bidding History"
