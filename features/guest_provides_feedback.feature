Feature: Feedback options
  As a user
  I want to be able to give feedback
  So I can learn more about Micropurchase

  # Should add more interactions here
  Scenario: Visiting the homepage
    When I visit the home page
    Then I should see a link to give feedback
    And I should see an email link to get in touch
    And I should see a link to the github repository
