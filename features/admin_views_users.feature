Feature: Admin views users
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

  Scenario: A user that is not a small business
    Given I am an administrator
    And there is a user in SAM.gov who is not a small business
    When I sign in
    And I visit the admin users page
    Then I should see a column labeled "Small Business?"
    And I should see "No" for the user in the "Small Business?" column

  Scenario: A user who is a small business
    Given I am an administrator
    And there is a user in SAM.gov who is a small business
    When I sign in
    And I visit the admin users page
    Then I should see a column labeled "Small Business?"
    And I should see "Yes" for the user in the "Small Business?" column

  Scenario: A user who is not in SAM.gov
    Given I am an administrator
    And there is a user who is not in SAM.gov
    When I sign in
    And I visit the admin users page
    Then I should see a column labeled "Small Business?"
    And I should see "N/A" for the user in the "Small Business?" column
