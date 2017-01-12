Feature: Admin signs out
  As an admin
  I want be able to sign out

  Scenario: Admin signs out with github
    Given I am an administrator
    And I sign in
    When I click on the "Logout" link
    Then I should be logged out

  Scenario: Admin signs out with login.gov
    Given I am an administrator with a login.gov account
    And I visit the admin sign in page
    And I click on the "Authorize with Login.gov" button
    When I click on the "Logout" link
    Then I should be logged out
    