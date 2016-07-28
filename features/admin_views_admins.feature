Feature: Admin views admins
  As an administrator
  I want to be able to see information about admins
  j
  Scenario: visiting the admin admins page
    Given I am an administrator
    And I sign in
    When I click on the "People" link
    Then I should be on the admin admins page
    And I will not see a warning I must be an admin
    And I should see my user info
