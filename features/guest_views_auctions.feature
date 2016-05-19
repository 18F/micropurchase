Feature: Basic Auction Views
  As an unauthenticated user
  I want to be able to view auctions on the site
  So that I can learn about micropurchase

  Scenario: Visiting the home page
    Given there is an open auction
    And there is also an unpublished auction
    When I visit the home page
    Then I should see the auction
    And I should not see the unpublished auction
    And I should see a "Bid" button
    And there should be meta tags for the index page for 1 open and 0 future auctions

  Scenario: Visiting a auction detail page
    Given there is an open auction
    And there is also an unpublished auction

    When I visit the auction page
    Then I should see the auction's title
    And I should see the auction's description
    And I should see an "Open" status
    And I should see when the auction started
    And I should see when the auction ends
    And I should see a current bid amount
    And there should be meta tags for the open auction

  Scenario: There are no auctions
    When I visit the home page
    Then I should see a message about no auctions
    And there should be meta tags for the index page for 0 open and 0 future auctions
