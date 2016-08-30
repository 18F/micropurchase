Feature: Winning vendor views auction
  As a vendor
  I want to be able to know that I won an auction
  So that I can deliver work to be evaluated

  @background_jobs_off
  Scenario: I am the winner, have not started work
    Given I am an authenticated vendor
    And I am going to win an auction
    Then I should not receive an email notifying me that I won
    When the auction ends
    And I visit the auction page
    And I should see the ready for work status box
    And I should receive an email notifying me that I won

  Scenario: I am the winner, auction was rejected
    Given I am an authenticated vendor
    And I won an auction that was rejected
    When I visit the auction page
    Then I should see winning bidder status for a rejected auction
