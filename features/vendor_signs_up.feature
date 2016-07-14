Feature: Signing up
  As a vendor
  I should be able to sign up for the application

  Scenario: New user logs in, created and logs out via header link
    Given I only have a Github account
    When I visit the home page
    And I click on the "Sign up" link
    Then I should be on the sign up page
    And I should see a "Logout" link

    When I click on the "Continue" link
    Then I should be on my profile page
    And I should see the name from github authentication
