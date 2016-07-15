Feature: Signing in and out
  As a vendor
  I should be able to log into the application
  So that I can bid on auctions

  Scenario: Existing user logs in and clicks the edit profile link
    Given I am a user with a verified SAM account
    When I visit the home page
    And I click on the "Sign in" link
    Then I should be on the home page
    And I should see a "Logout" link

    When I click on the "My profile" link
    Then I should be on my profile page
    Then I should see a profile form with my info
