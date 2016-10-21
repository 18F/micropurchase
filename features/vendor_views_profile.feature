Feature: Vendor views profile
  As a vendor on micro-purchase platform
  I want to go to one place to access information about my account and my bid history
  So the current bid history and profile pages should be collapsed into 1 page

  Scenario: Vendor navigates to /account/profile page
    Given I am an authenticated vendor
    When I visit my profile page
    Then I should see a page header for my account page
    And the profile subnav should be selected
    And I should see a profile form with my info

  Scenario: Vendor who has not bid navigates to bid history page
    Given I am an authenticated vendor
    When I visit my profile page
    Then I should see a page header for my account page

    When I click on the bids placed subnav
    Then the bids placed subnav should be selected
    And I should see I have placed no bids

  Scenario: Vendor who has placed bids navigates to the bid history page
    Given I am an authenticated vendor
    And there is an open auction
    And I have placed a bid
    When I visit my bid history page
    Then I should see a page header for my account page
    And the bids placed subnav should be selected
    And I should see my bid history
    And I should not see bids from other users
