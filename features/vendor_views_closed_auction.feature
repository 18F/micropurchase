Feature: Vendor views closed auctions
  As a vendor
  I want to be able to view closed auctions
  So that I see who won

  @background_jobs_off
  Scenario: I am the winner
    Given I am an authenticated vendor
    And I am going to win an auction
    Then I should not receive an email notifying me that I won
    When the auction ends
    And I visit the auction page
    Then I should see the auction had a winning bid with name
    And I should see the ready for work status box
    And there should be meta tags for the closed auction
    And I should receive an email notifying me that I won

  @background_jobs_off
  Scenario: I am not the winner
    Given I am an authenticated vendor
    And I am going to lose an auction
    Then I should not receive an email notifying me that I won
    When the auction ends
    And I visit the auction page
    Then I should see the auction had a winning bid with name
    Then I should see I am not the winner
    And I should see when the auction started
    And I should see when the auction ended
    And there should be meta tags for the closed auction
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
