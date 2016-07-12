Feature: Guest views open auction
  As a guest
  I should be able to view an open auction
  So I can decide if I want to bid

  Scenario: Navigating to bid history
    Given there is an open auction
    When I visit the home page
    Then I should see the auction's summary

    When I click on the auction's title
    Then I should see the bid history

  Scenario: There is an open auction
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

  Scenario: There is an open auction with required skills
    Given there is an open auction with some skills
    When I visit the auction page
    Then I should see the skills required for the auction

  Scenario: There is an expiring auction
    Given there is an expiring auction
    When I visit the home page
    Then I should see an "Expiring" label
    And there should be meta tags for the index page for 1 open and 0 future auctions

    When I visit the auction page
    Then I should see an "Expiring" status
    And I should see when the auction started
    And I should see when the auction ends
    And I should see the delivery deadline
    And there should be meta tags for the open auction

