Feature: Admin views an auction with payment needed from an "other" P-card
  As an administrator
  I want to see if an auction needs to be paid directly by a customer
  So that I can notify them if there is a problem

  Scenario: Admin sees that accepted auction requires payment via other p-card (not 18F)
    Given I am an administrator
    And I sign in
    And there is an accepted auction that needs payment
    And the auction is for a different purchase card

    When I visit the admin auction page for that auction
    Then I should see an admin status message that the auction needs payment from a customer

  Scenario: Mark as paid
    Given I am an administrator
    And I sign in
    And there is an accepted auction that needs payment
    And the auction is for a different purchase card

    When I visit the admin auction page for that auction
    And I mark the auction as paid
#    Then I should see the C2 status for an auction with payment confirmation
