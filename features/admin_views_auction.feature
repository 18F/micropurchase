Feature: Admin views public auction pages
  As an administrator
  I want to be able to click to edit an auction from the auction show page
  So that I don't have to go back to the auctions admin panel

  Scenario: Admin navigates to edit page from auction show page
    Given I am an administrator
    And I sign in
    And there is an open auction
    And I visit the auction page
    Then I should see the "Edit" link for the auction

    When I click on the "Edit" link for the auction
    Then I should be on the admin form for that auction

    When I click on the "Update" button
    Then I should be on the auction page

  Scenario: Non-admin looks at the public auction page
    Given I am a user with a verified SAM account
    And I sign in
    And there is an open auction
    When I visit the auction page
    Then I should not see an "Edit" link for the auction
