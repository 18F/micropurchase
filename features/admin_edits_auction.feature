Feature: Admin edits auctions in the admins panel
  As an admin
  I should be able to modify existing auctions

  Scenario: Updating an auction
    Given I am an administrator
    And there is an open auction
    And there is a client account to bill to
    And I sign in
    And I visit the auctions admin page

    When I click to edit the auction
    Then I should see the current auction attributes in the form
    And I should be able to edit the existing auction form

    When I click on the "Update" button
    Then I should be on the admin auctions page
    And I expect my auction changes to have been saved
    And I should see the start time I set for the auction
    And I should see the end time I set for the auction

    When I click on the auction's title
    Then I should see new content on the page
