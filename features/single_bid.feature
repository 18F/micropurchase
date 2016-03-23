Feature: Single-bid auctions
  As a vendor
  I want to be able to bid on single-bid auctions
  So I can build software if I win

  Scenario: viewing the rules page
    Given there is a single-bid auction
    When I visit the home page
    Then I expect to see a link to single-bid rules

    When I click on the auction title
    Then I expect to see the rules for single-bid auctions

  Scenario: bidding on a single-bid auction
    Given there is a single-bid auction
    And I am allowed to bid
    When I visit the home page
    Then I expect to not see "Current bid:"

    When I click on the auction title
    Then I expect to be on the auction page
    And I expect to see "Your bid:"
    And I expect to not see "Current bid:"

    When I click on the "BID" button
    Then I expect to see "Your bid:"

    When I submit a bid for $3493
    Then I expect to see a confirmation for $3493

    When I click on the "Confirm" button
    Then I expect to not see a "BID" button
    And I expect to see "Your bid: $3,493.00"

    When I visit the auction page
    Then I expect to not see a "BID" button
    And I expect to see "Your bid: $3,493.00"

  Scenario: viewing your own single bid
    Given there is a single-bid auction
    And I am allowed to bid
    When I visit the auction page
    And I click on the "BID" button

    When I submit a bid for $500
    Then I expect to see a confirmation for $500

    When I click on the "Confirm" button
    Then I expect to see "Your bid: $500"

    When I visit the auction bids page
    Then I expect to see "$500"
    And I expect to not see "$500 *"
    And I expect to not see bids from other users

  Scenario: viewing the bid history for a closed single-bid auction
    Given there is a closed single-bid auction
    And I am allowed to bid
    When I visit the auction bids page
    Then I expect to not see "Bids are sealed until the auction ends."
    And I expect to not see "See the auction rules to learn more."
    And I should be able to see the full details for each bid
