Feature: Admin accepts delivery of a project
  As an admin
  I want to set an auction status to be approved
  So the vendor can get paid

  Scenario: Marking an auction as accepted successfully
    Given I am an administrator
    And I sign in
    And there is an auction that needs evaluation
    And the auction has a c2 proposal url
    When I visit the admin auction page for that auction
    And I mark the auction as accepted
    Then I should see the admin status for an accepted auction

  Scenario: Marking an auction as accepted, vendor cannot be paid
    Given I am an administrator
    And there is an auction where the winning vendor is not eligible to be paid
    And I sign in
    When I visit the admin auction page for that auction
    And I mark the auction as accepted
    Then I should see an error that the vendor cannot be paid

  Scenario: Marking an auction as accepted, vendor does not have payment information
    Given I am an administrator
    And I sign in
    And there is an auction where the winning vendor is missing a payment method
    When I visit the admin auction page for that auction
    And I mark the auction as accepted
    Then the vendor should receive an email requesting payment information
