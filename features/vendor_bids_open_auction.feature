Feature: Vendor bids on an open auction
  As a vendor
  I want to be able to bid on auctions
  So I can be paid for work

  Scenario: Logging in to place a bid
    Given there is an open auction
    And I am a user with a verified SAM account
    And the auction has a lowest bid amount of 1000
    When I visit the home page
    Then I should see the auction's title
    Then I should see "Current winning bid: $1,000"

    When I click on the auction's title
    Then I should be on the auction page
    And I should see a link to the auction issue URL
    And there should be meta tags for the open auction

    When I visit the home page
    And I click on the auction's title
    Then I should see a link to the auction issue URL

    When I click on the "BID" button
    Then I should see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" link
    And I visit my profile page
    Then I should be on my profile page
    And I click on the "Submit" button
    And I click on the auction's title
    When I click on the "BID" button

    When I submit a bid for $800
    Then I should see a confirmation for $800

    When I click on the "Confirm" button
    Then I should see a current bid amount of $800

    When I visit the home page
    Then I should see "Your bid is winning: $800.00"

  Scenario: Logging in before bidding
    Given there is an open auction
    And the auction has a lowest bid amount of 1000
    When I visit the home page
    Then I should see "Current winning bid: $1,000"

    And I am a user with a verified SAM account
    And I sign in and verify my account information
    And I click on the auction's title
    When I click on the "BID" button
    Then I should not see an "Authorize With Github" button

    When I submit a bid for $999
    Then I should see a confirmation for $999

    When I click on the "Confirm" button
    Then I should see a current bid amount of $999
    And I should see I have the winning bid
