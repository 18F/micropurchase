Feature: Bidding
  As a vendor
  I want to be able to bid on auctions
  So I can be paid for work

  Scenario: Logging in to place a bid
    Given there is an open auction
    And I am a user with a verified SAM account
    When I visit the home page
    Then I should see the auction's title
    And I should see a current bid amount

    When I click on the auction's title
    Then I should be on the auction page
    And I should see a link to the auction issue URL
    And there should be meta tags for the open auction

    When I visit the home page
    And I click on the "View details" link
    Then I should see a link to the auction issue URL

    When I click on the "BID" button
    Then I should see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" link
    And I visit my profile page
    Then I should be on my profile page
    And I click on the "Submit" button
    Then I should see the auction's title

    When I click on the "Bid" button
    Then I should see a current bid amount

    When I submit a bid for $800
    Then I should see a confirmation for $800

    When I click on the "Confirm" button
    Then I should see a current bid amount of $800

    When I visit the home page
    Then I should see a "Bid" button
    And I should see "Current bid: $800.00"

  Scenario: Logging in before bidding
    Given there is an open auction

    When I visit the home page
    Then I should see a current bid amount

    And I am a user with a verified SAM account
    And I sign in and verify my account information
    When I click on the "Bid" button
    Then I should not see an "Authorize With Github" button
    And I should see a current bid amount

    When I submit a bid for $999
    Then I should see a confirmation for $999

    When I click on the "Confirm" button
    Then I should see a current bid amount of $999
    And I should see I have the winning bid

  Scenario: Viewing an auction when I have not bid
    Given there is an open bidless auction
    And I am an authenticated vendor
    When I visit the home page
    And I click on the Bid button

    Then I should be on the new bid page
    And I should not see an "Authorize With Github" button
    And I should see a message about no bids

    Scenario: A vendor sees small business only auctions on the auction view page
      Given there is an auction with a starting price between the micropurchase threshold and simplified acquisition threshold
      And I am a user with a verified SAM account who is not a small business
      And I sign in
      When I visit the auction page
      Then I should not see the bid button
      And I should see a Small-business only status

    Scenario: A vendor sees a non small business only auctions on the auction view page
      Given there is a below the micropurchase threshold auction
      And I am a user with a verified SAM account who is not a small business
      And I sign in
      When I visit the auction page
      Then I should see the bid button
      And I should not see a Small-business only status

  Scenario: When someone else has outbid me
    Given there is an open auction
    And I am an authenticated vendor
    When I visit the home page
    And I click on the "Bid" button

    Then I should not see an "Authorize With Github" button
    And I should be on the new bid page
    And I should see a current bid amount
    And I should see I do not have the winning bid
