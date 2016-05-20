Feature: Vendor views closed auctions
  As a vendor
  I want to be able to view closed auctions
  So that I see who won

  Scenario: I am the winner
    Given there is a closed auction
    And I am an authenticated vendor
    And I have placed the lowest bid
    When I visit the auction page
    Then I should see the auction had a winning bid with name
    And I should see I am the winner
    And I should see when the auction started
    And I should see when the auction ended
    And there should be meta tags for the closed auction

  Scenario: I am not the winner
    Given there is a closed auction
    And I am an authenticated vendor
    And I have placed a bid that is not the lowest
    When I visit the auction page
    Then I should see the auction had a winning bid with name
    Then I should see I am not the winner
    And I should see when the auction started
    And I should see when the auction ended
    And there should be meta tags for the closed auction
    And email notifications are sent to losing bidders
    And I should receive an email notifying me that I did not win

  Scenario: I have not bid on the auction
    Given there is a closed auction
    And I am an authenticated vendor
    And I have not placed a bid
    When I visit the auction page
    Then I should see the auction had a winning bid with name
    And I should not see a winner alert box
    And I should see when the auction started
    And I should see when the auction ended
    And there should be meta tags for the closed auction

  Scenario: Nobody has bid on the auction
    Given there is a closed bidless auction
    And I am an authenticated vendor
    When I visit the auction page
    Then I should see when the auction ended
    And I should see the auction ended with no bids
    And I should see when the auction started
    And I should see when the auction ended
    And there should be meta tags for the closed auction

