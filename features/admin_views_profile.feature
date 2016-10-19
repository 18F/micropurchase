Feature: Admin views profile
  As an administrator
  I want to go to one place to access information about my account and my bid history
  So the current bid history and profile pages should be collapsed into 1 page

  Scenario: Vendor navigates to /account/profile page
    Given I am an administrator
    And I sign in
    When I visit my profile page
    Then I should see a page header labeled "My Account"
    And the "Profile" subnav should be selected
    And I should see a profile form with my info
    And I should not see a "Bids placed" subnav
