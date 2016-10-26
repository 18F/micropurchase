Feature: Admin views open auction
  As a admin
  I should be able to view an open auction

  Scenario: There is an open auction
    Given there is an open auction
    And I am an administrator
    And I sign in
    When I visit the admin auction page for that auction
    Then I should see the open auction message for admins
    And I should see the current winning bid in a header subtitle

    When I visit the auction page
    Then I should see the open auction message for admins
    And I should see the current winning bid in a header subtitle

  Scenario: There is an open auction for the other purchase card
    Given there is an open auction
    And the auction is for a different purchase card
    And I am an administrator
    And I sign in

    When I visit the admin auction page for that auction
    Then I should see the open auction message for admins
    And I should see the current winning bid in a header subtitle
