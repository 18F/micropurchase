Feature: Admin view action items
  As an admin
  I want to see the action items dashboard
  So I can tell what actions I might need to take

  Scenario: Viewing the action items dashboard
    Given I am an administrator
    And there are complete and successful auctions
    And there is an unpublished auction
    And I sign in
    When I visit the admin action items page
    Then I should see the name of each dashboard auction
    And I should see edit links for each dashboard auction

  Scenario: Viewing the drafts dashboard
    Given I am an administrator
    And there is an unpublished auction
    And I sign in
    When I visit the admin drafts page
    Then I should see the auction's title
