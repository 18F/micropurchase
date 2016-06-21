Feature: Admin designates an admin as a contracting officer
  As an administrator
  I want to be able to declare some users contracting officers
  So they can create auctions above the micropurchase threshold

  Scenario: Admin makes user a contracting officer
    Given I am an administrator
    And there are users in the system
    When I sign in
    And I visit the admin users page
    And I click the edit user link next to the first admin user
    And I check the 'Contracting officer' checkbox
    And I submit the changes to the user
    Then I expect there to be a contracting officer in the list of admin users
