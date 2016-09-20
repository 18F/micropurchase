Feature: Admin rejects auction
  As an administrator
  I want to be able to reject an auction

  Scenario: Admin rejects auction via show page
    Given I am an administrator
    And I sign in
    And there is an auction that needs evaluation
    When I visit the admin auction page for that auction
    And I mark the auction as rejected
    Then I should see the admin status for a rejected auction
    Then the vendor should receive an email notifying them that the work was rejected
