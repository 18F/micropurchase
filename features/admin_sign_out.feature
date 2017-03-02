Feature: Admin signs out
  As an admin
  I want be able to sign out

  Scenario: Admin signs out with github
    Given I am an administrator
    And I sign in
    When I click on the "Logout" link
    Then I should be logged out
