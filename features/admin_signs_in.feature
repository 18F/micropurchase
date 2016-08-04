Feature: Admin signs in
  As an admin
  I want be taken to the admin panel when I log in

  Scenario: Admin signs in
    Given I am an administrator
    And I sign in
    Then I should be on the admin needs attention auctions page
