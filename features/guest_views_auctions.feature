Feature: Basic Auction Views
  As an unauthenticated user
  I want to be able to view auctions on the site
  So that I can learn about micropurchase

  Scenario: Visiting the home page
    Given there is an open auction with some skills
    And there is also an unpublished auction
    When I visit the home page
    Then I should see the auction
    And I should not see the unpublished auction
    And there should be meta tags for the index page for 1 open and 0 future auctions

  Scenario: Navigating to the rules
    Given there is an open auction
    And there is a sealed-bid auction
    When I visit the home page
    Then I should see a "Reverse" link
    And I should see a "Sealed bid" link

    When I click on the "Reverse" link
    Then I should be on the rules page for reverse auctions

    When I visit the home page
    And I click on the "Sealed bid" link
    Then I should be on the rules page for sealed-bid auctions

  Scenario: There are no auctions
    When I visit the home page
    Then I should see a message about no auctions
    And there should be meta tags for the index page for 0 open and 0 future auctions

  Scenario: Public sees the auction customer
    Given there is an auction with an associated customer
    When I visit the auction page
    Then I should see the customer name on the page

  Scenario: Public should not see a customer label if it's not set
    Given there is an open auction
    When I visit the auction page
    Then I should not see a label for the customer on the page
