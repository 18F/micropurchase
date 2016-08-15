Feature: Vendor views an open auction
  As a vendor
  I want to be able to view the details of auctions
  So that I can possibly place a bid

  Scenario: Viewing an auction when nobody has bid
    Given there is an open bidless auction
    And I am an authenticated vendor
    When I visit the home page
    And I click on the auction's title
    And I should see the maximum bid amount in the bidding form

  Scenario: Viewing an auction when someone else has outbid me
    Given there is an open auction
    And I am an authenticated vendor
    And I have placed a bid that is not the lowest
    When I visit the home page
    And I click on the auction's title
    And I should see the maximum bid amount in the bidding form
    And I should see I do not have the winning bid

  Scenario: Vendor is not verified via Sam.gov
    Given there is an open auction
    And I am a user without a verified SAM account
    And I sign in
    When I visit the auction page
    Then I should see the open auction message for vendors not verified by Sam.gov
