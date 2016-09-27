Feature: Admin marks auction as delivered
  As an admin, I want to be able to mark an auction as done if a vendor forgets to do that themselves
  So there should be a way for me to do this in the UI

  Scenario: Admin sees "Mark as delivered" button in status box of auction show page
    Given I am an administrator
    And I sign in
    And there is a published auction that has a winner
    And there is a delivery URL specified
    And the vendor has not yet clicked the "I'm done" button
    When I go to the admin auction show page for that auction
    Then I should see a status for administrators there is a work in progress
    And I should see a button to mark as delivered
