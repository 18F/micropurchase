Feature: Admin Dashboard
  As an admin
  I want to see a dashboard of the auctions
  So I can tell easily how things are going

  Scenario: Viewing the action items dashboard
    Given I am an administrator
    And there are complete and successful auctions
    And there is also an unpublished auction
    And I sign in
    When I visit the admin action items page
    Then I expect to see the name of each dashboard auction

  Scenario: Previewing an unpublished auction
    Given I am an administrator
    And I sign in
    And there is also an unpublished auction
    When I visit the preview page for the unpublished auction
    Then I should see a preview of the auction
