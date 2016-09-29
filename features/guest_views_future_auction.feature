Feature: Guest views future auction
  As a guest
  I want to learn about upcoming auctions
  So I can decide to bid on them

  Scenario: There is a future auction
    Given there is a future auction
    When I visit the home page
    Then I should see a "Coming soon" status
    And there should be meta tags for the index page for 0 open and 1 future auctions

    When I visit the auction page
    Then I should see a "Coming soon" label
    And I should not see the bid form
    And I should see the future auction message for guests
