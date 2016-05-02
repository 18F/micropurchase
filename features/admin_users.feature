Feature: Admin Users
  As an administrator
  I want to be able to see information about users
  So that I can see how many users we have

  Scenario: visiting the admin users page
    Given I am an administrator
    And I sign in
    When I visit the admin users page
    Then I will not see a warning I must be an admin
    And I should see my user info

  Scenario: counting the numbers of users and admins
    Given I am an administrator
    And there are users in the system
    When I visit the admin users page
    And I sign in
    Then I expect the page to show me the number of regular users
    And I expect the page to show me the number of admin users

  Scenario: makes user a contracting officer
    Given I am an administrator
    And there are users in the system
    And I visit the admin users page
    When I sign in
    And I click the edit user link next to the first non-admin user
    And I check the 'Contracting officer' checkbox
    And I submit the changes to the user
    Then I expect there to be a contracting officer in the list of users
