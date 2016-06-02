Feature: Guest views bid details
  As a guest
  I would like to be able to view all the bids on auctions
  So I can see what bidding was like

  Scenario: When the auction is over
    Given there is a closed auction
    When I visit the auction bids page
    Then I should be able to see the full details for each bid

  Scenario: When the auction is current
    Given there is an open auction
    When I visit the auction bids page
    Then I should not see the bidder name or duns for any bid
