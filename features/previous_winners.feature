Feature: Previous Winners View and Previous Winners Archive Page
  As an unauthenticated user
  I want to be able to previous winners on the site
  So that I can learn about micropurchase

  Scenario: Visiting the previous winners page
    Given there is a closed auction
    When I visit the previous winners page
    Then I should see six numbers on the page
    And I should see a section with two donut charts
    And I should see a Winning bid section
    And I should see a Community section
    And I should see a Bids by auction section

  Scenario: Navigating to the previous winners archive page
    Given there is a closed auction
    When I visit the previous winners page
    Then I should see a link to the previous winners archive page
    When I click on the previous winners link
    Then I should visit the previous winners archive page

  Scenario: Visiting the previous winners archive page
    Given there is a closed auction
    When I visit the previous winners archive page
    Then I should see a dropdown menu
    And the menu should default to All
    And I should see a list of all the previous auctions





