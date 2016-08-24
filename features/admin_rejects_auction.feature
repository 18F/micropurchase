Feature: Admin rejects auction
  As an administrator
  I want to be able to reject an auction

  Scenario: Auction is delivered, pending acceptance
    Given I am an administrator
    And I sign in
    And there is an auction that needs evaluation
    When I visit the admin auction page for that auction
    And I mark the auction as rejected
    Then I should see the admin status for a rejected auction
