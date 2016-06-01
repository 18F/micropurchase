Feature: Vendor views auctions set aside for small businesses only
  As a vendor
  I want to be able to see auctions for small-businesses only
  So I can bid on them

  Scenario: A vendor sees small business only auctions on the auction view page
    Given there is an auction with a starting price between the micropurchase threshold and simplified acquisition threshold
    And I am a user with a verified SAM account who is not a small business
    And I sign in
    When I visit the auction page
    Then I should not see the bid button
    And I should see a "Small-business only" status
      
  Scenario: A vendor sees a non small business only auctions on the auction view page
    Given there is an auction below the micropurchase threshold
    And I am a user with a verified SAM account who is not a small business
    And I sign in
    When I visit the auction page
    Then I should see the bid button
    And I should not see a "Small-business only" status
