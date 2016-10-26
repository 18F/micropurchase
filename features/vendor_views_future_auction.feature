Feature: Vendor views future auction
  As a vendor
  I want to learn about upcoming auctions
  So I can decide to bid on them

  Scenario: There is a future auction
    Given there is a future auction
    And I am an authenticated vendor
    When I visit the auction page
    Then I should see a "Coming soon" label
    And I should see a relative opening time for the auction
    And I should not see the bid form
    And I should see the future auction message for vendors

  Scenario: There is a future auction that is about to open
    Given there is a future auction that will open today
    And I am an authenticated vendor
    When I visit the auction page
    Then I should see a "Coming soon" label
    And I should see a relative opening time for the auction
    And I should not see the bid form
    And I should see the future auction message for vendors
    And I should see the starting price
