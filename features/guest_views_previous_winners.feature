Feature: Guest Views Previous Winners Page
  As an unauthenticated user
  I want to be able to see previous auction winners
  So that I can learn about micropurchase

  Scenario: Visiting the previous winners page
    Given there is a closed auction
    When I visit the previous winners page
    Then I should see seven numbers on the page
    And I should see a section with two donut charts
    And I should see a Winning bid section
    And I should see a Community section
    And I should see a Bids by auction section
