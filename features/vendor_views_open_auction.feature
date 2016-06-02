Feature: Vendor views an open auction
  As a vendor
  I want to be able to view the details of auctions
  So that I can possibly place a bid

  Scenario: Viewing an auction when I have not bid on it
    Given there is an open bidless auction
    And I am an authenticated vendor
    When I visit the home page
    And I click on the auction's title
    And I click on the "BID" button

    Then I should be on the new bid page
    And I should not see an "Authorize With Github" button
    And I should see a message about no bids

  Scenario: Viewing an auction when someone else has outbid me
    Given there is an open auction
    And I am an authenticated vendor
    When I visit the home page
    And I click on the auction's title
    And I click on the "BID" button

    Then I should not see an "Authorize With Github" button
    And I should be on the new bid page
    And I should see a current bid amount
    And I should see I do not have the winning bid

