Feature: Guest views future auction
  As a guest
  I want to learn about upcoming auctions
  So I can decide to bid on them

  Scenario: There is a future auction
    Given there is a future auction
    When I visit the home page
    Then I should see a "Coming Soon" label
    And I should not see a "Bid" button
    And there should be meta tags for the index page for 0 open and 1 future auctions

    When I visit the auction page
    Then I should see a "Coming Soon" status
    And there should be meta tags for the closed auction
