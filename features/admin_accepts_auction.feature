Feature: Admin accepts delivery of a project
  As an admin
  I want to set an auction status to be approved
  So the vendor can get paid

  Scenario: Marking an auction status as accepted via auction form
    Given I am an administrator
    And there is an auction that needs evaluation
    And I sign in
    When I visit the admin form for that auction
    And I select the status as accepted
    And I click on the update button
    Then I should see that the auction was accepted

  Scenario: Marking an auction as accepted via admin auction show page
    Given I am an administrator
    And I sign in
    And there is an auction that needs evaluation
    When I visit the admin auction page for that auction
    And I mark the auction as accepted
    Then I should see the admin status for an accepted auction

  Scenario: Marking an auction as accepted where the vendor cannot be paid
    Given I am an administrator
    And there is an auction where the winning vendor is not eligible to be paid
    And I sign in
    When I visit the admin form for that auction
    And I select the status as accepted
    And I click on the update button
    Then I should see an error that the vendor cannot be paid

  Scenario: Marking an auction as accepted via form, vendor does not have payment information
    Given I am an administrator
    And there is an auction where the winning vendor is missing a payment method
    And I sign in
    When I visit the admin form for that auction
    And I select the status as accepted
    And I click on the update button
    Then the vendor should receive an email requesting payment information

  Scenario: Marking an auction as accepted via show page, vendor does not have payment information
    Given I am an administrator
    And I sign in
    And there is an auction where the winning vendor is missing a payment method
    When I visit the admin auction page for that auction
    And I mark the auction as accepted
    Then the vendor should receive an email requesting payment information
