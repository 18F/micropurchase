Feature: Toggling visibility on the sam status warning
  As a user looking to bid on an auction
  I want to have a clear, but not annoying, indication of my sam status
  So that I will not bid with the false expectation that I can win

  Scenario: When sam status is verified
    Given I am a user with a verified SAM account
    When I sign in and verify my account information
    Then I should not see a warning about my SAM registration

  Scenario: When sam status unverified
    Given I am a user without a verified sam account
    When I sign in and verify my account information
    Then I should see a warning that my SAM registration is not complete

  @javascript
  Scenario: Toggling the sam status warning
    Given I am a user without a verified sam account
    And there is an open auction
    When I sign in and verify my account information
    And I collapse the warning about my SAM registration
    Then I will not see the warning
    And I will see a link to expand the warning

    When I visit the auction
    Then I will see that the warning is still collapsed

    When I click to expand the warning
    Then I should see a warning that my SAM registration is not complete

    When I visit the home page
    Then I should see a warning that my SAM registration is not complete
