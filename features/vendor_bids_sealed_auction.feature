Feature: Vendor bids on a sealed-bid auction
  As a vendor
  I want to be able to bid on sealed-bid auctions
  So I can build software if I win

  Scenario: viewing the rules page
    Given there is a sealed-bid auction
    When I visit the home page
    Then I should see that the auction is Sealed-bid

    When I click on the auction's title
    Then I should see the rules for Sealed-bid auctions

  @javascript
  Scenario: bidding on a sealed-bid auction
    Given there is a sealed-bid auction with bids
    And I am an authenticated vendor
    When I visit the home page
    Then I should not see "Current bid:"

    When I click on the auction's title
    Then I should be on the auction page
    And I should not see "Your bid:"
    And I should see "Current bid:"
    And I should see the bid form
    And I should see the maximum bid amount in the bidding form

    When I submit a bid for $3493
    And I click OK on the javascript confirm dialog for a bid amount of $3,493.00
    Then I should see a status message that confirms I placed a sealed bid

    When I visit the auction page
    Then I should not see the bid form
    And I should see "Your bid: $3,493.00"
    Then I should see a status message that confirms I placed a sealed bid

  @javascript
  Scenario: viewing your own bid
    Given there is a sealed-bid auction
    And I am an authenticated vendor
    When I visit the auction page

    When I submit a bid for $500
    And I click OK on the javascript confirm dialog for a bid amount of $500.00
    And I click on the "Bids" link
    Then I should see "$500"
    And I should not see "$500 *"
    And I should not see bids from other users

 @javascript
 Scenario: Vendor bids too high
    Given there is a sealed-bid auction
    And I am a user with a verified SAM account
    And I sign in
    When I visit the auction page
    And I submit a bid for $3900
    And I click OK on the javascript confirm dialog for a bid amount of $3,900.00
    Then I should see my bid is too high
