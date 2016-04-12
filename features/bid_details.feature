Feature: Bid Details
  As a vendor
  I want to be able to view all the bids on auctions
  So I can make a good bid

  Scenario: When the auction is over
    Given there is a closed auction
    When I visit the auction bids page
    Then I should be able to see the full details for each bid

  Scenario: When the auction is current and I'm not logged in
    Given there is an open auction
    When I visit the auction bids page
    Then I should not see the bidder name or duns for any bid

  Scenario: When the auction is open and I'm logged in
    Given there is an open auction
    And I am an authenticated vendor
    And I have placed a bid
    When I visit the auction bids page
    Then I should see my name and DUNS only on my bids
