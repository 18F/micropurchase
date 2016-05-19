Feature: Vendor views a closed sealed-bid auction
  As a vendor
  I want to be able to view a closed sealed-bid auction
  So I can see who won

  Scenario: viewing a closed single-bid auction
    Given there is a closed single-bid auction
    And I am an authenticated vendor
    When I visit the auction page
    Then I should see a winning bid amount

    When I visit the auction bids page
    Then I should not see "Bids are sealed until the auction ends."
    And I should not see "See the auction rules to learn more."
    And I should be able to see the full details for each bid
