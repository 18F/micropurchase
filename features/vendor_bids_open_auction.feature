Feature: Vendor bids on an open auction
  As a vendor
  I want to be able to bid on auctions
  So I can be paid for work

  Scenario: Logging in before bidding
    Given there is an open auction
    And the auction has a lowest bid amount of 1000
    When I visit the home page
    Then I should see "Current winning bid: $1,000"

    And I am a user with a verified SAM account
    And I sign in and verify my account information
    And I click on the auction's title

    When I submit a bid for $999
    Then I should see a confirmation for $999

    When I click on the "Confirm" button
    Then I should see "Your bid: $999"
    And I should not see the bid form
    And I should see I have the winning bid
