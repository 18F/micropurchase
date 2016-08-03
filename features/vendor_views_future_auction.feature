Feature: Vendor views future auction
  As a vendor
  I want to learn about upcoming auctions
  So I can decide to bid on them

  Scenario: There is a future auction
    Given there is a future auction
    And I am an authenticated vendor
    When I visit the auction page
    Then I should see a "Coming Soon" label
    And I should not see the bid form
    And I should see the future auction message for vendors
