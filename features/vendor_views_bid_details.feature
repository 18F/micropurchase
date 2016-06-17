Feature: Vendor views bid details
  As a vendor
  I want to be able to view all the bids on an auction
  So I can make a good bid

  @javascript
  Scenario: When the auction is over
    Given there is a closed auction
    And I am an authenticated vendor
    When I visit the auction page
    And I click on the "Bids" link
    Then I should be able to see the full details for each bid

  @javascript
  Scenario: When the auction is open and I'm logged in
    Given there is an open auction
    And I am an authenticated vendor
    And I have placed a bid
    When I visit the auction page
    And I click on the "Bids" link
    Then I should see my name and DUNS only on my bids
