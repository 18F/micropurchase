Feature: Toggling visibility on the sam status warning
  As a user looking to bid on an auction
  I want to have a clear, but not annoying, indication of my sam status
  So that I will not bid with the false expectation that I can win

  Scenario: When sam status is verified
    Given I am a user with a verified SAM account
    When I sign in and verify my account information
    Then I should not see an alert warning me about my SAM registration

  Scenario: When sam status unverified
    Given I am a user without a verified sam account
    When I sign in and verify my account information
    Then I should see an alert warning me that my SAM registration is not complete

  @wip @javascript
  Scenario: Toggling the sam status warning
    Given I am a user without a verified sam account
    When I sign in and verify my account information
    When I collapse the alert warning me about my SAM registrtation
    Then I will not see the alert
    And I will see an link to expand the alert
