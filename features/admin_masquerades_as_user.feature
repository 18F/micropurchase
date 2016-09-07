Feature: Admin masquerades as a user
  As an admin
  I want to view the website as a user
  So I can see what it looks like for them

  Scenario: Admin masquerades as a user
    Given I am an administrator
    And I sign in
    And there is a user in the system who has bid on an auction
    And masquerading is turned on
    When I visit the admin vendors page
    And I click on the Masquerade link
    And I visit the auction page
    Then I should see the ready for work status box

    When I click on the Stop Masquerading link
    And I visit the auction page
    Then I should see the closed auction message for non-bidders

  Scenario: Admin cannot masquerade as a user
    Given I am an administrator
    And I sign in
    And there is a user in the system who has bid on an auction
    And masquerading is turned off
    When I visit the admin vendors page
    Then I should not see the Masquerade link
