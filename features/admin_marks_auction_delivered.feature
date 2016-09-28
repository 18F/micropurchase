Feature: Admin marks auction as delivered
  As an admin, I want to be able to mark an auction as done if a vendor forgets to do that themselves
  So there should be a way for me to do this in the UI

  Scenario: Admin sees "Mark as delivered" button in status box of auction show page
    Given I am an administrator
    And I sign in
    And there is an auction with work in progress
    When I visit the admin auction page for that auction
    Then I should see the work in progress status box for admins
    And I should see a button to mark as delivered

  Scenario: Admin marks the auction as delivered
    Given I am an administrator
    And I sign in
    And there is an auction with work in progress
    When I visit the admin auction page for that auction
    And I click the mark as delivered button
    Then I should see the admin status for an auction that is pending acceptance
