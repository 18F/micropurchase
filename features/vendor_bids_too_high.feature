Feature: Vendor bids too high
  As a vendor
  I should get an error when I bid higher than the maximum allowed bid
  So I can make a valid bid

  Background:
    Given I am a user with a verified SAM account
    And I sign in

 @javascript
 Scenario: reverse auction

    Given there is an open auction
    And the auction has a lowest bid amount of 1000
    When I visit the home page
    Then I should see "Current winning bid: $1,000"

    When I click on the auction's title
    And I submit a bid for $1200
    And I click OK on the javascript confirm dialog for a bid amount of $1,200.00
    Then I should see my bid is too high
