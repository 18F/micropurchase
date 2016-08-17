Feature: Admin accepts delivery of a project
  As an admin
  I want to set an auction status to be approved
  And have the C2 Proposal created automatically
  So the vendor can get paid

  Scenario: Marking an auction status as accepted
    Given I am an administrator
    And there is an auction that needs evaluation
    And I sign in
    When I visit the admin form for that auction
    And I select the status as accepted
    And I click on the update button
    Then I should see that the auction has a C2 Proposal URL
    And I should see that the auction was accepted

  Scenario: Marking an auction as accepted where the vendor cannot be paid
    Given I am an administrator
    And there is an auction where the winning vendor is not eligible to be paid
    And I sign in
    When I visit the admin form for that auction
    And I select the status as accepted
    And I click on the update button
    Then I should see an error that the vendor cannot be paid

  Scenario: Marking an auction as accepted where the vendor does not have payment information
    Given I am an administrator
    And there is an auction where the winning vendor is missing a payment method
    And I sign in
    When I visit the admin form for that auction
    And I select the status as accepted
    And I click on the update button
    Then the vendor should receive an email requesting payment information
