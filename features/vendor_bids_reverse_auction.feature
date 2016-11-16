Feature: Vendor bids on a reverse auction
  As a vendor
  I want to be able to bid on auctions
  So I can be paid for work

  Scenario: Viewing an auction when someone else has outbid me
    Given there is an open auction
    And I am an authenticated vendor
    And I have placed a bid that is not the lowest
    When I visit the home page
    And I click on the auction's title
    And I should see the maximum bid amount in the bidding form
    And I should see I do not have the winning bid

  @javascript
  Scenario: I have not bid on the auction yet
    Given there is an open auction
    And the auction has a lowest bid amount of 1000
    When I visit the home page
    And I am a user with a verified SAM account
    And I sign in and verify my account information

    When I visit the home page
    And I click on the auction's title

    Then I should see the current winning bid in a header subtitle

    When I submit a bid for $999
    And I click OK on the javascript confirm dialog for a bid amount of $999.00
    And I should not see the bid form
    And I should see I have the current winning bid in a header subtitle
    And I should see I have the winning bid

 @javascript
 Scenario: Vendor bids too high
    Given there is an open auction
    And I am a user with a verified SAM account
    And I sign in
    And the auction has a lowest bid amount of 1000
    When I visit the home page
    Then I should see "Current winning bid: $1,000"

    When I click on the auction's title
    And I submit a bid for $1200
    And I click OK on the javascript confirm dialog for a bid amount of $1,200.00
    Then I should see my bid is too high
