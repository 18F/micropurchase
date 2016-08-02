Feature: Admin views open auction
  As a admin
  I should be able to view an open auction

  Scenario: There is an open auction
    Given there is an open auction
    And I am an administrator
    And I sign in
    When I visit the auction page
    Then I should see the auction's title
    And I should not see the bid form
    And I should the open auction message for admins
