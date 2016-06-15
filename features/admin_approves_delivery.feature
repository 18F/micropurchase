Feature: Admin approves delivery of a project
  As an admin
  I want to set an auction result to be approved
  And have the CAP Proposal created automatically
  So the vendor can get paid

  Scenario: Marking an auction result as accepted
    Given I am an administrator
    And there is an auction that needs evaluation
    And I sign in
    When I visit the admin form for that auction
    And I select the result as accepted
    And I click on the "Update" button
    Then the proposal should have a CAP Proposal URL
    When I visit the admin form for that auction
    Then I should see that the auction has a CAP Proposal URL

    Scenario: Marking an auction as accepted where the vendor cannot be paid
      Given I am an administrator
      And there is an auction where the winning vendor is not eligible to be paid
      And I sign in
      When I visit the admin form for that auction
      And I select the result as accepted
      And I click on the "Update" button
      Then the proposal should not have a CAP Proposal URL
      And I should see an error that "The vendor cannot be paid"
