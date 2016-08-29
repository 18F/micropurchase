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
    And I should see the ready for work status box
    And I should receive an email notifying me that I won

  @background_jobs_off
  Scenario: I am not the winner
    Given I am an authenticated vendor
    And I am going to lose an auction
    Then I should not receive an email notifying me that I won
    When the auction ends
    And I visit the auction page
    Then I should see that I did not have the winning bid
    And I should receive an email notifying me that I did not win

  Scenario: I have not bid on the auction
    Given there is a closed auction
    And I am an authenticated vendor
    And I have not placed a bid
    When I visit the auction page
    Then I should see the closed auction message for non-bidders

  Scenario: Nobody has bid on the auction
    Given there is a closed bidless auction
    And I am an authenticated vendor
    When I visit the auction page
    Then I should see the closed auction message for non-bidders
