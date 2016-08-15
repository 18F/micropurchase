Feature: Guest Views Insights page
  As an unauthenticated user
  I want to be able to see previous auction winners
  So that I can learn about micropurchase

  Scenario: Visiting the insights page
    Given there is an accepted auction
    When I visit the insights page
    Then I should see seven numbers on the page
    And I should see that there is one total auction
    And I should see a section with two donut charts
    And I should see a Winning bid section
    And I should see a Community section
    And I should see a Bids by auction section

  @enable_caching
  Scenario: Visiting the insights page before and after cache clearing
    Given there is an accepted auction
    And I visit the insights page
    Then I should see that there is one total auction
    When there is another accepted auction
    And the cache clears
    And I refresh the page
    Then I should see that there are two total auctions
