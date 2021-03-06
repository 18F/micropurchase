Feature: Admin signs in
  As an admin
  I want be taken to the admin panel when I log in

  Scenario: Admin signs in
    Given I am an administrator
    And I sign in
    Then I should be on the admin needs attention auctions page

  Scenario: Logged out admin tries to visit admin path
    When I visit the admin page
    Then I should be on the admin login page

  Scenario: Admin signs in with login.gov
    Given I am an administrator with a login.gov account
    And I visit the admin sign in page
    When I click on the "Authorize with Login.gov" button
    Then I should be on the admin needs attention auctions page

  Scenario: Non-admin attempts to sign in with login.gov
    Given I am a regular user with a login.gov account
    And I visit the admin sign in page
    When I click on the "Authorize with Login.gov" button
    Then I should see an error that "no admin account found"
