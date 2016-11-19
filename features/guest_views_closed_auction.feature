Feature: Guest views closed auction
  As a guest
  I want to see details about past auctions
  So I can learn more about Micro-purchase

  Scenario: There is a closed auction
    Given there is a closed auction
    When I visit the home page
    Then I should see a "Closed" status
    And I should see the auction had a winning bid

    When I visit the auction page
    Then I should see a "Closed" label
    And I should see the closed auction message for non-bidders

  Scenario: There is an auction that ended without any bids
    Given there is a closed auction with no bids
    When I visit the home page
    Then I should see a messages that the auction has no bids

  Scenario: Winning vendor was paid
    Given there is a paid auction
    When I visit the auction page
    Then I should see when the winning vendor was paid in ET
