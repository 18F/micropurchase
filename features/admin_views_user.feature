Feature: Admin views user
  As an administrator
  I want to be able to click to see a user's information
  So that I do not need to ssh in order to do so

  Scenario: Admin navigates to show page from list of all users
    Given I am an administrator
    And I sign in
    And there are users in the system
    When I visit the admin users page
    And I click on the name of the first user
    Then I should see that user's information
