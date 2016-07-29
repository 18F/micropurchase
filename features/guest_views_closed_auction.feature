Feature: Guest views closed auction
  As a guest
  I want to see details about past auctions
  So I can learn more about Micro-purchase

  Scenario: There is a closed auction
    Given there is a closed auction
    When I visit the home page
    Then I should see a "Closed" status
    And I should see the auction had a winning bid
    And there should be meta tags for the index page for 0 open and 0 future auctions

    When I visit the auction page
    Then I should see a "Closed" label
    And I should see the auction had a winning bid with name
    And I should see when the auction started
    And I should see when the auction ended
    And I should see the delivery deadline
    And I should not see the bid form
    And there should be meta tags for the closed auction

  Scenario: Winning vendor was paid
    Given there is a paid auction
    When I visit the auction page
    Then I should see when the winning vendor was paid in ET
